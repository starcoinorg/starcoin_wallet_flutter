const BASEURL = "http://localhost:9850";
const WSURL = "ws://localhost:9870";

class WalletUtil {
  static String getShortAddress(String address) {
    int length = address.length;
    return address.substring(0, 10) +
        "..." +
        address.substring(length - 10, length);
  }
}
