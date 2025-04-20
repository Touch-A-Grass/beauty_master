import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSingleChangeListener<B extends StateStreamable<S>, S> extends BlocListener<B, S> {
  BlocSingleChangeListener({
    super.key,
    super.bloc,
    required dynamic Function(S state) map,
    required super.listener,
    super.child,
    bool identicalCheck = true,
  }) : super(
         listenWhen:
             (prev, curr) =>
                 map(curr) != null && (identicalCheck ? !identical(map(prev), map(curr)) : map(prev) != map(curr)),
       );
}
