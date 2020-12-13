import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stcerwallet/model/stored_keypair.dart';

abstract class IConfigurationService {
  Future<void> setMnemonic(String value);
  Future<void> setEntropyMnemonic(String value);
  Future<void> setupDone(bool value);
  Future<void> setPrivateKey(String value);
  Future<void> setKeyPairs(List<StoredKeypair> value);
  Future<void> addKeyPair(StoredKeypair value);
  String getMnemonic();
  String getPrivateKey();
  bool didSetupWallet();
  String getEntropyMnemonic();
  List<StoredKeypair> getKeyPairs();
}

class ConfigurationService implements IConfigurationService {
  SharedPreferences _preferences;
  ConfigurationService(this._preferences);

  @override
  Future<void> setMnemonic(String value) async {
    await _preferences.setString("mnemonic", value);
  }

  @override
  Future<void> setPrivateKey(String value) async {
    await _preferences.setString("privateKey", value);
  }

  @override
  Future<void> setupDone(bool value) async {
    await _preferences.setBool("didSetupWallet", value);
  }

  // gets
  @override
  String getMnemonic() {
    return _preferences.getString("mnemonic");
  }

  @override
  String getPrivateKey() {
    return _preferences.getString("privateKey");
  }

  @override
  bool didSetupWallet() {
    return _preferences.getBool("didSetupWallet") ?? false;
  }

  @override
  Future<void> setEntropyMnemonic(String value) async {
    await _preferences.setString("entropyMnemonic", value);
  }

  @override
  String getEntropyMnemonic() {
    return _preferences.getString("entropyMnemonic");
  }

  @override
  Future<void> setKeyPairs(List<StoredKeypair> value) async{
    await _preferences.setString("keypairs", jsonEncode(value));
  }

  @override
  List<StoredKeypair> getKeyPairs(){
    final keypairString = _preferences.getString("keypairs");
    if(keypairString!=null){
      return jsonDecode(keypairString);
    }else{
      return List();
    }
  }

  @override
  Future<void> addKeyPair(StoredKeypair value) async{
    var keypairs=getKeyPairs();
    for(StoredKeypair keypair in keypairs){
      if(keypair==value){
        return ;
      }
    }
    keypairs.add(value);
    await setKeyPairs(keypairs);
  }
}
