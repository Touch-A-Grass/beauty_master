import 'dart:async';

import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class NavigationStateUpdater extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool isAuthorized = false;

  NavigationStateUpdater(this._authRepository) {
    isAuthorized = _authRepository.getAuth() != null;
    _subscribe();
  }

  StreamSubscription? _subscription;

  void _subscribe() {
    _subscription = _authRepository.watchAuth().listen((auth) {
      isAuthorized = auth != null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
