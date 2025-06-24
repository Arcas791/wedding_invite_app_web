import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'app/router.dart';

void main() {
  runApp(const WeddingInviteApp());
}

class WeddingInviteApp extends StatelessWidget {
  const WeddingInviteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nuestra Boda',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
