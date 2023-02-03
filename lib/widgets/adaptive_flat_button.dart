import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;
  const AdaptiveFlatButton(this.text, this.handler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: Colors.purple, onPressed: handler, child: Text(text))
        : TextButton(
            onPressed: handler,
            child: Text(text),
          );
  }
}
