
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  CustomCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text.rich(
          TextSpan(
            text: "J'accepte les ",
            children: [
              TextSpan(
                text: "conditions d'utilisation",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Ajouter la logique de navigation ici
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
