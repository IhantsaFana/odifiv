# 🔥 Configuration Firebase

Ce guide explique comment configurer Firebase pour le projet Fivondronana.

## Prérequis

- Compte Google
- Accès à [Firebase Console](https://console.firebase.google.com/)
- Flutter CLI installé

## Étapes de configuration

### 1. Créer un projet Firebase

1. Aller à https://console.firebase.google.com/
2. Cliquer sur "Créer un projet"
3. Entrer le nom: `fivondronana`
4. Désactiver Google Analytics (optionnel)
5. Cliquer "Créer un projet"

### 2. Ajouter Android

1. Dans la console Firebase, cliquer sur l'icône Android
2. Entrer le nom du package: `com.example.fivondronana`
3. Télécharger `google-services.json`
4. Placer le fichier dans: `android/app/`
5. Suivre les instructions de configuration Gradle

### 3. Ajouter iOS

1. Dans la console Firebase, cliquer sur l'icône iOS
2. Entrer le Bundle ID: `com.example.fivondronana`
3. Télécharger `GoogleService-Info.plist`
4. Ouvrir `ios/Runner.xcworkspace` avec Xcode
5. Glisser-déposer le fichier plist dans Xcode
6. S'assurer que le fichier est ajouté au cible "Runner"

### 4. Ajouter Web (optionnel)

1. Dans la console Firebase, cliquer sur l'icône Web
2. Entrer le nom de l'app
3. Copier la configuration Firebase
4. Ajouter à `web/index.html`

## Services à activer

### Authentication

1. Aller dans "Authentication" → "Sign-in method"
2. Activer:
   - **Email/Password**
   - **Google** (optionnel)
   - **Phone Number** (optionnel)

### Firestore Database

1. Aller dans "Firestore Database"
2. Cliquer "Create Database"
3. Choisir une région (ex: europe-west1)
4. Choisir le mode "Start in production mode"
5. Cliquer "Create"

#### Structure Firestore

```
firestore/
├── users/
│   ├── {userId}/
│   │   ├── email: string
│   │   ├── name: string
│   │   ├── role: string (admin|user)
│   │   └── createdAt: timestamp
│
├── fivondronana/
│   ├── {fivondronanaId}/
│   │   ├── name: string
│   │   ├── number: integer
│   │   ├── faritra: string
│   │   ├── faritany: string
│   │   └── foibe: string
│
├── members/
│   ├── {memberId}/
│   │   ├── firstName: string
│   │   ├── lastName: string
│   │   ├── totem: string
│   │   ├── division: string (Mpanazava|Tily)
│   │   ├── currentSampana: string
│   │   ├── position: string
│   │   ├── fivondronanaId: string (reference)
│   │   ├── talents: array
│   │   ├── sampanaHistory: array
│   │   ├── dateOfBirth: timestamp
│   │   ├── commitmentDate: timestamp
│   │   ├── photoUrl: string
│   │   └── updatedAt: timestamp
```

### Cloud Storage

1. Aller dans "Cloud Storage"
2. Clicker "Get started"
3. Choisir la même région que Firestore
4. Cliquer "Done"

#### Structure Storage

```
gs://fivondronana-bucket/
├── members/
│   ├── {memberId}/
│   │   └── {photoFileName}.jpg
├── groups/
│   └── {fivondronanaId}/
│       └── photos/
└── documents/
```

## Configuration Dart/Flutter

### 1. Créer firebase_options.dart

Le fichier `lib/config/firebase_options.dart` est auto-généré. Utiliser FlutterFire CLI:

```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer Firebase pour le projet
flutterfire configure
```

Cela créera automatiquement `firebase_options.dart`.

### 2. Variables d'environnement

Créer un fichier `.env` à la racine du projet:

```env
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_auth_domain
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_APP_ID=your_app_id
```

**Attention**: Ne jamais commit le fichier `.env` en production!

## Règles de sécurité Firestore

Remplacer les règles par défaut par celles-ci:

```firestore-rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Authentification requise pour tous
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Règles spécifiques pour users
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth != null;
    }
    
    // Règles pour members (lire tous, créer si auth)
    match /members/{memberId} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null;
      allow delete: if false; // Soft delete seulement
    }
    
    // Règles pour fivondronana (lire tous)
    match /fivondronana/{fivondronanaId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## Règles de sécurité Cloud Storage

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.resource.size < 5 * 1024 * 1024; // 5MB max
    }
  }
}
```

## Test de la configuration

```dart
// Vérifier Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialisé!');
}
```

## Troubleshooting

### Erreur: "Project ID is not set"

```bash
# Exécuter flutterfire configure
flutterfire configure
```

### Erreur: "android/google-services.json not found"

1. Télécharger le fichier depuis Firebase Console
2. Le placer dans `android/app/`
3. Exécuter `flutter clean && flutter pub get`

### Erreur: "Authentication not configured"

1. Aller à Firebase Console → Authentication
2. Activer au moins une méthode de connexion
3. Activer Identity Platform (si nécessaire)

## Liens utiles

- [Firebase Docs](https://firebase.google.com/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)

---

**Version**: 1.0.0
**Dernière mise à jour**: Janvier 2026
