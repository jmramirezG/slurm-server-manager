import 'dart:async';

import 'package:slurm_server_manager/utils/custom_logging.dart';

class LoginController {
  static bool loginInProcess = false;
  static LoginController? _instance;
  bool connected = false;
  String loginStatus = "";

  factory LoginController() {
    _instance ??= LoginController._();
    return _instance!;
  }

  LoginController._() {
    //apiController.apiSignal.listen(apiControllerSlot);
  }

  Future<void> login(String username, String? password) async {
    loginInProcess = true;
    CustomLogging().logger.i("Initializing ...");
    Completer completer = Completer();

    if (!connected) {
      CustomLogging().logger.i("We are not connected yet. Doing it");
      // Try to connect
    }

    if (!connected) {
      await Future.doWhile(
          () => Future.delayed(Duration.zero).then((_) => !connected));
    }

    CustomLogging().logger.i("Connected.");

    return completer.future;
  }
}
