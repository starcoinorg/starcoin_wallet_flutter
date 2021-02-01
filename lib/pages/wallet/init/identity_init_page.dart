import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stcerwallet/context/setup/wallet_setup_provider.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/wallet/init/wallet_account_create_page.dart';
import 'package:stcerwallet/pages/wallet/init/wallet_account_import_page.dart';
import 'package:stcerwallet/style/styles.dart';

class IdentityInitPage extends StatelessWidget {
  static const String routeName = Routes.main + '/init';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget body = new Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            height: 240.0,
            color: Colors.blue,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  FontAwesomeIcons.users,
                  size: 48.0,
                  color: Colors.white,
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: new Text(
                    'Create Your First Starcoin wallets',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: new Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: Dimens.padding * 2),
              child: new RaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(WalletAccountCreatePage.routeName);
                },
                color: Colors.blue,
                child: new Container(
                  alignment: Alignment.center,
                  height: Dimens.itemHeight,
                  child: new Text('Create Identity'),
                ),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(
                vertical: 28.0, horizontal: Dimens.padding * 1.5),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: Dimens.line,
                  color: theme.dividerColor,
                ),
                new Text('Or',
                    style: new TextStyle(
                        fontSize: 22.0,
                        decoration: TextDecoration.none,
                        color: theme.hintColor)),
                Container(
                  width: 100.0,
                  height: Dimens.line,
                  color: theme.dividerColor,
                ),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding * 2),
            child: new FlatButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      return WalletSetupProvider(builder: (context, store) {
                        return WalletAccountImportPage();
                      });
                    },
                  ));
                },
                child: new Container(
                  child: new Text('Recover Identity'),
                  alignment: Alignment.center,
                  height: Dimens.itemHeight,
                )),
          ),
        ],
      ),
    );

    return new Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: new Theme(
            data: theme.copyWith(
                backgroundColor: Colors.white, brightness: Brightness.light),
            child: body),
        top: false,
        bottom: false,
      ),
    );
  }

  _appBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new AppBar(
      brightness: theme.brightness,
      elevation: 0.0,
      iconTheme: theme.iconTheme,
      backgroundColor: Colors.white,
    );
  }
}
