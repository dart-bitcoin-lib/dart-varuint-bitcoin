import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_varuint_bitcoin/dart_varuint_bitcoin.dart' as varuint;

void main() {
  ByteData buffer = ByteData(2);
  final encoded = varuint.encode(0xfc, buffer, 1);
  print(hex.encode(encoded.buffer.buffer.asUint8List()));
  // => 00fx

  ByteData buffer2 =
      Uint8List.fromList(List.from([0x00, 0xfc])).buffer.asByteData();
  final decoded = varuint.decode(buffer2, 1);
  print(decoded.output.toRadixString(16));
  // => fc
}