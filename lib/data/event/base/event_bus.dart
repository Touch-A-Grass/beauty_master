import 'package:rxdart/rxdart.dart';

abstract class EventBus<T> {
  final _stream = PublishSubject<T>();

  Stream<T> get stream => _stream.stream;

  void emit(T event) => _stream.sink.add(event);
}
