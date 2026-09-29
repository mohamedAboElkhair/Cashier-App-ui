import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:templet/core/routing/app_routes.dart';
import 'package:templet/core/styling/app_assets.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/core/utils/storge_helper.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 250),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final token = await sl<StorgeHelper>().getToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      GoRouter.of(context).pushReplacementNamed(AppRoutes.mainScreen);
    } else {
      GoRouter.of(context).pushReplacementNamed(AppRoutes.loginScreem);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: SvgPicture.asset(
            AppAssets.logoLogIn,
            width: 190,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
