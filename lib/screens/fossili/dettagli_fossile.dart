import 'package:flutter/material.dart';

class DettagliFossile extends StatefulWidget {
  const DettagliFossile({Key? key}) : super(key: key);

  @override
  State<DettagliFossile> createState() => _DettagliFossileState();
}

class _DettagliFossileState extends State<DettagliFossile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text('dettagli'),

      ),
    );
  }
}
