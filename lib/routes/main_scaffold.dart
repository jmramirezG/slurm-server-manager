import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/utils/globals.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<StatefulWidget> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getTitle(String location) {
    if (location.contains(Globals.auxFileBrowsingScreen)) {
      return S.current.files.capitalize();
    } else if (location.contains(Globals.auxNodeInfoScreen)) {
      return S.current.nodes.capitalize();
    } else if (location.contains(Globals.auxServerInfoScreen)) {
      return S.current.server_information.capitalize();
    } else {
      return SSHManager().getAddress()!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String location = GoRouterState.of(context).uri.toString();
    IconButton selectedButton;

    if (location == Globals.mainScreen) {
      selectedButton = IconButton(
        onPressed: () {
          SSHManager().closeConnection();
          GoRouter.of(context).go(
            Globals.startScreen,
          );
        },
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
    } else {
      selectedButton = IconButton(
        onPressed: () {
          GoRouter.of(context).go(Globals.mainScreen);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {
        if (location == Globals.mainScreen) {
          SSHManager().closeConnection();
          GoRouter.of(context).go(
            Globals.startScreen,
          );
        } else {
          GoRouter.of(context).go(
            Globals.mainScreen,
          );
        }
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          shadowColor: colorScheme.primary,
          title: Text(
            _getTitle(location),
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: selectedButton,
          actions: location == Globals.mainScreen
              ? null
              : [
                  Container(),
                ],
        ),
        backgroundColor: colorScheme.background,
        body: SafeArea(
          child: widget.child,
        ),
        endDrawer: Drawer(
          elevation: 10,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                ),
                child: Text(
                  S.current.menu.capitalize(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  S.current.files.capitalize(),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.closeEndDrawer();

                  GoRouter.of(context).go(
                    Globals.auxFileBrowsingScreen,
                    extra: SSHManager().getAddress(),
                  );
                },
              ),
              ListTile(
                title: Text(
                  S.current.ssh_console.capitalize(),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.closeEndDrawer();

                  GoRouter.of(context).go(
                    Globals.auxSSHScreen,
                  );
                },
              ),
              ListTile(
                title: Text(
                  S.current.nodes.capitalize(),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.closeEndDrawer();

                  GoRouter.of(context).go(
                    Globals.auxNodeInfoScreen,
                  );
                },
              ),
              ListTile(
                title: Text(
                  S.current.server_information.capitalize(),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _scaffoldKey.currentState!.closeEndDrawer();

                  GoRouter.of(context).go(
                    Globals.auxServerInfoScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
