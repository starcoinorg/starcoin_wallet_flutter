import 'package:etherwallet/model/wallet.dart';
import 'package:starcoin_wallet/wallet/account.dart';

abstract class WalletAction {}

class InitialiseWallet extends WalletAction {
  InitialiseWallet(this.address, this.privateKey,this.account,this.publicKey);
  final String address;
  final String privateKey;
  final Account account;
  final String publicKey;
}

class BalanceUpdated extends WalletAction {
  BalanceUpdated(this.ethBalance, this.tokenBalance);
  final BigInt ethBalance;
  final BigInt tokenBalance;
}

class UpdatingBalance extends WalletAction {}

Wallet reducer(Wallet state, WalletAction action) {
  if (action is InitialiseWallet) {
    return state.rebuild((b) => b
      ..address = action.address
      ..privateKey = action.privateKey
      ..account = action.account
    );
  }

  if (action is UpdatingBalance) {
    return state.rebuild((b) => b..loading = true);
  }

  if (action is BalanceUpdated) {
    return state.rebuild((b) => b
      ..loading = false
      ..ethBalance = action.ethBalance
      ..tokenBalance = action.tokenBalance);
  }

  return state;
}
