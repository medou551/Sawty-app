class BureauModel {
  final String id;
  final String name;
  final String region;
  final String moughataa;
  final double latitude;
  final double longitude;
  final String status;

  const BureauModel({
    required this.id,
    required this.name,
    required this.region,
    required this.moughataa,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory BureauModel.fromMap(String id, Map<String, dynamic> map) {
    return BureauModel(
      id: id,
      name: map['name'] ?? '',
      region: map['region'] ?? '',
      moughataa: map['moughataa'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      status: map['status'] ?? 'inactive',
    );
  }
}