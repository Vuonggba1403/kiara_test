import 'package:bloc/bloc.dart';

class MainTabCubit extends Cubit<int> {
  MainTabCubit() : super(1); // Initial index is 1 (Insights page)

  /// Updates the current tab index
  void changeIndex(int index) => emit(index);
}
