import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/context/transfer/wallet_transfer_provider.dart';
import 'package:stcerwallet/context/wallet/wallet_provider.dart';
import 'package:stcerwallet/manager/specific_wallet_manage_page.dart';
import 'package:stcerwallet/model/hdwallet.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/wallet/receive_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_manage_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_transfer_page.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/network_manager.dart';
import 'package:stcerwallet/service/wallet_manager.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/token_item_widget.dart';
import 'package:stcerwallet/view/wallet_widget.dart';

class WalletPage extends HookWidget {
  static const String routeName = Routes.wallet + "/index";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  ConfigurationService configurationService;

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    final _store = useWallet(context);
    configurationService = Provider.of<ConfigurationService>(context);

    return FutureBuilder<AccountState>(
        future: getAccountState(),
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
              "Loading",
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

  Future<AccountState> getAccountState() async {
    final wallets = await WalletManager.instance.wallets;
    final wallet = wallets[0];
    //final address = store.state.address;
    //final publicKey = store.state.account.keyPair.getPublicKeyHex();
    final address = wallet.defaultAccount().getAddress();
    final publicKey = wallet.defaultAccount().keyPair.getPublicKeyHex();

    log("public key is " + wallet.defaultAccount().keyPair.getPublicKeyHex());
    log("private key is " + wallet.defaultAccount().keyPair.getPrivateKeyHex());
    log("address is " + wallet.defaultAccount().getAddress());

    try {
//      final stcBalance = await store.state.account
//          .balanceOfStc(NetworkManager.getCurrentNetworkUrl().httpUrl);
      final stcBalance = await wallet
          .defaultAccount()
          .balanceOfStc(NetworkManager.getCurrentNetworkUrl().httpUrl);

      final tokenList = await wallet
          .defaultAccount()
          .getAccountToken(NetworkManager.getCurrentNetworkUrl().httpUrl);

      return AccountState(
          balance: stcBalance.toBigInt(),
          sequenceNumber: BigInt.zero,
          address: address,
          publicKey: "0x" + publicKey,
          assets: tokenList);
    } catch (ex) {
      log(ex.toString());
      return AccountState(
          balance: BigInt.zero,
          sequenceNumber: BigInt.zero,
          address: address,
          publicKey: "0x" + publicKey,
          assets: []);
    }
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
              return ReceivePage.name(state.address, state.publicKey);
            }));
          }),
      actions: <Widget>[
        new IconButton(
            icon: Icon(Icons.send, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  return WalletTransferProvider(builder: (context, store) {
                    return WalletTransferPage("Send Tokens", state.assets);
                  });
                },
              ));
            }),
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
      onMoreTap: () async {
        //wallet.privateKey = configurationService.getPrivateKey();
        final scwallets = await WalletManager.instance.wallets;
        final scwallet = scwallets[0];
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new SpecificWalletManagePage(
            wallet: scwallet,
            account: scwallet.defaultAccount(),
            isDefault: true,
          );
        }));
      },
      state: state,
    );
    Widget assetsMarkWidget = _bodyLabel(context);

    list.add(currentWalletWidget);
    list.add(assetsMarkWidget);
    List<Widget> assetsWidgetList = state.assets.map<Widget>((asset) {
      return new TokenItemWidget(asset);
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
