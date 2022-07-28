import 'user.dart';

class Room {
  late final String id;
  late final int maxParticipant;

  late String title;
  late String createdByUser;

  List<User> userList = [];
  List<String> invitedUserIdList = [];

  late bool isCreatorFunctionsEnabled;

  late bool isPrivate;

  int get usersCount => userList.length;

  Room({
    required this.id,
    required this.title,
    required this.createdByUser,
    this.isCreatorFunctionsEnabled = false,
    this.maxParticipant = 99,
    this.isPrivate = false,
    userList,
    invitedUserIdList,
  }) {
    this.userList = userList == null ? [] : userList;
    this.invitedUserIdList = invitedUserIdList == null ? [] : invitedUserIdList;
  }

  Room.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  void update(Map<String, dynamic> map) {
    fromMap(map, update: true);
  }

  void fromMap(Map<String, dynamic> map, {bool update = false}) {
    if (update == false) {
      id = map["id"];
      maxParticipant = map["maxParticipant"];
      title = map["title"];
      createdByUser = map["createdByUser"];
      isCreatorFunctionsEnabled = false;
      isPrivate = map["isPrivate"];
    }

    invitedUserIdList
        .addAll((map["invitedUserIdList"] as List<dynamic>).cast<String>());

    if ((map["userList"] as List).isNotEmpty) {
      userList.clear();
      for (var user in map["userList"]) {
        userList.add(User(
          userName: user["userName"],
          uid: user["uid"],
          socket: user["socket"],
        ));
      }
    } else {
      userList = [];
    }
  }

  // only for create room
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "createdByUser": createdByUser,
      "userList": [],
      "invitedUserIdList": [],
      "isCreatorFunctionsEnabled": isCreatorFunctionsEnabled,
      "maxParticipant": maxParticipant,
      "isPrivate": isPrivate,
    };
  }
}
