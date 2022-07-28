import 'package:intl/intl.dart';

class Contact {
  int? id;
  String? pathToImage;
  String? name;
  String? phone;
  String? email;
  DateTime? birthdayDate;

  Contact({
    this.id,
    this.pathToImage,
    this.name,
    this.phone,
    this.email,
    this.birthdayDate,
  });

  String get birthday {
    if (birthdayDate == null) return "none";

    return DateFormat.yMMMMd().format(birthdayDate!);
  }

  @override
  String toString() {
    return "$id $name $phone $email";
  }

  Contact.fromMap(data) {
    id = data["id"];
    pathToImage = data["pathToImage"];
    name = data["name"];
    phone = data["phone"];
    email = data["email"];
    birthdayDate = data["birthdayDate"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(data["birthdayDate"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "pathToImage": pathToImage,
      "name": name,
      "phone": phone,
      "email": email,
      "birthdayDate": birthdayDate?.millisecondsSinceEpoch,
    };
  }
}
