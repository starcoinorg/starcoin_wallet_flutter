import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/context/setup/wallet_setup_handler.dart';
import 'package:stcerwallet/context/setup/wallet_setup_provider.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/wallet/unlock/keystore_import_page.dart';
import 'package:stcerwallet/pages/wallet/unlock/mnemonic_import_page.dart';
import 'package:stcerwallet/pages/wallet/unlock/private_key_import_page.dart';
import 'package:stcerwallet/style/styles.dart';

enum _ImportType { Keystore, Mnemonic, PrivateKey }

class WalletAccountImportPage extends HookWidget {
  static const String routeName = Routes.wallet + 'account/import';

  static const List<_ImportType> _tabs = [
    //_ImportType.Keystore,
    _ImportType.Mnemonic,
    //_ImportType.PrivateKey
  ];

  @override
  Widget build(BuildContext context) {
    var store = useWalletSetup(context);

    return new DefaultTabController(
        length: _tabs.length,
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(context),
          body: new TabBarView(children: _bodyImportWidgets(context, store)),
        ));
  }

  _appBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double iconSize = 28.0;
    return new AppBar(
      brightness: Brightness.light,
      iconTheme: theme.iconTheme,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: new Text('Import Starcoin Wallet'),
      actions: <Widget>[
        new IconButton(
          icon: Image.asset('assets/images/ic_qrcode_scan.png',
              color: theme.primaryColor, width: iconSize, height: iconSize),
          onPressed: () {
            print('scan');
          },
        ),
      ],
      bottom: new PreferredSize(
          child: new Column(
            children: <Widget>[
              Divider(
                height: Dimens.line,
              ),
              new TabBar(
                  indicatorColor: theme.indicatorColor,
                  labelStyle: new TextStyle(),
                  labelColor: Colors.blue,
                  tabs: _tabs.map((type) {
                    return new Tab(
                      text: getTabName(type),
                    );
                  }).toList()),
              Divider(
                height: Dimens.line,
              )
            ],
          ),
          preferredSize: Size.fromHeight(50.0)),
    );
  }

  String getTabName(_ImportType type) {
    String tabName = '';
    switch (type) {
      case _ImportType.Keystore:
        tabName = 'Keystore';
        break;
      case _ImportType.Mnemonic:
        tabName = 'Mnemonic';
        break;
      case _ImportType.PrivateKey:
        tabName = 'Private Key';
        break;
    }
    return tabName;
  }

  _bodyImportWidgets(BuildContext context, WalletSetupHandler store) {
    return _tabs.map((type) {
      Widget page;
      switch (type) {
        case _ImportType.Keystore:
          page = KeystoreImportPage();
          break;
        case _ImportType.Mnemonic:
          page = MnemonicImportPage(store);
          break;
        case _ImportType.PrivateKey:
          page = PrivateKeyImportPage();
          break;
      }
      return page;
    }).toList();
  }
}
