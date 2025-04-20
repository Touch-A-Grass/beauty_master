import 'dart:async';

import 'package:beauty_master/core/constants.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/asset_icon.dart';
import 'package:beauty_master/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class CodeScreen extends StatefulWidget {
  final VoidCallback backToPhonePressed;
  final ValueChanged<String> onCodeEntered;
  final bool isLoading;

  const CodeScreen({super.key, required this.backToPhonePressed, required this.isLoading, required this.onCodeEntered});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final ValueNotifier<Duration> timeToResend = ValueNotifier(const Duration(minutes: 1));

  late final Timer resendTimer;

  @override
  void initState() {
    super.initState();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeToResend.value.inSeconds > 0) {
        timeToResend.value = timeToResend.value - const Duration(seconds: 1);
      }
    });
  }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (prev, curr) =>
              curr is AuthCodeState && (prev is! AuthCodeState || prev.codeRetrievedTime != curr.codeRetrievedTime),
      listener: (context, state) {
        if (state is! AuthCodeState) return;

        timeToResend.value = const Duration(seconds: 60);
      },
      child: Stack(
        children: [
          if (widget.isLoading) const Positioned(bottom: 0, left: 0, right: 0, child: LinearProgressIndicator()),
          Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverSafeArea(
                  bottom: false,
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 64),
                          AssetIcon(
                            'assets/icons/beauty_service.svg',
                            size: 164,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 64),
                          OtpTextField(
                            enabled: !widget.isLoading,
                            onSubmit: (code) {
                              widget.onCodeEntered.call(code);
                            },
                            autoFocus: true,
                            numberOfFields: 6,
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32, top: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedBuilder(
                            animation: timeToResend,
                            builder:
                                (context, _) => TextButton(
                                  onPressed:
                                      timeToResend.value.inSeconds > 0 || widget.isLoading
                                          ? null
                                          : () {
                                            context.read<AuthBloc>().add(const AuthEvent.resendCodeRequested());
                                          },
                                  child:
                                      timeToResend.value.inSeconds > 0
                                          ? Text(
                                            S
                                                .of(context)
                                                .telegramResendInMessage(timeToResend.value.inSeconds.toString()),
                                          )
                                          : Text(S.of(context).telegramResendButton),
                                ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 32),
                          OutlinedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(Constants.telegram2FABotLink));
                            },
                            child: Text(S.of(context).telegramRedirectButton),
                          ),
                          const SizedBox(height: 32),
                          TextButton(
                            onPressed: widget.isLoading ? null : widget.backToPhonePressed,
                            child: Text(S.of(context).changePhoneButton),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
