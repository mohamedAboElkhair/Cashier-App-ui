import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/core/utils/service_locator.dart';
import 'package:templet/features/auth_screen/accout_user_screen.dart';
import 'package:templet/features/auth_screen/cubit/auth_cubit.dart';
import 'package:templet/features/auth_screen/users_screen.dart';
import 'package:templet/features/widgets/app_br_widget.dart';
import 'package:templet/generated/locale_keys.g.dart';

class _NavigationDestination {
  const _NavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.screen,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget screen;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static final List<_NavigationDestination> _destinations = [
    // _NavigationDestination(
    //   label: LocaleKeys.nav_home,
    //   icon: Icon(Icons.home_outlined),
    //   selectedIcon: Icon(Icons.home, color: AppColore.primaryColor),
    //   screen: MultiBlocProvider(
    //     providers: [
    //       BlocProvider(create: (_) => sl<ManageProjectCubit>()),
    //       BlocProvider(create: (_) => sl<StorageCubit>()..fetchStorage()),
    //     ],
    //     child: HomeScreen(),
    //   ),
    // ),
    _NavigationDestination(
      label: LocaleKeys.userinfo_users,
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people, color: AppColore.welletFlap),
      screen: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthCubit>()),
          // BlocProvider(create: (_) => sl<StorageCubit>()..fetchStorage()),
        ],
        child: UsersScreen(),
      ),
    ),
    // _NavigationDestination(
    //   label: LocaleKeys.userinfo_users,
    //   icon: Icon(Icons.people_outline),
    //   selectedIcon: Icon(Icons.people, color: AppColore.welletFlap),
    //   screen: Center(child: Text('Users')),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _destinations.map((d) => d.screen).toList(),
      ),
      bottomNavigationBar: AppBrWidget(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: d.icon,
                selectedIcon: d.selectedIcon,
                label: d.label.tr(),
              ),
            )
            .toList(),
      ),
    );
  }
}
