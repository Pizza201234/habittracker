import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget{
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      content:TextField(
        controller: controller,
      ),
      actions:
        [
          MaterialButton
            (
            onPressed:onSave,
            child:Text(
              "Save",
            ),
          ),
          MaterialButton
            (
            onPressed:onCancel,
            child:Text(
              "Cancel",
            ),
          ),
        ]
    );
  }
}