import 'dart:async';

import 'package:flutter/services.dart';

typedef RedirecEvent = void Function(String url);

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {
  //Event Channel creation
  static const stream = const EventChannel('wallet.starcoin.org/events');

  //Method channel creation
  static const platform = const MethodChannel('wallet.starcoin.org/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  //Adding the listener into contructor
  DeepLinkBloc() {
    //Checking application start by deep link
    //startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    //stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  StreamSubscription listen(RedirecEvent onRedirected) {
    startUri().then(onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    return stream.receiveBroadcastStream().listen((d) => onRedirected(d));
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
