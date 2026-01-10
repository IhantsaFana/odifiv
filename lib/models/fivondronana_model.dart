class Fivondronana {
  final String id;
  final String name;
  final int number;
  final String faritra;
  final String faritany;
  final String foibe;
  final DateTime createdAt;
  final DateTime updatedAt;

  Fivondronana({
    required this.id,
    required this.name,
    required this.number,
    required this.faritra,
    required this.faritany,
    required this.foibe,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fivondronana.fromJson(Map<String, dynamic> json) {
    return Fivondronana(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? 0,
      faritra: json['faritra'] ?? '',
      faritany: json['faritany'] ?? '',
      foibe: json['foibe'] ?? '',
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
      'name': name,
      'number': number,
      'faritra': faritra,
      'faritany': faritany,
      'foibe': foibe,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
