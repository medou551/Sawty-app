import '../../main.dart';
import '../models/candidate_model.dart';
import '../models/election_model.dart';

class ElectionService {
  Future<List<ElectionModel>> getOpenElections() async {
    final response = await supabase
        .from('elections')
        .select()
        .eq('status', 'open')
        .order('created_at', ascending: false);
    return (response as List)
        .map((row) => ElectionModel.fromMap(row['id'] as String, row))
        .toList();
  }

  Future<List<CandidateModel>> getCandidates(String electionId) async {
    final response = await supabase
        .from('candidates')
        .select()
        .eq('election_id', electionId)
        .order('name', ascending: true);
    return (response as List)
        .map((row) => CandidateModel.fromMap(row['id'] as String, row))
        .toList();
  }
}
