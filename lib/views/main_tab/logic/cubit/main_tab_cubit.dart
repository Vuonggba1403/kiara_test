import 'package:bloc/bloc.dart';

part 'main_tab_state.dart';

/// Cubit quản lý trạng thái của main tab navigation
/// Chịu trách nhiệm theo dõi tab nào đang được chọn
class MainTabCubit extends Cubit<MainTabState> {
  MainTabCubit() : super(const MainTabIndexChanged(1));

  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  /// Thay đổi tab được chọn
  void changeIndex(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;
    emit(MainTabIndexChanged(index));
  }
}
