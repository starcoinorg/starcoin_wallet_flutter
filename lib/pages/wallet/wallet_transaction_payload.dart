import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:starcoin_wallet/starcoin/starcoin.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:stcerwallet/components/wallet/transaction_payload_form.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/util/wallet_util.dart';
import 'dart:developer';

class WalletTransactionPayloadPage extends HookWidget {
  static const String routeName = Routes.wallet + '/transaction_payload';

  WalletTransactionPayloadPage(
      {@required this.payloadHex, @required this.privateKeyString});

  final String payloadHex;
  final String privateKeyString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction With Payload"),
      ),
      body: TransactionPayloadForm(
        transactionPayloadHex: payloadHex,
        onSubmit: (payloadHex) async {
          try {
            final privateKey = Helpers.hexToBytes(privateKeyString);
            final account = Account.fromPrivateKey(privateKey, BASEURL);
            final payloadLcs = Helpers.hexToBytes(payloadHex);
            final payload = TransactionPayload.lcsDeserialize(payloadLcs);
            await account.sendTransaction(payload);
          } catch (ex) {
            log(ex);
          }
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );
  }
}
