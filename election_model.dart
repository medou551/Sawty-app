class ElectionModel {
  final String id;
  final String title;
  final String type;
  final String status;

  ElectionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
  });

  factory ElectionModel.fromMap(String id, Map<String, dynamic> map) {
    return ElectionModel(
      id: id,
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? '',
    );
  }
}