class News {
  int? storyId;
  String? title;
  String? summary;
  DateTime? modifiedAt;
  String? image;

  News({this.storyId, this.title, this.summary, this.modifiedAt, this.image});

  News.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    title = json['title'];
    summary = json['summary'];
    modifiedAt = DateTime.parse(json['modifiedAt']);
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storyId'] = storyId;
    data['title'] = title;
    data['summary'] = summary;
    data['modifiedAt'] = modifiedAt;
    data['image'] = image;
    return data;
  }
}
