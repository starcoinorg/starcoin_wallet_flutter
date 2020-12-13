import 'package:starcoin_wallet/wallet/keypair.dart';

class StoredKeypair {

  final KeyPair _keyPair;
  final bool _isDefault;

  StoredKeypair(this._keyPair,this._isDefault);

  @override
  String toString() {
    return 'Keypair{_keyPair: $_keyPair, _isDefault: $_isDefault}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoredKeypair &&
          runtimeType == other.runtimeType &&
          _keyPair == other._keyPair &&
          _isDefault == other._isDefault;

  @override
  int get hashCode => _keyPair.hashCode ^ _isDefault.hashCode;

  StoredKeypair.fromJson(Map<String, dynamic> json)
      : _keyPair = KeyPair.fromJson(json['keypair']),
        _isDefault = json['is_default'];

  Map<String, dynamic> toJson() => {
    "keypair": _keyPair,
    "is_default": _isDefault,
  };

  String getPrivateKey(){
    return _keyPair.getPrivateKeyHex();
  }

  String getAddress(){
    return _keyPair.getAddress();
  }
}