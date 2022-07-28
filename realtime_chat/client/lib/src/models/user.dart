class User {
  late String? userName;
  String? password;
  late String? uid;

  late String? socket;

  List<String> createdRoomsId = [];

  User({
    this.userName,
    this.password,
    this.uid,
    this.socket,
    createdRoomsId,
  });

  @override
  String toString() {
    return """
      {
        userName: ${userName},
        password: ${password},
        uid: ${uid},
        socket: ${socket},
        createdRoomsId: ${createdRoomsId},
      }
    """;
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "password": password,
      "uid": uid,
      "socket": socket,
      "createdRoomsId": createdRoomsId,
    };
  }

  void setSettings(Map<String, dynamic> data) {
    // print(data);
    uid = data["uid"];
    socket = data["socket"];
    createdRoomsId
        .addAll((data["createdRoomsId"] as List<dynamic>).cast<String>());
  }

  User.fromMap(Map<String, dynamic> map) {
    userName = map["userName"];
    uid = map["uid"];
    socket = map["socket"];

    createdRoomsId
        .addAll((map["createdRoomsId"] as List<dynamic>).cast<String>());
  }
}
