import 'dart:async';

enum RepositoryEvent { toLazy, toIndex }

class RepositoryBloc {
  int _repository = 0;

  final StreamController<RepositoryEvent> _eventController =
      StreamController<RepositoryEvent>();
  StreamSink<RepositoryEvent> get eventSink => _eventController.sink;

  final StreamController<int> _stateController = StreamController<int>();
  StreamSink<int> get _stateSink => _stateController.sink;
  Stream<int> get stateStream => _stateController.stream;

  void _mapEventToState(RepositoryEvent repositoryEvent) {
    if (repositoryEvent == RepositoryEvent.toLazy) {
      _repository = 0;
    } else {
      _repository = 1;
    }

    _stateSink.add(_repository);
  }

  RepositoryBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
