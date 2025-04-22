import 'package:auto_route/annotations.dart';
import 'package:beauty_master/presentation/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:beauty_master/presentation/screens/profile_screen/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(context.read())..add(ProfileEvent.started()),
      child: ProfileWidget(),
    );
  }
}
