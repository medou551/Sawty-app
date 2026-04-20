import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/elections/elections_screen.dart';
import '../../features/candidates/candidates_screen.dart';
import '../../features/sig/assigned_bureau_screen.dart';
import '../../features/sig/bureau_map_screen.dart';
import '../../features/success/success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return OtpScreen(
          phoneNumber: data['phoneNumber'] as String,
          verificationId: data['verificationId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/elections',
      builder: (context, state) => const ElectionsScreen(),
    ),
    GoRoute(
      path: '/candidates',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return CandidatesScreen(
          electionId: data['electionId'] as String,
          electionTitle: data['electionTitle'] as String,
        );
      },
    ),
    GoRoute(
      path: '/sig/map',
      builder: (context, state) => const BureauMapScreen(),
    ),
    GoRoute(
      path: '/sig/assigned',
      builder: (context, state) => const AssignedBureauScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessScreen(),
    ),
  ],
);