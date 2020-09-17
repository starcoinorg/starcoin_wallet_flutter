import 'package:stcerwallet/components/wallet/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'components/dialog/alert.dart';
import 'components/menu/main_menu.dart';
import 'context/wallet/wallet_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class WalletMainPage extends HookWidget {
  WalletMainPage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    var store = useWallet(context);

    //log("public is "+store.state.publicKey.toString());
    useEffect(() {
      store.initialise();
      return null;
    }, []);

    return Scaffold(
      drawer: MainMenu(
        address: store.state.address,
        onReset: () async {
          Alert(
              title: "Warning",
              text:
                  "Without your seed phrase or private key you cannot restore your wallet balance",
              actions: [
                FlatButton(
                  child: Text("cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text("reset"),
                  onPressed: () async {
                    await store.resetWallet();
                    Navigator.popAndPushNamed(context, "/");
                  },
                )
              ]).show(context);
        },
      ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.refresh),
              onPressed: !store.state.loading
                  ? () async {
                      await store.fetchOwnBalance();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Balance updated"),
                        duration: Duration(milliseconds: 800),
                      ));
                    }
                  : null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              Navigator.of(context).pushNamed("/transfer");
            },
          ),
        ],
      ),
      body: Balance(
        address: store.state.address,
        ethBalance: store.state.ethBalance,
        tokenBalance: store.state.tokenBalance,
      ),
    );
  }
}
