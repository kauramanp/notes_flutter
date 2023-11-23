class Notes {
  int? id;
  String title;
  String description;
  String? createdAt;

  Notes({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt,
      };

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
