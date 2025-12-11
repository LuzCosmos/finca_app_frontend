import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/recieve_cattle_form.dart';

class PurchaseReceptionInfo extends StatefulWidget {
  final List<Map<String, dynamic>> lots;
  final Future<void> Function(CattleData) onSubmit;

  const PurchaseReceptionInfo({super.key, required this.lots, required this.onSubmit});

  @override
  State<PurchaseReceptionInfo> createState() => _PurchaseReceptionInfoState();
}

class _PurchaseReceptionInfoState extends State<PurchaseReceptionInfo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}