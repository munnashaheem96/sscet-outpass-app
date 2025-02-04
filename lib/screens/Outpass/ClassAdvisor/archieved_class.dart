import 'package:flutter/material.dart';

class ArchivedClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Classes'),
      ),
      body: Center(
        child: Text('No archived classes available.'),
      ),
    );
  }
}