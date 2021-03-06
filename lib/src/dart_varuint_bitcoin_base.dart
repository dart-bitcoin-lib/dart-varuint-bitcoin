import 'dart:typed_data';

var _maxSafeInteger = 9007199254740991;

void _checkUInt53(int n) {
  if (n < 0 || n > _maxSafeInteger) {
    throw RangeError('value out of range');
  }
}

class _EncodeOutputModel {
  final int bytes;

  final Uint8List buffer;

  _EncodeOutputModel(this.bytes, this.buffer);

  @override
  String toString() {
    return buffer.toString();
  }
}

class _DecodeOutputModel {
  final int bytes;

  final int output;

  _DecodeOutputModel(this.bytes, this.output);

  @override
  String toString() {
    return output.toString();
  }
}

/// Encode varuint
_EncodeOutputModel encode(int number, [Uint8List? buffer, int offset = 0]) {
  _checkUInt53(number);

  int bytes = 0;

  buffer ??= Uint8List(encodingLength(number));

  ByteData bufferByteData = buffer.buffer.asByteData();

  // 8 bit
  if (number < 0xfd) {
    bufferByteData.setUint8(offset, number);
    bytes = 1;

    // 16 bit
  } else if (number <= 0xffff) {
    bufferByteData.setUint8(offset, 0xfd);
    bufferByteData.setUint16(offset + 1, number, Endian.little);
    bytes = 3;

    // 32 bit
  } else if (number <= 0xffffffff) {
    bufferByteData.setUint8(offset, 0xfe);
    bufferByteData.setUint32(offset + 1, number, Endian.little);
    bytes = 5;

    // 64 bit
  } else {
    bufferByteData.setUint8(offset, 0xff);
    bufferByteData.setUint64(offset + 1, number, Endian.little);
    bytes = 9;
  }

  return _EncodeOutputModel(bytes, buffer);
}

/// Decode varuint
_DecodeOutputModel decode(Uint8List buffer, [int offset = 0]) {
  int bytes = 0, output;

  ByteData bufferByteData = buffer.buffer.asByteData();
  int first = bufferByteData.getUint8(offset);

  // 8 bit
  if (first < 0xfd) {
    bytes = 1;
    output = first;
    // 16 bit
  } else if (first == 0xfd) {
    bytes = 3;
    output = bufferByteData.getUint16(offset + 1, Endian.little);

    // 32 bit
  } else if (first == 0xfe) {
    bytes = 5;
    output = bufferByteData.getUint32(offset + 1, Endian.little);

    // 64 bit
  } else {
    bytes = 9;
    output = bufferByteData.getUint64(offset + 1, Endian.little);
  }

  return _DecodeOutputModel(bytes, output);
}

/// Get encoding length of varuint
int encodingLength(int number) {
  _checkUInt53(number);

  return (number < 0xfd
      ? 1
      : number <= 0xffff
          ? 3
          : number <= 0xffffffff
              ? 5
              : 9);
}
