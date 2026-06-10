import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TODO: Define EventsState and implement EventsNotifier.
class EventsState {
  const EventsState();
}

class EventsNotifier extends StateNotifier<EventsState> {
  EventsNotifier() : super(const EventsState());
  // TODO: implement actions
}

final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>(
  (_) => EventsNotifier(),
);
