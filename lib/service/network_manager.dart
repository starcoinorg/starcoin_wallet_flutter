import 'dart:collection';
import 'dart:developer';

import 'package:starcoin_wallet/wallet/json_rpc.dart';
import 'package:starcoin_wallet/wallet/pubsub.dart';
import 'package:stcerwallet/service/database_service.dart';
import 'package:web_socket_channel/io.dart';

import 'package:http/http.dart';


enum Network { PROXIMA, HALLEY, DEV, TEST, MAIN }

const NETWORKS = [
  Network.PROXIMA,
  Network.HALLEY,
];

const NETWORKID = {
  Network.MAIN: 1,
  Network.PROXIMA: 2,
  Network.HALLEY: 3,
  Network.DEV: 254,
  Network.TEST: 255,
};

const NETWORKNAMES = {
  Network.MAIN: "Main",
  Network.PROXIMA: "Proxima",
  Network.HALLEY: "Halley",
  Network.DEV: "Dev",
  Network.TEST: "Test",
};

const NETWORKNODES = {
  Network.MAIN: ["localhost"],
  Network.PROXIMA: [
    "proxima1.seed.starcoin.org",
    "proxima2.seed.starcoin.org",
    "proxima3.seed.starcoin.org"
  ],
  Network.HALLEY: [
    "halley1.seed.starcoin.org",
    "halley2.seed.starcoin.org",
    "halley3.seed.starcoin.org"
  ],
  Network.DEV: ["localhost"],
  Network.TEST: ["localhost"],
};


class StarcoinUrl {
  final String httpUrl;
  final String wsUrl;

  StarcoinUrl(this.httpUrl,this.wsUrl);
}

class NetworkUrl extends Entity {
  static final String tableName = "network_urls";

  final String networkName;
  final String url;

  NetworkUrl(this.networkName, this.url);

  @override
  String createTable() {
    return "CREATE TABLE IF NOT EXISTS network_urls(network VARCHAR(32) PRIMARY KEY, url VARCHAR(1024))";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "network": networkName,
      "url": url,
    };
  }

  @override
  String getTableName() {
    return tableName;
  }
}

NetworkUrl mapToNetworkUrl(Map<String, dynamic> record) {
  return NetworkUrl(record['network'], record['url']);
}

MapFunction<NetworkUrl> template = (Map<String, dynamic> record) =>
    NetworkUrl(record['network'], record['url']);

const DEFAULTNETWORK = "default_network";

class NetworkManager {

  static HashSet<NetworkUrl> _networkSet = HashSet<NetworkUrl>();
  static String _defualtNetwork = "Proxima";

  static Future<List<NetworkUrl>> getNetworks() async {
    try {
      _networkSet.clear();
      final db = await DatabaseService.getInstance();
      var result = await db.queryAll(NetworkUrl.tableName, mapToNetworkUrl);
      var networkDB = HashSet<String>();
      for (var network in result){
        networkDB.add(network.networkName);
        _networkSet.add(network);
      }
      for (var network in NETWORKS) {
        if(!networkDB.contains(NETWORKNAMES[network])){
          final networkUrl = NetworkUrl(NETWORKNAMES[network], NETWORKNODES[network][0]);
          result.add(networkUrl);
          _networkSet.add(networkUrl);
        }
      }
      return result;
    } catch (ex) {
      log(ex.toString());
      return [];
    }
  }

  static Future<void> setCurrentNetwork(String network) async{
    try {
      final db = await DatabaseService.getInstance();
      await db.insertRaw(CONFIGINSERT,[DEFAULTNETWORK,network,network]);
      await getNetworks();
      _defualtNetwork=network;
    } catch (ex) {
      log(ex.toString());
    }
  }

  static Future<void> addNetwork(String network,String url) async{
    try {
      final db = await DatabaseService.getInstance();
      final networkItem = NetworkUrl(network, url);
      await db.insert(networkItem);
      _networkSet.add(networkItem);
    } catch (ex) {
      log(ex.toString());
    }
  }

  static Future<void> deleteNetwork(String network) async{
    try {
      final db = await DatabaseService.getInstance();
      await db.delete(NetworkUrl.tableName,"network=?", [network]);
      NetworkUrl needDeleteNetwork;
      for(var item in _networkSet){
        if(item.networkName==network){
          needDeleteNetwork = item;
        }
      }
      if (needDeleteNetwork!=null)
        _networkSet.remove(needDeleteNetwork);
    } catch (ex) {
      log(ex.toString());
    }
  }

  static Future<String> getCurrentNetwork() async{
    try {
      final db = await DatabaseService.getInstance();
      final networkConfig=await db.queryRaw("select * from config where property =? ",[DEFAULTNETWORK]);
      if (networkConfig!=null && networkConfig.length>0){
          _defualtNetwork=networkConfig[0]['value'];
      }
    } catch (ex) {
      log(ex.toString());
    }
    return _defualtNetwork;
  }

  static String getDefaultNetwork() {
    return _defualtNetwork;
  }

  static StarcoinUrl getCurrentNetworkUrl() {
    for(var network in _networkSet){
      if(network.networkName==_defualtNetwork){
        return StarcoinUrl("http://"+network.url+":9850", "ws://"+network.url+":9870");
      }
    }
    throw Exception("can't find default network ，default network is $_defualtNetwork");
  }

  static PubSubClient getClient(){
    final starcoinUrl=NetworkManager.getCurrentNetworkUrl();
    final socket = IOWebSocketChannel.connect(Uri.parse(starcoinUrl.wsUrl));
    final rpc = JsonRPC(starcoinUrl.httpUrl, Client());
    final pubSubClient = PubSubClient(socket.cast<String>(), rpc);
    return pubSubClient;
  }
}