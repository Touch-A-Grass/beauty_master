import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin SubscriptionBloc<S> on BlocBase<S> {
  final List<StreamSubscription> _subscriptions = [];

  StreamSubscription<T> subscribe<T>(Stream<T> stream, void Function(T event) onData,
      {void Function(Object error)? onError}) {
    final StreamSubscription<T> subscription = stream.listen(onData, onError: onError);
    _subscriptions.add(subscription);
    return subscription;
  }

  void unsubscribe(StreamSubscription? subscription) {
    if (subscription == null) return;
    subscription.cancel();
    _subscriptions.remove(subscription);
  }

  @override
  Future<void> close() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
