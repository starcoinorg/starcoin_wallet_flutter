import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: new Text('Transactions'),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 16.0),
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
