import 'package:beauty_master/domain/models/staff_profile.dart';
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
                    : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(16),
                          sliver: SliverMainAxisGroup(
                            slivers: [SliverToBoxAdapter(child: _ProfileItem(profile: state.profile!))],
                          ),
                        ),
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
        SizedBox.square(
          dimension: 80,
          child: CircleAvatar(
            foregroundImage: widget.profile.photo != null ? CachedNetworkImageProvider(widget.profile.photo!) : null,
            child: Text(widget.profile.initials),
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
      ],
    );
  }
}
