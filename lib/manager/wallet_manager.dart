
import 'package:stcerwallet/model/hdwallet.dart';

class WalletManager {

  Map<String,HDWallet> _wallets = {};

  bool isWalletExisted(String address,HDWallet wallet){
    String lowerCaseAddress = address.toLowerCase();
    return _wallets.containsKey(lowerCaseAddress);
  }



}