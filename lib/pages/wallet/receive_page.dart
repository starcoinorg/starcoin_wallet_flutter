import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceivePage extends StatelessWidget {

  final String address;

  final String publicKey;


  ReceivePage.name(this.address,this.publicKey);

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: publicKey ?? "",
              size: 250.0,
            ),
            SizedBox(height: 5),
            Text(" Address ",style: TextStyle(color:Colors.grey),),
            SelectableText(address ?? "",),
            SizedBox(height: 5),
            Text(" Public Key ",style: TextStyle(color:Colors.grey),),
            SelectableText(publicKey ?? ""),
          ],
        ),
      ));
  }

  _appBar(BuildContext context) {
    return new AppBar(
      title: new Text('Receive'),
    );
  }
}