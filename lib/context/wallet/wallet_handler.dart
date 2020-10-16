import 'package:stcerwallet/model/wallet.dart';
import 'package:stcerwallet/service/address_service.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/contract_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/service/watch_event_service.dart';
import 'dart:developer';

import 'wallet_state.dart';

class WalletHandler {
  WalletHandler(
    this._store,
    this._addressService,
    this._contractService,
    this._configurationService,
    this._watchEventService,
  );

  final Store<Wallet, WalletAction> _store;
  final AddressService _addressService;
  final ConfigurationService _configurationService;
  final ContractService _contractService;
  final WatchEventService _watchEventService;

  Wallet get state => _store.state;

  Future<void> initialise() async {
      final entropyMnemonic = _configurationService.getMnemonic();
      final privateKey = _configurationService.getPrivateKey();

      if (entropyMnemonic != null && entropyMnemonic.isNotEmpty) {
        _initialiseFromMnemonic(entropyMnemonic);
        return;
      }

      _initialiseFromPrivateKey(privateKey);
  }

  Future<void> _initialiseFromMnemonic(String entropyMnemonic) async {
    //final mnemonic = _addressService.entropyToMnemonic(entropyMnemonic);
    final privateKey = _addressService.getPrivateKey(entropyMnemonic);
    final address = await _addressService.getPublicAddress(privateKey);

    log("public key is " + address.keyPair.getPublicKeyHex());
    log("address is " + address.getAddress());
    log("private key is $privateKey");
    _store.dispatch(InitialiseWallet(address.getAddress(), privateKey, address,
        address.keyPair.getPublicKeyHex()));

    await _initialise();
  }

  Future<void> _initialiseFromPrivateKey(String privateKey) async {
    final address = await _addressService.getPublicAddress(privateKey);

    _store.dispatch(InitialiseWallet(address.getAddress(), privateKey, address,
        address.keyPair.getPublicKeyHex()));

    await _initialise();
  }

  Future<void> _initialise() async {
    await this.fetchOwnBalance();

    _watchEventService.listenTransfer(state.account, () async {
      log("new txn event");
      await fetchOwnBalance();
    });
  }

  Future<void> fetchOwnBalance() async {
    _store.dispatch(UpdatingBalance());

    var tokenBalance = BigInt.zero;

    var stcBalance = await state.account.balanceOfStc();

    // TODO
    var balance = BigInt.from(stcBalance.low);
    log("balance is $balance");
    _store.dispatch(BalanceUpdated(balance, tokenBalance));
  }

  Future<void> resetWallet() async {
    await _configurationService.setMnemonic(null);
    await _configurationService.setupDone(false);
  }
}
