import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ReportsPageState();
  }
}

class ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Reports Page'),);
  }
}