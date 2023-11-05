import 'dart:convert';

import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_theme/json_theme.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/job_model.dart';
import 'package:slurm_server_manager/models/server_model.dart';
import 'package:slurm_server_manager/routes/aux_screens/aux_ssh_screen.dart';
import 'package:slurm_server_manager/routes/aux_screens/aux_files_screen.dart';
import 'package:slurm_server_manager/routes/aux_screens/aux_node_info_screen.dart';
import 'package:slurm_server_manager/routes/aux_screens/aux_server_info_screen.dart';
import 'package:slurm_server_manager/routes/aux_screens/main_screen.dart';
import 'package:slurm_server_manager/routes/connecting_screen.dart';
import 'package:slurm_server_manager/routes/error_modal.dart';
import 'package:slurm_server_manager/routes/job_modal.dart';
import 'package:slurm_server_manager/routes/main_scaffold.dart';
import 'package:slurm_server_manager/routes/new_server_modal.dart';
import 'package:slurm_server_manager/routes/start_screen.dart';
import 'package:slurm_server_manager/utils/globals.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: Globals.startScreen,
  routes: <RouteBase>[
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Globals.startScreen,
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Globals.newServerModal,
      pageBuilder: (context, state) {
        Server? serverData = state.extra as Server?;
        return CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: false,
          opaque: false,
          transitionDuration: const Duration(
            milliseconds: 100,
          ),
          reverseTransitionDuration: const Duration(
            milliseconds: 50,
          ),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: NewServerModal(
            serverData: serverData,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Globals.errorModal,
      pageBuilder: (context, state) {
        dynamic extraContent = state.extra as dynamic;
        return CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: false,
          opaque: false,
          transitionDuration: const Duration(
            milliseconds: 100,
          ),
          reverseTransitionDuration: const Duration(
            milliseconds: 50,
          ),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: ErrorModal(
            extraContent: extraContent,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Globals.jobModal,
      pageBuilder: (context, state) {
        Job selectedJob = state.extra as Job;
        return CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: false,
          opaque: false,
          transitionDuration: const Duration(
            milliseconds: 100,
          ),
          reverseTransitionDuration: const Duration(
            milliseconds: 50,
          ),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: JobModal(
            jobData: selectedJob,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Globals.connectingScreen,
      builder: (context, state) {
        Server server = Server.fromMap(state.extra as Map<String, dynamic>);
        return ConnectingScreen(
          serverData: server,
        );
      },
    ),
    ShellRoute(
      parentNavigatorKey: _rootNavigatorKey,
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: MainScaffold(
            child: child,
          ),
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
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: Globals.mainScreen,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: Globals.auxFileBrowsingScreen,
          builder: (context, state) => const FilesScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: Globals.auxSSHScreen,
          builder: (context, state) => const SSHScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: Globals.auxNodeInfoScreen,
          builder: (context, state) => const NodesInfoScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: Globals.auxServerInfoScreen,
          builder: (context, state) => const ServerInfoScreen(),
        ),
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
  await Hive.initFlutter();
  Hive.registerAdapter(ServerAdapter());

  const secureStorage = FlutterSecureStorage();
  final encryptionKeyString = await secureStorage.read(key: 'key');
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKeyUint8List = base64Url.decode(key!);
  await Hive.openBox(
    'allServers',
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );

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
