import 'package:flutter/material.dart';

const BASEURL = "http://192.168.31.17:9850";

class WalletUtil {

  static String getShortAddress(String address){
    int length = address.length;
    return address.substring(0,10) + "..."+ address.substring(length-10,length);
  }

}