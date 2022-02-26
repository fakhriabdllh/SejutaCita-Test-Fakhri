import 'dart:async';

enum UserEvent { toLazy, toIndex }

class UserBloc {
  int _user = 0;

  final StreamController<UserEvent> _eventController =
      StreamController<UserEvent>();
  StreamSink<UserEvent> get eventSink => _eventController.sink;

  final StreamController<int> _stateController = StreamController<int>();
  StreamSink<int> get _stateSink => _stateController.sink;
  Stream<int> get stateStream => _stateController.stream;

  void _mapEventToState(UserEvent userEvent) {
    if (userEvent == UserEvent.toLazy) {
      _user = 0;
    } else {
      _user = 1;
    }

    _stateSink.add(_user);
  }

  UserBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
