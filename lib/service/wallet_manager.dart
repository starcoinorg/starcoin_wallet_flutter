import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/model/scwallet.dart';
import 'package:stcerwallet/service/database_service.dart';

class WalletManager {
  static final WalletManager _addressManager = new WalletManager._internal();
  WalletManager._internal();
  static WalletManager get instance => _addressManager;
  static String _tableName = "seeds";

  static List<ScWallet> _wallets;

  Future<List<ScWallet>> get wallets async {
    if (_wallets == null) {
      _wallets = await _init();
    }
    return _wallets;
  }

  Future<List<ScWallet>> _init() async {
    final databaseService = await DatabaseService.getInstance();
    final result = await databaseService.queryAll(_tableName, mapToScWallet);
    return result;
  }

  Future<void> initWallet(String seed) async {
    final databaseService = await DatabaseService.getInstance();

    final result = await databaseService
        .insert(ScWallet.initAccount(ScWallet.DEFAULT, seed));
    return result;
  }

  void addAccount(int index) async {
    if (index > _wallets.length) {
      return;
    }
    final wallet = _wallets[index];
    wallet.addAccount();

    final databaseService = await DatabaseService.getInstance();
    await databaseService.update(wallet);
  }

  void deleteAccount(int index, Account account) async {
    if (index > _wallets.length) {
      return;
    }
    final wallet = _wallets[index];
    wallet.deleteAccount(account);

    final databaseService = await DatabaseService.getInstance();
    await databaseService.update(wallet);
  }
}
