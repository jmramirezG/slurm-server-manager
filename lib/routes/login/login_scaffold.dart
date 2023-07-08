import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 650) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    return Stack(
      children: [
        Image(
          image:
              const AssetImage('assets/images/vertical_login_background.png'),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        WillPopScope(
          onWillPop: () {
            if (MediaQuery.of(context).orientation == Orientation.landscape) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
              ]);
            }
            return Future.value(true);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: child,
          ),
        ),
      ],
    );
  }
}
