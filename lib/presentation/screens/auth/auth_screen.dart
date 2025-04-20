import 'package:auto_route/annotations.dart';
import 'package:beauty_master/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:beauty_master/presentation/screens/auth/widget/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  final VoidCallback onLoggedIn;

  const AuthScreen({super.key, required this.onLoggedIn});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context.read()),
      child: AuthWidget(onLoggedIn: onLoggedIn),
    );
  }
}
