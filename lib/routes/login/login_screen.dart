import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:slurm_server_manager/controllers/login_controller.dart';
import 'package:slurm_server_manager/routes/login/password_input.dart';
import 'package:slurm_server_manager/utils/custom_logging.dart';
import 'package:slurm_server_manager/utils/globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late bool _showBiometric;
  late bool _autofillUsername;
  late TextEditingController __usernameController;
  late TextEditingController _passwordController;
  late FocusNode focusNodePassword;
  late FocusNode focusNodeScreen;
  late FutureBuilder _usernameInput;
  late PasswordInput _passwordInput;

  @override
  void initState() {
    super.initState();
    _showBiometric = true;
    _autofillUsername = true;
    __usernameController = TextEditingController();
    _passwordController = TextEditingController();
    focusNodePassword = FocusNode();
    focusNodeScreen = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
        //DeviceOrientation.landscapeLeft,
        //DeviceOrientation.landscapeRight,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /*final languaje = Localizations.localeOf(context).languageCode;
    CustomLogging().logger.d("Languaje: $languaje");
    if (languaje == "en") {
      Globals.measurementSystem = 2;
      Globals.temperatureMeasurement = 2;
    }*/

    if (MediaQuery.of(context).size.width < 650) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    BoxDecoration inputContainerDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset:
              const Offset(0, 3), // Cambia la posición de la sombra (elevación)
        )
      ],
    );

    _usernameInput = usernameInput(context, inputContainerDecoration);

    _passwordInput = PasswordInput(
      callback: () {
        if (__usernameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          login();
        }
      },
      focusNodePassword: focusNodePassword,
      passwordController: _passwordController,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: SafeArea(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
                left: 8,
                top: 16,
              ),
              child: FutureBuilder(
                future: _checkAuthenticate(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data! && _showBiometric && _autofillUsername) {
                      return FutureBuilder(
                        future:
                            const FlutterSecureStorage().read(key: 'username'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.data!.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  brandLogo(
                                    context,
                                  ),
                                  _usernameInput,
                                  biometricAccesButton(),
                                  changeBiometricButton(
                                    context,
                                  ),
                                ],
                              );
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              brandLogo(
                                context,
                              ),
                              _usernameInput,
                              _passwordInput,
                              loginButton(
                                context,
                              ),
                              changeOnlyPassword(
                                context,
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      brandLogo(
                        context,
                      ),
                      _usernameInput,
                      _passwordInput,
                      loginButton(
                        context,
                      ),
                      changeOnlyPassword(
                        context,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding changeOnlyPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 4.0,
        bottom: 16,
      ),
      child: FutureBuilder<String?>(
        future: const FlutterSecureStorage().read(key: 'username'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              _autofillUsername) {
            return Row(
              children: (MediaQuery.of(context).size.width >
                      MediaQuery.of(context).size.height)
                  ? [
                      FilledButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: () {
                          setState(() {
                            _autofillUsername = false;
                          });
                        },
                        child: Text(
                          "Not you change user",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      FilledButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: () {
                          setState(() {
                            _autofillUsername = false;
                          });
                          CustomLogging().logger.i("Deleting databases ...");
                        },
                        child: Text(
                          "Not you change user",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Padding brandLogo(context) {
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 30.0,
        ),
        child: Image(
          image: const AssetImage("assets/images/azul_logo.png"),
          height: MediaQuery.of(context).size.height * 0.2,
          fit: BoxFit.fitWidth,
          alignment: Alignment.centerLeft,
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 30.0,
      ),
      child: Image(
        image: AssetImage("assets/images/azul_logo.png"),
      ),
    );
  }

  FutureBuilder usernameInput(context, decoration) {
    return FutureBuilder<String?>(
      future: const FlutterSecureStorage().read(key: 'username'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.data ?? '') != '') {
          __usernameController.text = __usernameController.text.isNotEmpty
              ? __usernameController.text
              : snapshot.data!;
          if (_autofillUsername) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 32,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    snapshot.data!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 32,
            bottom: 24.0,
          ),
          child: Container(
            decoration: decoration,
            child: TextFormField(
              onTapOutside: (a) {
                FocusScope.of(context).requestFocus(focusNodeScreen);
              },
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(focusNodePassword),
              controller: __usernameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "usuario",
                prefixIcon: Icon(
                  Icons.person_2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void parseError(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Error desconocido"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void login() {
    _login().then((value) {
      CustomLogging().logger.d("Going home...");
      GoRouter.of(context).go(Globals.homeScreen);
    }).catchError(
      (e) {
        parseError(e);
      },
    );
  }

  void loginBiometric() {
    _loginBiometric().then((value) {
      CustomLogging().logger.d("Going home...");
      GoRouter.of(context).go(Globals.homeScreen);
    }).catchError(
      (e) {
        parseError(e);
      },
    );
  }

  Future<void> _login() async {
    if (LoginController.loginInProcess) {
      throw FlutterError("IN PROGRESS");
    }
    CustomLogging().logger.d('Email:${__usernameController.text}');
    CustomLogging().logger.d('Password:${_passwordController.text}');
    await LoginController().login(
      __usernameController.text,
      _passwordController.text,
    );
  }

  Future<void> _loginBiometric() async {
    if (LoginController.loginInProcess) {
      throw FlutterError("IN PROGRESS");
    }

    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    CustomLogging().logger.d('canAuthenticate: $canAuthenticate');

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    CustomLogging().logger.d('availableBiometrics:$availableBiometrics');

    final bool authenticated = await auth.authenticate(
      localizedReason: "Autentica con la huella o la cara",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
        useErrorDialogs: true,
      ),
    );

    if (authenticated) {
      CustomLogging().logger.i('Autenticación biométrica exitosa');

      final username = await const FlutterSecureStorage().read(key: 'username');
      CustomLogging().logger.d('username biometric $username');

      await LoginController().login(username.toString(), null);
    } else {
      throw FlutterError("UNAUTHORIZED");
    }
  }

  Padding loginButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: FilledButton(
        onPressed: () {
          if (__usernameController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) {
            login();
          }
        },
        style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Inciar sesión",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding changeBiometricButton(context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 4.0,
        bottom: 16,
      ),
      child: Row(
        children: (MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height)
            ? [
                FilledButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    setState(() {
                      _showBiometric = false;
                    });
                  },
                  child: Text(
                    "Acceso con contraseña",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                FilledButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    setState(() {
                      _showBiometric = false;
                    });
                  },
                  child: Text(
                    "Acceso con contraseña",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
      ),
    );
  }

  Future<bool> _checkAuthenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    return await auth.canCheckBiometrics
        ? (await auth.getAvailableBiometrics()).isNotEmpty
        : false;
  }

  Widget biometricAccesButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: FilledButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
        onPressed: () {
          loginBiometric();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Text(
                "Acceso biométrico",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.fingerprint,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: Text(
                "Toca para iniciar",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
