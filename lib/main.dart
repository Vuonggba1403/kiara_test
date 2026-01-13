import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/main_tab/ui/main_tab_view.dart';
import 'package:kiara_app_test/views/music_player/logic/cubit/global_music_player_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlobalMusicPlayerCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //     backgroundColor: Color(0xFF16213E),
        //     selectedItemColor: Color(0xFF8BC34A),
        //     unselectedItemColor: Colors.grey,
        //     type: BottomNavigationBarType.fixed,
        //   ),
        // ),
        home: const MainTabView(),
      ),
    );
  }
}
