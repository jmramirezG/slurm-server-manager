import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';
import 'package:xterm/xterm.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late List<Map<String, dynamic>> _lsWidgetsList;
  late String valuableData;

  late final terminal = Terminal(
    platform: TerminalTargetPlatform.android,
  );

  @override
  void initState() {
    _lsWidgetsList = [];
    valuableData = "";
    super.initState();

    initServerState();
  }

  Future<void> initTerminal() async {
    final session = await SSHManager().getShellWithConfig(
      SSHPtyConfig(
        type: "xterm",
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    if (session != null) {
      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        session.resizeTerminal(width, height, pixelWidth, pixelHeight);
      };

      terminal.onOutput = (data) {
        session.write(utf8.encode(data) as Uint8List);
      };

      session.stdout
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(getDataForCurrentRoute);

      session.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);
    }
  }

  void initServerState() async {
    await initTerminal();
    terminal.textInput(
        "cd ~ && ls -la --group-directories-first --color=never && pwd\n");
  }

  Future<void> getDataForCurrentRoute(String rawItems) async {
    CustomLogging().logger.d("Raw content is $rawItems");
    valuableData += rawItems;
    List<Map<String, dynamic>> newWidgetList = [];
    if (valuableData.split("total").length > 1) {
      valuableData = valuableData.split("total").last;
    }
    List<String> currentItems =
        valuableData.split("total").last.split("\n").sublist(
              2,
              valuableData.split("total").last.split("\n").length - 2,
            );
    String currentPath = valuableData
        .split("total")
        .last
        .split("\n")[valuableData.split("total").last.split("\n").length - 2];

    for (int i = 0; i < currentItems.length; i++) {
      String item = currentItems[i];
      item = item.trim();

      if (item.split(" ").last != "." && item.isNotEmpty) {
        newWidgetList.add(
          buildItem(
            item,
            i % 2 == 1
                ? Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3)
                : Theme.of(context).colorScheme.surface,
          ),
        );
      }
    }
    if (newWidgetList.isNotEmpty) {
      newWidgetList.insert(
        0,
        {
          "leading": IconButton(
            onPressed: () => terminal.textInput(
                "cd ~ && ls -la --group-directories-first --color=never && pwd\n"),
            color: Theme.of(context).colorScheme.primary,
            iconSize: MediaQuery.of(context).size.width / 8,
            padding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            alignment: Alignment.center,
            icon: const Icon(
              Icons.home_outlined,
            ),
          ),
          "title": SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              currentPath,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
          ),
          "onTap": null,
          "color": Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
        },
      );
      setState(() {
        _lsWidgetsList = newWidgetList;
      });
    }
  }

  void cdTo(String path) async {
    CustomLogging().logger.d("cding to $path");
    terminal.textInput(
        "cd $path && ls -la --group-directories-first --color=never && pwd\n");
  }

  Map<String, dynamic> buildItem(
    String item,
    Color background,
  ) {
    bool isDir = item.startsWith("d");

    String path = item.split(" ").last;

    return {
      "leading": Icon(
        isDir ? Icons.folder_open_outlined : Icons.description_outlined,
        color: Theme.of(context).colorScheme.primary,
        size: MediaQuery.of(context).size.width / 10,
      ),
      "title": SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          path,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
          ),
        ),
      ),
      "onTap": () => isDir ? cdTo(path) : null,
      "color": background,
      "onLongPress": path != ".."
          ? () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  alignment: Alignment.center,
                  title: Text(
                    isDir
                        ? S.current.delete_dir.capitalize()
                        : S.current.delete_file.capitalize(),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  content: Text(
                    "${S.current.name.capitalize()}: $path",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        S.current.no.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        S.current.yes.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmDelete != null && confirmDelete) {
                terminal.textInput(
                    "rm -rf $path && ls -la --group-directories-first --color=never && pwd\n");
              }
            }
          : null,
    };
  }

  /*
  
  Useful commands:
    * ls

    * mkdir

    * cd
  
  Combine all commands above with listview.builder

  */

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ListView(
          children: ListTile.divideTiles(
            context: context,
            color: Theme.of(context).colorScheme.primary,
            tiles: _lsWidgetsList.map(
              (element) => element == _lsWidgetsList.first
                  ? ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8.0,
                      ),
                      leading: element["leading"],
                      title: element["title"],
                      onTap: element["onTap"],
                      tileColor: element["color"],
                    )
                  : ListTile(
                      leading: element["leading"],
                      title: element["title"],
                      onTap: element["onTap"],
                      tileColor: element["color"],
                      onLongPress: element["onLongPress"],
                    ),
            ),
          ).toList(),
        ),
        _lsWidgetsList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 4.0,
                ),
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const CircleBorder(
                        side: BorderSide(
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    String? newDirName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        TextEditingController textFieldController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text(
                            S.current.directory_name.capitalize(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize,
                            ),
                          ),
                          content: TextField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize,
                            ),
                            controller: textFieldController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                              labelText: S.current.name.capitalize(),
                              prefixIcon: Icon(
                                Icons.folder_open_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: MediaQuery.of(context).size.width / 12,
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                S.current.cancel.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize,
                                ),
                              ),
                              onPressed: () => context.pop(
                                null,
                              ),
                            ),
                            TextButton(
                              child: Text(
                                S.current.accept.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize,
                                ),
                              ),
                              onPressed: () => context.pop(
                                textFieldController.text,
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (newDirName != null && newDirName.isNotEmpty) {
                      terminal.textInput(
                          "mkdir $newDirName && ls -la --group-directories-first --color=never && pwd\n");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 9,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
