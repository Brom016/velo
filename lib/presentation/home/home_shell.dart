import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../dashboard/dashboard_screen.dart';
import '../map/map_screen.dart';
import '../camera/camera_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import 'home_controller.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    final pages = <Widget>[
      const DashboardScreen(),
      const MapScreen(),
      const CameraScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Obx(() => Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: IndexedStack(
        index: c.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: AppDimensions.bottomNavHeight + MediaQuery.of(context).padding.bottom,
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: c.currentIndex.value,
          onTap: c.onTabTapped,
          backgroundColor: AppColors.bgSurface,
          selectedItemColor: AppColors.amber,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 11,
          ),
          items: List.generate(5, (i) {
            final locked = (i == 1 || i == 2) && c.isGuest;
            return BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(c.iconFor(i)),
                  if (locked)
                    Positioned(
                      top: -2,
                      right: -6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.bgSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_outline,
                          size: 7, color: AppColors.textDisabled),
                      ),
                    ),
                ],
              ),
              label: c.labelFor(i),
            );
          }),
        ),
      ),
    ));
  }
}
