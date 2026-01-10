# 📱 Fivondronana - Guide Développeur

## Table des matières

1. [Vue d'ensemble du projet](#vue-densemble)
2. [Architecture de l'application](#architecture)
3. [Configuration initiale](#configuration-initiale)
4. [Structure des dossiers](#structure-des-dossiers)
5. [Modèles de données](#modèles-de-données)
6. [Services et fonctionnalités](#services-et-fonctionnalités)
7. [Workflow de développement](#workflow-de-développement)
8. [Conventions de code](#conventions-de-code)
9. [Déploiement](#déploiement)

---

## 🎯 Vue d'ensemble

**Fivondronana** est une application mobile de digitalisation pour le scout protestant à Madagascar (SAMPATI/FSFLM/SATIMPA).

### Caractéristiques principales

- **Semi-offline**: L'app fonctionne même sans connexion internet
- **Firebase intégré**: Authentication, Firestore (base de données), et Storage
- **Synchronisation automatique**: Sync des données quand la connexion revient
- **Multi-plateforme**: Android, iOS, Web, Linux, Windows, macOS

### Stack technologique

- **Framework**: Flutter
- **Language**: Dart
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: GetX
- **Local Storage**: Hive (NoSQL local)
- **Database local**: SQLite
- **Connectivity**: connectivity_plus

---

## 🏗️ Architecture

```
Architecture en couches:

┌─────────────────────────────────┐
│      UI Layer (Screens)         │ - Pages, dialogs, widgets
├─────────────────────────────────┤
│   State Management (GetX)       │ - Controllers, GetX bindings
├─────────────────────────────────┤
│    Services & Repositories      │ - Logique métier
├─────────────────────────────────┤
│  Data Layer (Firebase, Hive)    │ - Persistance des données
└─────────────────────────────────┘
```

### Principes SOLID appliqués

- **S**ingle Responsibility: Chaque classe a une responsabilité unique
- **O**pen/Closed: Ouvert à l'extension, fermé à la modification
- **L**iskov Substitution: Interfaces et héritages cohérents
- **I**nterface Segregation: Interfaces spécifiques et ciblées
- **D**ependency Inversion: Dépendre d'abstractions, pas de concrets

---

## ⚙️ Configuration initiale

### Prérequis

```bash
# Flutter
flutter --version  # >= 3.10.4

# Dart
dart --version   # >= 3.10.4

# Android SDK
# iOS SDK (sur macOS)
# Xcode (pour macOS/iOS)
```

### Étapes d'installation

1. **Cloner et configurer le projet**
   ```bash
   git clone <repo>
   cd fivondronana
   flutter pub get
   ```

2. **Configurer Firebase**
   - Aller sur [Firebase Console](https://console.firebase.google.com/)
   - Créer un nouveau projet
   - Ajouter Android et iOS
   - Télécharger:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`

3. **Configurer les variables d'environnement**
   ```bash
   cp .env.example .env
   # Éditer .env avec vos valeurs Firebase
   ```

4. **Installer les dépendances**
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Exécuter l'app**
   ```bash
   flutter run
   ```

---

## 📁 Structure des dossiers

```
lib/
├── main.dart                 # Point d'entrée
│
├── config/                   # Configuration globale
│   ├── firebase_config.dart # Setup Firebase
│   ├── app_theme.dart       # Thèmes et styles
│   └── app_constants.dart   # Constantes métier
│
├── models/                   # Modèles de données
│   ├── member_model.dart    # Membres (scouts)
│   └── fivondronana_model.dart  # Structure administrative
│
├── services/                 # Logique métier
│   ├── offline_service.dart # Gestion cache local
│   ├── connectivity_service.dart # Gestion réseau
│   ├── auth_service.dart    # Authentification Firebase
│   ├── member_service.dart  # CRUD Membres
│   └── sync_service.dart    # Synchronisation offline/online
│
├── controllers/              # GetX Controllers
│   ├── auth_controller.dart
│   ├── member_controller.dart
│   └── connectivity_controller.dart
│
├── screens/                  # Pages de l'app
│   ├── splash/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   ├── members/
│   │   ├── members_list_screen.dart
│   │   ├── member_detail_screen.dart
│   │   └── member_form_screen.dart
│   └── settings/
│
├── widgets/                  # Widgets réutilisables
│   ├── common/
│   │   ├── app_bar.dart
│   │   ├── loading_indicator.dart
│   │   └── error_widget.dart
│   ├── forms/
│   ├── dialogs/
│   └── cards/
│
└── utils/                    # Utilitaires
    ├── validators.dart      # Validations
    ├── formatters.dart      # Formatage données
    ├── logger.dart          # Logs
    └── extensions.dart      # Extensions Dart
```

---

## 💾 Modèles de données

### Member (Scout)

```dart
class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String? totem;              // Nom préféré
  final String? photoUrl;           // Photo profile
  final String? address;            // Adresse
  final DateTime? dateOfBirth;      // Date naissance
  final DateTime? commitmentDate;   // Date engagement
  final String? commitmentPlace;    // Lieu engagement
  final List<String> sampanaHistory; // Historique sampana
  final List<String> talents;       // Talents
  final String division;            // Mpanazava ou Tily
  final String currentSampana;      // Sampana actuel
  final String? position;           // Poste (Filoha, Tonia, etc)
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Fivondronana (Structure administrative)

```dart
class Fivondronana {
  final String id;
  final String name;
  final int number;                // Numéro identifiant
  final String faritra;
  final String faritany;
  final String foibe;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

---

## 🔧 Services et fonctionnalités

### 1. OfflineService
Gère la sauvegarde locale avec Hive.

```dart
// Utilisation
final offline = OfflineService();
await offline.initialize();

// Sauvegarder
await offline.saveData('members', membersList);

// Récupérer
final data = offline.getData('members');

// Supprimer
await offline.deleteData('members');
```

### 2. ConnectivityService
Gère l'état de la connexion réseau.

```dart
// Dans un GetX Controller
final connectivity = Get.find<ConnectivityService>();

// Écouter les changements
ever(connectivity.isOnline, (isOnline) {
  if (isOnline) {
    syncData();
  }
});

// Vérifier l'état
if (connectivity.isOnline.value) {
  // Faire un appel réseau
}
```

### 3. FirebaseConfig
Configuration centralisée Firebase.

```dart
// Dans main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const MyApp());
}
```

---

## 👨‍💻 Workflow de développement

### 1. Créer une nouvelle Feature

**Étapes:**

1. Créer la branche
   ```bash
   git checkout -b feature/my-feature
   ```

2. Créer le modèle (si nécessaire)
   ```dart
   // lib/models/my_model.dart
   class MyModel {
     // ...
   }
   ```

3. Créer le service
   ```dart
   // lib/services/my_service.dart
   class MyService {
     // Logique métier
   }
   ```

4. Créer le controller GetX
   ```dart
   // lib/controllers/my_controller.dart
   class MyController extends GetxController {
     // État et logique
   }
   ```

5. Créer la UI
   ```dart
   // lib/screens/my_screen.dart
   class MyScreen extends StatelessWidget {
     // Interface utilisateur
   }
   ```

6. Commit et push
   ```bash
   git add .
   git commit -m "feat: add my feature"
   git push origin feature/my-feature
   ```

### 2. Mode de synchronisation Offline

```dart
class MyController extends GetxController {
  final _myService = Get.find<MyService>();
  final _connectivity = Get.find<ConnectivityService>();
  final _offline = OfflineService();

  @override
  void onInit() {
    super.onInit();
    
    // Écouter les changements de connectivité
    ever(_connectivity.isOnline, (_) async {
      if (_connectivity.isOnline.value) {
        await _syncPendingData();
      }
    });
  }

  Future<void> addItem(Item item) async {
    // Sauvegarder localement d'abord
    await _offline.saveData('item_${item.id}', item);

    // Si online, sync avec Firebase
    if (_connectivity.isOnline.value) {
      await _myService.uploadItem(item);
    }
  }

  Future<void> _syncPendingData() async {
    // Synchroniser les données en attente
    // 1. Charger du Hive
    // 2. Uploader vers Firebase
    // 3. Supprimer du Hive
  }
}
```

---

## 📝 Conventions de code

### Naming Conventions

```dart
// Classes
class MemberController { }
class MemberService { }

// Variables et fonctions
final myVariable = 'value';
void myFunction() { }

// Constants
const String appName = 'Fivondronana';

// Private members
final _privateField = 'private';
void _privateMethod() { }
```

### Code Formatting

```bash
# Formater le code
dart format lib/

# Linter
flutter analyze

# Tests
flutter test
```

### Commentaires

```dart
/// Documentation pour les méthodes publiques
/// Explique le quoi et le pourquoi, pas le comment

// Commentaires sur une ligne pour la logique interne

/// Classe qui gère la synchronisation des données
class SyncService {
  /// Synchronise les données en attente avec Firebase
  /// 
  /// Lance une exception si la connexion est perdue
  Future<void> syncData() async {
    // Logique de sync...
  }
}
```

---

## 🚀 Déploiement

### Android

```bash
# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release

# Construire un bundle (pour Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build iOS
flutter build ios --release

# Archive pour TestFlight/App Store
# À faire depuis Xcode
```

### Web

```bash
# Build web
flutter build web --release

# Servir localement
flutter run -d chrome --release
```

---

## 🐛 Troubleshooting

### Erreur "NDK not found"
```bash
# Solution
rm -rf /path/to/android-sdk/ndk
flutter clean
flutter pub get
```

### Erreur "Gradle build failed"
```bash
# Solution
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Firebase configuration manquante
- Vérifier que `google-services.json` est en `android/app/`
- Vérifier que `GoogleService-Info.plist` est en `ios/Runner/`
- Vérifier que le projet Firebase est correctement configuré

---

## 📚 Ressources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter](https://firebase.flutter.dev/)
- [GetX Documentation](https://github.com/jonataslaw/getx/wiki)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

## 👥 Support et Questions

Pour toute question ou problème:
1. Consulter ce guide
2. Vérifier les logs Flutter
3. Ouvrir une issue GitHub
4. Contacter l'équipe développement

---

**Dernière mise à jour**: Janvier 2026
**Version**: 1.0.0
