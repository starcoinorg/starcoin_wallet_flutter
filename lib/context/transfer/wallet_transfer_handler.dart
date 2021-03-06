import 'dart:async';
import 'dart:developer';
//import 'dart:math';

import 'package:stcerwallet/context/transfer/wallet_transfer_state.dart';
import 'package:stcerwallet/model/wallet_transfer.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/network_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:starcoin_wallet/serde/serde.dart';
import 'package:starcoin_wallet/starcoin/starcoin.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:stcerwallet/service/wallet_manager.dart';

class WalletTransferHandler {
  WalletTransferHandler(
    this._store,
    this._configurationService,
  );

  final Store<WalletTransfer, WalletTransferAction> _store;
  final ConfigurationService _configurationService;

  WalletTransfer get state => _store.state;

  Future<bool> transfer(String to, String publicKey, String amount,
      TokenBalance tokenBalance) async {
    var completer = new Completer<bool>();

    final wallets = await WalletManager.instance.wallets;
    final wallet = wallets[0];

    //var privateKey = _configurationService.getPrivateKey();

    //log("private KEY is " + privateKey);
    _store.dispatch(WalletTransferStarted());

    try {
      //var account = Account.fromPrivateKey(Helpers.hexToBytes(privateKey));
      // await account.transferSTC(
      //     NetworkManager.getCurrentNetworkUrl().httpUrl,
      //     Int128(0, int.parse(amount)),
      //     AccountAddress(Helpers.hexToBytes(to)),
      //     Bytes(getAuthKey(Helpers.hexToBytes(publicKey))));

      await wallet.defaultAccount().transferToken(
          NetworkManager.getCurrentNetworkUrl().httpUrl,
          Int128(0, int.parse(amount)),
          AccountAddress(Helpers.hexToBytes(to)),
          Bytes(getAuthKey(Helpers.hexToBytes(publicKey))),
          tokenBalance.token);

      completer.complete(true);
      // await _contractService.send(
      //   privateKey,
      //   EthereumAddress.fromHex(to),
      //   BigInt.from(double.parse(amount) * pow(10, 18)),
      //   onTransfer: (from, to, value) {
      //     completer.complete(true);
      //   },
      //   onError: (ex) {
      //     _store.dispatch(WalletTransferError(ex.toString()));
      //     completer.complete(false);
      //   },
      // );
    } catch (ex) {
      log(ex.toString());
      _store.dispatch(WalletTransferError(ex.toString()));
      completer.complete(false);
    }

    return completer.future;
  }

  Future<bool> sendTransaction(String payloadHex) async {
    var completer = new Completer<bool>();
    var privateKey = _configurationService.getPrivateKey();

    log("private KEY is " + privateKey);
    _store.dispatch(WalletTransferStarted());

    try {
      var account = Account.fromPrivateKey(Helpers.hexToBytes(privateKey));
      final payloadLcs = Helpers.hexToBytes(payloadHex);
      final payload = TransactionPayload.bcsDeserialize(payloadLcs);
      await account.sendTransaction(
          NetworkManager.getCurrentNetworkUrl().httpUrl, payload);
      completer.complete(true);
    } catch (ex) {
      log(ex);
      _store.dispatch(WalletTransferError(ex.toString()));
      completer.complete(false);
    }

    return completer.future;
  }
}
