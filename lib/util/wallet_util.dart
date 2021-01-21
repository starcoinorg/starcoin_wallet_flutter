import 'dart:io';

import 'package:starcoin_wallet/starcoin/starcoin.dart';

//const BASEURL = "http://proxima3.seed.starcoin.org:9850";
//const WSURL = "ws://proxima3.seed.starcoin.org:9870";
//const BASEURL = "http://localhost:9850";
//const WSURL = "ws://localhost:9870";

class WalletUtil {
  static String getShortAddress(String address) {
    if (Platform.isAndroid || Platform.isIOS) {
      int length = address.length;
      return address.substring(0, 10) +
          "..." +
          address.substring(length - 10, length);
    } else {
      return address;
    }
  }

  static String formatTokenStructTag(TypeTagStructItem tokenType) {
    return "${tokenType.value.address.toString()}::${tokenType.value.module.value}::${tokenType.value.name.value}";
  }
}
