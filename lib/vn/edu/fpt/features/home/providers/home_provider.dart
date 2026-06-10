import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TODO: Define HomeState and implement HomeNotifier.
class HomeState {
  const HomeState();
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
  // TODO: implement actions
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (_) => HomeNotifier(),
);
