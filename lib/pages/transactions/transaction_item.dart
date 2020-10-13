
import 'package:flutter/material.dart';
import 'package:starcoin_wallet/wallet/wallet_client.dart';
import 'package:stcerwallet/pages/transactions/transaction_detail.dart';
import 'package:stcerwallet/style/styles.dart';

Color darkBlue = Color(0xff071d40);
Color lightBlue = Color(0xff1b4dff);

class TransactionItem extends StatelessWidget {
  final TransactionWithInfo transactionWithInfo;

  const TransactionItem({
    Key key,
    this.transactionWithInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(
              builder: (context) => TransactionDetailPage(title: "TransactionDetail",transactionWithInfo: transactionWithInfo)));
        },
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "new txn ",
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .apply(color: darkBlue, fontWeightDelta: 2),
              ),
            ),
          ],
        ),
        SizedBox(height: 11),
        Row(
          children: <Widget>[
            Text("Sender: "),
            Text("${transactionWithInfo.txn['UserTransaction']['authenticator']['Ed25519']['public_key']}")
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            new Expanded(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text("Transaction Number: "),
                  Text("${transactionWithInfo.txn['UserTransaction']['raw_txn']['sequence_number']}")
                ])),
            new Padding(
              padding: EdgeInsets.only(right: Dimens.padding),
              child: new Icon(
                Icons.keyboard_arrow_right,
                size: Dimens.itemIconSize,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[Text("Type: "), Text((() {
            if(transactionWithInfo.paymentType==PaymentType.Send){
              return "Send";}
            return "Recieve";
          })())],
        ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[Text("Status: "), Text("${transactionWithInfo.txnInfo['status']}")],
        ),
        Divider(
          height: 21,
        ),
      ],
    ));
  }
}
