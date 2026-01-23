import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String? id;
  final String? photoUrl;
  final String fullName;
  final String totemOrNickname;
  final String role; // beazina, mpiandraikitra, etc.
  final String branch; // mavo, maitso, etc.
  final String function;
  final String phone;
  final String? email;
  final DateTime? birthDate;
  final DateTime? entryDateScout;
  final DateTime? promiseDateScout;
  final List<ProgressionMilestone> progression;
  final bool isAssurancePaid;
  final String status;

  MemberModel({
    this.id,
    this.photoUrl,
    required this.fullName,
    required this.totemOrNickname,
    required this.role,
    required this.branch,
    required this.function,
    required this.phone,
    this.email,
    this.birthDate,
    this.entryDateScout,
    this.promiseDateScout,
    this.progression = const [],
    this.isAssurancePaid = false,
    this.status = 'active',
  });

  // Convert Firestore Document to MemberModel
  factory MemberModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return MemberModel(
      id: doc.id,
      photoUrl: data['photoUrl'],
      fullName: data['fullName'] ?? '',
      totemOrNickname: data['totemOrNickname'] ?? '',
      role: data['role'] ?? 'beazina',
      branch: data['branch'] ?? 'mavo',
      function: data['function'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      entryDateScout: (data['entryDateScout'] as Timestamp?)?.toDate(),
      promiseDateScout: (data['promiseDateScout'] as Timestamp?)?.toDate(),
      progression: (data['progression'] as List? ?? [])
          .map((m) => ProgressionMilestone.fromMap(m))
          .toList(),
      isAssurancePaid: data['isAssurancePaid'] ?? false,
      status: data['status'] ?? 'active',
    );
  }

  // Convert MemberModel to JSON for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      if (photoUrl != null) 'photoUrl': photoUrl,
      'fullName': fullName,
      'totemOrNickname': totemOrNickname,
      'role': role,
      'branch': branch,
      'function': function,
      'phone': phone,
      if (email != null) 'email': email,
      if (birthDate != null) 'birthDate': Timestamp.fromDate(birthDate!),
      if (entryDateScout != null) 'entryDateScout': Timestamp.fromDate(entryDateScout!),
      if (promiseDateScout != null) 'promiseDateScout': Timestamp.fromDate(promiseDateScout!),
      'progression': progression.map((m) => m.toMap()).toList(),
      'isAssurancePaid': isAssurancePaid,
      'status': status,
    };
  }
}

class ProgressionMilestone {
  final String title;
  final DateTime date;
  final String place;

  ProgressionMilestone({
    required this.title,
    required this.date,
    required this.place,
  });

  factory ProgressionMilestone.fromMap(Map<String, dynamic> map) {
    return ProgressionMilestone(
      title: map['title'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      place: map['place'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'place': place,
    };
  }
}
