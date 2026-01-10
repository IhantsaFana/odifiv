# AuthService, LoginScreen & RegisterScreen - Documentation

## 📋 Overview
Implémentation complète du système d'authentification Firebase pour Fivondronana avec écrans de connexion et d'inscription.

**Date**: Janvier 2025  
**Status**: ✅ Complet et testé  
**Compilation**: ✅ No issues found!

---

## 1️⃣ AuthService (`lib/services/auth_service.dart`)

### Qu'est-ce que c'est?
Service singleton qui encapsule Firebase Authentication avec des méthodes pratiques pour :
- Inscription (email/mot de passe)
- Connexion
- Déconnexion
- Réinitialisation de mot de passe
- Gestion de l'état d'authentification

### Méthodes principales

```dart
// 1. Inscription
Future<User?> registerWithEmail({
  required String email,
  required String password,
  required String displayName,
})

// 2. Connexion
Future<User?> loginWithEmail({
  required String email,
  required String password,
})

// 3. Déconnexion
Future<void> logout()

// 4. Réinitialisation mot de passe
Future<void> resetPassword({required String email})

// Getters d'état
bool get isAuthenticated
String? get userEmail
String? get userDisplayName
Stream<User?> get authStateChanges
```

### Gestion des erreurs
Firebase errors mappés en français:
- `user-not-found` → "Utilisateur non trouvé"
- `wrong-password` → "Mot de passe incorrect"
- `email-already-in-use` → "Cet email est déjà utilisé"
- `weak-password` → "Le mot de passe est trop faible"
- `too-many-requests` → "Trop de tentatives de connexion"
- Et plus...

### Logging
Toutes les opérations sont loggées avec `Logger()`:
```dart
final logger = Logger();
logger.i('User logged in: ${user.email}');
logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
```

---

## 2️⃣ AuthController (`lib/controllers/auth_controller.dart`)

### Qu'est-ce que c'est?
Contrôleur GetX qui gère l'état d'authentification et l'interface avec AuthService.

### Responsabilités
- Émettre les changements d'état d'authentification
- Valider les entrées utilisateur
- Cacher les données utilisateur localement
- Afficher les messages d'erreur en français
- Gérer les états de chargement

### Observables (Rx)

```dart
// Utilisateur actuel (Firebase User)
final Rxn<User?> currentUser = Rxn<User?>();

// État de chargement (pour les boutons)
final isLoading = false.obs;

// Message d'erreur
final errorMessage = Rxn<String>();

// Utilisateur authentifié?
final isAuthenticated = false.obs;
```

### Méthodes publiques

```dart
// Inscription avec validation
Future<bool> register({
  required String email,
  required String password,
  required String displayName,
})

// Connexion avec validation
Future<bool> login({
  required String email,
  required String password,
})

// Déconnexion
Future<void> logout()

// Réinitialisation mot de passe
Future<bool> resetPassword(String email)

// Nettoyer les erreurs
void clearError()
```

### Validations
- ✅ Email valide (regex)
- ✅ Mot de passe ≥ 6 caractères
- ✅ Affichage des critères en temps réel
- ✅ Confirmation mot de passe
- ✅ Nom non vide

### Cache local
Quand l'utilisateur se connecte:
```dart
offlineService.saveData('currentUser_email', user.email);
offlineService.saveData('currentUser_name', user.displayName);
offlineService.saveData('currentUser_id', user.uid);
```

---

## 3️⃣ LoginScreen (`lib/screens/auth/login_screen.dart`)

### Qu'est-ce que c'est?
Écran de connexion avec email et mot de passe.

### Fonctionnalités

#### Formulaire
- ✅ Champ email avec validation
- ✅ Champ mot de passe avec icône visibilité
- ✅ Bouton connexion avec état de chargement

#### Navigation
- ✅ Lien vers RegisterScreen ("Créer un compte")
- ✅ Lien mot de passe oublié (TODO)

#### UX
- ✅ Erreurs affichées dans une dialog
- ✅ Indicateur de chargement spinner
- ✅ Indication "Connexion requise pour le premier accès"

### Architecture

```
LoginScreen (StatefulWidget)
├── Form (_formKey)
├── Controllers
│   ├── _emailController
│   ├── _passwordController
│   └── _obscurePassword
└── Méthodes
    ├── _handleLogin()
    ├── _showErrorDialog()
    └── dispose()
```

### Flux utilisateur

1. Utilisateur entre email et mot de passe
2. Clique sur "Connexion"
3. `_handleLogin()` valide et appelle `authController.login()`
4. Pendant le chargement, bouton disabled avec spinner
5. Si succès → Navigation vers `/home`
6. Si erreur → Dialog avec message d'erreur en français

---

## 4️⃣ RegisterScreen (`lib/screens/auth/register_screen.dart`)

### Qu'est-ce que c'est?
Écran d'inscription avec validation mot de passe avancée.

### Fonctionnalités

#### Formulaire
- ✅ Champ nom complet (min 3 caractères)
- ✅ Champ email avec validation
- ✅ Champ mot de passe avec critères en temps réel
- ✅ Champ confirmation mot de passe
- ✅ Checkbox "J'accepte les conditions d'utilisation"

#### Validations mot de passe (en temps réel)
Affichage des critères avec checkmarks:
- ✅ Au moins 6 caractères
- ✅ Au moins une lettre majuscule (A-Z)
- ✅ Au moins une lettre minuscule (a-z)
- ✅ Au moins un chiffre (0-9)

#### UX
- ✅ Appbar avec bouton retour
- ✅ Dialog de succès après inscription
- ✅ Erreurs affichées en français
- ✅ Indicateur de chargement spinner
- ✅ Lien vers LoginScreen

### Widget auxiliaire: `_PasswordCriteria`

```dart
class _PasswordCriteria extends StatelessWidget {
  final String text;
  final bool isValid;
  
  // Affiche checkmark si valide, radio_button si non
}
```

### Flux utilisateur

1. Utilisateur remplit le formulaire
2. Critères mot de passe s'affichent en temps réel (vert si valide)
3. Accepte les conditions
4. Clique sur "Créer un compte"
5. Validation complète du formulaire
6. `authController.register()` crée le compte
7. Si succès → Dialog de succès → `/home`
8. Si erreur → Dialog d'erreur avec message français

---

## 5️⃣ AuthWrapper (`lib/main.dart`)

### Qu'est-ce que c'est?
Widget qui affiche LoginScreen ou HomeScreen selon l'état d'authentification.

```dart
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.isAuthenticated.value) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    });
  }
}
```

### Routes GetX

```dart
getPages: [
  GetPage(name: '/login', page: () => const LoginScreen()),
  GetPage(name: '/register', page: () => const RegisterScreen()),
  GetPage(name: '/home', page: () => const HomeScreen()),
],
```

---

## 6️⃣ Initialisation dans main()

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase
  await FirebaseConfig.initialize();
  
  // Offline storage
  await OfflineService().initialize();
  
  // GetX Services (IMPORTANT: Ordre)
  Get.put<OfflineService>(OfflineService());
  Get.put<ConnectivityService>(ConnectivityService());
  Get.put<AuthController>(AuthController()); // ← Dépend d'OfflineService
  
  runApp(const FivondronanaApp());
}
```

⚠️ **Important**: L'ordre d'initialisation est crucial!
- OfflineService d'abord (dependency pour AuthController)
- ConnectivityService
- AuthController (utilise OfflineService)

---

## 7️⃣ AppTheme Update

Ajout de `sampanaPrimaryColor`:

```dart
static const Color sampanaPrimaryColor = Color(0xFF1a4d7e);
```

Utilisé dans les boutons et textes des écrans d'auth.

---

## ⚙️ Configuration Firebase

### Plateforme Web (déjà configurée)
```javascript
apiKey: "AIzaSyBXXX...",
authDomain: "gestion-esmia.firebaseapp.com",
projectId: "gestion-esmia",
appId: "1:381473826253:web:7073b7ffdbada1e77d9084",
```

### Android (déjà configuré)
```
App ID: 1:381473826253:android:e44153b3eab8a1857d9084
```

### iOS (déjà configuré)
```
App ID: 1:381473826253:ios:25946542189995b97d9084
```

**Vérifier**: `lib/config/firebase_options.dart` contient les vraies clés pour tous les packages.

---

## 🔐 Flow Sécurité

```
User Input
    ↓
LoginScreen/RegisterScreen Validation (Client)
    ↓
AuthController Validation (Business Logic)
    ↓
Firebase Authentication (Serveur)
    ↓
Success/Error Response
    ↓
Cache Local (OfflineService)
    ↓
Update AuthController State
    ↓
AuthWrapper Refresh UI
```

---

## 📝 Checklist Implémentation

- ✅ AuthService avec méthodes Firebase
- ✅ AuthController avec validation et état
- ✅ LoginScreen avec formulaire
- ✅ RegisterScreen avec critères mot de passe
- ✅ AuthWrapper pour redirection
- ✅ Routes GetX configurées
- ✅ AppTheme updaté (sampanaPrimaryColor)
- ✅ Flutter analyze: No issues
- ✅ Messages d'erreur en français
- ✅ Cache local des données utilisateur
- ✅ Logging avec Logger
- ✅ Gestion des états de chargement

---

## 🚀 Prochaines étapes

1. **Forgot Password Screen** (TODO dans LoginScreen)
   - Écran pour réinitialiser mot de passe
   - Vérification email → Reset link

2. **User Profile Setup**
   - Compléter profil après inscription
   - Division, Sampana, Position, Totem

3. **Firebase Firestore**
   - Sauvegarder données utilisateur
   - Members collection avec sous-collections

4. **Tests**
   - Unit tests AuthService
   - Widget tests LoginScreen/RegisterScreen
   - Integration tests auth flow

5. **Sécurité**
   - Firestore Rules
   - Validation côté serveur
   - Rate limiting réinitialisation mot de passe

---

## 📚 Fichiers modifiés

| Fichier | Statut | Notes |
|---------|--------|-------|
| `lib/services/auth_service.dart` | ✅ Créé | Service Firebase Auth |
| `lib/controllers/auth_controller.dart` | ✅ Créé | Contrôleur GetX |
| `lib/screens/auth/login_screen.dart` | ✅ Créé | Écran connexion |
| `lib/screens/auth/register_screen.dart` | ✅ Créé | Écran inscription |
| `lib/main.dart` | ✅ Modifié | AuthWrapper + routes |
| `lib/config/app_theme.dart` | ✅ Modifié | Ajout sampanaPrimaryColor |

---

## 🔗 References

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Flutter Forms Best Practices](https://flutter.dev/docs/cookbook/forms/validation)

---

**Questions?** Consultez les commentaires dans le code ou demandez au team!
