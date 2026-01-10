# 📋 Conventions de Développement

Ce guide explique les conventions utilisées dans le projet Fivondronana.

## 📝 Convention des Commits Git

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: Nouvelle fonctionnalité
- **fix**: Correction de bug
- **docs**: Documentation
- **style**: Formatage, ponctuation, oubli semicolon
- **refactor**: Refactorisation de code
- **perf**: Amélioration de performance
- **test**: Ajout de tests
- **chore**: Build, dépendances, configuration
- **ci**: Configuration CI/CD

### Exemples

```bash
# Nouvelle feature
git commit -m "feat(auth): add email authentication with Firebase"

# Bug fix
git commit -m "fix(members): resolve crash when loading empty list"

# Documentation
git commit -m "docs: update DEVELOPER_GUIDE.md with offline sync example"

# Refactoring
git commit -m "refactor(services): extract member validation logic"

# Avec description
git commit -m "feat(sync): implement offline data synchronization

- Add pending queue for offline operations
- Sync data when connection is restored
- Show sync status indicator in UI

Closes #123"
```

## 🌳 Stratégie de Branches

```
main                    # Production
  ├── develop          # Développement
  │   ├── feature/auth-*
  │   ├── feature/members-*
  │   ├── feature/offline-*
  │   ├── bugfix/*
  │   └── hotfix/*
  │
  └── release-*        # Release branches
```

### Nommage des branches

```
feature/<feature-name>      # Nouvelle fonctionnalité
bugfix/<bug-name>          # Correction de bug
hotfix/<issue-name>        # Fix urgent sur main
refactor/<scope>           # Refactorisation
docs/<doc-name>            # Documentation
chore/<task-name>          # Maintenance
```

### Exemples

```bash
git checkout -b feature/member-form
git checkout -b bugfix/sync-crash
git checkout -b hotfix/auth-token-expiry
```

## 📂 Structure des Fichiers Dart

### Architecture des dossiers

```
lib/
├── config/              # Configuration globale
├── models/              # Entités métier
├── services/            # Logique métier
├── controllers/         # GetX controllers (état)
├── screens/             # Pages/Écrans
├── widgets/             # Composants réutilisables
├── utils/               # Utilitaires (validators, formatters)
└── main.dart
```

### Fichier par dossier

```
/lib/services/member_service.dart
/lib/models/member_model.dart
/lib/controllers/member_controller.dart
/lib/screens/members/members_list_screen.dart
/lib/screens/members/member_detail_screen.dart
/lib/widgets/cards/member_card.dart
```

## 📖 Convention de Nommage Dart

### Classes et Types

```dart
// PascalCase pour les classes
class UserService { }
class MemberController extends GetxController { }

// Interfaces et mixins
abstract class Repository { }
mixin Validatable { }

// Enums
enum MemberDivision { mpanazava, tily }
enum SampanaColor { mavo, maitso, mena, grenat }
```

### Variables et Fonctions

```dart
// camelCase pour les variables
String firstName = '';
int memberCount = 0;
bool isOnline = true;

// camelCase pour les fonctions
void fetchMembers() { }
Future<void> saveData() async { }

// Private (underscore prefix)
String _privateField = '';
void _privateMethod() { }

// Constants
const String appName = 'Fivondronana';
const int maxMembersPerGroup = 30;
```

### Paramètres nommés

```dart
// Utiliser required pour les paramètres obligatoires
void createMember({
  required String firstName,
  required String lastName,
  String? totem,
}) { }

// Appel
createMember(
  firstName: 'John',
  lastName: 'Doe',
  totem: 'Lion',
);
```

## 📐 Structure des Classes

```dart
class MemberController extends GetxController {
  // 1. Variables statiques
  static const String _tag = 'MemberController';

  // 2. Services et dépendances
  final _memberService = Get.find<MemberService>();
  final _offlineService = OfflineService();

  // 3. Variables réactives GetX
  final members = <Member>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  // 4. Getters
  bool get isEmpty => members.isEmpty;
  int get count => members.length;

  // 5. Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    _initListeners();
    _loadMembers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 6. Méthodes publiques
  Future<void> addMember(Member member) async {
    isLoading.value = true;
    try {
      await _memberService.create(member);
      members.add(member);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 7. Méthodes privées
  void _initListeners() {
    // Logic...
  }

  Future<void> _loadMembers() async {
    // Logic...
  }
}
```

## 🧪 Tests Unitaires

### Naming convention pour les tests

```dart
// test/services/member_service_test.dart
void main() {
  group('MemberService', () {
    test('should create member successfully', () {
      // Arrange
      final member = Member(...);
      
      // Act
      final result = service.create(member);
      
      // Assert
      expect(result, isNotNull);
    });

    test('should throw error on invalid member', () {
      // Arrange
      final invalidMember = Member(...);
      
      // Act & Assert
      expect(
        () => service.create(invalidMember),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
```

## 📊 Gestion d'État avec GetX

### Pattern simple

```dart
class Counter extends GetxController {
  final count = 0.obs;
  
  void increment() => count++;
  void decrement() => count--;
}

// Dans le widget
class CounterWidget extends StatelessWidget {
  final counter = Get.put(Counter());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('${counter.count}'));
  }
}
```

### Pattern avec GetxController

```dart
class MemberListController extends GetxController {
  final members = <Member>[].obs;
  final selectedMember = Rxn<Member>();
  final isLoading = false.obs;

  void selectMember(Member member) {
    selectedMember.value = member;
  }

  Future<void> loadMembers() async {
    isLoading.value = true;
    try {
      final data = await _memberService.getAll();
      members.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
```

## 🎨 Styles et Thèmes

### Usage du thème global

```dart
// ✅ Bon
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
)

// ❌ Mauvais
Text(
  'Hello',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

### Couleurs personnalisées

```dart
// ✅ Bon (utiliser AppTheme.dart)
Color sampanaColor = AppTheme.voronkelyColor;

// ❌ Mauvais
Color color = Color(0xFFFFD700);
```

## 📝 Documentation du Code

### Commentaires au-dessus des fonctions

```dart
/// Crée un nouveau membre dans le système
///
/// Cette fonction valide les données et les sauvegarde
/// en base de données locale puis synchronise avec Firebase.
/// 
/// Parameters:
///   - member: L'instance Member à créer
///
/// Throws:
///   - ValidationException si les données sont invalides
///   - FirebaseException si la sauvegarde échoue
///
/// Returns: L'ID du membre créé
Future<String> createMember(Member member) async {
  // ...
}
```

### Commentaires en ligne

```dart
// ✅ Bon
// Vérifier que l'email n'existe pas déjà
if (await _userExists(email)) {
  throw UserAlreadyExistsException();
}

// ❌ Mauvais
// i++
i++;
```

## 🔄 Workflow Pull Request

1. **Créer une branche**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Développer la feature**
   - Commit reguliers avec messages clairs
   - Tests unitaires

3. **Préparer la PR**
   ```bash
   # Formater le code
   dart format lib/
   
   # Analyser
   flutter analyze
   
   # Tests
   flutter test
   ```

4. **Pusher la branche**
   ```bash
   git push origin feature/my-feature
   ```

5. **Créer la Pull Request**
   - Template de PR:
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   
   ## Testing
   - [ ] Unit tests added/updated
   - [ ] Manually tested
   
   ## Screenshots
   (if applicable)
   
   ## Checklist
   - [ ] Code formatted with `dart format`
   - [ ] `flutter analyze` passes
   - [ ] No console warnings
   ```

## 🚀 Linting et Formatting

### Configurer dans VS Code

Ajouter à `.vscode/settings.json`:

```json
{
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

### Commands

```bash
# Formater tous les fichiers
dart format lib/ test/

# Analyser le code
flutter analyze

# Vérifier les tests
flutter test
```

---

## 📚 Ressources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [GetX Documentation](https://github.com/jonataslaw/getx/wiki)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Version**: 1.0.0
**Dernière mise à jour**: Janvier 2026
