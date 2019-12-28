import 'package:meta/meta.dart';

@immutable
abstract class IndexState {
  int isIndex;

  IndexState({this.isIndex});
}

class InitialIndexState extends IndexState {
  InitialIndexState():super(isIndex:0);
}
class SetIndexState extends IndexState{
  SetIndexState.index(int index):super(isIndex:index);
}