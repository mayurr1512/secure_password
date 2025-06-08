import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:password_manager/data/repository/credential_repository.dart';
import 'package:password_manager/ui/bloc/auth_bloc.dart';
import 'package:password_manager/ui/bloc/credential_bloc.dart';
import 'package:password_manager/ui/theme/theme_cubit.dart';
import 'package:password_manager/ui/screens/splash_screen.dart';
import 'package:password_manager/utils/service/app_lock_service.dart';
import 'package:sizer/sizer.dart';

import 'ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final credRepo = CredentialRepository();

  runApp(MyApp(credRepo));
}

class MyApp extends StatefulWidget {
  final CredentialRepository credRepo;
  const MyApp(this.credRepo, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    NoScreenshot.instance.screenshotOff();
    AppLockService().start(_navigatorKey);
  }

  @override
  void dispose() {
    AppLockService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GestureDetector(
            onTap: AppLockService().userInteractionDetected,
            onPanDown: (_) => AppLockService().userInteractionDetected(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatus())),
                BlocProvider(create: (_) => CredentialBloc(widget.credRepo)..add(LoadCredentials())),
                BlocProvider(create: (_) => ThemeCubit()),
              ],
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp(
                    title: 'Secure Password',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    home: const SplashScreen(),
                    navigatorKey: _navigatorKey,
                  );
                },
              )
            ),
          );
        }
    );
  }
}

