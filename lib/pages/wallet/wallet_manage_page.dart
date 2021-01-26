import 'package:flutter/material.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/manager/specific_wallet_manage_page.dart';
import 'package:stcerwallet/model/hdwallet.dart';
import 'package:stcerwallet/model/scwallet.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stcerwallet/pages/wallet/init/wallet_account_import_page.dart';
import 'package:stcerwallet/service/wallet_manager.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/wallet_item_widget.dart';

class WalletManagePage extends StatefulWidget {
  @override
  State<WalletManagePage> createState() {
    return WalletManagePageState();
  }

  static const String routeName = Routes.wallet + '/manage';
}

class WalletManagePageState extends State<WalletManagePage> {
  bool reload = false;

  Future<List<ScWallet>> getAllWallets() async {
    return await WalletManager.instance.wallets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScWallet>>(
        future: getAllWallets(),
        builder: (context, AsyncSnapshot<List<ScWallet>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: _appBar(context),
                backgroundColor: Colors.white,
                body: new ListView(children: _body(context, snapshot.data)));
          } else {
            return new Center(
                child: Text(
              "Loading",
              textAlign: TextAlign.center,
            ));
          }
        });
  }

  Widget _appBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new AppBar(
      brightness: theme.brightness,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: new InkWell(
                child: new Ink(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: new Icon(
                    FontAwesomeIcons.angleDoubleDown,
                    size: 12.0,
                    color: theme.primaryColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(12.0)),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            child: new InkWell(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: new Icon(
                      Icons.access_time,
                      size: 20.0,
                      color: theme.primaryColor,
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 2.0, top: 4.0, bottom: 4.0),
                    child: new Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 12.0, color: theme.primaryColor),
                    ),
                  )
                ],
              ),
              onTap: () {
                print('go records');
              },
              borderRadius: new BorderRadius.circular(8.0),
            ),
          )
        ],
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
    );
  }

  _body(BuildContext context, List<ScWallet> wallets) {
    final wallet = wallets[0];
    List<Widget> list = new List();
    list.add(_bodyLabelMain(context));
    list.add(new Divider(
      height: 10.0,
      color: Colors.transparent,
    ));

    for (Account account in wallet.accounts) {
      final hdwallet = new HDWallet(
          name: "wallet",
          address: account.getAddress(),
          privateKey: account.keyPair.getPrivateKeyHex(),
          mnemonic: "");
      list.add(new WalletItemWidget(
        wallet: hdwallet,
        onMoreTap: () async {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            bool isDefault = false;
            if (account == wallet.defaultAccount()) {
              isDefault = true;
            }
            return new SpecificWalletManagePage(
              wallet: wallet,
              account: account,
              isDefault: isDefault,
            );
          }));
        },
      ));
    }
    // list.add(new Divider(
    //   height: 10.0,
    //   color: Colors.transparent,
    // ));
    // list.add(_bodyLabelImported(context));
    // list.add(new Divider(
    //   height: 10.0,
    //   color: Colors.transparent,
    // ));
    // for (int i = 0; i < 2; i++) {
    //   list.add(new WalletItemWidget(wallet: new HDWallet()));
    // }
    return list;
  }

  Widget _bodyLabelMain(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      height: 32.0,
      padding: EdgeInsets.only(left: Dimens.padding),
      color: theme.backgroundColor,
      child: new Row(
        children: <Widget>[
          new Icon(Icons.person,
              size: 20.0, color: theme.primaryColor.withOpacity(0.85)),
          new Expanded(
              child: new Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: new Text(
              'Main Wallet',
              style: new TextStyle(
                  fontSize: 12.0, color: theme.primaryColor.withOpacity(0.85)),
            ),
          )),
          new Ink(
            padding: EdgeInsets.only(right: 8.0),
            height: 32.0,
            width: 40.0,
            child: new InkWell(
              child: new Icon(
                Icons.add,
                size: 20.0,
              ),
              onTap: () async {
                await WalletManager.instance.addAccount(0);
                setState(() {
                  this.reload = true;
                });
              },
              borderRadius: BorderRadius.circular(32.0),
            ),
          )
        ],
      ),
    );
  }

  Widget _bodyLabelImported(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Ink(
      color: theme.backgroundColor,
      height: 32.0,
      padding: EdgeInsets.only(left: Dimens.padding),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.file_download,
              size: 20.0, color: theme.primaryColor.withOpacity(0.85)),
          new Expanded(
            child: new Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: new Text(
                'Imported Wallets',
                style: new TextStyle(
                    fontSize: 12.0,
                    color: theme.primaryColor.withOpacity(0.85)),
              ),
            ),
          ),
          new Ink(
            padding: EdgeInsets.only(right: 8.0),
            height: 32.0,
            width: 40.0,
            child: new InkWell(
              child: new Icon(
                Icons.add,
                size: 20.0,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(WalletImportPage.routeName);
              },
              borderRadius: BorderRadius.circular(32.0),
            ),
          )
        ],
      ),
    );
  }
}
