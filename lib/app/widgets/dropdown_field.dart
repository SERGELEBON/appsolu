
import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;

  DropdownField({
    required this.label,
    required this.icon,
    required this.items,
    this.validator,
    this.onSaved,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: validator,
      onSaved: onSaved, onChanged: (String? value) {  },
    );
  }
}
