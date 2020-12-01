import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stcerwallet/context/wallet/wallet_handler.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/service/network_manager.dart';
import 'package:stcerwallet/style/styles.dart';

import 'package:flutter_slidable/flutter_slidable.dart';


class NetworkPage extends StatefulWidget {
  static const String routeName = Routes.profile + "/network_settings";

  final WalletHandler _walletHandler;

  NetworkPage(this._walletHandler);

  @override
  State<StatefulWidget> createState() {
    return NetworkPageState(_walletHandler);
  }
}

class NetworkPageState extends State<NetworkPage> {
  bool needReload;
  final WalletHandler _walletHandler;

  NetworkPageState(this._walletHandler);

  @override
  Widget build(BuildContext context) {
    var defaultNetwork = NetworkManager.getDefaultNetwork();
    if (defaultNetwork == null) {
      defaultNetwork = "Proxima";
    }

    final ThemeData theme = Theme.of(context);
    final TextEditingController nodeNameController =
        new TextEditingController();
    final TextEditingController urlController = new TextEditingController();

    final appBar = new AppBar(
      bottom: new PreferredSize(
          child: Divider(
            height: Dimens.line,
            color: theme.dividerColor,
          ),
          preferredSize: new Size.fromHeight(Dimens.line)),
      elevation: 0.0,
      centerTitle: true,
      actions: <Widget>[
        new IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () {
            showDialog<Null>(
              context: context,
              builder: (BuildContext context) {
                return new SimpleDialog(
                    title: new Text('添加新节点'),
                    children: <Widget>[
                      new SimpleDialogOption(
                          child: TextFormField(
                              autofocus: true,
                              controller: nodeNameController,
                              decoration: InputDecoration(
                                  labelText: "节点名",
                                  hintText: "节点名",
                                  icon: Icon(Icons.person)))),
                      new SimpleDialogOption(
                          child: TextFormField(
                              autofocus: true,
                              controller: urlController,
                              decoration: InputDecoration(
                                  labelText: "Url",
                                  hintText: "Url",
                                  icon: Icon(Icons.link)))),
                      new SimpleDialogOption(
                          child: RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              child: Text("确定"),
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                await onConfirmNewNode(
                                    nodeNameController.value.text,
                                    urlController.value.text);
                                Navigator.of(context).pop();
                              })),
                    ]);
              },
            );
          },
        ),
      ],
    );


    return FutureBuilder<List<NetworkUrl>>(
        future: NetworkManager.getNetworks(),
        builder: (context, AsyncSnapshot<List<NetworkUrl>> snapshot) {
          if (snapshot.hasData) {
            final networks = snapshot.data;
            return SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: appBar,
                  body: Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: ListView.separated(
                        itemCount: networks.length,
                        itemBuilder: (ctx, i) {
                          return NetworkItem(networks[i],
                              defaultNetwork, reloadList,this.afterChangeNetwork);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider(
                            height: 1.0,
                          );
                        }),
                  )),
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

  Future<void> onConfirmNewNode(String name, String url) async {
    try {
      await NetworkManager.addNetwork(name, url);
    } catch (ex) {
      log(ex.toString());
    }
    setState(() {
      needReload = true;
    });
  }

  Future<void> afterChangeNetwork() async {
    await _walletHandler.stopWatch();
    await _walletHandler.startNewNodeWatch(NetworkManager.getClient());
  }

  void reloadList() {
    setState(() {
      needReload = true;
    });
  }

}

typedef ReloadFunction = Function();
typedef AfterNetworkChangeFunction = Function();

class NetworkItem extends StatelessWidget {
  final NetworkUrl networkUrl;
  final String defaultNetowrk;

  final ReloadFunction reloadFunction;
  final AfterNetworkChangeFunction afterNetworkChangeFunction;

  NetworkItem(this.networkUrl, this.defaultNetowrk,
      this.reloadFunction,this.afterNetworkChangeFunction);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isAndroid) {
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: RadioListTile(
          value: networkUrl.networkName,
          onChanged: (value) async {
            await NetworkManager.setCurrentNetwork(value);
            reloadFunction();
            await afterNetworkChangeFunction();
          },
          title: Row(children: <Widget>[
            Text(networkUrl.networkName),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(this.networkUrl.url))
          ]),
          groupValue: this.defaultNetowrk,
          selected: this.defaultNetowrk == networkUrl.networkName,
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              await deleteNetowrk(networkUrl.networkName);
            },
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: RadioListTile(
          value: networkUrl.networkName,
          onChanged: (value) async {
            await NetworkManager.setCurrentNetwork(value);
            reloadFunction();
            await afterNetworkChangeFunction();
          },
          title: Row(children: <Widget>[
            Text(networkUrl.networkName),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(this.networkUrl.url))
          ]),
          secondary: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await deleteNetowrk(networkUrl.networkName);
            },
          ),
          groupValue: this.defaultNetowrk,
          selected: this.defaultNetowrk == networkUrl.networkName,
        ),
      );
    }
  }

  Future<void> deleteNetowrk(String name) async {
    try {
      await NetworkManager.deleteNetwork(name);
    } catch (ex) {
      log(ex.toString());
    }
    reloadFunction();
  }
}
