import "dart:io";
import 'package:local_database_null_safety/local_database_null_safety.dart';
import "package:flutter_test/flutter_test.dart";

void main() {
  String home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars["HOME"]!;
  } else if (Platform.isLinux) {
    home = envVars["HOME"]!;
  } else if (Platform.isWindows) {
    home = envVars["UserProfile"]!;
  } else {
    throw new Exception("Unknown platform");
  }
  test("Put to, read from, and remove from the database", () async {
    //Arrange
    Database database = Database(home + "/data");
    //Act
    database["dir1"] = dir1File();
    //Assert
    expect((await database["dir1"])["d"], dir1File()["d"]);
    expect((await database["dir1"])["b"], dir1File()["b"]);
    expect((await database["dir1"])["a"], dir1File()["a"]);
    expect(await database["dir1/a/0"], 1);
    expect(await database["nonexistant"], null);

    //Act
    await database.remove("dir1");
    //Assert
    expect((await database["dir1"]).toString(), "null");
    new Directory(home + "/data")..deleteSync(recursive: true);
  });
}

Map<String, Object> dir1File() {
  return {
    "a": [1, 2, 3],
    "b": {"c": 5},
    "d": [
      1,
      2,
      {"e": 5}
    ]
  };
}
