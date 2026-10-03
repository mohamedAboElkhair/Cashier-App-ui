import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:templet/core/constants/app_constants.dart';
import 'package:templet/core/networking/dio_helper.dart';
import 'package:templet/core/routing/app_routes.dart';
import 'package:templet/core/routing/router_generation_config.dart';
import 'package:templet/core/styling/app_themes.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/core/utils/storge_helper.dart';
import 'package:templet/core/utils/url_strategy_stub.dart';
import 'package:templet/generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kIsWeb) usePathUrlStrategy();
  setupServiceLocator();

  // Auto-logout when the server rejects the stored token.
  // Covers both HTTP 401 and Laravel's quirky 200 + {"error":"Token not valid"}.
  sl<DioHelper>().setUnauthorizedHandler(() async {
    await sl<StorgeHelper>().deleteToken();
    RouterGenerationConfig.goRouter.go(AppRoutes.loginScreem);
  });

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      assetLoader: CodegenLoader(),
      fallbackLocale: Locale('ar'),
      startLocale: Locale(AppConstants.lang),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Manage your money',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: RouterGenerationConfig.goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
