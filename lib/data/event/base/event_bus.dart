import 'package:rxdart/rxdart.dart';

abstract class EventBus<T> {
  final _controller = PublishSubject<T>();

  Stream<T> get stream => _controller.stream;

  void emit(T event) => _controller.sink.add(event);
}
