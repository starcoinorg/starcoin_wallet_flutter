import 'package:flutter/material.dart';
import 'package:stcerwallet/components/wallet/export_page.dart';
import 'package:stcerwallet/model/hdwallet.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/list/list_item_widget.dart';

class SpecificWalletManagePage extends StatelessWidget {
//  static const String routeName = Routes.wallet + '/manage';

  final HDWallet wallet;

  SpecificWalletManagePage({this.wallet});

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
    return Column(
      children: <Widget>[
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
                content: wallet.mnemonic,
                title: "Export Mnemonic",
              );
            }));
          },
          bottomLineType: BottomLineType.Gap,
        ),
        // new ListItemWidget(
        //   iconData: Icons.folder,
        //   title: 'Export Keystore',
        //   onTapCallback: () {},
        //   bottomLineType: BottomLineType.Gap,
        // ),
        new ListItemWidget(
          iconData: Icons.vpn_key,
          title: 'Export Private Key',
          onTapCallback: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return new ExportPage(
                content: "0x" + wallet.privateKey,
                title: "Export Private Key",
              );
            }));
          },
          bottomLineType: BottomLineType.None,
        ),
      ],
    );
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
                new Text(wallet.address)
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
