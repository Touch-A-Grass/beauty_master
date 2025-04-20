import 'dart:async';

import 'package:beauty_master/domain/repositories/auth_repository.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PushHandler extends StatefulWidget {
  final Widget child;

  const PushHandler({super.key, required this.child});

  @override
  State<PushHandler> createState() => _PushHandlerState();
}

class _PushHandlerState extends State<PushHandler> {
  late final AuthRepository authRepository;

  StreamSubscription? subscription;

  @override
  void initState() {
    authRepository = context.read<AuthRepository>();
    subscription = authRepository.watchAuth().listen((auth) async {
      try {
        if (auth == null) {
          // await FirebaseMessaging.instance.deleteToken();
        } else {
          // await FirebaseMessaging.instance.requestPermission();
          // final token = await FirebaseMessaging.instance.getToken(
          //   vapidKey: 'BKogdkJ_48uzdfhySGKse28l1d47bghqim8I3SR87s5VosvmDXhxnRosnooyaqRgweHm4qVqgEMcHkLrBUFl7SA',
          // );
          // debugPrint(token);
          // if (token != null) {
          //   await authRepository.sendFirebaseToken(token);
          // }
        }
      } catch (_) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
