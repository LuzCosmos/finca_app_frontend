import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Selector de fecha para filtros de listado (móvil y web).
class MassiveEventListDateFilterField extends StatelessWidget {
  const MassiveEventListDateFilterField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.width,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final inner = InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 1),
        );
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value == null ? '—' : DateFormat('yyyy/MM/dd').format(value!),
        ),
      ),
    );
    if (width != null) {
      return SizedBox(width: width, child: inner);
    }
    return inner;
  }
}
