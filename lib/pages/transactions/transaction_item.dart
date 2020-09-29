
import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/transactions/transaction_detail.dart';
import 'package:stcerwallet/style/styles.dart';

Color darkBlue = Color(0xff071d40);
Color lightBlue = Color(0xff1b4dff);

class TransactionItem extends StatelessWidget {
  final Map<String, String> transaction;

  const TransactionItem({
    Key key,
    this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.pushNamed(context,TransactionDetailPage.routeName);
        },
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${transaction['title']}",
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
            Text("Originator: "),
            Text("${transaction['originator']}")
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
                  Text("${transaction['transaction_number']}")
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
          children: <Widget>[Text("Type: "), Text("${transaction['type']}")],
        ),
        Divider(
          height: 21,
        ),
      ],
    ));
  }
}
