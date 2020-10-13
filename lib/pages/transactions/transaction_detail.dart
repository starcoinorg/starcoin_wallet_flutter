import 'package:flutter/material.dart';
import 'package:starcoin_wallet/wallet/wallet_client.dart';
import 'package:stcerwallet/pages/routes/routes.dart';

class TransactionDetailPage extends StatelessWidget {
  static const String routeName = Routes.wallet + '/transaction_detail';
  final TransactionWithInfo transactionWithInfo;

  TransactionDetailPage({@required this.title, this.transactionWithInfo});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: new Text('TransactionDetail')),
        body: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 11),
              Row(
                children: <Widget>[
                  Text("Transaction Hash : "),
                  Text(
                      "${transactionWithInfo.txnInfo['transaction_hash']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Status : "),
                  Text(
                      "${transactionWithInfo.txnInfo['status']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Block Hash : "),
                  Text(
                      "${transactionWithInfo.event['block_hash']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Block Number : "),
                  Text(
                      "${transactionWithInfo.event['block_number']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Gas Used : "),
                  Text(
                      "${transactionWithInfo.txnInfo['gas_used']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Gas Price : "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['raw_txn']['gas_unit_price']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Gas Token Code : "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['raw_txn']['gas_token_code']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Max Gas Amount : "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['raw_txn']['max_gas_amount']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Sequence Number : "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['raw_txn']['sequence_number']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Sender Address : "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['raw_txn']['sender']}")
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text("Sender Public Key: "),
                  Text(
                      "${transactionWithInfo.txn['UserTransaction']['authenticator']['Ed25519']['public_key']}")
                ],
              ),
            ],
          ),
        ));
  }
}
