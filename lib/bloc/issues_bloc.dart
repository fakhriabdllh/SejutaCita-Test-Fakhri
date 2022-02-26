import 'dart:async';

enum IssuesEvent { toLazy, toIndex }

class IssuesBloc {
  int _issues = 0;

  final StreamController<IssuesEvent> _eventController =
      StreamController<IssuesEvent>();
  StreamSink<IssuesEvent> get eventSink => _eventController.sink;

  final StreamController<int> _stateController = StreamController<int>();
  StreamSink<int> get _stateSink => _stateController.sink;
  Stream<int> get stateStream => _stateController.stream;

  void _mapEventToState(IssuesEvent issuesEvent) {
    if (issuesEvent == IssuesEvent.toLazy) {
      _issues = 0;
    } else {
      _issues = 1;
    }

    _stateSink.add(_issues);
  }

  IssuesBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
