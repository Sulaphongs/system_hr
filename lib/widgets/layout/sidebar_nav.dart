import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem(this.label, this.icon, this.route);
}

const _navItems = [
  _NavItem(AppStrings.navDashboard, Icons.dashboard_rounded, '/dashboard'),
  _NavItem(AppStrings.navEmployees, Icons.people_rounded, '/employees'),
  _NavItem(AppStrings.navPositions, Icons.work_rounded, '/positions'),
  _NavItem(AppStrings.navMilitaryRanks, Icons.military_tech_rounded, '/military-ranks'),
  _NavItem(AppStrings.navOrgChart, Icons.account_tree_rounded, '/org-chart'),
  _NavItem(AppStrings.navFinance, Icons.account_balance_wallet_rounded, '/finance'),
  _NavItem(AppStrings.navPayroll, Icons.payments_rounded, '/payroll'),
  _NavItem(AppStrings.navReports, Icons.bar_chart_rounded, '/reports'),
  _NavItem(AppStrings.navSettings, Icons.settings_rounded, '/settings'),
];

class SidebarNav extends StatelessWidget {
  final String currentRoute;

  const SidebarNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 56,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.appTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  AppStrings.appSubtitle,
                  style: TextStyle(
                    color: AppColors.sidebarText.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: _navItems.map((item) {
                final isActive = currentRoute.startsWith(item.route);
                return _SidebarTile(
                  item: item,
                  isActive: isActive,
                  onTap: () => context.go(item.route),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.sidebarActive.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border(
                left: BorderSide(color: AppColors.sidebarActive, width: 3))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          leading: Icon(
            item.icon,
            color: isActive ? AppColors.sidebarActive : AppColors.sidebarText,
            size: 20,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.sidebarText,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
