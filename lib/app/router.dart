import 'package:go_router/go_router.dart';

import '../features/wedding_invite/presentation/screens/invitation_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const InvitationScreen(),
    ),
  ],
);