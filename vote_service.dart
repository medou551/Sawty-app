import '../../main.dart';

class VoteService {
  Future<void> submitVote({
    required String electionId,
    required String candidateId,
    required String bureauId,
    required double gpsLatitude,
    required double gpsLongitude,
    required double distanceFromBureauKm,
    required bool regionMatch,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté.');

    await supabase.rpc('submit_vote', params: {
      'p_user_id': userId,
      'p_election_id': electionId,
      'p_candidate_id': candidateId,
      'p_bureau_id': bureauId,
      'p_gps_lat': gpsLatitude,
      'p_gps_lng': gpsLongitude,
      'p_distance_km': distanceFromBureauKm,
      'p_region_match': regionMatch,
    });
  }

  Future<List<Map<String, dynamic>>> getResults({required String electionId}) async {
    final response = await supabase
        .from('vote_results')
        .select()
        .eq('election_id', electionId)
        .order('vote_count', ascending: false);
    return List<Map<String, dynamic>>.from(response as List);
  }
}
