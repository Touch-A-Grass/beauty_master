import 'package:beauty_master/presentation/components/app_overlay.dart';
import 'package:beauty_master/presentation/components/error_snackbar.dart';
import 'package:beauty_master/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:beauty_master/presentation/screens/auth/screens/code/code_screen.dart';
import 'package:beauty_master/presentation/screens/auth/screens/phone/phone_screen.dart';
import 'package:beauty_master/presentation/screens/auth/screens/telegram/telegram_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWidget extends StatefulWidget {
  final VoidCallback onLoggedIn;

  const AuthWidget({super.key, required this.onLoggedIn});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
            listener: (context, state) {
              FocusScope.of(context).unfocus();

              pageController.animateToPage(
                switch (state) {
                  AuthPhoneState() => 0,
                  AuthCodeState() => 2,
                  AuthTelegramState() => 1,
                },
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen:
                (prev, curr) =>
                    prev is AuthCodeState &&
                    curr is AuthCodeState &&
                    curr.error != null &&
                    !identical(prev.error, curr.error),
            listener: (context, state) {
              if (state is! AuthCodeState || state.error == null) return;
              context.showErrorSnackBar(state.error!);
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen:
                (prev, curr) =>
                    curr is AuthCodeState &&
                    curr.isLoggedIn &&
                    (prev is! AuthCodeState || prev.isLoggedIn != curr.isLoggedIn),
            listener: (context, state) {
              if (state is! AuthCodeState) return;
              widget.onLoggedIn();
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder:
              (context, state) => AppOverlay(
                child: Scaffold(
                  body: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      PhoneScreen(
                        onPhoneEntered: (phone) => context.read<AuthBloc>().add(AuthEvent.phoneEntered(phone)),
                      ),
                      const TelegramScreen(),
                      CodeScreen(
                        onCodeEntered: (code) => context.read<AuthBloc>().add(AuthEvent.codeEntered(code)),
                        backToPhonePressed: () => context.read<AuthBloc>().add(const AuthEvent.changePhoneRequested()),
                        isLoading: state is AuthCodeState && state.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
