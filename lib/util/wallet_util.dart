const BASEURL = "http://proxima3.seed.starcoin.org:9850";
const WSURL = "ws://proxima3.seed.starcoin.org:9870";
//const BASEURL = "http://192.168.245.165:9850";
//const WSURL = "ws://192.168.245.165:9870";

class WalletUtil {
  static String getShortAddress(String address) {
    int length = address.length;
    return address.substring(0, 10) +
        "..." +
        address.substring(length - 10, length);
  }
}
