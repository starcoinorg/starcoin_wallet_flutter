import 'package:flutter/material.dart';
import 'package:stcerwallet/context/wallet/wallet_handler.dart';
import 'package:stcerwallet/context/wallet/wallet_provider.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/pages/transactions/transaction_item.dart';
import 'package:starcoin_wallet/wallet/wallet_client.dart';
import 'package:stcerwallet/util/wallet_util.dart';
import 'package:optional/optional.dart';
import 'dart:developer';

var i = 0;

class TransactionsPage extends StatefulWidget {
  static const String routeName = Routes.market + "/transactions";

  @override
  State<StatefulWidget> createState() {
    return TransactionsPageState();
  }
}

class TransactionsPageState extends State<TransactionsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = false;
  WalletHandler store;
  bool needInit = true;
  List<TransactionWithInfo> txns;

  @override
  void initState() {
    super.initState();
    _showRefreshLoading();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    setState(() {
      if (needInit) {
        store = useWallet(context);
      }
      needInit = false;
      return null;
    });

    return FutureBuilder<List<TransactionWithInfo>>(
        future: getAccountState(store),
        builder: (context, AsyncSnapshot<List<TransactionWithInfo>> snapshot) {
          if (snapshot.hasData) {
            this.txns = snapshot.data;
            return SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
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
                    title: new Text(
                      'Transaction List',
                      style: new TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  body: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: NotificationListener<ScrollNotification>(
                          onNotification:
                              (ScrollNotification scrollNotification) {
                            if (scrollNotification.metrics.pixels >=
                                scrollNotification.metrics.maxScrollExtent) {
                              _loadMore();
                            }
                            return false;
                          },
                          child: RefreshIndicator(
                            child: ListView.separated(
                                itemCount: this.txns.length,
                                itemBuilder: (ctx, i) {
                                  return TransactionItem(
                                      transactionWithInfo: this.txns[i]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return new Divider(
                                    height: 1.0,
                                  );
                                }),
                            onRefresh: _handleRefresh,
                          )))),
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

  Future<List<TransactionWithInfo>> getAccountState(WalletHandler store) async {
    final walletClient = new WalletClient(BASEURL);
    final batchClient = new BatchClient(WSURL);
    try {
      final txnList = await batchClient.getTxnListBatch(
          walletClient,
          store.state.account,
          Optional.of(0),
          Optional.empty(),
          Optional.empty());
      return txnList;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  // 上拉加载
  Future<Null> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final txnList = await getAccountState(this.store);
      setState(() {
        this.txns = txnList;
      });
    }
  }

  _showRefreshLoading() {
    Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<Null> _handleRefresh() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final txnList = await getAccountState(this.store);
      setState(() {
        this.txns = txnList;
      });
    }
  }
}
