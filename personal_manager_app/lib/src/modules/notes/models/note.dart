class Note {
  int? id;
  String? title;
  String? content;
  int? color;

  Note({
    this.id,
    this.title,
    this.content,
    this.color,
  });

  @override
  String toString() {
    return "{title: $title, content: $content, color: $color}";
  }

  Note.fromMap(Map<String, dynamic> data) {

    id = data["id"];
    title = data["title"].toString();
    content = data["content"].toString();
    color = data["color"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "color": color,
    };
  }
}
