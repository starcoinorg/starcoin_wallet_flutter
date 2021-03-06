import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:starcoin_wallet/wallet/pubsub.dart';
import 'package:stcerwallet/model/wallet.dart';
import 'package:stcerwallet/pages/wallet/wallet_transaction_payload.dart';
import 'package:stcerwallet/service/address_service.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/contract_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/service/deep_link_service.dart';
import 'package:stcerwallet/service/navigator_observer.dart';
import 'package:stcerwallet/service/network_manager.dart';
import 'package:stcerwallet/service/watch_event_service.dart';
import 'dart:developer';

import 'wallet_state.dart';
import 'package:flutter/material.dart';

class WalletHandler {
  WalletHandler(
    this._store,
    this._addressService,
    this._contractService,
    this._configurationService,
    this._watchEventService,
    this._bloc,
  );

  final Store<Wallet, WalletAction> _store;
  final AddressService _addressService;
  final ConfigurationService _configurationService;
  final ContractService _contractService;
  final WatchEventService _watchEventService;
  final DeepLinkBloc _bloc;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Wallet get state => _store.state;

  Future<void> initialise() async {
    final entropyMnemonic = _configurationService.getEntropyMnemonic();
    final privateKey = _configurationService.getPrivateKey();

    if (entropyMnemonic != null && entropyMnemonic.isNotEmpty) {
      _initialiseFromMnemonic(entropyMnemonic);
      return;
    }

    _initialiseFromPrivateKey(privateKey);
  }

  Future<void> _initialiseFromMnemonic(String entropyMnemonic) async {
    log(entropyMnemonic);
    //final mnemonic = _addressService.entropyToMnemonic(entropyMnemonic);
    final privateKey = _addressService.getPrivateKey(entropyMnemonic);
    final address = await _addressService.getPublicAddress(privateKey);

    log("public key is " + address.keyPair.getPublicKeyHex());
    log("private key is " + Helpers.byteToHex(address.keyPair.getPrivateKey()));
    log("address is " + address.getAddress());

    _store.dispatch(InitialiseWallet(address.getAddress(), privateKey, address,
        address.keyPair.getPublicKeyHex()));

    await _initialiseRedirect();
    await _initialise();
  }

  Future<void> _initialiseFromPrivateKey(String privateKey) async {
    final address = await _addressService.getPublicAddress(privateKey);

    _store.dispatch(InitialiseWallet(address.getAddress(), privateKey, address,
        address.keyPair.getPublicKeyHex()));

    await _initialiseRedirect();
    await _initialise();
  }

  Future<void> _initialise() async {
    await this.fetchOwnBalance();

    _watchEventService.listenTransfer(state.account, () async {
      log("new txn event");
      await fetchOwnBalance();
    });
  }

  Future<void> _initialiseRedirect() async {
    _bloc.listen((String url) {
      final tokens = url.split("/");
      if (tokens.length == 0) {
        return;
      }
      final payloadHex = tokens[tokens.length - 1];
      final privateKey = _configurationService.getPrivateKey();
      CustomNavigatorObserver.getInstance().navigator.push(MaterialPageRoute(
          builder: (BuildContext context) => WalletTransactionPayloadPage(
              payloadHex: payloadHex, privateKeyString: privateKey)));
    });
  }

  Future<void> fetchOwnBalance() async {
    _store.dispatch(UpdatingBalance());

    var tokenBalance = BigInt.zero;

    var stcBalance = await state.account.balanceOfStc(NetworkManager.getCurrentNetworkUrl().httpUrl);

    // TODO
    var balance = BigInt.from(stcBalance.low);
    _store.dispatch(BalanceUpdated(balance, tokenBalance));
  }

  Future<void> resetWallet() async {
    await _configurationService.setMnemonic(null);
    await _configurationService.setupDone(false);
    await _watchEventService.dispose();
  }

  Future<void> stopWatch() async {
    await _watchEventService.dispose();
  }

  Future<void> startWatch() async {
    _watchEventService.listenTransfer(state.account, () async {
      log("new txn event");
      await fetchOwnBalance();
    });
  }

  Future<void> startNewNodeWatch(PubSubClient client) async {
    _watchEventService.setClient(client);

    _watchEventService.listenTransfer(state.account, () async {
      log("new txn event");
      await fetchOwnBalance();
    });
  }

}
