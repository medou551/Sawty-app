import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class AuthService {
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await supabase.auth.signInWithOtp(phone: phoneNumber);
      onCodeSent(phoneNumber); // on réutilise le numéro comme jeton de session
    } on AuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError('Erreur envoi OTP : $e');
    }
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final response = await supabase.auth.verifyOTP(
      phone: verificationId,
      token: smsCode,
      type: OtpType.sms,
    );
    if (response.user == null) {
      throw Exception('Code OTP incorrect ou expiré.');
    }
  }

  User? get currentUser => supabase.auth.currentUser;
  String? get currentUserId => supabase.auth.currentUser?.id;
  Future<void> signOut() => supabase.auth.signOut();
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
