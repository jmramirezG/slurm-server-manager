// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:slurm_server_manager/generated/l10n.dart';
import 'package:slurm_server_manager/models/job_model.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/string_extensions.dart';

class JobModal extends StatelessWidget {
  final Job jobData;

  const JobModal({
    super.key,
    required this.jobData,
  });

  /*
  
  Useful slurm commands:
    * squeue (and params): Get general info about all jobs, maybe filter by jobid to parse current job‘s info

    * scancel: Stop a job by passing the jobid.

    * sstat: Get specific info about a job using the jobid: CPU usage, VM usage, task info, node info...
      IMPORTANT: AVOID SENDING A LOT OF SSTATs AS IT WILL OVERLOAD THE SERVER

    * sacct: Get info about past jobs.
      https://slurm.schedmd.com/sstat.html

    * scontrol: Manage jobs and get info about them. Can replace all previous commands.
      https://slurm.schedmd.com/scontrol.html

  */
  @override
  Widget build(BuildContext context) {
    List<Widget> availableButtons = <Widget>[];
    if (jobData.status == JobStatus.RUNNING ||
        jobData.status == JobStatus.CONFIGURING ||
        jobData.status == JobStatus.PENDING ||
        jobData.status == JobStatus.UNKNOWN) {
      availableButtons.add(
        FilledButton(
          onPressed: () async {
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  alignment: Alignment.center,
                  title: Text(
                    S.current.cancel.capitalize(),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  content: Text(
                    S.current.comfirm_cancel.capitalize(),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: <Widget>[
                    FilledButton(
                      style: ButtonStyle(
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
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
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
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
              await SSHManager().writeToSharedSession("scancel ${jobData.id}");
            }

            if (context.canPop()) {
              context.pop();
            }
          },
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
              S.current.cancel.toUpperCase(),
            ),
          ),
        ),
      );
    }
    bool canPause = false;
    bool needsPause = false;
    if (jobData.status == JobStatus.RUNNING) {
      canPause = true;
      needsPause = true;
    } else if (jobData.status == JobStatus.SUSPENDED ||
        jobData.status == JobStatus.STOPPED) {
      canPause = true;
    }

    if (canPause) {
      availableButtons.add(
        FilledButton(
          onPressed: () async {
            String result = utf8.decode(
              await SSHManager().writeToSharedSession(
                  "scontrol ${needsPause ? "suspend" : "resume"} ${jobData.id}"),
            );
            CustomLogging().logger.d("Result is $result");
            if (result.toLowerCase().contains("permission denied")) {
              CustomLogging().logger.d("Trying with sudo");
              String? userPassword = SSHManager().getPassword();
              if (SSHManager().getIsKey()) {
                TextEditingController passwordController =
                    TextEditingController(
                  text: "",
                );

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
                                S.current.superuser_permissions_required
                                    .capitalize(),
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
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.pop(passwordController.text),
                              child: Text(
                                S.current.accept.capitalize(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize,
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
              result = utf8.decode(
                await SSHManager().writeToSharedSession(
                    "echo $userPassword | sudo -S scontrol ${needsPause ? "suspend" : "resume"} ${jobData.id}"),
              );

              CustomLogging().logger.d("Result is $result");
            }
            if (context.canPop()) {
              context.pop();
            }
          },
          style: ButtonStyle(
            textStyle: MaterialStatePropertyAll<TextStyle>(
              TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Colors.white,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: needsPause ? 16.0 : 4.0,
            ),
            child: Text(
              needsPause
                  ? S.current.pause.toUpperCase()
                  : S.current.resume.toUpperCase(),
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
            width: MediaQuery.of(context).size.width * 4.5 / 5,
            height: MediaQuery.of(context).size.height * 1 / 2,
            child: Card(
              elevation: 20,
              margin: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.current.job_info.capitalize(),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.jobid.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    jobData.id.toString(),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.name.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    jobData.name,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.status.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    jobData.status.name
                                        .toLowerCase()
                                        .capitalize(),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color: jobData.status == JobStatus.RUNNING
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : jobData.status ==
                                                      JobStatus.SUSPENDED ||
                                                  jobData.status ==
                                                      JobStatus.CANCELLED ||
                                                  jobData.status ==
                                                      JobStatus.FAILED
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.submit_time.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.MMMd()
                                        .add_jms()
                                        .format(jobData.submitTime),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    textWidthBasis: TextWidthBasis.parent,
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.start_time.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    jobData.startTime.year == 0
                                        ? "-"
                                        : DateFormat.yMMMd()
                                            .add_jms()
                                            .format(jobData.startTime),
                                    style: TextStyle(
                                      fontSize: jobData.startTime.year == 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontSize
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.current.end_time.capitalize()}:",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    jobData.endTime.year == 0
                                        ? "-"
                                        : DateFormat.yMMMd()
                                            .add_jms()
                                            .format(jobData.endTime),
                                    style: TextStyle(
                                      fontSize: jobData.endTime.year == 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontSize
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .fontSize,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [...availableButtons],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                      ),
                      child: FilledButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          }
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStatePropertyAll<TextStyle>(
                            TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              S.current.exit.toUpperCase(),
                            ),
                          ),
                        ),
                      ),
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
