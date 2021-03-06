import 'package:stcerwallet/service/configuration_service.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:starcoin_wallet/wallet/account_manager.dart';
import 'package:stcerwallet/service/wallet_manager.dart';

abstract class IAddressService {
  String generateMnemonic();
  String getPrivateKey(String mnemonic);
  Future<Account> getPublicAddress(String privateKey);
  Future<bool> setupFromMnemonic(String mnemonic);
  Future<bool> setupFromPrivateKey(String privateKey);
  String entropyToMnemonic(String entropyMnemonic);
}

class AddressService implements IAddressService {
  IConfigurationService _configService;
  AddressService(this._configService);

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  String entropyToMnemonic(String entropyMnemonic) {
    return bip39.entropyToMnemonic(entropyMnemonic);
  }

  @override
  String getPrivateKey(String mnemonic) {
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'STARCOIN');
    Account account = wallet.generateAccount(0);
    return Helpers.byteToHex(account.keyPair.getPrivateKey());
  }

  @override
  Future<Account> getPublicAddress(String privateKey) async {
    final private = Helpers.hexToBytes(privateKey);
    final keypair = KeyPair(private);
    final account = Account(keypair);
    return account;
  }

  @override
  Future<bool> setupFromMnemonic(String mnemonic) async {
    final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);

    Wallet wallet = new Wallet(mnemonic: cryptMnemonic, salt: 'STARCOIN');
    Account account = wallet.generateAccount(0);

    WalletManager.instance.initWallet(cryptMnemonic, mnemonic);

    await _configService.setMnemonic(mnemonic);
    await _configService.setEntropyMnemonic(cryptMnemonic);

    await _configService
        .setPrivateKey(Helpers.byteToHex(account.keyPair.getPrivateKey()));
    await _configService.setupDone(true);
    return true;
  }

  @override
  Future<bool> setupFromPrivateKey(String privateKey) async {
    await _configService.setMnemonic(null);
    await _configService.setEntropyMnemonic(null);
    await _configService.setPrivateKey(privateKey);
    await _configService.setupDone(true);
    return true;
  }
}
