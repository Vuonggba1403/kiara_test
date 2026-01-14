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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainTabCubit(),
      child: BlocBuilder<MainTabCubit, MainTabState>(
        builder: (context, state) {
          final currentIndex = state is MainTabIndexChanged ? state.index : 1;

          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: context.read<MainTabCubit>().changeIndex,
                  children: const [
                    CommonPage(),
                    InsightsPage(),
                    CommonPage(),
                    CommonPage(),
                    CommonPage(),
                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(16),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tabWidth = constraints.maxWidth / 5;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic,
                              left: tabWidth * currentIndex + tabWidth * 0.1,
                              top: 10,
                              bottom: 10,
                              width: tabWidth * 0.8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                final data = [
                                  ('assets/image/home.png', 'Home'),
                                  ('assets/image/insights.png', 'Insights'),
                                  ('assets/image/mess.png', 'Kiara'),
                                  ('assets/image/sounds.png', 'Sounds'),
                                  ('assets/image/user.png', 'Profile'),
                                ][index];

                                return Expanded(
                                  child: TabButton(
                                    iconPath: data.$1,
                                    label: data.$2,
                                    isActive: currentIndex == index,
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeInOutCubic,
                                      );
                                    },
                                  ),
                                );
                              }),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
