class VoterStatusModel {
  final String uid;
  final bool eligible;
  final bool hasVoted;
  final String assignedBureauId;
  final String assignedRegion;

  VoterStatusModel({
    required this.uid,
    required this.eligible,
    required this.hasVoted,
    required this.assignedBureauId,
    required this.assignedRegion,
  });

  factory VoterStatusModel.fromMap(String uid, Map<String, dynamic> map) {
    return VoterStatusModel(
      uid: uid,
      eligible: map['eligible'] ?? false,
      hasVoted: map['has_voted'] ?? false,
      assignedBureauId: map['assigned_bureau_id'] ?? '',
      assignedRegion: map['assigned_region'] ?? '',
    );
  }
}