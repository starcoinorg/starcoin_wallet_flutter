import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:stcerwallet/sdk/web3j/utils/numbers.dart';

//Copy and pasted from the rlp nodejs library, translated to dart on a
//best-effort basis.

Uint8List encode(dynamic input) {
	if (input is List && !(input is Uint8List)) {
		var output = <Uint8List>[];
		for (var data in input) {
			output.add(encode(data));
		}

		var data = _concat(output);
		return _concat([encodeLength(data.length, 192), data]);
	} else {
		var data = toBuffer(input);

		if (data.length == 1 && data[0] < 128) {
			return data;
		} else {
			return _concat([encodeLength(data.length, 128), data]);
		}
	}
}

Uint8List encodeLength(int length, int offset) {
	if (length < 56) {
		return new Uint8List.fromList([length + offset]);
	} else {
		var hexLen = toHex(length, pad: true);
		var lLength = hexLen.length ~/ 2;

		return _concat([new Uint8List.fromList([offset + 55 + lLength]), new Uint8List.fromList(hex.decode(hexLen))]);
	}
}

Uint8List _concat(List<Uint8List> lists) {
	var list = <int>[];

  lists.forEach(list.addAll);

	return new Uint8List.fromList(list);
}

Uint8List toBuffer(dynamic data) {
	if (data is Uint8List)
		return data;

	if (data is String) {
		print("Notice: Tried to rlp-encode a string. Thats not supported yet. Go edit library:web3dart/src/utils/rlp.dart, line 53 if you need it");
		return new Uint8List.fromList([]); //TODO RLP encode strings
	} else if (data is int) {
		if (data == 0)
			return new Uint8List(0);

		return new Uint8List.fromList(numberToBytes(data));
	} else if (data is BigInt) {
		if (data == BigInt.zero)
			return new Uint8List(0);

		return new Uint8List.fromList(numberToBytes(data));
	} else if (data is List<int>) {
		return new Uint8List.fromList(data);
	}

	throw new TypeError();
}