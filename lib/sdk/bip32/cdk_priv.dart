import 'package:stcerwallet/sdk/bip32/extended_private_key.dart';

abstract class CKDPrivate {

  ExtendedPrivateKey cKDPrivate(final int index);
}