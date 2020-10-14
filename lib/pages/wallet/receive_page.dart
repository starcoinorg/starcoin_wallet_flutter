import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:starcoin_wallet/wallet/helper.dart';

class ReceivePage extends StatelessWidget {

  final String publicKey;

  ReceivePage.name(this.publicKey);

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    final address=Helpers.publicKeyIntoAddressHex(publicKey);

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
            SelectableText("Address is :0x"+address ?? "",),
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