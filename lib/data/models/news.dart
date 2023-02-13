import 'package:equatable/equatable.dart';

const String tableNews = 'news';
const String columnStoryId = 'storyId';
const String columnTitle = 'title';
const String columnSummary = 'summary';
const String columnModifiedAt = 'modifiedAt';
const String columnImageUrl = 'imageUrl';

class News extends Equatable {
  late final int storyId;
  String? title;
  String? summary;
  DateTime? modifiedAt;
  String? imageUrl;

  News(
      {required this.storyId,
      this.title,
      this.summary,
      this.modifiedAt,
      this.imageUrl});

  News.fromAPIMap(Map<String, dynamic> json) {
    storyId = json['storyId'];
    title = json['title'];
    summary = json['summary'];
    modifiedAt = DateTime.parse(json['modifiedAt']);
    imageUrl = json['image'];
  }

  News.fromInternalDbMap(Map<String, dynamic> json) {
    storyId = json['storyId'];
    title = json['title'];
    summary = json['summary'];
    modifiedAt = DateTime.parse(json['modifiedAt']);
    imageUrl = json['imageUrl'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storyId'] = storyId;
    data['title'] = title;
    data['summary'] = summary;
    data['modifiedAt'] = modifiedAt.toString();
    data['imageUrl'] = imageUrl;
    return data;
  }

  @override
  List<Object?> get props => [storyId, title, summary, modifiedAt, imageUrl];
}
