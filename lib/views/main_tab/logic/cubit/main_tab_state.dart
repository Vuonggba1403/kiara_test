part of 'main_tab_cubit.dart';

/// Base class cho các state của MainTab
sealed class MainTabState {
  const MainTabState();
}

/// State khởi tạo ban đầu
final class MainTabInitial extends MainTabState {
  const MainTabInitial();
}

/// State khi tab index thay đổi
/// [index] - Index của tab đang được chọn (0-4)
final class MainTabIndexChanged extends MainTabState {
  final int index;

  const MainTabIndexChanged(this.index);
}
