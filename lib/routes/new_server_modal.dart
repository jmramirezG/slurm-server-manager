import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/server_model.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/globals.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class NewServerModal extends StatefulWidget {
  final Server? serverData;
  const NewServerModal({
    super.key,
    this.serverData,
  });

  @override
  State<StatefulWidget> createState() => _NewServerModalState();
}

class _NewServerModalState extends State<NewServerModal> {
  late FocusNode focusNodeScreen;

  late TextEditingController addressController;

  late FocusNode focusNodePort;
  late TextEditingController portController;

  late FocusNode focusNodeUsername;
  late TextEditingController usernameController;

  late FocusNode focusNodePassword;
  late TextEditingController passwordController;

  late bool isKey;

  late bool hidePassword;

  late bool rememberServer;

  @override
  void initState() {
    focusNodeScreen = FocusNode();
    addressController = TextEditingController(
      text: widget.serverData != null ? widget.serverData!.address : "",
    );
    focusNodePort = FocusNode();
    portController = TextEditingController(
      text:
          widget.serverData != null ? widget.serverData!.port.toString() : "22",
    );
    focusNodeUsername = FocusNode();
    usernameController = TextEditingController(
      text: widget.serverData != null ? widget.serverData!.username : "",
    );
    focusNodePassword = FocusNode();
    passwordController = TextEditingController(
      text: widget.serverData != null ? widget.serverData!.password : "",
    );
    hidePassword = true;
    rememberServer = true;
    isKey = widget.serverData != null ? widget.serverData!.isKey : false;
    super.initState();
  }

  void establishConnection() {
    if (addressController.text != "" &&
        portController.text != "" &&
        int.parse(portController.text) > 0 &&
        int.parse(portController.text) < 65000 &&
        usernameController.text != "" &&
        passwordController.text != "") {
      GoRouter.of(context).go(
        Globals.connectingScreen,
        extra: {
          "address": addressController.text,
          "port": int.parse(portController.text),
          "username": usernameController.text,
          "password": passwordController.text,
          "isKey": isKey,
          "save": rememberServer,
        },
      );
    }
  }

  void saveAndExit() {
    List<dynamic> serverList = Hive.box("allServers").get("all");

    int index = serverList.indexOf(widget.serverData!);

    if (index == -1) {
      CustomLogging()
          .logger
          .e("Element ${widget.serverData} not found in serverList");
      GoRouter.of(context).push(
        Globals.errorModal,
        extra:
            S.current.server_not_found(widget.serverData!.address).capitalize(),
      );
    } else {
      serverList.removeAt(index);
      serverList.insert(
        index,
        Server(
          addressController.text,
          int.parse(portController.text),
          usernameController.text,
          passwordController.text,
          true,
          isKey,
        ),
      );
      Hive.box("allServers").put("all", serverList);
      GoRouter.of(context).pop();
    }
  }

  void deleteServer() async {
    List<dynamic> serverList = Hive.box("allServers").get("all");

    int index = serverList.indexOf(widget.serverData!);

    if (index == -1) {
      CustomLogging()
          .logger
          .e("Element ${widget.serverData} not found in serverList");
      GoRouter.of(context).push(
        Globals.errorModal,
        extra:
            S.current.server_not_found(widget.serverData!.address).capitalize(),
      );
    } else {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(
              S.current.forget_server.capitalize(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            content: Text(
              S.current.forget_server_long.capitalize(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              FilledButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll<TextStyle>(
                    TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Text(
                    S.current.no.toUpperCase(),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FilledButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll<TextStyle>(
                    TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Text(
                    S.current.yes.toUpperCase(),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      if (confirm != null && confirm) {
        serverList.removeAt(index);
        Hive.box("allServers").put("all", serverList);
      }
      // ignore: use_build_context_synchronously
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elementsToShow = [
      TextFormField(
        onTapOutside: (a) =>
            FocusScope.of(context).requestFocus(focusNodeScreen),
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(focusNodePort),
        controller: addressController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: S.current.address.capitalize(),
        ),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      TextFormField(
        focusNode: focusNodePort,
        onTapOutside: (a) =>
            FocusScope.of(context).requestFocus(focusNodeScreen),
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.number,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(focusNodeUsername),
        controller: portController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: S.current.port.capitalize(),
        ),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      TextFormField(
        focusNode: focusNodeUsername,
        onTapOutside: (a) =>
            FocusScope.of(context).requestFocus(focusNodeScreen),
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (value) {
          if (!isKey) {
            FocusScope.of(context).requestFocus(focusNodePassword);
          }
        },
        controller: usernameController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: S.current.user.capitalize(),
        ),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Text(
              S.current.password.capitalize(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Switch(
            hoverColor: Colors.transparent,
            activeColor: Theme.of(context).colorScheme.primaryContainer,
            thumbColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.primary,
            ),
            focusColor: Theme.of(context).colorScheme.primaryContainer,
            activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
            inactiveThumbColor: Theme.of(context).colorScheme.primaryContainer,
            inactiveTrackColor: Theme.of(context).colorScheme.primaryContainer,
            overlayColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.primaryContainer,
            ),
            trackColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.primaryContainer,
            ),
            trackOutlineColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.primaryContainer,
            ),
            splashRadius: 0.01,
            value: isKey,
            onChanged: (bool? value) {
              setState(() {
                passwordController.text = "";
                isKey = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Text(
              S.current.keys.capitalize(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: isKey
            ? FilledButton(
                onPressed: () async {
                  FilePickerResult? filePickerResult =
                      await FilePicker.platform.pickFiles();

                  if (filePickerResult != null) {
                    File selectedFile =
                        File(filePickerResult.files.single.path!);

                    try {
                      String fileText = selectedFile.readAsStringSync();

                      if (fileText.toLowerCase().contains("private key")) {
                        setState(() {
                          passwordController.text = fileText;
                        });
                      }
                    } catch (e) {
                      CustomLogging()
                          .logger
                          .e("File could not be processed: $e");
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        passwordController.text.isEmpty
                            ? Icons.file_open_outlined
                            : Icons.file_download_done_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      Text(
                        passwordController.text.isEmpty
                            ? S.current.select_file.capitalize()
                            : S.current.file_selected.capitalize(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : TextFormField(
                onTapOutside: (a) =>
                    FocusScope.of(context).requestFocus(focusNodeScreen),
                autocorrect: false,
                focusNode: focusNodePassword,
                obscureText: hidePassword,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(focusNodeScreen),
                controller: passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: S.current.password.capitalize(),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    ];

    if (widget.serverData == null) {
      elementsToShow.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Checkbox(
              hoverColor: Colors.transparent,
              splashRadius: 0.01,
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(
                rememberServer
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              value: rememberServer,
              onChanged: (bool? value) {
                setState(() {
                  rememberServer = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Text(
                S.current.remember_server.capitalize(),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      elementsToShow.add(
        TextButton(
          onPressed: deleteServer,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 4.0,
            ),
            child: Text(
              S.current.forget_server.capitalize(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 4,
            height: MediaQuery.of(context).size.height * 1 / 2,
            child: Card(
              elevation: 40,
              margin: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.serverData != null
                          ? S.current.edit_server.capitalize()
                          : S.current.add_new_server.capitalize(),
                      style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .fontSize,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: elementsToShow,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              S.current.cancel.toUpperCase(),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: widget.serverData != null
                              ? saveAndExit
                              : establishConnection,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              widget.serverData != null
                                  ? S.current.save.toUpperCase()
                                  : S.current.connect.toUpperCase(),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
