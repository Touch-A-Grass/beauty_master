import 'package:beauty_master/core/config.dart';
import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/api/dio_factory.dart';
import 'package:beauty_master/data/event/order_changed_event_bus.dart';
import 'package:beauty_master/data/repositories/auth_repository.dart';
import 'package:beauty_master/data/repositories/order_repository.dart';
import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:beauty_master/data/storage/location_storage.dart';
import 'package:beauty_master/data/storage/profile_storage.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/domain/use_cases/logout_use_case.dart';
import 'package:beauty_master/presentation/navigation/navigation_state_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Di extends StatelessWidget {
  final AuthStorage authStorage;
  final ProfileStorage profileStorage;
  final Widget child;

  const Di({super.key, required this.child, required this.authStorage, required this.profileStorage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        //   Storages
        RepositoryProvider.value(value: authStorage),
        RepositoryProvider.value(value: profileStorage),
        RepositoryProvider(create: (context) => OrderChangedEventBus()),
        RepositoryProvider(create: (context) => LocationStorage()),
        RepositoryProvider(create: (context) => DioFactory.create(context.read())),
        RepositoryProvider(create: (context) => BeautyClient(context.read(), baseUrl: Config.apiBaseUrl)),
        //   Repositories
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(context.read(), context.read(), context.read()),
        ),
        RepositoryProvider<OrderRepository>(create: (context) => OrderRepositoryImpl(context.read(), context.read())),
        //   Logic
        RepositoryProvider(create: (context) => LogoutUseCase(context.read())),
        ChangeNotifierProvider(create: (context) => NavigationStateUpdater(context.read())),
      ],
      child: child,
    );
  }
}
