class HDWallet {
  String name;

  String address;

  String privateKey;

  String icon;

  String mnemonic;

  HDWallet(
      {this.name, this.address, this.privateKey, this.icon, this.mnemonic});

  @override
  int get hashCode {
    return address.hashCode;
  }

  @override
  bool operator ==(other) {
    if (other is HDWallet) {
      return address.toLowerCase() == other.address.toLowerCase();
    }
    return false;
  }

  @override
  String toString() {
    return 'HDWallet{name: $name, address: $address, privateKey: $privateKey, icon: $icon, mnemonic: $mnemonic}';
  }
}
