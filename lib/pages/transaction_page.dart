import 'package:flutter/material.dart';
import 'package:stcerwallet/context/wallet/wallet_handler.dart';
import 'package:stcerwallet/context/wallet/wallet_provider.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/pages/transactions/transaction_item.dart';
import 'package:starcoin_wallet/wallet/wallet_client.dart';
import 'package:stcerwallet/util/wallet_util.dart';
import 'package:optional/optional.dart';

List<Map<String, String>> transactions = [
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
  {
    'title': 'Street greenig project',
    'originator': 'Cybdom Tech',
    'transaction_number': '98217302193491',
    'type': 'Public',
    'status': 'Pairing',
  },
];

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
        store.initialise();
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
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
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
                            child: ListView.builder(
                              itemCount: this.txns.length,
                              itemBuilder: (ctx, i) {
                                return TransactionItem(
                                    transactionWithInfo: this.txns[i]);
                              },
                            ),
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
    final txnList = await walletClient.getTxnList(store.state.account,
        Optional.of(0), Optional.empty(), Optional.empty());
    return txnList;
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
