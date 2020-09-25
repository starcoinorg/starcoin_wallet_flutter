import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/wallet/wallet_create_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_import_page.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Create new wallet"),
              onPressed: () {
                Navigator.of(context).pushNamed(WalletCreatePage.routeName);
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: OutlineButton(
                child: Text("Import wallet"),
                onPressed: () {
                  Navigator.of(context).pushNamed(WalletImportPage.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
