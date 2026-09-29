import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/features/auth_screen/cubit/auth_cubit.dart';
import 'package:templet/features/auth_screen/cubit/auth_state.dart';
import 'package:templet/features/auth_screen/models/user_model.dart';
import 'package:templet/features/widgets%20copy/app_bar_widget.dart';
import 'package:templet/features/widgets%20copy/loading_widget.dart';
import 'package:templet/features/widgets%20copy/primay_button_widget.dart';
import 'package:templet/generated/locale_keys.g.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserModel>? _cachedUsers;
  bool _isManualRefreshing = false;
  String _selectedRole = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    await context.read<AuthCubit>().getAllUsers();
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '-';
    try {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (_) {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  void _showUserDetailsBottomSheet(UserModel user) {
    final isAr = context.locale.languageCode == 'ar';
    final isVerified = user.emailVerifiedAt != null;
    final role = (user.role ?? 'USER').toUpperCase();
    final roleColor = _getRoleColor(user.role);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                const SizedBox(height: 20),

                // Header with avatar & name
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [roleColor.withValues(alpha: 0.8), roleColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(user.name),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? (isAr ? 'بدون اسم' : 'No Name'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: roleColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: roleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 18),

                // Details list
                _buildModalDetailRow(
                  icon: Icons.tag_rounded,
                  label: isAr ? 'معرف المستخدم (ID)' : 'User ID',
                  value: user.id != null ? '#${user.id}' : '-',
                ),
                const SizedBox(height: 14),
                _buildModalDetailRow(
                  icon: Icons.email_outlined,
                  label: isAr ? 'البريد الإلكتروني' : 'Email Address',
                  value: user.email ?? '-',
                  isCopyable: true,
                ),
                const SizedBox(height: 14),
                _buildModalDetailRow(
                  icon: Icons.admin_panel_settings_outlined,
                  label: isAr ? 'الدور / الصلاحية' : 'Role',
                  value: role,
                ),
                const SizedBox(height: 14),
                _buildModalDetailRow(
                  icon: isVerified
                      ? Icons.verified_user_outlined
                      : Icons.pending_outlined,
                  label: isAr ? 'حالة التوثيق' : 'Verification Status',
                  value: isVerified
                      ? (isAr ? 'موثق' : 'Verified')
                      : (isAr ? 'غير موثق' : 'Unverified'),
                  valueColor: isVerified
                      ? const Color(0xFF10B981)
                      : Colors.amber.shade800,
                ),
                const SizedBox(height: 14),
                _buildModalDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: isAr ? 'تاريخ الإنشاء' : 'Created At',
                  value: _formatDate(user.createdAt),
                ),
                const SizedBox(height: 14),
                _buildModalDetailRow(
                  icon: Icons.update_outlined,
                  label: isAr ? 'آخر تحديث' : 'Updated At',
                  value: _formatDate(user.updatedAt),
                ),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColore.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    child: Text(
                      isAr ? 'إغلاق' : 'Close',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isCopyable = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const Spacer(),
        if (isCopyable && value != '-')
          IconButton(
            icon: const Icon(
              Icons.copy_rounded,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.locale.languageCode == 'ar'
                        ? 'تم نسخ البريد الإلكتروني'
                        : 'Email copied to clipboard',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Copy',
          ),
      ],
    );
  }

  Color _getRoleColor(String? role) {
    final r = (role ?? '').toLowerCase().trim();
    if (r == 'admin' || r == 'مدير' || r == 'مسؤول') {
      return const Color(0xFF2563EB); // Royal Blue
    } else if (r == 'manager' || r == 'مشرف') {
      return const Color(0xFF7C3AED); // Purple
    } else if (r == 'employee' || r == 'موظف') {
      return const Color(0xFF0D9488); // Teal
    } else {
      return const Color(0xFF059669); // Emerald Green
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AllUsersSuccessState) {
            if (_isManualRefreshing) {
              _isManualRefreshing = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAr
                        ? 'تم تحديث قائمة المستخدمين بنجاح'
                        : 'Users list refreshed successfully',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
            setState(() {
              _cachedUsers = state.users;
            });
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
          final isLoading = state is AuthLoadingState && _cachedUsers == null;
          final isRefreshing =
              state is AuthLoadingState && _cachedUsers != null;
          final isError = state is AuthErrorState && _cachedUsers == null;
          final errorMessage = state is AuthErrorState
              ? state.errorMessage
              : '';

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isManualRefreshing = true;
              });
              await _fetchUsers();
            },
            color: AppColore.primaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                AppBarWidget(
                  title: LocaleKeys.userinfo_users.tr(),
                  showLanguageAction: true,
                  showRefreshAction: true,
                  onRefresh: () async {
                    setState(() {
                      _isManualRefreshing = true;
                    });
                    await _fetchUsers();
                  },
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
                    hasScrollBody: false,
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
                              onPressed: _fetchUsers,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (_cachedUsers != null)
                  _buildUsersContent(_cachedUsers!)
                else
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(
                      title: isAr ? 'لا يوجد مستخدمين' : 'No users found',
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsersContent(List<UserModel> allUsers) {
    final isAr = context.locale.languageCode == 'ar';

    // Calculate metrics
    final totalCount = allUsers.length;
    int adminCount = 0;
    int regularUserCount = 0;
    int verifiedCount = 0;

    for (final u in allUsers) {
      final role = (u.role ?? '').toLowerCase().trim();
      if (role == 'admin' || role == 'مدير' || role == 'مسؤول') {
        adminCount++;
      } else {
        regularUserCount++;
      }
      if (u.emailVerifiedAt != null) {
        verifiedCount++;
      }
    }

    // Filter users based on role and search query
    final filteredUsers = allUsers.where((u) {
      final role = (u.role ?? '').toLowerCase().trim();

      if (_selectedRole == 'admin' &&
          role != 'admin' &&
          role != 'مدير' &&
          role != 'مسؤول') {
        return false;
      }
      if (_selectedRole == 'user' &&
          (role == 'admin' || role == 'مدير' || role == 'مسؤول')) {
        return false;
      }
      if (_selectedRole == 'verified' && u.emailVerifiedAt == null) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (u.name ?? '').toLowerCase();
        final email = (u.email ?? '').toLowerCase();
        final id = u.id?.toString() ?? '';
        final roleStr = (u.role ?? '').toLowerCase();
        return name.contains(q) ||
            email.contains(q) ||
            id.contains(q) ||
            roleStr.contains(q);
      }
      return true;
    }).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Metrics Row
              _buildMetricsRow(
                totalCount: totalCount,
                adminCount: adminCount,
                userCount: regularUserCount,
                verifiedCount: verifiedCount,
                isAr: isAr,
              ),
              const SizedBox(height: 16),

              // Search Bar
              _buildSearchBar(isAr),
              const SizedBox(height: 12),

              // Filter Chips
              _buildFilterChips(
                total: totalCount,
                admins: adminCount,
                users: regularUserCount,
                verified: verifiedCount,
                isAr: isAr,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // Users List
        if (filteredUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 52,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAr
                        ? 'لا يوجد مستخدمين يطابقون معايير البحث'
                        : 'No users matching the search criteria',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildUserCard(filteredUsers[index], isAr);
              },
            ),
          ),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildMetricsRow({
    required int totalCount,
    required int adminCount,
    required int userCount,
    required int verifiedCount,
    required bool isAr,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: isAr ? 'الكل' : 'All Users',
            count: '$totalCount',
            icon: Icons.people_alt_outlined,
            color: AppColore.primaryColor,
            bgColor: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: isAr ? 'المسؤولين' : 'Admins',
            count: '$adminCount',
            icon: Icons.shield_outlined,
            color: const Color(0xFF2563EB),
            bgColor: const Color(0xFFDBEAFE),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: isAr ? 'المستخدمين' : 'Users',
            count: '$userCount',
            icon: Icons.person_outline_rounded,
            color: const Color(0xFF059669),
            bgColor: const Color(0xFFD1FAE5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: isAr ? 'موثق' : 'Verified',
            count: '$verifiedCount',
            icon: Icons.check_circle_outline_rounded,
            color: const Color(0xFF10B981),
            bgColor: const Color(0xFFECFDF5),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isAr) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim();
          });
        },
        decoration: InputDecoration(
          hintText: isAr
              ? 'بحث بالاسم، البريد أو المعرف...'
              : 'Search by name, email or ID...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColore.primaryColor,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFilterChips({
    required int total,
    required int admins,
    required int users,
    required int verified,
    required bool isAr,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(label: isAr ? 'الكل' : 'All', count: total, value: 'all'),
          const SizedBox(width: 8),
          _buildChip(
            label: isAr ? 'المسؤولين' : 'Admins',
            count: admins,
            value: 'admin',
            activeColor: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isAr ? 'المستخدمين' : 'Users',
            count: users,
            value: 'user',
            activeColor: const Color(0xFF059669),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isAr ? 'موثق' : 'Verified',
            count: verified,
            value: 'verified',
            activeColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required int count,
    required String value,
    Color activeColor = AppColore.primaryColor,
  }) {
    final isSelected = _selectedRole == value;
    return InkWell(
      onTap: () => setState(() => _selectedRole = value),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user, bool isAr) {
    final initials = _getInitials(user.name);
    final roleColor = _getRoleColor(user.role);
    final role = (user.role ?? 'USER').toUpperCase();
    final isVerified = user.emailVerifiedAt != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showUserDetailsBottomSheet(user),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Name/Email + Role Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar Circle
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [roleColor.withValues(alpha: 0.8), roleColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name and Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.name ?? (isAr ? 'بدون اسم' : 'No Name'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 16,
                                  color: Color(0xFF10B981),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.email ?? '-',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: roleColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom Row: ID + Date + View Arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User ID
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 15,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.id != null ? 'ID: #${user.id}' : 'ID: -',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Created At
                    if (user.createdAt != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('yyyy-MM-dd').format(user.createdAt!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                    // Arrow Icon
                    Row(
                      children: [
                        Text(
                          isAr ? 'التفاصيل' : 'Details',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColore.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          isAr
                              ? Icons.keyboard_arrow_left_rounded
                              : Icons.keyboard_arrow_right_rounded,
                          size: 18,
                          color: AppColore.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required String title, required IconData icon}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          PrimayButtonWidget(
            buttonText: LocaleKeys.buildinginfo_retry.tr(),
            width: 160,
            onPressed: _fetchUsers,
          ),
        ],
      ),
    );
  }
}
