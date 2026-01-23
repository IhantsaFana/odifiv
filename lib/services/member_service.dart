import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member_model.dart';
import 'package:logger/logger.dart';

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  final String _collection = 'members';

  // Get all members (Stream for Real-time)
  Stream<List<MemberModel>> getMembersStream() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MemberModel.fromFirestore(doc))
            .toList());
  }

  // Add a new member
  Future<String?> addMember(MemberModel member) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(member.toFirestore());
      _logger.i('Member added successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Error adding member: $e');
      return null;
    }
  }

  // Update an existing member
  Future<bool> updateMember(MemberModel member) async {
    if (member.id == null) return false;
    try {
      await _firestore
          .collection(_collection)
          .doc(member.id)
          .update(member.toFirestore());
      _logger.i('Member updated successfully: ${member.id}');
      return true;
    } catch (e) {
      _logger.e('Error updating member: $e');
      return false;
    }
  }

  // Toggle Assurance Status
  Future<bool> toggleAssurance(String memberId, bool isPaid) async {
    try {
      await _firestore.collection(_collection).doc(memberId).update({
        'isAssurancePaid': isPaid,
      });
      return true;
    } catch (e) {
      _logger.e('Error toggling assurance: $e');
      return false;
    }
  }

  // Get a single member
  Future<MemberModel?> getMember(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return MemberModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _logger.e('Error getting member: $e');
      return null;
    }
  }
}
