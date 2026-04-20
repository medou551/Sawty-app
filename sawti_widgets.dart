import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════
// SAWTI v2 — Composants partagés bilingues AR+FR
// ═══════════════════════════════════════════════════════

// ── Widget bilingue de base ───────────────────────────
// Affiche texte FR à gauche, AR à droite
class BiLabel extends StatelessWidget {
  final String fr;
  final String ar;
  final double fontSizeFr;
  final double fontSizeAr;

  const BiLabel({
    super.key,
    required this.fr,
    required this.ar,
    this.fontSizeFr = 10,
    this.fontSizeAr = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fr.toUpperCase(), style: GoogleFonts.dmSans(
            fontSize: fontSizeFr, fontWeight: FontWeight.w600,
            letterSpacing: 0.6, color: SC.muted,
          )),
          Text(ar, style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: fontSizeAr, color: SC.muted,
            fontWeight: FontWeight.w500,
          )),
        ],
      ),
    );
  }
}

// ── Header sombre courbé avec branding bilingue ───────
class SawtiHeader extends StatelessWidget {
  final String titleFr;
  final String subtitleFr;
  final String? subtitleAr;
  final String emoji;
  final String brandArSubtitle;

  const SawtiHeader({
    super.key,
    required this.titleFr,
    this.subtitleFr = '',
    this.subtitleAr,
    this.emoji = '🗳',
    this.brandArSubtitle = 'صوتي · لجنتي الانتخابية',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SC.forest,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Logo row
            Row(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: SC.gold,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(child: Text(emoji,
                  style: const TextStyle(fontSize: 17))),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(brandArSubtitle,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: Color(0xFFE8F5E9),
                  )),
                Text('SAWTI · CENI Mauritanie',
                  style: GoogleFonts.dmSans(
                    fontSize: 10, color: const Color(0x66FFFFFF),
                    letterSpacing: 0.3,
                  )),
              ]),
            ]),
            const SizedBox(height: 14),
            // Title
            Text(titleFr,
              style: GoogleFonts.instrumentSerif(
                fontSize: 22, color: const Color(0xFFE8F5E9), height: 1.2,
              )),
            if (subtitleFr.isNotEmpty || subtitleAr != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitleAr != null
                  ? '$subtitleFr · $subtitleAr'
                  : subtitleFr,
                style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 11, color: Color(0x66FFFFFF),
                ),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 18),
        Container(
          height: 22,
          decoration: const BoxDecoration(
            color: SC.cream,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Barre de progression 8 segments (saisie téléphone) ─
class PhoneSegmentBar extends StatelessWidget {
  final int filled;
  final bool isError;

  const PhoneSegmentBar({super.key, required this.filled, this.isError = false});

  @override
  Widget build(BuildContext context) {
    final n = filled.clamp(0, 8);
    final done = n == 8 && !isError;
    final segColor = isError ? SC.error : SC.jade;

    return Row(children: [
      ...List.generate(8, (i) => Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          height: 3,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            color: i < n ? segColor : SC.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
      const SizedBox(width: 6),
      Text(
        done ? '✓' : '$n/8',
        style: GoogleFonts.dmSans(
          fontSize: 10, fontWeight: FontWeight.w600,
          color: isError ? SC.error : done ? SC.sage : SC.muted,
        ),
      ),
    ]);
  }
}

// ── Hint box bilingue (info / ok / erreur) ────────────
enum HintKind { neutral, good, bad }

class BiHintBox extends StatelessWidget {
  final String fr;
  final String ar;
  final HintKind kind;

  const BiHintBox({
    super.key,
    required this.fr,
    required this.ar,
    this.kind = HintKind.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = switch (kind) {
      HintKind.good    => (bg: SC.successBg, border: const Color(0xFFA8C8A8), text: const Color(0xFF2D6A4F)),
      HintKind.bad     => (bg: SC.errorBg,   border: const Color(0xFFDDBCBA), text: const Color(0xFF8B2020)),
      HintKind.neutral => (bg: SC.infoBg,    border: SC.border,               text: SC.muted),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: cfg.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(fr, style: GoogleFonts.dmSans(fontSize: 11, height: 1.6, color: cfg.text)),
        Text(ar,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 11, height: 1.5, color: cfg.text,
          )),
      ]),
    );
  }
}

// ── 6 cases OTP individuelles ─────────────────────────
class OtpInput extends StatefulWidget {
  final void Function(String otp) onComplete;
  const OtpInput({super.key, required this.onComplete});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  String get _full => _ctrls.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final filled = _ctrls[i].text.isNotEmpty;
        final isCurrent = _nodes[i].hasFocus;
        return Container(
          width: 44, height: 54,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _ctrls[i],
            focusNode: _nodes[i],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.dmSans(
              fontSize: 22, fontWeight: FontWeight.w700, color: SC.jade,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: isCurrent
                ? const Color(0xFFF0F7F0)
                : filled ? SC.successBg : SC.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: filled ? SC.jade : SC.border, width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: SC.jade, width: 2),
              ),
            ),
            onChanged: (v) {
              if (v.isEmpty && i > 0) {
                _nodes[i - 1].requestFocus();
              } else if (v.isNotEmpty && i < 5) {
                _nodes[i + 1].requestFocus();
              }
              setState(() {});
              if (_full.length == 6) widget.onComplete(_full);
            },
          ),
        );
      }),
    );
  }
}

// ── Barre GPS bureau de vote ──────────────────────────
class GpsBar extends StatelessWidget {
  final String bureauNameFr;
  final String bureauNameAr;
  final double distanceKm;
  final bool isValid; // dans le rayon autorisé

  const GpsBar({
    super.key,
    required this.bureauNameFr,
    required this.bureauNameAr,
    required this.distanceKm,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SC.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isValid ? const Color(0xFFA8C8A8) : SC.error, width: 1.5,
        ),
      ),
      child: Row(children: [
        // Pulsing dot
        _PulsingDot(color: isValid ? SC.sage : SC.error),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            isValid ? 'Bureau assigné : $bureauNameFr' : 'Trop loin : $bureauNameFr',
            style: GoogleFonts.dmSans(
              fontSize: 11, fontWeight: FontWeight.w600, color: SC.ink,
            ),
          ),
          Text(
            isValid ? 'مكتب التصويت : $bureauNameAr' : 'بعيد جداً : $bureauNameAr',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'NotoNaskhArabic', fontSize: 10, color: SC.muted,
            ),
          ),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            '${distanceKm.toStringAsFixed(1)} km',
            style: GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: isValid ? SC.jade : SC.error,
            ),
          ),
          Text(
            isValid ? '✓ Validé' : '✗ Trop loin',
            style: GoogleFonts.dmSans(fontSize: 9, color: isValid ? SC.sage : SC.error),
          ),
        ]),
      ]),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: widget.color,
          ),
        ),
      ),
    );
  }
}

// ── Avatar initiales candidat ─────────────────────────
class CandidateAvatar extends StatelessWidget {
  final String name;
  final double size;
  final List<Color>? gradientColors;

  const CandidateAvatar({
    super.key,
    required this.name,
    this.size = 46,
    this.gradientColors,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [SC.jade, SC.gold];
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(_initials, style: GoogleFonts.dmSans(
          fontSize: size * 0.3, fontWeight: FontWeight.w700,
          color: Colors.white,
        )),
      ),
    );
  }
}

// ── Bouton bilingue principal ─────────────────────────
class BiButton extends StatelessWidget {
  final String fr;
  final String ar;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const BiButton({
    super.key,
    required this.fr,
    required this.ar,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: onPressed == null ? null : ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: isLoading
          ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(fr, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              Text(ar, style: const TextStyle(
                fontFamily: 'NotoNaskhArabic', fontSize: 13,
              )),
            ]),
      ),
    );
  }
}

// ── Section label bilingue ────────────────────────────
class BiSectionLabel extends StatelessWidget {
  final String fr;
  final String ar;
  const BiSectionLabel({super.key, required this.fr, required this.ar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fr, style: GoogleFonts.dmSans(
            fontSize: 10, fontWeight: FontWeight.w600,
            color: SC.muted, letterSpacing: 0.5,
          )),
          Text(ar, style: const TextStyle(
            fontFamily: 'NotoNaskhArabic', fontSize: 11, color: SC.muted,
          )),
        ],
      ),
    );
  }
}
