import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TODO: Define RequestsState and implement RequestsNotifier.
class RequestsState {
  const RequestsState();
}

class RequestsNotifier extends StateNotifier<RequestsState> {
  RequestsNotifier() : super(const RequestsState());
  // TODO: implement actions
}

final requestsProvider = StateNotifierProvider<RequestsNotifier, RequestsState>(
  (_) => RequestsNotifier(),
);
