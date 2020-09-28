import 'package:flutter/material.dart';

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
    return Column(
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
            SizedBox(width: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: Color(0xffd5d7dc),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text("Pairing"),
            )
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
            Text("Transaction Number: "),
            Text("${transaction['transaction_number']}")
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
    );
  }
}
