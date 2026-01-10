class AppConstants {
  // Fivondronana Structure
  static const List<String> organizations = [
    'Foibe',
    'Faritany',
    'Faritra',
    'Fivondronana',
    'Sampana'
  ];

  // Divisions
  static const List<String> divisions = [
    'Mpanazava (Fille)',
    'Tily (Garçon)',
  ];

  // Sampana pour Mpanazava
  static const Map<String, Map<String, String>> mpanazovaLevels = {
    'voronkely': {
      'name': 'Voronkely',
      'ageRange': '6-12 ans',
      'color': 'Mavo (Jaune)',
      'hex': '#FFD700'
    },
    'mpanazova': {
      'name': 'Mpanazova',
      'ageRange': '12-16 ans',
      'color': 'Maitso (Vert)',
      'hex': '#2ECC71'
    },
    'afo': {
      'name': 'Afo',
      'ageRange': '+16 ans',
      'color': 'Mena (Rouge)',
      'hex': '#E74C3C'
    },
  };

  // Sampana pour Tily
  static const Map<String, Map<String, String>> tilyLevels = {
    'lovitao': {
      'name': 'Lovitao',
      'ageRange': '6-12 ans',
      'color': 'Mavo (Jaune)',
      'hex': '#FFD700'
    },
    'tily': {
      'name': 'Tily',
      'ageRange': '12-16 ans',
      'color': 'Maitso (Vert)',
      'hex': '#2ECC71'
    },
    'mpiandalana': {
      'name': 'Mpiandalana',
      'ageRange': '16-21 ans',
      'color': 'Mena (Rouge)',
      'hex': '#E74C3C'
    },
    'menafify': {
      'name': 'Menafify',
      'ageRange': '+21 ans',
      'color': 'Grenat',
      'hex': '#5B2C1F'
    },
  };

  // Member positions
  static const List<String> memberPositions = [
    'Filoha',
    'Tonia',
    'Mpiandraikitra',
    'Beazina',
  ];

  // Responsibilities
  static const List<String> responsibilities = [
    'Mpampilalao (Animateur/ice)',
    'Mpandrindra (Trésorier/ère)',
    'Tompo-toerana (Responsable de terrain)',
  ];

  // API endpoints
  static const String firebaseProjectId = 'your-project-id';
  static const String apiBaseUrl = '';

  // Local storage keys
  static const String userKey = 'user';
  static const String tokenKey = 'token';
  static const String syncStatusKey = 'sync_status';
}
