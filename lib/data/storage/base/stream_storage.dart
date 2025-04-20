import 'package:rxdart/rxdart.dart';

abstract class StreamStorage<T> {
  final BehaviorSubject<T> _stream;

  StreamStorage({required T initialValue}) : _stream = BehaviorSubject<T>.seeded(initialValue);

  Stream<T> get stream => _stream.stream;

  T get value => _stream.value;

  void update(T value) => _stream.add(value);

  void dispose() => _stream.close();
}
