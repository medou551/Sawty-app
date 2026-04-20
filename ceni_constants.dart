// ═══════════════════════════════════════════════════════
// SAWTI v2 — Constantes CENI Mauritanie
// Données officielles : wilayas, opérateurs, types élection
// ═══════════════════════════════════════════════════════

class CeniConstants {

  // ── 15 Wilayas officielles de Mauritanie ──────────────
  static const List<Wilaya> wilayas = [
    Wilaya(id: 'nouakchott_ouest',   fr: 'Nouakchott Ouest',    ar: 'نواكشوط الغربية',  lat: 18.0858, lng: -15.9785),
    Wilaya(id: 'nouakchott_nord',    fr: 'Nouakchott Nord',     ar: 'نواكشوط الشمالية', lat: 18.1200, lng: -15.9500),
    Wilaya(id: 'nouakchott_sud',     fr: 'Nouakchott Sud',      ar: 'نواكشوط الجنوبية', lat: 18.0500, lng: -15.9500),
    Wilaya(id: 'hodh_chargui',       fr: 'Hodh Ech-Chargui',    ar: 'الحوض الشرقي',     lat: 15.9000, lng: -7.0000),
    Wilaya(id: 'hodh_gharbi',        fr: 'Hodh El-Gharbi',      ar: 'الحوض الغربي',     lat: 16.3000, lng: -9.5000),
    Wilaya(id: 'assaba',             fr: 'Assaba',               ar: 'العصابة',          lat: 16.9500, lng: -11.4000),
    Wilaya(id: 'gorgol',             fr: 'Gorgol',               ar: 'كوركول',           lat: 15.9000, lng: -12.7000),
    Wilaya(id: 'brakna',             fr: 'Brakna',               ar: 'البراكنة',         lat: 17.1000, lng: -13.5000),
    Wilaya(id: 'trarza',             fr: 'Trarza',               ar: 'الترارزة',         lat: 17.5000, lng: -14.5000),
    Wilaya(id: 'adrar',              fr: 'Adrar',                ar: 'آدرار',            lat: 20.5000, lng: -12.8000),
    Wilaya(id: 'dakhlet_nouadhibou', fr: 'Dakhlet Nouadhibou',  ar: 'داخلة نواذيبو',    lat: 20.9333, lng: -17.0333),
    Wilaya(id: 'tagant',             fr: 'Tagant',               ar: 'التگانت',          lat: 18.5000, lng: -11.5000),
    Wilaya(id: 'guidimaka',          fr: 'Guidimaka',            ar: 'كيدماغة',          lat: 15.5000, lng: -12.2000),
    Wilaya(id: 'tiris_zemmour',      fr: 'Tiris Zemmour',        ar: 'تيرس زمور',        lat: 22.7000, lng: -12.5000),
    Wilaya(id: 'inchiri',            fr: 'Inchiri',              ar: 'إينشيري',          lat: 20.5000, lng: -14.8000),
  ];

  // ── Types d'élections CENI ─────────────────────────────
  static const List<ElectionType> electionTypes = [
    ElectionType(id: 'presidentielle', fr: 'Présidentielle',  ar: 'رئاسية',      emoji: '🇲🇷'),
    ElectionType(id: 'legislative',    fr: 'Législative',     ar: 'تشريعية',     emoji: '🏛'),
    ElectionType(id: 'municipale',     fr: 'Municipale',      ar: 'بلدية',       emoji: '🏙'),
    ElectionType(id: 'senatoriale',    fr: 'Sénatoriale',     ar: 'شيوخ',        emoji: '⚖'),
    ElectionType(id: 'regionale',      fr: 'Régionale',       ar: 'جهوية',       emoji: '🗺'),
    ElectionType(id: 'referendum',     fr: 'Référendum',      ar: 'استفتاء',     emoji: '📋'),
  ];

  // ── Opérateurs téléphoniques mauritaniens ─────────────
  // Source: ANRPTS / ARE Mauritanie
  static const Map<String, MrOperator> operators = {
    '20': MrOperator(name: 'Mauritel', ar: 'موريتيل'),
    '21': MrOperator(name: 'Mauritel', ar: 'موريتيل'),
    '22': MrOperator(name: 'Mauritel', ar: 'موريتيل'),
    '23': MrOperator(name: 'Mauritel', ar: 'موريتيل'),
    '36': MrOperator(name: 'Mattel',   ar: 'ماتيل'),
    '37': MrOperator(name: 'Mattel',   ar: 'ماتيل'),
    '38': MrOperator(name: 'Mattel',   ar: 'ماتيل'),
    '39': MrOperator(name: 'Mattel',   ar: 'ماتيل'),
    '46': MrOperator(name: 'Chinguitel', ar: 'شنقيتيل'),
    '47': MrOperator(name: 'Chinguitel', ar: 'شنقيتيل'),
    '48': MrOperator(name: 'Chinguitel', ar: 'شنقيتيل'),
    '49': MrOperator(name: 'Chinguitel', ar: 'شنقيتيل'),
  };

  // ── Âge minimum de vote ───────────────────────────────
  static const int minVotingAge = 18;

  // ── Distance max bureau de vote (km) ─────────────────
  static const double maxBureauDistanceKm = 20.0;

  // ── NNI : format exact (10 chiffres) ─────────────────
  static const int nniLength = 10;
  static const String nniPattern = r'^\d{10}$';

  // ── Indicatif pays ────────────────────────────────────
  static const String countryCode = '+222';
  static const int phoneDigits = 8;
}

// ── Value objects ─────────────────────────────────────

class Wilaya {
  final String id;
  final String fr;
  final String ar;
  final double lat;
  final double lng;
  const Wilaya({required this.id, required this.fr, required this.ar,
    required this.lat, required this.lng});
}

class ElectionType {
  final String id;
  final String fr;
  final String ar;
  final String emoji;
  const ElectionType({required this.id, required this.fr,
    required this.ar, required this.emoji});
}

class MrOperator {
  final String name;
  final String ar;
  const MrOperator({required this.name, required this.ar});
}
