// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';
import 'package:xml2json/xml2json.dart';

class NodesInfoScreen extends StatefulWidget {
  const NodesInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NodesInfoScreenState();
}

class _NodesInfoScreenState extends State<NodesInfoScreen> {
  /*
  
  Useful commands:
    * sinfo: Command used to show info about nodes.
      https://slurm.schedmd.com/sinfo.html
  
  Use commands above for every node and use ListView.builder

  */

  late List<Widget> _nodesInfo;

  static Map<String, String> valuesOfInterests = {
    "threads": S.current.threads.capitalize(),
    "cores": S.current.cores.capitalize(),
    "user": S.current.user.capitalize(),
    "avail": S.current.status.capitalize(),
    "free_mem": "${S.current.free_ram.capitalize()}(MB)",
    "cpu_load": S.current.cpu_load.capitalize(),
  };

  @override
  void initState() {
    _nodesInfo = [];

    fetchNodesInfo();
    super.initState();
  }

  List<Widget> buildSMIOutput(String xmlString) {
    List<Widget> finalWidgetList = [];
    if (xmlString.contains("srun: error")) {
      return [];
    }

    final myTransformer = Xml2Json();
    try {
      myTransformer.parse(xmlString);

      var json = jsonDecode(myTransformer.toParker());

      if (json["nvidia_smi_log"]["gpu"].runtimeType is List) {
        for (var gpuData in json["nvidia_smi_log"]["gpu"]) {
          List<Widget> thisGpuData = [];

          try {
            thisGpuData.add(
              Container(
                decoration: BoxDecoration(
                  color: thisGpuData.length % 2 == 0
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
                            S.current.total_memory.capitalize(),
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
                            gpuData["fb_memory_usage"]["total"].toString(),
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
          } catch (e) {}
          try {
            thisGpuData.add(
              Container(
                decoration: BoxDecoration(
                  color: thisGpuData.length % 2 == 0
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
                            S.current.memory_utilization.capitalize(),
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
                            gpuData["utilization"]["memory_util"].toString(),
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
          } catch (e) {}
          try {
            thisGpuData.add(
              Container(
                decoration: BoxDecoration(
                  color: thisGpuData.length % 2 == 0
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
                            S.current.gpu_utilization.capitalize(),
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
                            gpuData["utilization"]["gpu_util"].toString(),
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
          } catch (e) {}

          try {
            thisGpuData.add(
              Container(
                decoration: BoxDecoration(
                  color: thisGpuData.length % 2 == 0
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
                            S.current.temperature.capitalize(),
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
                            gpuData["temperature"]["gpu_temp"].toString(),
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
          } catch (e) {}
          try {
            thisGpuData.add(
              Container(
                decoration: BoxDecoration(
                  color: thisGpuData.length % 2 == 0
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
                            S.current.consumed_power.capitalize(),
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
                            gpuData["power_readings"]["power_draw"].toString(),
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
          } catch (e) {}
          finalWidgetList.add(
            Expandable(
              centralizeFirstChild: true,
              initiallyExpanded: false,
              firstChild: Text(
                gpuData["product_name"],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: thisGpuData,
              ),
            ),
          );
        }
      } else {
        List<Widget> widgetList = [];

        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.product_name.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["product_name"]
                              .toString(),
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
        } catch (e) {}
        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.total_memory.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["fb_memory_usage"]
                                  ["total"]
                              .toString(),
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
        } catch (e) {}
        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.memory_utilization.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["utilization"]
                                  ["memory_util"]
                              .toString(),
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
        } catch (e) {}
        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.gpu_utilization.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["utilization"]
                                  ["gpu_util"]
                              .toString(),
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
        } catch (e) {}

        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.temperature.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["temperature"]
                                  ["gpu_temp"]
                              .toString(),
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
        } catch (e) {}
        try {
          widgetList.add(
            Container(
              decoration: BoxDecoration(
                color: widgetList.length % 2 == 0
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
                          S.current.consumed_power.capitalize(),
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
                          json["nvidia_smi_log"]["gpu"]["power_readings"]
                                  ["power_draw"]
                              .toString(),
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
        } catch (e) {}

        finalWidgetList.add(
          Expandable(
            backgroundColor: Colors.transparent,
            centralizeFirstChild: true,
            initiallyExpanded: false,
            secondChild: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetList,
            ),
            firstChild: ListTile(
              tileColor:
                  Theme.of(context).colorScheme.tertiaryContainer.withOpacity(
                        0.3,
                      ),
              title: Text(
                "GPU",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      // finalWidgetList.add(
      //   Text(
      //     json["nvidia_smi_log"]["gpu"].toString(),
      //   ),
      // );
    } catch (e) {
      CustomLogging().logger.e("Could not build nvidia-smi output");
    }

    return finalWidgetList;
  }

  Future<void> fetchNodesInfo() async {
    List<String> rawNodeInfo = utf8
        .decode(
          await SSHManager().writeToSharedSession("LANG=C sinfo --Node -OAll"),
        )
        .split("\n");
    if (rawNodeInfo.length > 1) {
      List<String> header = rawNodeInfo.first.split("|");

      CustomLogging().logger.d("Header is $header");

      rawNodeInfo.removeAt(0);
      CustomLogging().logger.d("First row is ${rawNodeInfo.first}");

      List<Widget> widgetList = [];

      for (String row in rawNodeInfo) {
        row = row.trim();
        Widget? widgetsToAdd = await buildNodeCard(row.split("|"), header);

        if (widgetsToAdd != null) {
          widgetList.add(widgetsToAdd);
        }
      }

      setState(() {
        _nodesInfo = widgetList;
      });
    }
  }

  Future<Widget?> buildNodeCard(
      List<String> rawStringData, List<String> headerValues) async {
    try {
      Map<String, String> valuesForWidget = {};
      String hostName = "";
      for (int i = 0; i < headerValues.length; i++) {
        String thisHeaderValue = headerValues[i].toLowerCase().trim();
        if (valuesOfInterests.containsKey(thisHeaderValue)) {
          valuesForWidget[valuesOfInterests.putIfAbsent(
            thisHeaderValue,
            () => "",
          )] = rawStringData[i];
        } else if ("hostnames".contains(thisHeaderValue)) {
          hostName = rawStringData[i];
        }
      }

      List<Widget> widgetList = [];

      Widget title = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          hostName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      );

      valuesForWidget.forEach(
        (dataTitle, value) => widgetList.add(
          Container(
            decoration: BoxDecoration(
              color: widgetList.length % 2 == 0
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
                        dataTitle.toString(),
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
                        value.toString(),
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
        ),
      );

      widgetList.addAll(
        buildSMIOutput(
          utf8.decode(
            await SSHManager().writeToSharedSession(
                "LANG=C srun --immediate -s --job-name='get_gpu_data_for_node' -w $hostName nvidia-smi -x -q"),
          ),
        ),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        child: Expandable(
          centralizeFirstChild: true,
          initiallyExpanded: false,
          firstChild: title,
          secondChild: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList,
          ),
        ),
      );
    } catch (e) {
      CustomLogging()
          .logger
          .e("Widget could not be obtained from $rawStringData: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _nodesInfo,
      ),
    );
  }
}
