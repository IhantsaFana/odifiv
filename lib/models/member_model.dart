class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String? totem;
  final String? photoUrl;
  final String? address;
  final DateTime? dateOfBirth;
  final DateTime? commitmentDate;
  final String? commitmentPlace;
  final List<String> sampanaHistory;
  final List<String> talents;
  final String division; // Mpanazava or Tily
  final String currentSampana;
  final String? position;
  final DateTime createdAt;
  final DateTime updatedAt;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.totem,
    this.photoUrl,
    this.address,
    this.dateOfBirth,
    this.commitmentDate,
    this.commitmentPlace,
    this.sampanaHistory = const [],
    this.talents = const [],
    required this.division,
    required this.currentSampana,
    this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      totem: json['totem'],
      photoUrl: json['photoUrl'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      commitmentDate: json['commitmentDate'] != null
          ? DateTime.parse(json['commitmentDate'])
          : null,
      commitmentPlace: json['commitmentPlace'],
      sampanaHistory: List<String>.from(json['sampanaHistory'] ?? []),
      talents: List<String>.from(json['talents'] ?? []),
      division: json['division'] ?? '',
      currentSampana: json['currentSampana'] ?? '',
      position: json['position'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'totem': totem,
      'photoUrl': photoUrl,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'commitmentDate': commitmentDate?.toIso8601String(),
      'commitmentPlace': commitmentPlace,
      'sampanaHistory': sampanaHistory,
      'talents': talents,
      'division': division,
      'currentSampana': currentSampana,
      'position': position,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
