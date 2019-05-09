import 'package:flutter/material.dart';

class BottomModal extends Dialog {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Card(
            child: TextField(),
          )
        ],
      ),
    );
  }
}