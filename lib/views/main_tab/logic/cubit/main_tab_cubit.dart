import 'package:bloc/bloc.dart';

part 'main_tab_state.dart';

class MainTabCubit extends Cubit<MainTabState> {
  MainTabCubit()
    : super(const MainTabIndexChanged(1)); // Initial index is 1 (Insights page)

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  /// Updates the current tab index
  void changeIndex(int index) {
    _currentIndex = index;
    emit(MainTabIndexChanged(index));
  }
}
