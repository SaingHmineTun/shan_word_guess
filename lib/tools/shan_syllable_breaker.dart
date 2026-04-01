const String _consonantCombo = "မၼငပတၵၺဝ";
const String _consonants =
    "\u1075-\u1081\u1004\u101e\u1010\u1011\u1015\u1019\u101a\u101b\u101c\u101d\u1022";

const String _v1 = "\u1083\u102E\u1084";
const String _v2 = "\u1030";
const String _v3 = "\u1031";
const String _arrYao = "\u1083";

const String _toneMarks = "\u1087\u1088\u1038\u1037\u1089\u108a";

const String _asat = "\u103a";
const String _kaiKhin = "\u1086";

const String _enChar = "a-zA-Z0-9";

const String _otherChar =
    "႐-႙၀-၉၊။"
    "!-/:-@\\[-`\\{-~\\s";

String syllableBreak(String input) {
  String output = input;

  // Rule 0a
  output = output.replaceAllMapped(
    RegExp("([$_consonants])([$_consonants](?!$_asat))([$_consonants](?!$_asat))"),
    (m) => "${m[1]} ${m[2]} ${m[3]}",
  );

  // Rule 0b
  output = output.replaceAllMapped(
    RegExp("([$_consonants])([ျံုူိီွႂ])?([$_consonants])(?!$_asat)"),
    (m) => "${m[1]}${m[2] ?? ''} ${m[3]}",
  );

  // Rule 1
  output = output.replaceAllMapped(
    RegExp("([$_toneMarks$_enChar$_otherChar])"),
    (m) => "${m[1]} ",
  );

  // Rule 2
  output = output.replaceAllMapped(
    RegExp("([$_asat$_kaiKhin$_v1])(?![$_toneMarks])"),
    (m) => "${m[1]} ",
  );

  // Rule 3
  output = output.replaceAllMapped(
    RegExp("($_v2)(?!(?:[$_consonantCombo][$_asat]|[$_toneMarks]))"),
    (m) => "${m[1]} ",
  );

  // Rule 4
  output = output.replaceAllMapped(
    RegExp("($_v3)(?!($_arrYao|[$_toneMarks]))"),
    (m) => "${m[1]} ",
  );

  // Rule 5: collapse spaces
  output = output.replaceAll(RegExp(" +"), " ");

  return output.trim();
}

List<String> syllableBreakAsList(String input) {
  return syllableBreak(input).split(" ");
}
