class CandidateModel {
  final String id;
  final String name;
  final String party;

  CandidateModel({
    required this.id,
    required this.name,
    required this.party,
  });

  factory CandidateModel.fromMap(String id, Map<String, dynamic> map) {
    return CandidateModel(
      id: id,
      name: map['name'] ?? '',
      party: map['party'] ?? '',
    );
  }
}