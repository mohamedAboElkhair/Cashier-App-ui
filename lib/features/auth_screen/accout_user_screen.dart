import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/features/auth_screen/cubit/auth_cubit.dart';
import 'package:templet/features/auth_screen/cubit/auth_state.dart';
import 'package:templet/features/auth_screen/models/user_model.dart';
import 'package:templet/features/widgets/app_bar_widget.dart';
import 'package:templet/features/widgets/loading_widget.dart';
import 'package:templet/features/widgets/primay_button_widget.dart';
import 'package:templet/features/widgets/text_field_widget.dart';
import 'package:templet/generated/locale_keys.g.dart';

class AccoutUserScreen extends StatefulWidget {
  const AccoutUserScreen({super.key});

  @override
  State<AccoutUserScreen> createState() => _AccoutUserScreenState();
}

class _AccoutUserScreenState extends State<AccoutUserScreen> {
  UserModel? _cachedUser;
  bool _isManualRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
    await context.read<AuthCubit>().getUserAcc();
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return LocaleKeys.home_not_available.tr();
    try {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (_) {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  void _showEditProfileDialog(UserModel user) {
    final nameController = TextEditingController(text: user.name ?? '');
    final emailController = TextEditingController(text: user.email ?? '');
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.userinfo_edit_user_profile.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.auth_name.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFieldWidget(
                      controller: nameController,
                      hintText: LocaleKeys.userinfo_please_enter_your_name.tr(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.userinfo_please_enter_your_name
                              .tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.auth_email.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFieldWidget(
                      controller: emailController,
                      hintText: LocaleKeys.userinfo_please_enter_your_email
                          .tr(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.userinfo_please_enter_your_email
                              .tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.auth_password.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFieldWidget(
                      controller: passwordController,
                      isPassword: true,
                      hintText: LocaleKeys
                          .userinfo_new_password_leave_empty_to_keep_current
                          .tr(),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoadingState;
                        return PrimayButtonWidget(
                          buttonText: LocaleKeys.userinfo_save_changes.tr(),
                          isLoading: isLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().updateUser(
                                id: user.id ?? 0,
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              Navigator.pop(bottomSheetContext);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            LocaleKeys.buildinginfo_Logout.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            LocaleKeys.buildinginfo_are_you_sure_you_want_to_log_out.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                LocaleKeys.userinfo_cancel.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColore.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthCubit>().Logout();
                context.go('/login');
              },
              child: Text(
                LocaleKeys.buildinginfo_yes_logout.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AccUserSuccessState) {
            if (_isManualRefreshing) {
              _isManualRefreshing = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.locale.languageCode == 'ar'
                        ? 'تم تحديث بيانات الحساب بنجاح'
                        : 'User info refreshed successfully',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
            setState(() {
              _cachedUser = state.user;
            });
          } else if (state is AuthGetUserSuccessState) {
            // Support legacy state as fallback
            _fetchUserData();
          } else if (state is AuthUpdateUserSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.userinfo_user_info_updated_successfully.tr(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            _fetchUserData();
          } else if (state is AuthErrorState) {
            _isManualRefreshing = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColore.redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState && _cachedUser == null;
          final isRefreshing = state is AuthLoadingState && _cachedUser != null;
          final isError = state is AuthErrorState && _cachedUser == null;
          final errorMessage = state is AuthErrorState
              ? state.errorMessage
              : '';

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isManualRefreshing = true;
              });
              await _fetchUserData();
            },
            color: AppColore.primaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                AppBarWidget(
                  title: LocaleKeys.navscreen_account.tr(),
                  showLanguageAction: true,
                  showRefreshAction: true,
                  onRefresh: () async {
                    setState(() {
                      _isManualRefreshing = true;
                    });
                    await _fetchUserData();
                  },
                  trailingActions: _cachedUser != null
                      ? [
                          IconButton(
                            onPressed: () => _showEditProfileDialog(_cachedUser!),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            tooltip: LocaleKeys.userinfo_edit_user_profile.tr(),
                          ),
                          IconButton(
                            onPressed: _showLogoutDialog,
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            tooltip: LocaleKeys.buildinginfo_Logout.tr(),
                          ),
                        ]
                      : null,
                ),
                if (isRefreshing)
                  const SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      color: AppColore.primaryColor,
                      backgroundColor: Color(0xFFEFF6FF),
                      minHeight: 3,
                    ),
                  ),
                if (isLoading)
                  const SliverFillRemaining(
                    child: Center(child: LoadingWidget()),
                  )
                else if (isError)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 64,
                              color: AppColore.redColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 24),
                            PrimayButtonWidget(
                              buttonText: LocaleKeys.buildinginfo_retry.tr(),
                              width: 180,
                              onPressed: _fetchUserData,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (_cachedUser != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeaderCard(_cachedUser!),
                          const SizedBox(height: 20),
                          _buildAccountDetailsCard(_cachedUser!),
                          const SizedBox(height: 20),
                          _buildSystemMetadataCard(_cachedUser!),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_off_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            LocaleKeys.userinfo_no_user_found.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          PrimayButtonWidget(
                            buttonText: LocaleKeys.buildinginfo_retry.tr(),
                            width: 160,
                            onPressed: _fetchUserData,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeaderCard(UserModel user) {
    final initials = _getInitials(user.name);
    final roleText = (user.role ?? 'USER').toUpperCase();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name ?? LocaleKeys.userinfo_full_name.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    roleText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetailsCard(UserModel user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColore.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColore.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.userinfo_user_details.tr(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            label: LocaleKeys.userinfo_full_name.tr(),
            value: user.name ?? '-',
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: LocaleKeys.userinfo_email.tr(),
            value: user.email ?? '-',
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.admin_panel_settings_outlined,
            label: LocaleKeys.userinfo_user_role.tr(),
            value: (user.role ?? 'User').toUpperCase(),
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.tag_rounded,
            label: LocaleKeys.buildinginfo_user_id.tr(),
            value: user.id != null ? '#${user.id}' : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMetadataCard(UserModel user) {
    final isVerified = user.emailVerifiedAt != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.settings_account_settings.tr(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isVerified
                        ? Icons.check_circle_outline
                        : Icons.pending_outlined,
                    size: 20,
                    color: isVerified
                        ? const Color(0xFF10B981)
                        : Colors.amber.shade700,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    LocaleKeys.suppliers_status.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isVerified
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isVerified ? 'Verified' : 'Unverified',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isVerified
                        ? const Color(0xFF10B981)
                        : Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Created At',
            value: _formatDate(user.createdAt),
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            icon: Icons.update_outlined,
            label: 'Last Updated',
            value: _formatDate(user.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
