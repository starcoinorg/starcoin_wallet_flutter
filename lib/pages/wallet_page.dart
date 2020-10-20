import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/context/wallet/wallet_handler.dart';
import 'package:stcerwallet/context/wallet/wallet_provider.dart';
import 'package:stcerwallet/manager/specific_wallet_manage_page.dart';
import 'package:stcerwallet/model/assets.dart';
import 'package:stcerwallet/model/hdwallet.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/wallet/receive_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_manage_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_transfer_page.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/token_item_widget.dart';
import 'package:stcerwallet/view/wallet_widget.dart';

class WalletPage extends HookWidget {
  static const String routeName = Routes.wallet + "/index";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  static bool inited = false;

  final List<Assets> _assets = [
    Assets(),
    Assets(),
    Assets(),
  ];

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    final store = useWallet(context);

    useEffect(() {
      if (inited == false) {
        store.initialise();
        inited = true;
      }
      return null;
    }, []);

    return FutureBuilder<AccountState>(
        future: getAccountState(store),
        builder: (context, AsyncSnapshot<AccountState> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: _appBar(context, snapshot.data),
              body: new RefreshIndicator(
                  key: _refreshIndicatorKey,
                  child: ListView(children: _body(context, snapshot.data)),
                  onRefresh: _handleRefresh),
            );
          } else {
            return new Center(
                child: Text(
              "Can't access starcoin node",
              textAlign: TextAlign.center,
            ));
          }
        });
  }

  Future<Null> _handleRefresh() async {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 2), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      print('refresh complete');
      _scaffoldKey.currentState?.showSnackBar(new SnackBar(
          content: const Text('Refresh complete'),
          action: new SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  Future<AccountState> getAccountState(WalletHandler store) async {
    final stcBalance = await store.state.account.balanceOfStc();
    final address = store.state.address;
    final publicKey = store.state.account.keyPair.getPublicKeyHex();

    return AccountState(
        balance: stcBalance.toBigInt(),
        sequenceNumber: BigInt.zero,
        address: address,
        publicKey: "0x" + publicKey);
  }

  Widget _appBar(BuildContext context, AccountState state) {
    final ThemeData theme = Theme.of(context);
    final double iconSize = 28.0;
    final double coinTypeSize = 12.0;
    final coinTypeWidget = new Ink(
      decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xff273541)),
          borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
      padding: EdgeInsets.only(left: 6.0, top: 4.0, right: 6.0, bottom: 4.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'STC',
            style: new TextStyle(color: Colors.black, fontSize: coinTypeSize),
          ),
          new Icon(
            Icons.keyboard_arrow_down,
            size: coinTypeSize,
            color: Colors.black,
          )
        ],
      ),
    );
    return new AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      bottom: new PreferredSize(
          child: Divider(
            height: Dimens.line,
            color: theme.dividerColor,
          ),
          preferredSize: new Size.fromHeight(Dimens.line)),
      elevation: 0.0,
      centerTitle: true,
      leading: new IconButton(
          icon: Image.asset('assets/images/ic_qrcode.png',
              width: iconSize, height: iconSize),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return ReceivePage.name(state.address, state.publicKey,
                  'assets/images/ic_default_wallet_avatar_4.png');
            }));
          }),
      actions: <Widget>[
        new IconButton(
          icon: Icon(Icons.send, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.of(context).pushNamed(WalletTransferPage.routeName);
          },
        ),
      ],
      title: new InkWell(
        child: coinTypeWidget,
        borderRadius: const BorderRadius.all(const Radius.circular(12.0)),
        onTap: () {
          Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
              (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
            return new WalletManagePage();
          }, transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            // 添加一个平移动画
            return Routes.bottom2TopTransition(animation, child);
          }));
        },
      ),
    );
  }

  List<Widget> _body(BuildContext context, AccountState state) {
    List<Widget> list = List();
    HDWallet wallet = new HDWallet();
    wallet.address = state.address;
    wallet.name = "STC Wallet";
    Widget currentWalletWidget = new WalletWidget(
      wallet: wallet,
      onMoreTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new SpecificWalletManagePage(
            wallet: wallet,
          );
        }));
      },
      state: state,
    );
    Widget assetsMarkWidget = _bodyLabel(context);

    list.add(currentWalletWidget);
    list.add(assetsMarkWidget);
    List<Widget> assetsWidgetList = _assets.map<Widget>((assets) {
      return new TokenItemWidget(assets);
    }).toList();
    list.addAll(assetsWidgetList);
    return list;
  }

  Widget _bodyLabel(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.only(left: 10.0, top: 4.0, bottom: 4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text('Assets',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            new InkWell(
              borderRadius: BorderRadius.circular(44.0),
              child: new Ink(
                width: 44.0,
                height: 44.0,
                child: new Icon(Icons.add_circle_outline),
              ),
              onTap: () {
                print('add');
              },
            )
          ],
        ));
  }
}
