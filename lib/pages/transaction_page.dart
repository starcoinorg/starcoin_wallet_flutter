import 'package:flutter/material.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/pages/transactions/transaction_item.dart';

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

var i=0;

class TransactionsPage extends StatefulWidget {
  static const String routeName = Routes.market + "/transactions";

  @override
  State<StatefulWidget> createState() {
    return TransactionsPageState();
  }
}

class TransactionsPageState extends State<TransactionsPage> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 显示加载进度圈
    _showRefreshLoading();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollNotification) {
              if (scrollNotification.metrics.pixels >=
                scrollNotification.metrics.maxScrollExtent) {
                  _loadMore();
                }
              return false;
            },
            child: RefreshIndicator(
              child:ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, i) {
                return TransactionItem(transaction: transactions[i]);
              },
            ),
              onRefresh: _handleRefresh,
            )
          ))),
    );
  }

  // 上拉加载
  Future<Null> _loadMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      // 模拟数据的延迟加载
      await Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          i++;
          transactions.add({
            'title': 'Street greenig project'+i.toString(),
            'originator': 'Cybdom Tech',
            'transaction_number': '98217302193491',
            'type': 'Public',
            'status': 'Pairing',
          });
        });
      });
    }
  }
  _showRefreshLoading() {
    // 这里使用延时操作是由于在执行刷新操作时_refreshIndicatorKey还未与RefreshIndicator关联
    Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // 在列表开头添加几条数据
        i++;
        transactions.insert(0,{
          'title': 'Street greenig project'+i.toString(),
          'originator': 'Cybdom Tech',
          'transaction_number': '98217302193491',
          'type': 'Public',
          'status': 'Pairing',
        });
      });
    });
  }
}
