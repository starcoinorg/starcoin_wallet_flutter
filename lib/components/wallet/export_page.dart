import 'package:stcerwallet/components/copyButton/copy_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExportPage extends HookWidget {
  ExportPage({this.content, this.title});

  final String content;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(
                      this.content,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CopyButton(
                        text: const Text('Export'),
                        value: this.content,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
