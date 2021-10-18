import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_varuint_bitcoin/dart_varuint_bitcoin.dart' as varuint;

void main() {
  Uint8List buffer = Uint8List(2);
  final encoded = varuint.encode(0xfc, buffer, 1);
  print(hex.encode(encoded.buffer.buffer.asUint8List()));
  // => 00fx

  Uint8List buffer2 = Uint8List.fromList([0x00, 0xfc]);
  final decoded = varuint.decode(buffer2, 1);
  print(decoded.output.toRadixString(16));
  // => fc
}
