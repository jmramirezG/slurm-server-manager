// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class ServerInfoScreen extends StatefulWidget {
  const ServerInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ServerInfoScreenState();
}

class _ServerInfoScreenState extends State<ServerInfoScreen> {
  /*
  
  Useful commands:
    * lsblk

    * df -h

    * lscpu

    * top

    * free -b | grep \":\" | head -1 | tr -s ' ' | cut -d ':' -f2 | awk '{\$1=\$1};1'
      bytes: total usado libre compartido búf/caché disponible
  
  Combine all commands above with listview.builder

  */

  late List<Widget> _staticWidgets;

  late String? xmlString;

  @override
  void initState() {
    _staticWidgets = [];
    xmlString = null;

    initPeriodicState();

    super.initState();
  }

  Future<void> initPeriodicState() async {
    List<Widget> staticWidgets = [];

    List<dynamic> lscpuData = json.decode(
      utf8.decode(
        await SSHManager().writeToSharedSession("LANG=C lscpu -J"),
      ),
    )["lscpu"];

    if (lscpuData.isNotEmpty && lscpuData.length > 6) {
      Map<String, String> searchedValues = {
        "architecture:": S.current.architecture.capitalize(),
        "model name:": S.current.cpu_model.capitalize(),
        "cpu(s):": S.current.count_cpu.capitalize(),
        "thread(s) per core:": S.current.threads_core.capitalize(),
        "«socket(s)»": "Sockets",
        "l1d": "Cache L1d",
        "l1i": "Cache L1i",
        "l2": "Cache L2",
        "l3": "Cache L3",
      };
      List<String> foundKeys = [];

      List<Widget> cpuDataWidgets = [];
      for (dynamic element in lscpuData) {
        try {
          String foundElement = "";
          for (String key in searchedValues.keys) {
            if ((element["field"].toString().toLowerCase().contains(key) ||
                    key.contains(element["field"].toString().toLowerCase())) &&
                !foundKeys.contains(key)) {
              foundKeys.add(key);
              foundElement = key;
              break;
            }
          }
          if (foundElement.isNotEmpty) {
            cpuDataWidgets.add(
              Container(
                decoration: BoxDecoration(
                  color: cpuDataWidgets.length % 2 == 0
                      ? Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.3)
                      : Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            searchedValues[foundElement].toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            element["data"].toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          CustomLogging()
              .logger
              .e("Element $element was not Map, trying with List");
          try {
            for (var innerElement in element) {
              try {
                String foundElement = "";
                for (String key in searchedValues.keys) {
                  if ((innerElement["field"]
                              .toString()
                              .toLowerCase()
                              .contains(key) ||
                          key.contains(innerElement["field"]
                              .toString()
                              .toLowerCase())) &&
                      !foundKeys.contains(key)) {
                    foundKeys.add(key);
                    foundElement = key;
                    break;
                  }
                }
                if (foundElement.isNotEmpty) {
                  cpuDataWidgets.add(
                    Container(
                      decoration: BoxDecoration(
                        color: cpuDataWidgets.length % 2 == 0
                            ? Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.3)
                            : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchedValues[innerElement["field"]
                                          .toString()
                                          .toLowerCase()]
                                      .toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .fontSize,
                                  ),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  innerElement["data"].toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } catch (e) {
                CustomLogging().logger.e("Element $innerElement was not Map");
              }
            }
          } catch (e) {
            CustomLogging().logger.e("Element $element was not List");
          }
        }
      }
      staticWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 8.0,
          ),
          child: Expandable(
            centralizeFirstChild: true,
            initiallyExpanded: false,
            firstChild: Text(
              "CPU",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
              textAlign: TextAlign.center,
            ),
            secondChild: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: cpuDataWidgets,
            ),
          ),
        ),
      );
    }

    String fileSystemInfoRaw = utf8.decode(
      await SSHManager().writeToSharedSession("df -hl"),
    );

    List<String> fileSystemInfo = fileSystemInfoRaw.split("\n").sublist(
          1,
          fileSystemInfoRaw.split("\n").length - 1,
        );

    if (fileSystemInfo.isNotEmpty) {
      List<Widget> fileSystemWidgets = [];
      for (String element in fileSystemInfo) {
        element = element.trim();
        if (element.isNotEmpty) {
          List<String> splitElementList = element.split(" ");
          splitElementList.removeWhere((element) => element.isEmpty);
          fileSystemWidgets.add(
            Container(
              decoration: BoxDecoration(
                color: fileSystemWidgets.length % 2 == 0
                    ? Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.3)
                    : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          splitElementList.first.toString().trim(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${S.current.mounted_in(splitElementList.last.toString().trim())}\n${S.current.percent_used(
                            splitElementList[2].toString().trim(),
                            splitElementList[4].toString().trim(),
                            splitElementList[1].toString().trim(),
                          )}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }

      staticWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 8.0,
          ),
          child: Expandable(
            centralizeFirstChild: true,
            initiallyExpanded: false,
            firstChild: Text(
              S.current.filesystem.capitalize(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
              textAlign: TextAlign.center,
            ),
            secondChild: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: fileSystemWidgets,
            ),
          ),
        ),
      );
    }

    List<String> ramInfo = utf8
        .decode(
          await SSHManager().writeToSharedSession(
              "free -h --si | grep \":\" | head -1 | tr -s ' ' | cut -d ':' -f2 | awk '{\$1=\$1};1'"),
        )
        .trim()
        .split(" ");

    if (ramInfo.isNotEmpty) {
      List<Widget> ramWidgets = [];

      if (ramInfo.isNotEmpty && ramInfo.length >= 6) {
        ramWidgets.addAll(
          [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo.first.trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.used.capitalize(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo[1].trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.free.capitalize(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo[2].trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.shared.capitalize(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo[3].trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Buffer",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo[4].trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.available.capitalize(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          ramInfo[5].trim().toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      staticWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 8.0,
          ),
          child: Expandable(
            centralizeFirstChild: true,
            initiallyExpanded: false,
            firstChild: Text(
              "RAM",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
              textAlign: TextAlign.center,
            ),
            secondChild: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: ramWidgets,
            ),
          ),
        ),
      );
    }

    setState(() {
      _staticWidgets = staticWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _staticWidgets,
      ),
    );
  }
}
