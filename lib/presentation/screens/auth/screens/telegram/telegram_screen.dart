import 'package:beauty_master/core/constants.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramScreen extends StatefulWidget {
  const TelegramScreen({super.key});

  @override
  State<TelegramScreen> createState() => _TelegramScreenState();
}

class _TelegramScreenState extends State<TelegramScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      AssetIcon(
                        'assets/icons/telegram.svg',
                        size: 96,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 32),
                      OutlinedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(Constants.telegram2FABotLink));
                        },
                        child: Text(S.of(context).telegramRedirectButton),
                      ),
                      const Spacer(),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(S.of(context).telegramConfirmDescription),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
