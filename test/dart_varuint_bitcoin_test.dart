import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_varuint_bitcoin/dart_varuint_bitcoin.dart' as varuint;
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  if (fixtures.containsKey(FixtureEnum.valid)) {
    for (Fixture fixture in fixtures[FixtureEnum.valid]!) {
      test('Valid encode #${fixture.hex} (${fixture.dec!.toString()})', () {
        final encoded = varuint.encode(fixture.dec!);
        expect(hex.encode(encoded.buffer.buffer.asUint8List()),
            equals(fixture.hex));
        expect(encoded.bytes, equals(fixture.hex!.length / 2));
      });
      test('Valid decode #${fixture.hex} (${fixture.dec!.toString()})', () {
        final decoded = varuint.decode(
            Uint8List.fromList(hex.decode(fixture.hex!)).buffer.asByteData());
        expect(decoded.output, equals(fixture.dec));
        expect(decoded.bytes, equals(fixture.hex!.length / 2));
      });
      test('Valid encode #${fixture.hex} (${fixture.dec!.toString()})', () {
        expect(varuint.encodingLength(fixture.dec!),
            equals(fixture.hex!.length / 2));
      });
    }
  }
  if (fixtures.containsKey(FixtureEnum.invalid)) {
    for (Fixture fixture in fixtures[FixtureEnum.invalid]!) {
      test('Invalid for #${fixture.hex} (${fixture.dec!.toString()})', () {
        try {
          varuint.encode(fixture.dec!);
        } catch (e) {
          expect(e, isRangeError);
          expect((e as RangeError).toString(), equals(fixture.msg));
          return;
        }

        throw Exception('Should be throw');
      });
    }
  }

  test('write to buffer with offset', () {
    ByteData buffer = ByteData(2);
    final encoded = varuint.encode(0xfc, buffer, 1);
    expect(hex.encode(encoded.buffer.buffer.asUint8List()), equals('00fc'));
    expect(encoded.bytes, 1);
  });

  test('should be a buffer', () {
    ByteData buffer =
        Uint8List.fromList(List.from([0x00, 0xfc])).buffer.asByteData();
    final decoded = varuint.decode(buffer, 1);
    expect(decoded.output, equals(0xfc));
    expect(decoded.bytes, 1);
  });
}
