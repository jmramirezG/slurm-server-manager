import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/job_model.dart';
import 'package:slurm_server_manager/utils/custom_circular_progress.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/globals.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double _loadAverage;
  late Duration _uptime;
  late List<Job> _jobList;
  late int _timeDiff;

  static bool stopTimerFlag = false;

  @override
  void initState() {
    super.initState();
    _loadAverage = 0.0;
    _uptime = Duration.zero;
    _jobList = [];

    _timeDiff = 0;

    initShell();
  }

  void manageError(dynamic e) {
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

  Future<void> initShell() async {
    SSHManager().onError(manageError);

    await getTimeDiff();

    await reloadState();

    Timer.periodic(
      const Duration(
        seconds: 7,
      ),
      (timer) async {
        if (stopTimerFlag) {
          timer.cancel();
        } else {
          await reloadState();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    stopTimerFlag = true;
  }

  @override
  void dispose() {
    super.dispose();
    stopTimerFlag = true;
  }

  Future<void> getTimeDiff() async {
    SSHManager sshManager = SSHManager();
    if (sshManager.getActiveConnection() != null) {
      DateTime timeSystem = DateTime.parse(
        utf8
            .decode(
              await sshManager.writeToSharedSession("date +%FT%H:%M:%S%z"),
            )
            .trim(),
      );

      CustomLogging().logger.d("Time system is $timeSystem");

      DateTime timeLocal = DateTime.now();

      CustomLogging().logger.d("Time local is $timeLocal");

      Duration diff = Duration(
        minutes: timeLocal.minute - timeSystem.minute,
        seconds: timeLocal.second - timeSystem.second,
        days: timeLocal.day - timeSystem.day,
        hours: timeLocal.hour - timeSystem.hour,
      );

      CustomLogging().logger.d("Time diff is $diff");

      setState(() {
        _timeDiff = diff.inHours;
      });
    }
  }

  double _getLoadAvgFromNodes(List<String> values) {
    double cpuSum = 0;
    double loadSum = 0;

    for (String nodeInfo in values) {
      if (nodeInfo.trim().isNotEmpty) {
        nodeInfo = nodeInfo.trim();
        List<String> nodeValues = nodeInfo.split(" ");
        cpuSum += int.parse(
              nodeValues[0].trim(),
            ) *
            int.parse(
              nodeValues[1].trim(),
            ) *
            int.parse(
              nodeValues[2].trim(),
            );
        loadSum += double.parse(
          nodeValues[3].trim(),
        );
      }
    }

    return (loadSum / cpuSum) * 100;
  }

  Future<void> reloadState() async {
    SSHManager sshManager = SSHManager();
    if (sshManager.getActiveConnection() != null) {
      Duration uptime = Duration(
        seconds: double.parse(
          utf8.decode(
            await sshManager
                .writeToSharedSession("echo \$(cut -d ' ' -f 1 </proc/uptime)"),
          ),
        ).toInt(),
      );

      CustomLogging().logger.d("Uptime is $uptime");

      List<String> valuesWithNoHeader = utf8
          .decode(
            await sshManager
                .writeToSharedSession('sinfo --Node --format "%X %Y %Z %O"'),
          )
          .split("\n")
          .sublist(
            1,
          );

      CustomLogging().logger.d("load avg values are $valuesWithNoHeader");

      double loadAvg = _getLoadAvgFromNodes(valuesWithNoHeader);

      CustomLogging().logger.d("load average is $_loadAverage");

      List<String> scontrolOutput = utf8
          .decode(
            await sshManager.writeToSharedSession("scontrol -a show job"),
          )
          .split("\n\n");

      //CustomLogging().logger.d("scontrolOutput is $scontrolOutput");

      List<Job> jobList = [];

      for (String jobRaw in scontrolOutput) {
        if (jobRaw.isNotEmpty && !jobRaw.contains("No jobs")) {
          try {
            List<String> rows = jobRaw.split(
              "\n",
            );
            int id = int.parse(
              rows[0].trim().split(" ")[0].split("=")[1],
            );
            String name = rows[0].split(" ")[1].split("=")[1];
            String userId =
                rows[1].trim().split(" ")[0].split("=")[1].substring(
                      0,
                      rows[1].trim().split(" ")[0].split("=")[1].indexOf("("),
                    );
            DateTime submitTime = DateTime.parse(
              rows[6].trim().split(" ")[0].split("=")[1],
            );
            JobStatus status = JobStatusExtension.fromString(
              rows[3].trim().split(" ")[0].split("=")[1],
            );
            DateTime startTime = DateTime(0);
            DateTime endTime = DateTime(0);
            try {
              startTime = DateTime.parse(
                rows[8].trim().split(" ")[0].split("=")[1],
              );
            } catch (e) {
              startTime = DateTime(0);
              CustomLogging().logger.e("Error parsing startTime: $e");
            }
            try {
              endTime = DateTime.parse(
                rows[8].trim().split(" ")[1].split("=")[1],
              );
            } catch (e) {
              endTime = DateTime(0);
              CustomLogging().logger.e("Error parsing endTime: $e");
            }

            if (status != JobStatus.UNKNOWN &&
                name != "get_gpu_data_for_node") {
              jobList.add(
                Job(
                  id,
                  name,
                  userId,
                  submitTime.add(
                    Duration(
                      hours: _timeDiff,
                    ),
                  ),
                  startTime.add(
                    Duration(
                      hours: _timeDiff,
                    ),
                  ),
                  endTime.add(
                    Duration(
                      hours: _timeDiff,
                    ),
                  ),
                  status,
                ),
              );
            }
          } catch (e) {
            CustomLogging().logger.e(
                "Error while processing job: $e\n rows are: ${jobRaw.split("\n")}");
          }
        }
      }

      setState(() {
        _uptime = uptime;
        _loadAverage = loadAvg;
        _jobList = jobList;
      });

      // TODO squeue and squeue --user to get all running jobs
    }
  }

  @override
  Widget build(BuildContext context) {
    int days = _uptime.inDays;
    stopTimerFlag = false;

    Widget uptimeWidget = SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: Text(
          days > 1
              ? S.current
                  .server_uptime_with_days(
                    days.toString(),
                    (_uptime - Duration(days: days)).inHours.toString(),
                    ((_uptime - Duration(days: days)).inMinutes % 60)
                        .toString(),
                  )
                  .capitalize()
              : S.current
                  .server_uptime(
                    _uptime.inHours.toString(),
                    (_uptime.inMinutes % 60).toString(),
                  )
                  .capitalize(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        primary: true,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: CircularBorderIcon(
                  color: Theme.of(context).colorScheme.secondary,
                  size: (MediaQuery.of(context).size.width / 2) -
                      (MediaQuery.of(context).size.width / 20),
                  extra: Center(
                    child: Text(
                      S.current.load_avg.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall!.fontSize,
                      ),
                    ),
                  ),
                  percentage: _loadAverage,
                ),
              ),
            ),
          ),
          uptimeWidget,
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.list_of_jobs.capitalize(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          _jobList.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Text(
                      S.current.no_jobs_available.capitalize(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall!.fontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SliverList.builder(
                  itemCount: _jobList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: Card(
                      margin: const EdgeInsets.all(
                        0.0,
                      ),
                      elevation: 5,
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () => GoRouter.of(context).push(
                          Globals.jobModal,
                          extra: _jobList[index],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${S.current.job.capitalize()} ${_jobList[index].id}: ${_jobList[index].name}",
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
                                _jobList[index]
                                    .status
                                    .name
                                    .toLowerCase()
                                    .capitalize(),
                                style: TextStyle(
                                  color: _jobList[index].status ==
                                          JobStatus.RUNNING
                                      ? Theme.of(context).colorScheme.primary
                                      : _jobList[index].status ==
                                                  JobStatus.SUSPENDED ||
                                              _jobList[index].status ==
                                                  JobStatus.CANCELLED ||
                                              _jobList[index].status ==
                                                  JobStatus.FAILED
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .fontSize,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
