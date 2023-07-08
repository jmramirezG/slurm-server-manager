import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController passwordController;

  final void Function() callback;

  final FocusNode focusNodePassword;

  const PasswordInput({
    super.key,
    required this.passwordController,
    required this.callback,
    required this.focusNodePassword,
  });

  @override
  State<StatefulWidget> createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  late bool _obscurePassword;
  @override
  void initState() {
    super.initState();
    _obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(
                  0, 3), // Cambia la posición de la sombra (elevación)
            )
          ],
        ),
        child: TextFormField(
          focusNode: widget.focusNodePassword,
          onTapOutside: (a) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          keyboardType: TextInputType.text,
          onFieldSubmitted: (value) {
            widget.callback();
          },
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Contraseña",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            prefixIcon: Icon(
              Icons.lock,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).colorScheme.primary,
                //color: Colors.grey.shade500,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
