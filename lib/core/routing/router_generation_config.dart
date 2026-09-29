import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:templet/core/routing/app_routes.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/core/utils/storge_helper.dart';
import 'package:templet/features/auth_screen/Forgot_password_screen.dart';
import 'package:templet/features/auth_screen/app_loading_screen.dart';
import 'package:templet/features/auth_screen/cubit/auth_cubit.dart';
import 'package:templet/features/auth_screen/login_screen.dart';
import 'package:templet/features/auth_screen/logo_screen.dart';
import 'package:templet/features/auth_screen/register_screen.dart';
import 'package:templet/features/main_screen/main_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.appLoadingScreen,
    redirect: (context, state) async {
      final location = state.uri.path;

      // PUBLIC hosted visitor-pass page (/pass/:token): a visitor opens this
      // from a WhatsApp link with no account. Never force login/redirect for it.
      // if (location.startsWith('${AppRoutes.publicPass}/')) {
      //   return null;
      // }

      final token = await sl<StorgeHelper>().getToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      final isAuthRoute =
          location == AppRoutes.appLoadingScreen ||
          location == AppRoutes.loginScreem ||
          location == AppRoutes.registerScreen ||
          location == AppRoutes.forgotPasswordScreen ||
          location == AppRoutes.logoScreen;

      if (!isLoggedIn) {
        return isAuthRoute ? null : AppRoutes.loginScreem;
      }

      // Security users get a locked-down experience: the scanner is the whole
      // app. Redirect them to the scanner from any other (non-scanner) route so
      // they cannot reach the normal app screens.
      final role = (await sl<StorgeHelper>().getrole())?.trim().toLowerCase();
      // final isSecurity = role == 'security';
      // if (isSecurity) {
      //   return location == AppRoutes.securityScanner
      //       ? null
      //       : AppRoutes.securityScanner;
      // }

      if (location == AppRoutes.loginScreem ||
          location == AppRoutes.registerScreen) {
        return AppRoutes.mainScreen;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.appLoadingScreen,
        path: AppRoutes.appLoadingScreen,
        builder: (context, state) => const AppLoadingScreen(),
      ),
      GoRoute(
        name: AppRoutes.logoScreen,
        path: AppRoutes.logoScreen,
        builder: (context, state) => LogoScreen(),
      ),

      GoRoute(
        name: AppRoutes.loginScreem,
        path: AppRoutes.loginScreem,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.forgotPasswordScreen,
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => ForgotPasswordScreen(),
      ),

      // GoRoute(
      //   name: AppRoutes.manageProjectScreens,
      //   path: AppRoutes.manageProjectScreens,
      //   builder: (context, state) {
      //     final projectId =
      //         state.pathParameters['projectId'] ??
      //         state.uri.queryParameters['projectId'] ??
      //         (state.extra is String ? state.extra as String : null);
      //     return BlocProvider(
      //       create: (context) => sl<ManageProjectCubit>(),
      //       child: ManageProjectScreens(projectId: projectId),
      //     );
      //   },
      // ),

      // Post-login re-agree gate. The property id / version / sections are
      // passed via `extra` from the login screen (this screen is transient and
      // not deep-linkable). If the property id is missing we cannot post a
      // consent, so fall through to the main app rather than crash.
      // GoRoute(
      //   name: AppRoutes.termsReagreeScreen,
      //   path: AppRoutes.termsReagreeScreen,
      //   builder: (context, state) {
      //     final extra = state.extra;
      //     final data = extra is Map ? extra : const {};
      //     final propertyId = data['propertyId'];
      //     if (propertyId is! int) {
      //       return MainScreen();
      //     }
      //     return TermsReagreeScreen(
      //       propertyId: propertyId,
      //       termsVersion: data['termsVersion'] is int
      //           ? data['termsVersion'] as int
      //           : null,
      //       sections: data['sections'] is List
      //           ? data['sections'] as List
      //           : null,
      //     );
      //   },
      // ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        builder: (context, state) => MainScreen(),
      ),
      // GoRoute(
      //   name: AppRoutes.securityScanner,
      //   path: AppRoutes.securityScanner,
      //   builder: (context, state) => const SecurityScannerScreen(),
      // ),
      // Stage 2: owner creates a visitor pass. Optional initial unit id is
      // passed via `extra` (String) so the dropdown can preselect it.
      // GoRoute(
      //   name: AppRoutes.createVisitorPass,
      //   path: AppRoutes.createVisitorPass,
      //   builder: (context, state) {
      //     final initialUnitId = state.extra is String
      //         ? state.extra as String
      //         : null;
      //     return CreateVisitorPassScreen(initialUnitId: initialUnitId);
      //   },
      // ),
      // Stage 2: management access-log report.
      //   GoRoute(
      //   name: AppRoutes.serviceTypesScreen,
      //   path: AppRoutes.serviceTypesScreen,
      //   builder: (context, state) => MultiBlocProvider(
      //     providers: [
      //       BlocProvider(create: (_) => sl<ServiceTypesCubit>()),
      //       BlocProvider(create: (_) => sl<PropertyCubit>()),
      //     ],
      //     child: const ServiceTypesScreen(),
      //   ),
      // ),
      // Property Finance: monthly report, bank accounts, income entries and
      // investment certificates. Management-only (Admin/Manager/Supervisor).
      // A certificate's payout schedule is reached by tapping a certificate
      // on investmentCertificatesScreen — that pushes a plain Navigator
      // route reusing the same FinanceLedgerCubit instance rather than a
      // fifth top-level app route (see InvestmentCertificatesScreen's doc).
      // suggestion routes
      // GoRoute(
      //   name: AppRoutes.suggestionDetailsScreen,
      //   path: AppRoutes.suggestionDetailsScreen,
      //   builder: (context, state) {
      //     SuggestionModel suggestionModel = state.extra as SuggestionModel;
      //     return BlocProvider(
      //       create: (context) => sl<SuggestionCubit>(),
      //       child: SuggestionDetailsScreen(suggestionModel: suggestionModel),
      //     );
      //   },
      // ),
    ],
  );
}
