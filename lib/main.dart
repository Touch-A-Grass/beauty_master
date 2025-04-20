import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:beauty_master/data/storage/profile_storage.dart';
import 'package:beauty_master/di/di.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/navigation/app_router.dart';
import 'package:beauty_master/presentation/navigation/guards/auth_guard.dart';
import 'package:beauty_master/presentation/navigation/navigation_state_updater.dart';
import 'package:beauty_master/presentation/screens/root/root_screen.dart';
import 'package:beauty_master/presentation/theme/colors.dart';
import 'package:beauty_master/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);
  final profileStorage = ProfileStorage(secureStorage: secureStorage);

  await authStorage.init();
  await profileStorage.init();

  runApp(Di(authStorage: authStorage, profileStorage: profileStorage, child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter appRouter;

  @override
  void initState() {
    appRouter = AppRouter(authGuard: AuthGuard(context.read<NavigationStateUpdater>()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.theme(AppColorScheme.light()),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [S.delegate, ...GlobalMaterialLocalizations.delegates],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: appRouter.config(reevaluateListenable: context.read<NavigationStateUpdater>()),
      builder: (context, child) => RootScreen(child: child ?? SizedBox.shrink()),
    );
  }
}
