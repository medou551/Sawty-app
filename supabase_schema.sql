-- ============================================================
--  SAWTI صوتي — Schéma Supabase PostgreSQL
--  À exécuter dans : Supabase Dashboard → SQL Editor
-- ============================================================

-- ─── Extensions ───────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;   -- pour les coordonnées GPS (optionnel)

-- ─── 1. ÉLECTIONS ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS elections (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title       TEXT NOT NULL,
  title_ar    TEXT,                        -- titre en arabe
  type        TEXT NOT NULL,               -- 'Présidentielle', 'Municipale', etc.
  status      TEXT NOT NULL DEFAULT 'draft'
              CHECK (status IN ('draft', 'open', 'closed', 'archived')),
  opens_at    TIMESTAMPTZ,
  closes_at   TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ─── 2. CANDIDATS ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS candidates (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  election_id UUID NOT NULL REFERENCES elections(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  name_ar     TEXT,
  party       TEXT,
  party_ar    TEXT,
  photo_url   TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ─── 3. BUREAUX DE VOTE ───────────────────────────────────
CREATE TABLE IF NOT EXISTS bureaux (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        TEXT NOT NULL,
  name_ar     TEXT,
  region      TEXT NOT NULL,
  moughataa   TEXT NOT NULL,
  latitude    DOUBLE PRECISION NOT NULL,
  longitude   DOUBLE PRECISION NOT NULL,
  status      TEXT NOT NULL DEFAULT 'active'
              CHECK (status IN ('active', 'inactive')),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ─── 4. STATUT ÉLECTORAL ──────────────────────────────────
-- Une ligne par électeur enregistré (importé depuis le fichier CENI)
CREATE TABLE IF NOT EXISTS voter_status (
  uid                  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone_number         TEXT UNIQUE NOT NULL,
  nni                  TEXT UNIQUE,        -- Numéro National d'Identité
  eligible             BOOLEAN NOT NULL DEFAULT TRUE,
  has_voted            BOOLEAN NOT NULL DEFAULT FALSE,
  assigned_bureau_id   UUID REFERENCES bureaux(id),
  assigned_region      TEXT,
  registered_at        TIMESTAMPTZ DEFAULT NOW(),
  voted_at             TIMESTAMPTZ
);

-- ─── 5. VOTES (anonymisés) ────────────────────────────────
-- On ne stocke PAS l'uid pour garantir le secret du vote.
-- La liaison "a voté" est dans voter_status.has_voted uniquement.
CREATE TABLE IF NOT EXISTS votes (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  election_id           UUID NOT NULL REFERENCES elections(id),
  candidate_id          UUID NOT NULL REFERENCES candidates(id),
  bureau_id             UUID NOT NULL REFERENCES bureaux(id),
  gps_lat               DOUBLE PRECISION,
  gps_lng               DOUBLE PRECISION,
  distance_from_bureau  DOUBLE PRECISION,   -- en km
  region_match          BOOLEAN,
  created_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ─── 6. VUE RÉSULTATS ─────────────────────────────────────
CREATE OR REPLACE VIEW vote_results AS
SELECT
  v.election_id,
  v.candidate_id,
  c.name          AS candidate_name,
  c.name_ar       AS candidate_name_ar,
  c.party         AS candidate_party,
  COUNT(*)::INT   AS vote_count
FROM votes v
JOIN candidates c ON c.id = v.candidate_id
GROUP BY v.election_id, v.candidate_id, c.name, c.name_ar, c.party;

-- ─── 7. FONCTION RPC : submit_vote ────────────────────────
-- Garantit l'atomicité : vérifie l'éligibilité, insère le vote,
-- marque l'électeur comme ayant voté — dans une seule transaction.
CREATE OR REPLACE FUNCTION submit_vote(
  p_user_id     UUID,
  p_election_id UUID,
  p_candidate_id UUID,
  p_bureau_id    UUID,
  p_gps_lat      DOUBLE PRECISION,
  p_gps_lng      DOUBLE PRECISION,
  p_distance_km  DOUBLE PRECISION,
  p_region_match BOOLEAN
) RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_status voter_status%ROWTYPE;
BEGIN
  -- Récupérer le statut de l'électeur (avec verrou)
  SELECT * INTO v_status
  FROM voter_status
  WHERE uid = p_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Électeur non enregistré (uid: %)', p_user_id;
  END IF;

  IF NOT v_status.eligible THEN
    RAISE EXCEPTION 'Électeur non éligible.';
  END IF;

  IF v_status.has_voted THEN
    RAISE EXCEPTION 'Vous avez déjà voté pour cette session.';
  END IF;

  -- Insérer le vote anonymisé
  INSERT INTO votes (
    election_id, candidate_id, bureau_id,
    gps_lat, gps_lng, distance_from_bureau, region_match
  ) VALUES (
    p_election_id, p_candidate_id, p_bureau_id,
    p_gps_lat, p_gps_lng, p_distance_km, p_region_match
  );

  -- Marquer l'électeur comme ayant voté
  UPDATE voter_status
  SET has_voted = TRUE, voted_at = NOW()
  WHERE uid = p_user_id;
END;
$$;

-- ─── 8. ROW LEVEL SECURITY (RLS) ──────────────────────────

-- Elections : lecture publique, écriture admin seulement
ALTER TABLE elections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "elections_read_all"  ON elections FOR SELECT USING (TRUE);
CREATE POLICY "elections_admin_write" ON elections FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- Candidats : lecture publique
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "candidates_read_all" ON candidates FOR SELECT USING (TRUE);
CREATE POLICY "candidates_admin_write" ON candidates FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- Bureaux : lecture publique
ALTER TABLE bureaux ENABLE ROW LEVEL SECURITY;
CREATE POLICY "bureaux_read_all" ON bureaux FOR SELECT USING (TRUE);
CREATE POLICY "bureaux_admin_write" ON bureaux FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- Voter status : lecture restreinte à l'électeur lui-même
ALTER TABLE voter_status ENABLE ROW LEVEL SECURITY;
CREATE POLICY "voter_status_self" ON voter_status FOR SELECT
  USING (uid = auth.uid());

-- Votes : personne ne peut lire les votes individuels (anonymat garanti)
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;
-- Pas de politique SELECT = aucun accès direct (la vue vote_results est publique)

-- ─── 9. DONNÉES DE TEST ───────────────────────────────────
INSERT INTO elections (id, title, title_ar, type, status) VALUES
  ('11111111-0000-0000-0000-000000000001',
   'Élection présidentielle 2026',
   'الانتخابات الرئاسية 2026',
   'Présidentielle', 'open'),
  ('11111111-0000-0000-0000-000000000002',
   'Municipales Nouakchott 2026',
   'البلدية نواكشوط 2026',
   'Municipale', 'open')
ON CONFLICT DO NOTHING;

INSERT INTO candidates (election_id, name, name_ar, party) VALUES
  ('11111111-0000-0000-0000-000000000001', 'Ahmed Salem', 'أحمد سالم', 'Union Citoyenne'),
  ('11111111-0000-0000-0000-000000000001', 'Mariam Mint Ely', 'مريم منت إلي', 'Voix Nationale'),
  ('11111111-0000-0000-0000-000000000001', 'Sidi Mohamed', 'سيدي محمد', 'Justice et Développement'),
  ('11111111-0000-0000-0000-000000000002', 'Fatimetou Kane', 'فاطمة تو كان', 'Nouakchott Demain'),
  ('11111111-0000-0000-0000-000000000002', 'Mohamed Ould Cheikh', 'محمد ولد الشيخ', 'Alliance Municipale')
ON CONFLICT DO NOTHING;

INSERT INTO bureaux (id, name, name_ar, region, moughataa, latitude, longitude, status) VALUES
  ('22222222-0000-0000-0000-000000000001',
   'École 1 - Tevragh Zeina', 'مدرسة 1 - تيفرغ زين',
   'Nouakchott Ouest', 'Tevragh Zeina', 18.1002, -15.9495, 'active'),
  ('22222222-0000-0000-0000-000000000002',
   'Lycée Dar Naim Centre', 'ثانوية دار النعيم المركز',
   'Nouakchott Nord', 'Dar Naim', 18.1130, -15.9760, 'active')
ON CONFLICT DO NOTHING;
