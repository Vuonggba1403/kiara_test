import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/views/main_tab/ui/main_tab_view.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget của ứng dụng
/// Khởi tạo các provider và theme cho toàn bộ app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlobalMusicPlayerCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainTabView(),
        theme: _buildAppTheme(),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      fontFamily: 'Arimo',
      scaffoldBackgroundColor: AppColors.scaffoldDeeper,
      canvasColor: AppColors.scaffoldDeeper,
      colorScheme: ColorScheme.dark(
        surface: AppColors.scaffoldDeeper,
        background: AppColors.scaffoldDeeper,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
