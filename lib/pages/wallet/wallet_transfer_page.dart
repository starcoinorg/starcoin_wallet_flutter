import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/components/wallet/transfer_form.dart';
import 'package:stcerwallet/context/transfer/wallet_transfer_provider.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'dart:io';

import 'package:stcerwallet/pages/wallet/qrcode_reader_page.dart';

class WalletTransferPage extends HookWidget {

  static const String routeName = Routes.wallet + '/transfer';

  WalletTransferPage({@required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var transferStore = useWalletTransfer(context);
    var qrcodeAddress = useState();

    var reader;
    if(Platform.isAndroid||Platform.isIOS){
      reader=<Widget>[
        IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed:  () {
              Navigator.of(context).pushNamed(
                QRCodeReaderPage.routeName,
                arguments: (scannedAddress) async {
                  qrcodeAddress.value = scannedAddress.toString();
                },
              );
            }
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: reader,
      ),
      body: TransferForm(
        address: qrcodeAddress.value,
        onSubmit: (address,publicKey, amount) async {
          final success = await transferStore.transfer(address, publicKey,amount);

          if (success) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
      ),
    );
  }
}