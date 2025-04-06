import 'package:flutter/material.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() {
  runApp(const WeddingInviteApp());
}

class WeddingInviteApp extends StatelessWidget {
  const WeddingInviteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nuestra Boda',
      debugShowCheckedModeBanner: false,
      theme: weddingTheme,
      routerConfig: router,
    );
  }
}
