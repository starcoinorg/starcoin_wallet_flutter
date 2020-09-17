import 'package:stcerwallet/service/configuration_service.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:stcerwallet/utils/const.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:starcoin_wallet/wallet/wallet.dart';

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
    return entropyMnemonic;
    //return bip39.entropyToMnemonic(entropyMnemonic);
  }

  @override
  String getPrivateKey(String mnemonic) {
    Wallet wallet = new Wallet(mnemonic: mnemonic,url: BASEURL, salt: 'STARCOIN');
    Account account = wallet.generateAccount(0);
    return Helpers.byteToHex(account.keyPair.getPrivateKey());
  }

  @override
  Future<Account> getPublicAddress(String privateKey) async {

    final private = Helpers.hexToBytes(privateKey);
    final keypair = KeyPair(private);
    final account = Account(keypair,BASEURL);
    return account;
  }

  @override
  Future<bool> setupFromMnemonic(String mnemonic) async {
    Wallet wallet = new Wallet(mnemonic: mnemonic, url: BASEURL,salt: 'STARCOIN');
    Account account = wallet.generateAccount(0);

    await _configService.setMnemonic(mnemonic);
    await _configService.setPrivateKey(Helpers.byteToHex(account.keyPair.getPrivateKey()));
    await _configService.setupDone(true);
    return true;
  }

  @override
  Future<bool> setupFromPrivateKey(String privateKey) async {
    await _configService.setMnemonic(null);
    await _configService.setPrivateKey(privateKey);
    await _configService.setupDone(true);
    return true;
  }
}
