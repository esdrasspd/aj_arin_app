import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator; // Agregar el validador

  const DatePickerField({
    Key? key,
    required this.controller,
    this.labelText = 'Fecha de nacimiento',
    this.validator, // Añadir al constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            validator: validator, // Usar el validador aquí
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.teal.shade900),
              suffixIcon:
                  Icon(Icons.calendar_today, color: Colors.teal.shade700),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                controller.text = pickedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
        ),
      ),
    );
  }
}
