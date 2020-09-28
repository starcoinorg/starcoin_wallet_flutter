import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/pages/transactions/transaction_item.dart';

List<Map<String, String>> transactions = [
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
];

class TransactionsPage extends StatelessWidget {
  static const String routeName = Routes.market + "/transactions";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            bottom: new PreferredSize(
                child: Divider(
                  height: Dimens.line,
                  color: theme.dividerColor,
                ),
                preferredSize: new Size.fromHeight(Dimens.line)),
            elevation: 0.0,
            centerTitle: true,
            title: new Text(
              'Transaction List',
              style: new TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, i) {
                return TransactionItem(transaction: transactions[i]);
              },
            ),
          )),
    );
  }
}
