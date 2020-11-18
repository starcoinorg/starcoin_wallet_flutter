import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stcerwallet/config/states.dart';
import 'package:stcerwallet/context/wallet/wallet_handler.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/transactions/stc_webview.dart';
import 'package:stcerwallet/view/list/switch_list_item_widget.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = Routes.profile + "/settings";
  final WalletHandler walletHandler;

  SettingsPage(this.walletHandler);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return StoreBuilder<AppState>(builder: (context, store) {
      var widgets = <Widget>[
        new SwitchListItemWidget(
          title: 'Theme Mode',
          isChecked: !store.state.theme.isDark(),
          valueChanged: (isChecked) {
            //store.dispatch(Action.ChangeTheme);
          },
          onTapCallback: () {
            //store.dispatch(Action.ChangeTheme);
          },
        ),
        new RaisedButton(
            onPressed: () {
              resetWallet();
            },
            child: new Text('Reset')),
      ];
      if (Platform.isAndroid || Platform.isIOS) {
        widgets.add(new RaisedButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                return new StcWebView();
              }));
            },
            child: new Text('Webview Test')));
      }
      return Scaffold(
          appBar: AppBar(
            title: new Text('Settings'),
          ),
          body: new Container(
              width: double.infinity,
              color: theme.backgroundColor,
              child: new Column(
                children: widgets,
              )));
    });
  }

  Future resetWallet() async {
    walletHandler.resetWallet();
  }
}
