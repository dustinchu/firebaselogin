import 'package:meta/meta.dart';

@immutable
abstract class IndexEvent {}

class InitIndex extends IndexEvent{
  @override
  String toString()=> 'InitIndex';
}
class AddIndex extends IndexEvent{
  @override
  String toString()=>'AddIndex';
}
class MinusIndex extends IndexEvent{
  @override
  String toString()=>'MinusIndex';
}