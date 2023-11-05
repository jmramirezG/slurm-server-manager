import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:slurm_server_manager/controllers/ssh_manager.dart';
import 'package:xterm/xterm.dart';

class SSHScreen extends StatefulWidget {
  const SSHScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SSHScreenState();
}

class _SSHScreenState extends State<SSHScreen> {
  late final terminal = Terminal(
    platform: TerminalTargetPlatform.android,
  );

  @override
  void initState() {
    super.initState();
    initTerminal();
  }

  Future<void> initTerminal() async {
    final session = await SSHManager().getShellWithConfig(
      SSHPtyConfig(
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
          .listen(terminal.write);

      session.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TerminalView(
            terminal,
            deleteDetection: true,
            keyboardType: TextInputType.text,
            scrollController: TrackingScrollController(),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          primary: false,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Colors.transparent,
                        ),
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => terminal.keyInput(
                        TerminalKey.tab,
                      ),
                      child: const Text(
                        "TAB",
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Colors.transparent,
                        ),
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => terminal.charInput(
                        0x63,
                        ctrl: true,
                      ),
                      child: const Text(
                        "Ctrl-C",
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Colors.transparent,
                        ),
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => terminal.charInput(
                        0x64,
                        ctrl: true,
                      ),
                      child: const Text(
                        "Ctrl-D",
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Colors.transparent,
                        ),
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                          TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => terminal.charInput(
                        0x78,
                        ctrl: true,
                      ),
                      child: const Text(
                        "Ctrl-X",
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      iconSize: MediaQuery.of(context).size.height / 30,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => terminal.keyInput(
                        TerminalKey.arrowUp,
                      ),
                      icon: const Icon(
                        Icons.arrow_upward,
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      iconSize: MediaQuery.of(context).size.height / 30,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => terminal.keyInput(
                        TerminalKey.arrowDown,
                      ),
                      icon: const Icon(
                        Icons.arrow_downward,
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      iconSize: MediaQuery.of(context).size.height / 30,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => terminal.keyInput(
                        TerminalKey.arrowLeft,
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 10,
                      thickness: 1,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      iconSize: MediaQuery.of(context).size.height / 30,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => terminal.keyInput(
                        TerminalKey.arrowRight,
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
