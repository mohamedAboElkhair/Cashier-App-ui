import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:templet/core/constants/app_constants.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/generated/locale_keys.g.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.onRefresh,
    this.showRefreshAction = true,
    this.showLanguageAction = true,
    this.showMenuAction = false,
    this.onMenuPressed,
    this.trailingActions,
  });

  final String title;
  final VoidCallback? onRefresh;
  final bool showRefreshAction;
  final bool showLanguageAction;
  final bool showMenuAction;
  final VoidCallback? onMenuPressed;
  final List<Widget>? trailingActions;

  @override
  Widget build(BuildContext context) {
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final shouldShowMenu = showMenuAction || hasDrawer;
    final canPop = Navigator.canPop(context);

    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      centerTitle: true,
      elevation: 5,
      expandedHeight: 60,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      leading: shouldShowMenu
          ? IconButton(
              onPressed:
                  onMenuPressed ??
                  () {
                    Scaffold.maybeOf(context)?.openDrawer();
                  },
              icon: const Icon(Icons.menu, color: Colors.white),
              tooltip: 'Menu',
            )
          : canPop
          ? IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              tooltip: 'Back',
            )
          : null,
      backgroundColor: AppColore.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColore.primaryColor,
                AppColore.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (showRefreshAction)
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
            tooltip: LocaleKeys.settings_refresh.tr(),
          ),
        if (showLanguageAction)
          IconButton(
            onPressed: () {
              if (context.locale.languageCode == 'en') {
                context.setLocale(const Locale('ar'));
              } else {
                context.setLocale(const Locale('en'));
              }
              AppConstants.lang = context.locale.languageCode;
            },
            icon: const Icon(Icons.language, size: 28, color: Colors.white),
            tooltip: LocaleKeys.settings_change_language.tr(),
          ),
        ...?trailingActions,
        const SizedBox(width: 8),
      ],
    );
  }
}
