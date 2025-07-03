import 'package:flutter/material.dart';

class PlatformAwarePage extends StatelessWidget {
  final Map<String, dynamic> platformInfo;

  const PlatformAwarePage(this.platformInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Información de Plataforma')),
      body: ListView.builder(
        itemCount: platformInfo.length,
        itemBuilder: (context, index) {
          final key = platformInfo.keys.elementAt(index);
          final value = platformInfo[key];

          return ListTile(
            title: Text(key.toString()),
            subtitle: Text(value.toString()),
          );
        },
      ),
    );
  }
}
