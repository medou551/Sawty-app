import '../../main.dart';
import '../models/bureau_model.dart';
import '../models/voter_status_model.dart';

class BureauService {
  Future<List<BureauModel>> getBureaux() async {
    final response = await supabase
        .from('bureaux')
        .select()
        .eq('status', 'active')
        .order('name', ascending: true);
    return (response as List)
        .map((row) => BureauModel.fromMap(row['id'] as String, row))
        .toList();
  }

  Future<BureauModel?> getBureauById(String bureauId) async {
    final response = await supabase
        .from('bureaux')
        .select()
        .eq('id', bureauId)
        .maybeSingle();
    if (response == null) return null;
    return BureauModel.fromMap(response['id'] as String, response);
  }

  Future<VoterStatusModel?> getCurrentUserVoterStatus(String uid) async {
    final response = await supabase
        .from('voter_status')
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (response == null) return null;
    return VoterStatusModel.fromMap(uid, response);
  }
}
