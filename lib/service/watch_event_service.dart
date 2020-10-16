import 'dart:async';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/pubsub.dart';

typedef TransferEvent = void Function();

abstract class IWatchEventService {
  Future<void> dispose();
  StreamSubscription listenTransfer(Account account,TransferEvent onTransfer);
}

class WatchEventService implements IWatchEventService {

  final PubSubClient client;

  WatchEventService(this.client);

  Future<void> dispose() async{
    await client.dispose();
  }

  StreamSubscription listenTransfer(Account account,TransferEvent onTransfer,{int take}) {
    var events = client.addFilter(NewTxnSendRecvEventFilter(account));

    if (take != null) {
      events = events.take(take);
    }

    return events.listen((event) {
      onTransfer();
    });
  }

}