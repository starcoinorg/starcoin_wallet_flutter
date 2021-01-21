import 'package:flutter/material.dart';
import 'package:starcoin_wallet/starcoin/starcoin.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/util/wallet_util.dart';
import 'package:starcoin_wallet/wallet/account.dart';

class TokenItemWidget extends StatelessWidget {
  final TokenBalance _asset;

  TokenItemWidget(this._asset);

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    final tokenIconSize = 40.0;
    final tokenType = _asset.token.type_params[0] as TypeTagStructItem;
    return new InkWell(
      child: new Ink(
        height: 72.0,
//        padding: new EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
        child: new Stack(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 16.0),
                  child: new Image.asset(
                    'assets/images/ic_transfer_eth_b.png',
                    height: tokenIconSize,
                    width: tokenIconSize,
                  ),
                ),
                new Expanded(
                    child: new Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: new Text(WalletUtil.formatTokenStructTag(tokenType)),
                )),
                new Container(
                  padding: new EdgeInsets.only(right: 16.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(_asset.balance.toString()),
                    ],
                  ),
                )
              ],
            ),
            new Container(
              child: Divider(height: Dimens.line, indent: 16.0),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
      onTap: () {
        print('token');
      },
    );
  }
}
