// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/server_model.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/globals.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void establishConnection(Server serverData, BuildContext context) {
    GoRouter.of(context).go(
      Globals.connectingScreen,
      extra: serverData.toMap(),
    );
  }

  Future<bool> checkAuth(Server serverData, BuildContext context) async {
    LocalAuthentication auth = LocalAuthentication();
    bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    CustomLogging().logger.d('canAuthenticate: $canAuthenticate');

    bool authenticated = false;

    // ignore: dead_code
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      CustomLogging().logger.d('availableBiometrics:$availableBiometrics');
      try {
        authenticated = await auth.authenticate(
          localizedReason: S.current.authenticate_face_finger.capitalize(),
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );
      } catch (e) {
        CustomLogging().logger.d(e);
      }
    } else {
      TextEditingController passwordController = TextEditingController(
        text: "",
      );
      String? userPassword;
      if (serverData.isKey) {
        FilePickerResult? filePickerResult =
            await FilePicker.platform.pickFiles();

        if (filePickerResult != null) {
          File selectedFile = File(filePickerResult.files.single.path!);

          try {
            String fileText = selectedFile.readAsStringSync();

            if (fileText.toLowerCase().contains("private key")) {
              userPassword = fileText;
            }
          } catch (e) {
            CustomLogging().logger.e("File could not be processed: $e");
          }
        }
      } else {
        userPassword = await showDialog<String>(
          context: context,
          builder: (context) {
            return Dialog(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Text(
                        S.current.confirm_authentication_method.capitalize(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      autocorrect: false,
                      obscureText: true,
                      autofocus: true,
                      enableSuggestions: false,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) {
                        context.pop(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: S.current.password.capitalize(),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(passwordController.text),
                      child: Text(
                        S.current.accept.capitalize(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      authenticated =
          userPassword != null && userPassword == serverData.password;
    }

    return authenticated;
  }

  void checkAuthThenEdit(Server serverData, BuildContext context) async {
    bool authenticated = await checkAuth(serverData, context);
    if (authenticated) {
      editInfoModal(serverData, context);
    } else {
      GoRouter.of(context).push(
        Globals.errorModal,
        extra: S.current.could_not_authenticate.capitalize(),
      );
    }
  }

  void checkAuthThenConnect(Server serverData, BuildContext context) async {
    bool authenticated = await checkAuth(serverData, context);
    if (authenticated) {
      establishConnection(serverData, context);
    } else {
      GoRouter.of(context).push(
        Globals.errorModal,
        extra: S.current.could_not_authenticate.capitalize(),
      );
    }
  }

  void editInfoModal(Server serverData, BuildContext context) {
    GoRouter.of(context).push(
      Globals.newServerModal,
      extra: serverData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.connections.capitalize(),
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(
          Globals.newServerModal,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box("allServers").listenable(),
          builder: (context, value, child) {
            List<Server> serverList =
                List<Server>.from(value.get("all", defaultValue: <Server>[]));
            return ListView.builder(
              itemCount: serverList.length,
              itemBuilder: (context, index) {
                Server currentItem = serverList[index];
                return Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(
                      0,
                    ),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () => checkAuthThenConnect(
                        currentItem,
                        context,
                      ),
                      onLongPress: () => checkAuthThenEdit(
                        currentItem,
                        context,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${currentItem.address}:${currentItem.port}",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentItem.username,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            currentItem.couldReach
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 25,
                                  )
                                : const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
