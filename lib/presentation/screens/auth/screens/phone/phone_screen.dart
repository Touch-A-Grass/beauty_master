import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/app_overlay.dart';
import 'package:beauty_master/presentation/components/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneScreen extends StatefulWidget {
  final ValueChanged<String> onPhoneEntered;

  const PhoneScreen({super.key, required this.onPhoneEntered});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  ValueNotifier<PhoneNumber?> phone = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: Scaffold(
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
                      IntlPhoneField(
                        autofocus: true,
                        showCountryFlag: false,
                        initialCountryCode: 'RU',
                        onChanged: (phoneNumber) {
                          phone.value = phoneNumber;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 64,
                      left: 32,
                      right: 32,
                      top: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: phone,
                        builder: (context, _) => FilledButton(
                          onPressed: isPhoneValid()
                              ? () => widget
                                  .onPhoneEntered(phone.value!.completeNumber)
                              : null,
                          child: Text(S.of(context).phoneNextButton),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isPhoneValid() {
    try {
      return phone.value != null && phone.value!.isValidNumber();
    } catch (_) {
      return false;
    }
  }
}
