part of 'main_tab_cubit.dart';

sealed class MainTabState {
  const MainTabState();
}

final class MainTabInitial extends MainTabState {
  const MainTabInitial();
}

final class MainTabIndexChanged extends MainTabState {
  final int index;

  const MainTabIndexChanged(this.index);
}
