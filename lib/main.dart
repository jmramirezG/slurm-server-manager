import 'dart:convert';

import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:json_theme/json_theme.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/routes/login/login_scaffold.dart';
import 'package:slurm_server_manager/utils/globals.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: Globals.loginRoute,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: LoginScaffold(child: child),
          barrierDismissible: true,
          opaque: false,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
      routes: [
        // GoRoute(
        //   parentNavigatorKey: _shellNavigatorKey,
        //   path: Globals.loginScreen,
        //   builder: (context, state) => const LoginScreen(),
        // ),
        // GoRoute(
        //   parentNavigatorKey: _shellNavigatorKey,
        //   path: Globals.forgotLoginScreen,
        //   builder: (context, state) => const ForgotPasswordScreen(),
        // ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Limit app to vertical orientation
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      //DeviceOrientation.landscapeLeft,
      //DeviceOrientation.landscapeRight,
    ],
  );

  final themeStr = await rootBundle.loadString('assets/app_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(
    BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 3),
      child: MaterialApp.router(
        routerConfig: _router,
        theme: theme,
        darkTheme: theme,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        //locale: const Locale('es'),
      ),
    ),
  );
}
