import 'package:flutter/material.dart';

/// Navegación genérica a cualquier página (Widget)
void openPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}
