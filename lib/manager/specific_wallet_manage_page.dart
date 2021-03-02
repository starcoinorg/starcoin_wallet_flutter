import 'package:flutter/material.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/components/wallet/export_page.dart';
import 'package:stcerwallet/model/scwallet.dart';
import 'package:stcerwallet/service/wallet_manager.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/list/list_item_widget.dart';

class SpecificWalletManagePage extends StatelessWidget {
//  static const String routeName = Routes.wallet + '/manage';

  final ScWallet wallet;
  final Account account;
  final bool isDefault;

  SpecificWalletManagePage({this.wallet, this.account, this.isDefault});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  _appBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new AppBar(
      brightness: theme.brightness,
      iconTheme: theme.iconTheme,
      backgroundColor: Colors.white,
      title: new Text(
        'Manage',
        style: new TextStyle(color: theme.primaryColor),
      ),
      bottom: new PreferredSize(
          child: Divider(
            height: Dimens.line,
            color: theme.dividerColor,
          ),
          preferredSize: new Size.fromHeight(Dimens.line)),
      elevation: 0.0,
      centerTitle: true,
    );
  }

  _body(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var bottomLineType = BottomLineType.Gap;
    if (isDefault) {
      bottomLineType = BottomLineType.None;
    }
    final exportPk = new ListItemWidget(
      iconData: Icons.vpn_key,
      title: 'Export Private Key',
      onTapCallback: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new ExportPage(
            content: "0x" + wallet.defaultAccount().keyPair.getPrivateKeyHex(),
            title: "Export Private Key",
          );
        }));
      },
      bottomLineType: bottomLineType,
    );

    var widgets = <Widget>[
      _bodyWallet(context),
      Divider(
        color: theme.dividerColor,
        height: Dimens.line,
      ),
      Divider(
        height: Dimens.divider,
        color: Colors.transparent,
      ),
      Divider(
        color: theme.dividerColor,
        height: Dimens.line,
      ),
      new ListItemWidget(
        iconData: Icons.import_export,
        title: 'Export Mnemonic',
        onTapCallback: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new ExportPage(
              content: wallet.getSeed(),
              title: "Export Mnemonic",
            );
          }));
        },
        bottomLineType: BottomLineType.Gap,
      ),
      exportPk
    ];
    if (!isDefault) {
      widgets.add(new ListItemWidget(
        iconData: Icons.wallet_travel,
        title: 'Set As Default Address',
        onTapCallback: () async {
          await WalletManager.instance.setDefaultAccount(0, account);
        },
        bottomLineType: BottomLineType.None,
        withArrow: false,
      ));
    }
    return Column(children: widgets);
  }

  _bodyWallet(BuildContext context) {
    return new Ink(
      height: 80.0,
      color: Colors.white,
      child: new InkWell(
        onTap: () {},
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(left: Dimens.padding),
              child: new Image.asset(
                'assets/images/ic_default_wallet_avatar_7.png',
                width: 48.0,
                height: 48.0,
              ),
            ),
            new Expanded(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('STC-Wallet'),
                new Text(account.getAddress())
              ],
            )),
            // new Padding(
            //   padding: EdgeInsets.only(right: Dimens.padding),
            //   child: new Icon(
            //     Icons.keyboard_arrow_right,
            //     size: Dimens.itemIconSize,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
