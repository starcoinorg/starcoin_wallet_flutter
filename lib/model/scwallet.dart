import 'dart:convert';

import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/account_manager.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:stcerwallet/service/database_service.dart';

class ScWallet extends Entity {
  static final String tableName = "seeds";

  Wallet wallet;
  List<Account> _accounts;
  int _addressCount;
  bool _isDefault;
  int _currentAccount;
  String _seed;

  ScWallet(this._accounts, this._addressCount, this._isDefault,
      this._currentAccount, this._seed) {
    this.wallet = Wallet(mnemonic: this._seed);
  }

  void addAccount() {
    final account = wallet.generateAccount(_addressCount++);
    this._accounts.add(account);
  }

  void deleteAccount(Account account) {
    _accounts.remove(account);
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
        _accounts.map((account) => account.keyPair.getPrivateKeyHex());
    return {
      "seed": _seed,
      "private_keys": jsonEncode(privatekeys),
      "address_count": _addressCount,
      "is_default": _isDefault,
      "current_account": _currentAccount,
    };
  }

  @override
  String toString() {
    return 'ScWallet{_accounts: $_accounts, _addressCount: $_addressCount, _isDefault: $_isDefault, _currentAccount: $_currentAccount, _seed: $_seed}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScWallet &&
          runtimeType == other.runtimeType &&
          wallet == other.wallet &&
          _accounts == other._accounts &&
          _addressCount == other._addressCount &&
          _isDefault == other._isDefault &&
          _currentAccount == other._currentAccount &&
          _seed == other._seed;

  @override
  int get hashCode =>
      wallet.hashCode ^
      _accounts.hashCode ^
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
  final List<String> privatekeysList = jsonDecode(privateKeys);
  var accounts = privatekeysList
      .map((privateKeyHex) => Account(KeyPair.fromHex(privateKeyHex)))
      .toList();

  return ScWallet(accounts, addressCount, isDefault, currentAccount, seed);
}
