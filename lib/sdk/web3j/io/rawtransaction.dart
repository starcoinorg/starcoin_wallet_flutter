import 'dart:typed_data';

import 'package:stcerwallet/sdk/web3j/utils/crypto.dart' as crypto;
import 'package:stcerwallet/sdk/web3j/utils/rlp.dart' as rlp;

class RawTransaction {

	final int nonce;
	final int gasPrice;
	final int gasLimit;

	final BigInt to;
	final BigInt value; //amount
	final List<int> data;

  RawTransaction({this.nonce, this.gasPrice, this.gasLimit, this.to, this.value, this.data});

  Uint8List encode(crypto.MsgSignature signature) {
		List<Uint8List> createRaw() {
			var list = <Uint8List>[]
        ..add(rlp.toBuffer(nonce))
        ..add(rlp.toBuffer(gasPrice))
        ..add(rlp.toBuffer(gasLimit))
        ..add(rlp.toBuffer(to ?? BigInt.zero))
        ..add(rlp.toBuffer(value))
        ..add(rlp.toBuffer(data ?? []));

			if (signature != null) {
				list..add(rlp.toBuffer(signature.v))
          ..add(rlp.toBuffer(signature.r))
          ..add(rlp.toBuffer(signature.s));
			}

			return list;
		}

		var byteData = createRaw();
		return rlp.encode(byteData);
	}

  Uint8List sign(Uint8List privateKey, int chainId) {
		var encodedTransaction = encode(
				new crypto.MsgSignature(BigInt.zero, BigInt.zero, chainId));
		var hashed = crypto.sha3digest.process(encodedTransaction);

		var signature = crypto.sign(hashed, privateKey);
		var vWithChain = signature.v + (chainId << 1) + 8;
		var updatedSignature = new crypto.MsgSignature(signature.r, signature.s, vWithChain);

		return encode(updatedSignature);
  }
}