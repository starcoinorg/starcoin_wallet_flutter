import 'dart:convert';

import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/account_manager.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:stcerwallet/service/database_service.dart';

class ScWallet extends Entity {
  static final String tableName = "seeds";
  static final int DEFAULT = 1;

  Wallet wallet;
  List<Account> accounts;
  int _addressCount;
  int _isDefault;
  int _currentAccount;
  String _seed;

  ScWallet(this.accounts, this._addressCount, this._isDefault,
      this._currentAccount, this._seed) {
    this.wallet = Wallet(mnemonic: this._seed);
  }

  ScWallet.initAccount(this._isDefault, this._seed) {
    this.wallet = Wallet(mnemonic: this._seed, salt: 'STARCOIN');
    Account account = this.wallet.newAccount();
    this._addressCount = 1;
    this._currentAccount = 0;
    this.accounts = [account];
  }

  String getMnemonic() {
    return _seed;
  }

  Account defaultAccount() {
    return accounts[_currentAccount];
  }

  void setDefaultAccount(Account account) {
    for (int i = 0; i < accounts.length; i++) {
      if (account == accounts[i]) {
        this._currentAccount = i;
      }
    }
  }

  void addAccount() {
    final account = wallet.generateAccount(_addressCount++);
    this.accounts.add(account);
  }

  void deleteAccount(Account account) {
    accounts.remove(account);
  }

  @override
  String createTable() {
    return "CREATE TABLE IF NOT EXISTS seeds(seed VARCHAR(128) PRIMARY KEY,private_keys JSON, address_count INT,is_default BOOLEAN,current_account INT)";
  }

  @override
  String getTableName() {
    return tableName;
  }

  @override
  Map<String, dynamic> toMap() {
    final privatekeys =
        accounts.map((account) => account.keyPair.getPrivateKeyHex()).toList();
    final jsonPrivateKeys = jsonEncode(privatekeys);
    return {
      "seed": _seed,
      "private_keys": jsonPrivateKeys,
      "address_count": _addressCount,
      "is_default": _isDefault,
      "current_account": _currentAccount,
    };
  }

  @override
  String toString() {
    return 'ScWallet{_accounts: $accounts, _addressCount: $_addressCount, _isDefault: $_isDefault, _currentAccount: $_currentAccount, _seed: $_seed}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScWallet &&
          runtimeType == other.runtimeType &&
          wallet == other.wallet &&
          accounts == other.accounts &&
          _addressCount == other._addressCount &&
          _isDefault == other._isDefault &&
          _currentAccount == other._currentAccount &&
          _seed == other._seed;

  @override
  int get hashCode =>
      wallet.hashCode ^
      accounts.hashCode ^
      _addressCount.hashCode ^
      _isDefault.hashCode ^
      _currentAccount.hashCode ^
      _seed.hashCode;
}

ScWallet mapToScWallet(Map<String, dynamic> record) {
  final seed = record['seed'];
  final addressCount = record['address_count'];
  final isDefault = record['is_default'];
  final currentAccount = record['current_account'];
  final privateKeys = record['private_keys'];
  final List<dynamic> privatekeysList = jsonDecode(privateKeys);
  var accounts = privatekeysList
      .map((privateKeyHex) => Account(KeyPair.fromHex(privateKeyHex)))
      .toList();

  return ScWallet(accounts, addressCount, isDefault, currentAccount, seed);
}
