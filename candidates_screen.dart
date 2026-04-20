import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/ceni_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/bureau_model.dart';
import '../../data/models/candidate_model.dart';
import '../../data/models/voter_status_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/bureau_service.dart';
import '../../data/services/election_service.dart';
import '../../data/services/geo_service.dart';
import '../../data/services/vote_service.dart';
import '../../l10n/strings.dart';
import '../../widgets/sawti_widgets.dart';

class CandidatesScreen extends StatefulWidget {
  final String electionId;
  final String electionTitle;
  final String? electionTitleAr;

  const CandidatesScreen({
    super.key,
    required this.electionId,
    required this.electionTitle,
    this.electionTitleAr,
  });

  @override
  State<CandidatesScreen> createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  final _elSvc   = ElectionService();
  final _bureauSvc = BureauService();
  final _geoSvc  = GeoService();
  final _voteSvc = VoteService();
  final _auth    = AuthService();

  List<CandidateModel> _candidates = [];
  bool _loading    = true;
  bool _submitting = false;
  String? _selected;

  // GPS state
  double? _distanceKm;
  BureauModel? _bureau;
  bool _gpsLoading = true;
  bool _gpsValid   = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadCandidates(), _loadGps()]);
  }

  Future<void> _loadCandidates() async {
    try {
      final data = await _elSvc.getCandidates(widget.electionId);
      if (mounted) setState(() { _candidates = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadGps() async {
    final user = _auth.currentUser;
    if (user == null) { setState(() => _gpsLoading = false); return; }

    try {
      final status = await _bureauSvc.getCurrentUserVoterStatus(user.uid);
      if (status == null) { setState(() => _gpsLoading = false); return; }

      final bureau = await _bureauSvc.getBureauById(status.assignedBureauId);
      if (bureau == null) { setState(() => _gpsLoading = false); return; }

      final pos = await _geoSvc.getCurrentLocation();
      final dist = _geoSvc.distanceKm(
        fromLat: pos.latitude, fromLng: pos.longitude,
        toLat: bureau.latitude, toLng: bureau.longitude,
      );

      if (mounted) setState(() {
        _bureau = bureau;
        _distanceKm = dist;
        _gpsValid   = dist <= CeniConstants.maxBureauDistanceKm;
        _gpsLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _gpsLoading = false);
    }
  }

  // ── Dialog de confirmation bilingue ──────────────────
  Future<void> _confirmVote(CandidateModel c) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🗳', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 10),
            Text(S.confirmTitleFr, style: GoogleFonts.instrumentSerif(
              fontSize: 18, color: SC.forest,
            )),
            Text(S.confirmTitleAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'NotoNaskhArabic', fontSize: 16, color: SC.forest,
              )),
            const SizedBox(height: 14),

            // Candidat sélectionné
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SC.successBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA8C8A8)),
              ),
              child: Row(children: [
                CandidateAvatar(name: c.name, size: 42),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name, style: GoogleFonts.dmSans(
                    fontSize: 13, fontWeight: FontWeight.w700, color: SC.ink,
                  )),
                  if (c.nameAr != null)
                    Text(c.nameAr!, textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic', fontSize: 12, color: SC.muted,
                      )),
                  Text(c.party, style: GoogleFonts.dmSans(fontSize: 11, color: SC.muted)),
                ])),
              ]),
            ),
            const SizedBox(height: 10),

            // GPS distance
            if (_distanceKm != null)
              BiHintBox(
                fr: '📍 Distance bureau : ${_distanceKm!.toStringAsFixed(1)} km — ${_gpsValid ? "Validé ✓" : "Hors zone ✗"}',
                ar: 'المسافة من المكتب : ${_distanceKm!.toStringAsFixed(1)} كم — ${_gpsValid ? "مقبول ✓" : "خارج النطاق ✗"}',
                kind: _gpsValid ? HintKind.good : HintKind.bad,
              ),

            // Avertissement irréversible
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9E7),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFF0C060)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(S.confirmWarnFr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 11, color: const Color(0xFF7D5A00), height: 1.6,
                  )),
                const SizedBox(height: 4),
                Text(S.confirmWarnAr,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 11, color: Color(0xFF7D5A00), height: 1.5,
                  )),
              ]),
            ),
            const SizedBox(height: 16),

            // Boutons
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => Navigator.pop(ctx, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: SC.cream,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: SC.border),
                  ),
                  child: Column(children: [
                    Text(S.cancelFr, style: GoogleFonts.dmSans(
                      fontSize: 13, color: SC.muted,
                    )),
                    Text(S.cancelAr,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic', fontSize: 12, color: SC.muted,
                      )),
                  ]),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(
                onTap: () => Navigator.pop(ctx, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: SC.forest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Text(S.confirmFr, style: GoogleFonts.dmSans(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: const Color(0xFFE8F5E9),
                    )),
                    Text(S.confirmAr, style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 12, color: Color(0xFFB8D8B8),
                    )),
                  ]),
                ),
              )),
            ]),
          ]),
        ),
      ),
    );

    if (ok == true) _vote(c);
  }

  Future<void> _vote(CandidateModel c) async {
    final user = _auth.currentUser;
    if (user == null) return;
    setState(() => _submitting = true);
    try {
      final status = await _bureauSvc.getCurrentUserVoterStatus(user.uid);
      if (status == null || !status.eligible) throw Exception(S.errDistFr);
      if (status.hasVoted) throw Exception(S.errAlreadyFr);

      final bureau = await _bureauSvc.getBureauById(status.assignedBureauId);
      if (bureau == null) throw Exception('Bureau introuvable');

      final pos  = await _geoSvc.getCurrentLocation();
      final dist = _geoSvc.distanceKm(
        fromLat: pos.latitude, fromLng: pos.longitude,
        toLat: bureau.latitude, toLng: bureau.longitude,
      );

      if (dist > CeniConstants.maxBureauDistanceKm) {
        throw Exception('${S.errDistFr}\n${S.errDistAr}');
      }

      await _voteSvc.submitVote(
        electionId: widget.electionId,
        candidateId: c.id,
        bureauId: bureau.id,
        gpsLatitude: pos.latitude,
        gpsLongitude: pos.longitude,
        distanceFromBureauKm: dist,
        regionMatch: dist <= CeniConstants.maxBureauDistanceKm,
      );

      if (!mounted) return;
      context.go('/success', extra: {
        'bureauFr': bureau.name,
        'bureauAr': bureau.nameAr ?? bureau.name,
        'distKm':   dist.toStringAsFixed(1),
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
        backgroundColor: SC.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SC.cream,
      body: Column(children: [
        // ── Header avec bouton retour ─────────────────
        Container(
          color: SC.forest,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 18, 14),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFE8F5E9), size: 18),
                  onPressed: () => context.pop(),
                ),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.electionTitle,
                    style: GoogleFonts.instrumentSerif(
                      fontSize: 17, color: const Color(0xFFE8F5E9),
                    )),
                  if (widget.electionTitleAr != null)
                    Text(widget.electionTitleAr!,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 12, color: Color(0x80FFFFFF),
                      )),
                ])),
              ]),
            ),
          ),
        ),

        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: SC.jade))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [

                // ── GPS bar ─────────────────────────────
                if (_gpsLoading)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SC.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: SC.border, width: 1.5),
                    ),
                    child: Row(children: [
                      const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: SC.jade),
                      ),
                      const SizedBox(width: 10),
                      Text('Vérification GPS en cours… تحقق GPS جارٍ…',
                        style: GoogleFonts.dmSans(fontSize: 12, color: SC.muted)),
                    ]),
                  )
                else if (_bureau != null && _distanceKm != null)
                  GpsBar(
                    bureauNameFr: _bureau!.name,
                    bureauNameAr: _bureau!.nameAr ?? _bureau!.name,
                    distanceKm: _distanceKm!,
                    isValid: _gpsValid,
                  ),

                // ── Avertissement hors zone ─────────────
                if (!_gpsLoading && !_gpsValid)
                  BiHintBox(
                    fr: S.errDistFr,
                    ar: S.errDistAr,
                    kind: HintKind.bad,
                  ),

                // ── Badge sécurité ──────────────────────
                BiHintBox(
                  fr: S.secureVoteFr,
                  ar: S.secureVoteAr,
                  kind: HintKind.neutral,
                ),

                // ── Liste candidats ─────────────────────
                ..._candidates.map((c) => _CandidateCard(
                  candidate: c,
                  isSelected: _selected == c.id,
                  isSubmitting: _submitting,
                  gpsValid: _gpsValid || _gpsLoading,
                  onTap: () => setState(() => _selected = c.id),
                  onVote: () => _confirmVote(c),
                )),
              ],
            ),
        ),
      ]),
    );
  }
}

// ── Carte candidat bilingue ───────────────────────────
class _CandidateCard extends StatelessWidget {
  final CandidateModel candidate;
  final bool isSelected;
  final bool isSubmitting;
  final bool gpsValid;
  final VoidCallback onTap;
  final VoidCallback onVote;

  const _CandidateCard({
    required this.candidate,
    required this.isSelected,
    required this.isSubmitting,
    required this.gpsValid,
    required this.onTap,
    required this.onVote,
  });

  static const _colors = [
    [Color(0xFF1A3A1E), Color(0xFFC9A84C)],
    [Color(0xFF185FA5), Color(0xFF378ADD)],
    [Color(0xFF533AB7), Color(0xFF7F77DD)],
    [Color(0xFF7D3C0A), Color(0xFFEF9F27)],
  ];

  @override
  Widget build(BuildContext context) {
    final idx = candidate.name.codeUnitAt(0) % _colors.length;
    final grad = _colors[idx];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SC.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? SC.forest : SC.border,
            width: isSelected ? 2.0 : 1.5,
          ),
        ),
        child: Column(children: [
          Row(children: [
            CandidateAvatar(
              name: candidate.name,
              size: 48,
              gradientColors: grad,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(candidate.name, style: GoogleFonts.dmSans(
                fontSize: 14, fontWeight: FontWeight.w700, color: SC.ink,
              )),
              if (candidate.nameAr != null)
                Text(candidate.nameAr!,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 13, color: SC.muted,
                  )),
              const SizedBox(height: 2),
              Text(candidate.party,
                style: GoogleFonts.dmSans(fontSize: 11, color: SC.muted)),
            ])),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: SC.jade, size: 22),
          ]),

          if (isSelected) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 44,
              child: ElevatedButton(
                onPressed: (isSubmitting || !gpsValid) ? null : onVote,
                child: isSubmitting
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(S.voteForFr, style: GoogleFonts.dmSans(
                        fontSize: 13, fontWeight: FontWeight.w600,
                      )),
                      const SizedBox(width: 8),
                      const Text(S.voteForAr, style: TextStyle(
                        fontFamily: 'NotoNaskhArabic', fontSize: 12,
                      )),
                    ]),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
