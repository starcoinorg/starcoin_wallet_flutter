import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceivePage extends StatelessWidget {

  final String address;

  final String publicKey;

  final String _avatar;

  ReceivePage.name(this.address,this.publicKey, this._avatar);

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);

    final addressWithKey = publicKey+address;
    return new Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: publicKey ?? "",
              size: 150.0,
            ),
            SelectableText("Address is :"+address ?? "",),
            SelectableText("Public Key is :"+publicKey ?? ""),
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