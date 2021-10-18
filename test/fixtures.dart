enum FixtureEnum { valid, invalid }

class Fixture {
  String? msg;
  int? dec;
  String? hex;

  Fixture({this.hex, this.dec, this.msg});
}

Map<FixtureEnum, List<Fixture>> fixtures = {
  FixtureEnum.valid: [
    Fixture(dec: 0, hex: "00"),
    Fixture(dec: 1, hex: "01"),
    Fixture(dec: 252, hex: "fc"),
    Fixture(dec: 253, hex: "fdfd00"),
    Fixture(dec: 254, hex: "fdfe00"),
    Fixture(dec: 255, hex: "fdff00"),
    Fixture(dec: 65534, hex: "fdfeff"),
    Fixture(dec: 65535, hex: "fdffff"),
    Fixture(dec: 65536, hex: "fe00000100"),
    Fixture(dec: 65537, hex: "fe01000100"),
    Fixture(dec: 4294967295, hex: "feffffffff"),
    Fixture(dec: 4294967296, hex: "ff0000000001000000"),
    Fixture(dec: 4294967297, hex: "ff0100000001000000"),
    Fixture(dec: 9007199254740991, hex: "ffffffffffffff1f00")
  ],
  FixtureEnum.invalid: [
    Fixture(dec: -1, msg: 'RangeError: value out of range'),
    Fixture(
        dec: 9007199254740992,
        hex: "ffffffffff00002000",
        msg: 'RangeError: value out of range')
  ]
};
