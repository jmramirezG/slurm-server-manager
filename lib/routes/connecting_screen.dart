// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/server_model.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/globals.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class ConnectingScreen extends StatelessWidget {
  final Server serverData;

  const ConnectingScreen({
    super.key,
    required this.serverData,
  });

  Future<bool> checkInternetConnection() async {
    CustomLogging().logger.i('Checking internet connection');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        CustomLogging().logger.i('Internet connection available');
        return true;
      }
    } on SocketException catch (_) {
      CustomLogging().logger.i('No internet connection available');
      return false;
    }
    return false;
  }

  Future<void> connectToServer(
    BuildContext context,
  ) async {
    CustomLogging().logger.i(
        "Trying to connect to server ${serverData.address}:${serverData.port} with username ${serverData.username}");
    if (!await checkInternetConnection()) {
      GoRouter.of(context).go(
        Globals.startScreen,
      );
      GoRouter.of(context).push(
        Globals.errorModal,
        extra: S.current.no_internet.capitalize(),
      );
    }
    try {
      SSHClient sshClient = await SSHManager().establishConnection(
        serverData.address,
        serverData.port,
        serverData.username,
        serverData.password,
        serverData.isKey,
      );
      await sshClient.authenticated;

      List<Server> serverList =
          Hive.box("allServers").get("all", defaultValue: <Server>[]);

      int serverFound = serverList.indexOf(serverData);

      if (serverFound != -1) {
        serverList.removeAt(serverFound);
        serverData.couldReach = true;
        serverList.insert(serverFound, serverData);
        Hive.box("allServers").put("all", serverList);
      }

      GoRouter.of(context).go(
        Globals.mainScreen,
        extra: serverData.address,
      );
    } catch (e) {
      CustomLogging()
          .logger
          .e("Error while connecting to server: $e - ${e.runtimeType}");
      switch (e.runtimeType) {
        case SSHAuthFailError:
          SSHManager().abortConnection();
          GoRouter.of(context).go(
            Globals.startScreen,
          );
          GoRouter.of(context).push(
            Globals.errorModal,
            extra: S.current.auth_failed.capitalize(),
          );
          break;
        case SSHAuthAbortError:
        case SSHChannelOpenError:
        case SSHChannelRequestError:
        case SSHError:
        case SSHHostkeyError:
        case SSHInternalError:
          SSHManager().abortConnection();
          GoRouter.of(context).go(
            Globals.startScreen,
          );
          break;
        case SocketException:
          GoRouter.of(context).go(
            Globals.startScreen,
          );
          GoRouter.of(context).push(
            Globals.errorModal,
            extra: S.current.connection_refused.capitalize(),
          );
          break;
        default:
          SSHManager().abortConnection();
          GoRouter.of(context).go(
            Globals.startScreen,
          );
          GoRouter.of(context).push(
            Globals.errorModal,
            extra: S.current.unknown_error.capitalize(),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (serverData.save) {
      List<Server> serverList = List<Server>.from(
          Hive.box("allServers").get("all", defaultValue: <Server>[]));

      int serverFound = serverList.indexOf(serverData);

      if (serverFound != -1) {
        serverList.removeAt(serverFound);
        serverList.insert(serverFound, serverData);
      } else {
        serverList.add(serverData);
      }

      Hive.box("allServers").put("all", serverList);
    }
    connectToServer(
      context,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text(
                    S.current.connecting_to_server.capitalize(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          Theme.of(context).textTheme.headlineMedium!.fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
