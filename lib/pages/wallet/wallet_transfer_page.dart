import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/components/wallet/transfer_form.dart';


class WalletTransferPage extends HookWidget {
  WalletTransferPage({@required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    //var transferStore = useWalletTransfer(context);
    var qrcodeAddress = useState();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed:  () {
              Navigator.of(context).pushNamed(
                "/qrcode_reader",
                arguments: (scannedAddress) async {
                  qrcodeAddress.value = scannedAddress.toString();
                },
              );
            }
          ),
        ],
      ),
      body: TransferForm(
        address: qrcodeAddress.value,
        onSubmit: (address, amount) async {
          //var success = await transferStore.transfer(address, amount);
          final success = true;

          if (success) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
      ),
    );
  }
}