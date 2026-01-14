import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kiara_app_test/views/common_page.dart';
import 'package:kiara_app_test/views/insights/ui/insights_page.dart';
import 'package:kiara_app_test/views/main_tab/logic/cubit/main_tab_cubit.dart';
import 'package:kiara_app_test/views/main_tab/ui/widgets/tab_button.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/mini_player.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

class _TabConfig {
  static const int initialTabIndex = 1;
  static const int totalTabs = 5;

  static const double miniPlayerBottomOffset = 96;
  static const double tabBarHeight = 76;
  static const double tabBarPadding = 16;
  static const double tabBarRadius = 24;

  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  static const Duration indicatorAnimationDuration = Duration(
    milliseconds: 300,
  );
  static const Curve animationCurve = Curves.easeInOutCubic;

  static const double blurSigma = 22;
  static const double containerOpacity = 0.18;
  static const double borderOpacity = 0.12;
}

class _TabItem {
  final String iconPath;
  final String label;

  const _TabItem(this.iconPath, this.label);
}

class _TabData {
  static const List<_TabItem> items = [
    _TabItem('assets/image/home.png', 'Home'),
    _TabItem('assets/image/insights.png', 'Insights'),
    _TabItem('assets/image/mess.png', 'Kiara'),
    _TabItem('assets/image/sounds.png', 'Sounds'),
    _TabItem('assets/image/user.png', 'Profile'),
  ];
}

/// Main screen với bottom navigation và page view
/// Quản lý điều hướng giữa các màn hình chính của app
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
    _pageController = PageController(initialPage: _TabConfig.initialTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: _TabConfig.pageTransitionDuration,
      curve: _TabConfig.animationCurve,
    );
  }

  List<Widget> _buildPages() {
    return const [
      CommonPage(),
      InsightsPage(),
      CommonPage(),
      CommonPage(),
      CommonPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainTabCubit(),
      child: BlocBuilder<MainTabCubit, MainTabState>(
        builder: (context, state) {
          final currentIndex = _getCurrentTabIndex(state);

          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: Stack(
              children: [
                _buildPageView(context),
                _buildMiniPlayer(),
                _buildBottomNavBar(currentIndex),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getCurrentTabIndex(MainTabState state) {
    return state is MainTabIndexChanged
        ? state.index
        : _TabConfig.initialTabIndex;
  }

  Widget _buildPageView(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: context.read<MainTabCubit>().changeIndex,
      children: _buildPages(),
    );
  }

  Widget _buildMiniPlayer() {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: _TabConfig.miniPlayerBottomOffset,
      child: MiniPlayer(),
    );
  }

  Widget _buildBottomNavBar(int currentIndex) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(_TabConfig.tabBarPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_TabConfig.tabBarRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _TabConfig.blurSigma,
              sigmaY: _TabConfig.blurSigma,
            ),
            child: Container(
              height: _TabConfig.tabBarHeight,
              decoration: _buildTabBarDecoration(),
              child: _buildTabBarContent(currentIndex),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildTabBarDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(_TabConfig.containerOpacity),
      borderRadius: BorderRadius.circular(_TabConfig.tabBarRadius),
      border: Border.all(
        color: Colors.white.withOpacity(_TabConfig.borderOpacity),
      ),
    );
  }

  Widget _buildTabBarContent(int currentIndex) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / _TabConfig.totalTabs;

        return Stack(
          alignment: Alignment.center,
          children: [
            _buildActiveIndicator(currentIndex, tabWidth),
            _buildTabButtons(currentIndex),
          ],
        );
      },
    );
  }

  Widget _buildActiveIndicator(int currentIndex, double tabWidth) {
    return AnimatedPositioned(
      duration: _TabConfig.indicatorAnimationDuration,
      curve: _TabConfig.animationCurve,
      left: tabWidth * currentIndex + tabWidth * 0.1,
      top: 8,
      bottom: 8,
      width: tabWidth * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildTabButtons(int currentIndex) {
    return Row(
      children: List.generate(_TabConfig.totalTabs, (index) {
        final tabItem = _TabData.items[index];

        return Expanded(
          child: TabButton(
            iconPath: tabItem.iconPath,
            label: tabItem.label,
            isActive: currentIndex == index,
            onTap: () => _navigateToPage(index),
          ),
        );
      }),
    );
  }
}
