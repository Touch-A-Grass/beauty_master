import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/app_image_picker.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:beauty_master/presentation/util/phone_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(title: const Text('Профиль')),
            body:
                state.profile == null
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.all(16),
                              sliver: SliverMainAxisGroup(
                                slivers: [SliverToBoxAdapter(child: _ProfileItem(profile: state.profile!))],
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            context.read<ProfileBloc>().add(const ProfileEvent.logoutRequested());
                                          },
                                          child: Text(S.of(context).logoutButton),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.isUpdatingUser) const Center(child: CircularProgressIndicator()),
                      ],
                    ),
          ),
    );
  }
}

class _ProfileItem extends StatefulWidget {
  final StaffProfile profile;

  const _ProfileItem({required this.profile});

  @override
  State<_ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<_ProfileItem> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            Uint8List? image = await AppImagePicker.pickImage(context);
            if (!context.mounted || image == null) return;
            image = await context.pushRoute<Uint8List?>(ImageCropRoute(image: image));
            if (!context.mounted || image == null) return;
            context.read<ProfileBloc>().add(ProfileEvent.updatePhotoRequested(image));
          },
          child: SizedBox.square(
            dimension: 80,
            child: CircleAvatar(
              foregroundImage: widget.profile.photo != null ? CachedNetworkImageProvider(widget.profile.photo!) : null,
              child: Text(widget.profile.initials),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                widget.profile.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(phoneFormatter.maskText(widget.profile.phoneNumber)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder:
                  (dialogContext) => _ChangeProfileDialog(widget.profile, (name) {
                    context.read<ProfileBloc>().add(ProfileEvent.updateUserRequested(name));
                  }),
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}

class _ChangeProfileDialog extends StatefulWidget {
  final StaffProfile user;
  final ValueChanged<String> onNameChanged;

  const _ChangeProfileDialog(this.user, this.onNameChanged);

  @override
  State<_ChangeProfileDialog> createState() => _ChangeProfileDialogState();
}

class _ChangeProfileDialogState extends State<_ChangeProfileDialog> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 32,
              children: [
                Text('Изменить имя', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Имя', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('Отменить'))),
                    Expanded(
                      child: FilledButton(
                        onPressed:
                            nameController.text.isEmpty || nameController.text.trim() == widget.user.name.trim()
                                ? null
                                : () {
                                  widget.onNameChanged(nameController.text.trim());
                                  Navigator.pop(context);
                                },
                        child: Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
