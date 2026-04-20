// ═══════════════════════════════════════════════════════
// SAWTI v2 — Chaînes bilingues (Arabe + Français)
// Adapté à la terminologie officielle CENI Mauritanie
// ═══════════════════════════════════════════════════════

class S {
  // ── App générale ──────────────────────────────────────
  static const appNameFr   = 'SAWTI';
  static const appNameAr   = 'صوتي';
  static const ceniFullFr  = 'Commission Électorale Nationale Indépendante';
  static const ceniFullAr  = 'اللجنة الوطنية المستقلة للانتخابات';
  static const countryFr   = 'République Islamique de Mauritanie';
  static const countryAr   = 'الجمهورية الإسلامية الموريتانية';

  // ── Login ─────────────────────────────────────────────
  static const loginTitleFr   = 'Vote électronique\nsécurisé';
  static const loginTitleAr   = 'التصويت الإلكتروني\nالآمن';
  static const phoneLabelFr   = 'Numéro de téléphone';
  static const phoneLabelAr   = 'رقم الهاتف';
  static const nniLabelFr     = 'NNI — Numéro National d\'Identification';
  static const nniLabelAr     = 'الرقم الوطني للتعريف';
  static const nniHintFr      = '10 chiffres';
  static const nniHintAr      = '١٠ أرقام';
  static const nameLabelFr    = 'Nom complet';
  static const nameLabelAr    = 'الاسم الكامل';
  static const birthLabelFr   = 'Année de naissance';
  static const birthLabelAr   = 'سنة الميلاد';
  static const wilayaLabelFr  = 'Wilaya';
  static const wilayaLabelAr  = 'الولاية';
  static const sendOtpFr      = 'Recevoir le code OTP';
  static const sendOtpAr      = 'إرسال رمز التحقق';
  static const securityFr     = '🔒 Chiffrement AES-256-GCM · Données sécurisées';
  static const securityAr     = 'البيانات مشفّرة ومحمية';

  // ── OTP ──────────────────────────────────────────────
  static const otpTitleFr     = 'Code de vérification';
  static const otpTitleAr     = 'رمز التحقق';
  static const otpSubFr       = 'Saisissez le code à 6 chiffres reçu par SMS.';
  static const otpSubAr       = 'أدخل الرمز المكوّن من 6 أرقام المُرسَل عبر الرسائل القصيرة';
  static const otpValidateFr  = 'Valider le code';
  static const otpValidateAr  = 'تأكيد الرمز';
  static const otpResendFr    = 'Renvoyer';
  static const otpResendAr    = 'إعادة إرسال';
  static const otpSecurityFr  = '🛡 Ne partagez jamais ce code. La CENI ne vous le demandera jamais.';
  static const otpSecurityAr  = 'لا تشارك هذا الرمز مع أي شخص. اللجنة لن تطلبه منك أبداً.';

  // ── Élections ─────────────────────────────────────────
  static const electTitleFr   = 'Élections en cours';
  static const electTitleAr   = 'الانتخابات الجارية';
  static const electSubFr     = 'Participez à la démocratie';
  static const electSubAr     = 'شارك في الديمقراطية الموريتانية';
  static const activeFr       = 'ACTIVES';
  static const activeAr       = 'نشطة';
  static const comingSoonFr   = 'À VENIR';
  static const comingSoonAr   = 'قادمة';
  static const activeBadgeFr  = 'Active';
  static const soonBadgeFr    = 'Bientôt';

  // ── Candidats ─────────────────────────────────────────
  static const candTitleFr    = 'Choisissez votre candidat';
  static const candTitleAr    = 'اختر مرشحك';
  static const voteForFr      = 'Voter pour ce candidat';
  static const voteForAr      = 'التصويت لهذا المرشح';
  static const secureVoteFr   = '🔒 Vote chiffré AES-256-GCM · Anonyme · Définitif';
  static const secureVoteAr   = 'صوتك مشفّر وسري ونهائي';
  static const gpsAssignedFr  = 'Bureau assigné';
  static const gpsAssignedAr  = 'مكتب التصويت المخصص';

  // ── Confirmation ─────────────────────────────────────
  static const confirmTitleFr = 'Confirmer votre vote ?';
  static const confirmTitleAr = 'هل تؤكد صوتك؟';
  static const confirmWarnFr  = '⚠ Cette action est irréversible.\nVotre vote sera chiffré et totalement anonyme.';
  static const confirmWarnAr  = 'هذا الإجراء لا يمكن التراجع عنه. صوتك مشفّر وسري تماماً.';
  static const cancelFr       = 'Annuler';
  static const cancelAr       = 'إلغاء';
  static const confirmFr      = 'Confirmer ✓';
  static const confirmAr      = 'تأكيد';

  // ── Succès / Reçu ─────────────────────────────────────
  static const successTitleFr  = 'Vote enregistré !';
  static const successTitleAr  = 'تم تسجيل صوتك!';
  static const successSubFr    = 'Votre voix a été comptabilisée de façon sécurisée et anonyme.';
  static const successSubAr    = 'تمّ احتساب صوتك بصورة آمنة وسرية';
  static const receiptTitleFr  = 'REÇU OFFICIEL CENI';
  static const receiptTitleAr  = 'إيصال رسمي للجنة الانتخابية';
  static const downloadPdfFr   = 'Télécharger le reçu PDF';
  static const downloadPdfAr   = 'تحميل الإيصال بصيغة PDF';
  static const backToVoteFr    = 'Retour aux élections';
  static const backToVoteAr    = 'العودة إلى الانتخابات';

  // ── Erreurs ───────────────────────────────────────────
  static const errPhone8Fr    = 'Le numéro doit contenir exactement 8 chiffres';
  static const errPhone8Ar    = 'يجب أن يتكون الرقم من 8 أرقام بالضبط';
  static const errBadPrefixFr = 'Indicatif invalide pour la Mauritanie';
  static const errBadPrefixAr = 'بادئة الرقم غير صالحة في موريتانيا';
  static const errNni10Fr     = 'Le NNI doit contenir exactement 10 chiffres';
  static const errNni10Ar     = 'يجب أن يتكون الرقم الوطني من 10 أرقام بالضبط';
  static const errAgeMinFr    = 'Vous devez avoir au moins 18 ans pour voter';
  static const errAgeMinAr    = 'يجب أن يكون عمرك 18 سنة على الأقل للتصويت';
  static const errAlreadyFr   = 'Vous avez déjà voté pour cette élection';
  static const errAlreadyAr   = 'لقد صوّتت مسبقاً في هذه الانتخابات';
  static const errGpsFr       = 'Impossible de vérifier votre position GPS';
  static const errGpsAr       = 'تعذّر التحقق من موقعك الجغرافي';
  static const errDistFr      = 'Vous êtes trop loin de votre bureau de vote assigné';
  static const errDistAr      = 'أنت بعيد جداً عن مكتب التصويت المخصص لك';

  // ── Nav ──────────────────────────────────────────────
  static const navElectionsFr = 'Élections';
  static const navElectionsAr = 'الانتخابات';
  static const navBureauFr    = 'Mon bureau';
  static const navBureauAr    = 'مكتبي';
  static const navProfileFr   = 'Profil';
  static const navProfileAr   = 'ملفي';
}
