import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';

class SSHManager {
  static SSHManager? _instance;

  SSHClient? _activeClient;
  String? _activeClientAddress;
  String? _activeClientPassword;
  bool _activeClientIsKey = false;

  void Function(dynamic)? _onError;

  factory SSHManager() {
    _instance ??= SSHManager._();
    return _instance!;
  }

  SSHManager._();

  Future<SSHClient> establishConnection(
    String address,
    int port,
    String username,
    String password,
    bool isKey,
  ) async {
    _activeClientAddress ??= address;
    _activeClientPassword ??= password;
    _activeClientIsKey = isKey;
    if (isKey) {
      _activeClient ??= SSHClient(
        await SSHSocket.connect(
          address,
          port,
        ),
        username: username,
        identities: [
          ...SSHKeyPair.fromPem(password),
        ],
      );
    } else {
      _activeClient ??= SSHClient(
        await SSHSocket.connect(
          address,
          port,
        ),
        username: username,
        onPasswordRequest: () => password,
      );
    }

    return _activeClient!;
  }

  SSHClient? getActiveConnection() {
    if (_activeClient != null) {
      return _activeClient!;
    }

    return null;
  }

  Future<SSHSession?> getShellWithConfig(SSHPtyConfig shellConfig) async {
    if (_activeClient != null) {
      return _activeClient!.shell(pty: shellConfig);
    }

    return Future.value(null);
  }

  void closeConnection() {
    if (_activeClient != null) {
      _activeClient!.close();
      _activeClient = null;
      _onError = null;
      _activeClientAddress = null;
      _activeClientPassword = null;
    }
  }

  void abortConnection() {
    _activeClient = null;
    _onError = null;
  }

  Future<Uint8List> writeToSharedSession(String command) async {
    if (_activeClient != null) {
      try {
        return await _activeClient!.run(command);
      } catch (e) {
        CustomLogging().logger.e("Error writing to shared session: $e");
        if (_onError != null) {
          _onError!(e);
        }
      }
    }
    return Uint8List(1);
  }

  void onError(void Function(dynamic) onErrorCallback) {
    _onError = onErrorCallback;
  }

  String? getAddress() {
    return _activeClientAddress;
  }

  String? getPassword() {
    return _activeClientPassword;
  }

  bool getIsKey() {
    return _activeClientIsKey;
  }
}
