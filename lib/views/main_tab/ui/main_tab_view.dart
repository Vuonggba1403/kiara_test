import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/common_page.dart';
import 'package:kiara_app_test/views/insights/ui/insights_page.dart';
import 'package:kiara_app_test/views/main_tab/logic/cubit/main_tab_cubit.dart';
import 'package:kiara_app_test/views/main_tab/ui/widgets/tab_button.dart';

import 'package:kiara_app_test/views/music_player/ui/widgets/mini_player.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigates to the specified page index with animation
  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainTabCubit(),
      child: BlocBuilder<MainTabCubit, MainTabState>(
        builder: (context, state) {
          final currentIndex = state is MainTabIndexChanged ? state.index : 1;
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                // Main content
                PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: context.read<MainTabCubit>().changeIndex,
                  children: [
                    CommonPage(),
                    InsightsPage(),
                    CommonPage(),
                    CommonPage(),
                    CommonPage(),
                  ],
                ),
                // Mini player overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: const MiniPlayer(),
                ),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigationBar(currentIndex),
          );
        },
      ),
    );
  }

  /// Builds the custom bottom navigation bar with animated indicator
  Widget _buildBottomNavigationBar(int currentIndex) {
    return Container(
      margin: const EdgeInsets.all(16),

      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / 5;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated selection indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      left: tabWidth * currentIndex + (tabWidth * 0.1),
                      top: 10,
                      bottom: 10,
                      width: tabWidth * 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryGreen,
                              AppColors.primaryGreen,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // Tab buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TabButton(
                            iconPath: 'assets/image/home.png',
                            label: "Home",
                            isActive: currentIndex == 0,
                            onTap: () => _navigateToPage(0),
                          ),
                        ),
                        Expanded(
                          child: TabButton(
                            iconPath: 'assets/image/insights.png',
                            label: "Insights",
                            isActive: currentIndex == 1,
                            onTap: () => _navigateToPage(1),
                          ),
                        ),
                        Expanded(
                          child: TabButton(
                            iconPath: 'assets/image/mess.png',
                            label: "Kiara",
                            isActive: currentIndex == 2,
                            onTap: () => _navigateToPage(2),
                          ),
                        ),
                        Expanded(
                          child: TabButton(
                            iconPath: 'assets/image/sounds.png',
                            label: "Sounds",
                            isActive: currentIndex == 3,
                            onTap: () => _navigateToPage(3),
                          ),
                        ),
                        Expanded(
                          child: TabButton(
                            iconPath: 'assets/image/user.png',
                            label: "Profile",
                            isActive: currentIndex == 4,
                            onTap: () => _navigateToPage(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
