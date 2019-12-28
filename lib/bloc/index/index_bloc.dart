import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebaselogin/bloc/index/bloc.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  @override
  IndexState get initialState => InitialIndexState();
  int index = 0;

  @override
  Stream<IndexState> mapEventToState(
    IndexEvent event,
  ) async* {
    if (event is InitIndex) {
      yield* _initIndexToState();
    } else if (event is AddIndex) {
      yield* _addIndexToState();
    } else if (event is MinusIndex) {
      yield* _minusIndexToState();
    }
  }

  Stream<IndexState> _initIndexToState() async* {
    index = 0;
    yield SetIndexState.index(index);
  }

  Stream<IndexState> _addIndexToState() async* {
    index += 1;
    yield SetIndexState.index(index);
  }

  Stream<IndexState> _minusIndexToState() async* {
    index -= 1;
    yield SetIndexState.index(index);
  }
}
