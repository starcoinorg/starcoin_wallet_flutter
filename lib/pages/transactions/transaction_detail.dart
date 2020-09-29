import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/routes/routes.dart';


class TransactionDetailPage extends StatelessWidget {

  static const String routeName = Routes.wallet + '/transaction_detail';

  TransactionDetailPage({@required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Settings')),
        body:Container(
          child: new Text('TransactionDetail'),
    ));
  }
}