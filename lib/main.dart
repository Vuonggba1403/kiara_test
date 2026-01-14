import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/global_music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/views/main_tab/ui/main_tab_view.dart';

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
        home: const MainTabView(),
        theme: ThemeData(fontFamily: 'Arimo'),
      ),
    );
  }
}
