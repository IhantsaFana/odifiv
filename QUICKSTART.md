# 🚀 Quick Start - Fivondronana

Démarrage rapide pour les développeurs.

## Installation en 5 minutes

### 1. Clone et setup
```bash
git clone <repo-url>
cd fivondronana
flutter pub get
```

### 2. Configure Firebase
```bash
# Installer FlutterFire CLI (si pas déjà fait)
dart pub global activate flutterfire_cli

# Configurer Firebase automatiquement
flutterfire configure
```

ou manuellement:
- Télécharger `google-services.json` → `android/app/`
- Télécharger `GoogleService-Info.plist` → `ios/Runner/`

### 3. Copy .env
```bash
cp .env.example .env
# Éditer .env avec vos credentials Firebase
```

### 4. Clean & Run
```bash
flutter clean
flutter pub get
flutter run
```

## Commandes courantes

```bash
# Lancer l'app
flutter run

# Lancer sur un device spécifique
flutter run -d <device_id>

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Exécuter les tests
flutter test

# Nettoyer le build
flutter clean
```

## Structure rapide

```
lib/
├── config/      → Configuration (Firebase, Thème, Constantes)
├── models/      → Entités (Member, Fivondronana)
├── services/    → Logique métier (Firebase, Offline, Sync)
├── controllers/ → GetX Controllers (État)
├── screens/     → Pages de l'app
├── widgets/     → Composants réutilisables
├── utils/       → Helpers (validators, formatters)
└── main.dart    → Point d'entrée
```

## Architecture semi-offline

1. **Données locales** → Hive (sauvegarde locale)
2. **Sync automatique** → ConnectivityService détecte la connexion
3. **Firebase** → Cloud Firestore + Storage

```dart
// Exemple: Ajouter un membre (fonctionne offline)
final controller = Get.find<MemberController>();
await controller.addMember(member); // Sauvegardé localement
// Se sync avec Firebase automatiquement si online
```

## Points clés pour débuter

✅ **À faire:**
- Lire [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) pour l'architecture complète
- Lire [FIREBASE_SETUP.md](FIREBASE_SETUP.md) pour configurer Firebase
- Lire [CONVENTIONS.md](CONVENTIONS.md) pour les standards de code

✅ **Les services essentiels:**
- `OfflineService` - Gère Hive (local storage)
- `ConnectivityService` - Détecte online/offline
- `FirebaseConfig` - Initialize Firebase
- `AppTheme` - Thème de l'app

✅ **Métier Fivondronana:**
- Hiérarchie: Foibe → Faritany → Faritra → Fivondronana
- Divisions: Mpanazava (filles) et Tily (garçons)
- Sampana (groupes d'âge) avec couleurs spécifiques
- Positions: Filoha, Tonia, Mpiandraikitra, Beazina

## Fichiers important à créer

1. **lib/config/firebase_options.dart** ← auto-généré par `flutterfire configure`
2. **.env** ← Copy de .env.example et remplir
3. **google-services.json** ← Depuis Firebase Console → Android
4. **GoogleService-Info.plist** ← Depuis Firebase Console → iOS

## Troubleshooting

**❌ "NDK not found"**
```bash
rm -rf ~/Android/sdk/ndk/28.2.13676358
flutter clean && flutter pub get
```

**❌ "Gradle build failed"**
```bash
cd android && ./gradlew clean && cd ..
flutter clean && flutter pub get && flutter run
```

**❌ "Firebase not initialized"**
- Vérifier que `flutterfire configure` a été exécuté
- Vérifier que google-services.json est dans android/app/

## Mode offline

L'app utilise un système de sync intelligent:

```
┌─────────────────┐
│  Action utilisateur
│  (ex: ajouter membre)
└────────┬────────┘
         │
         ▼
┌──────────────────────┐
│ 1. Sauvegarde locale │
│    (Hive)            │
└────────┬─────────────┘
         │
         ▼
┌──────────────────────┐
│ 2. Si online?        │
└─┬────────────────┬──┘
  │                │
  ▼                ▼
 OUI              NON
  │                │
  ▼                ▼
Upload       En attente
Firebase     Sync auto
  │                │
  ▼                ▼
Synchronisé  (quand online)
```

## Prochaines étapes

1. Créer les écrans de connexion
2. Implémenter le CRUD des membres
3. Ajouter la upload de photos
4. Configurer les notifications push
5. Déployer sur Play Store / App Store

---

**Besoin d'aide?** Consulter les docs complètes:
- [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) - Architecture détaillée
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Configuration Firebase
- [CONVENTIONS.md](CONVENTIONS.md) - Standards de code

**Dernière mise à jour**: Janvier 2026
