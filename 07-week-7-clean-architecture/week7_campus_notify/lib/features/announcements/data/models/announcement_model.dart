import '../../domain/entities/announcement.dart';

/// Representasi data luar (mis. JSON) + mapping ke entity.
/// Mapping hanya boleh hidup di layer data.
class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.body,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
      };

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  Announcement toEntity() => Announcement(id: id, title: title, body: body);
}
