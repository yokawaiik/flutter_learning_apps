List<String> decrypt(String text, int offset, String alphInput) {
  final alph = alphInput.split('');

  List<String> results = [];
  final cipher = text.toLowerCase().split("");

  for (var index = 0; index < alph.length; index++) {
    print(index);
    cipher.asMap().forEach((i, e) {
      if (alph.contains(e)) {
        final iter = alph.indexWhere((val) => val == e);

        if (iter - offset < 0) {
          cipher[i] = alph[alph.length + (iter - offset)];
        } else if (iter - offset >= 0) {
          cipher[i] = alph[iter - offset];
        } else {
          print("Err");
        }
      }
    });

    // add to result new string
    results.add(cipher.join(""));
  }

  return results;
}

String encrypt(String text, int offset, String alphInput) {
  final alph = alphInput.split('');

  var cipher = text.toLowerCase().split("");

  if (offset > alph.length || offset < 0) {
    throw Exception("Сдвиг должен быть от 1 до ${alph.length}");
  } else {
    cipher.asMap().forEach((i, e) {
      if (alph.contains(e)) {
        var iter = alph.indexWhere((val) => val == e);

        if (iter + offset >= alph.length) {
          cipher[i] = alph[iter + offset - alph.length];
        } else if (iter + offset <= alph.length - 1) {
          cipher[i] = alph[iter + offset];
        } else {
          print("Err");
        }
      }
    });

    return cipher.join("");
  }
}
