# 👥 Contributing to Fivondronana

Merci de vouloir contribuer au projet Fivondronana! Ce guide explique comment bien contribuer.

## Code of Conduct

- Respecter tous les contributeurs
- Communication constructive et bienveillante
- Zéro tolérance pour le harcèlement

## Comment contribuer

### Signaler un bug 🐛

1. Vérifier que le bug n'existe pas déjà dans les issues
2. Créer une issue avec le titre descriptif
3. Inclure:
   - Description claire du bug
   - Étapes à reproduire
   - Comportement attendu vs réel
   - Logs/screenshots
   - Version Flutter et OS

**Template:**
```markdown
## Description du bug
...

## Étapes à reproduire
1. 
2. 
3. 

## Comportement attendu
...

## Logs
```

### Proposer une feature 💡

1. Créer une issue avec le tag `enhancement`
2. Décrire:
   - Fonctionnalité souhaitée
   - Cas d'usage
   - Bénéfices
   - Alternatives considérées

### Soumettre du code

#### 1. Fork et branche

```bash
# Fork le repo (une seule fois)
# Puis cloner
git clone https://github.com/YOUR_USERNAME/fivondronana.git
cd fivondronana

# Créer une branche
git checkout -b feature/my-awesome-feature
```

#### 2. Développer

- Suivre les [CONVENTIONS.md](CONVENTIONS.md)
- Écrire des tests unitaires
- Commiter avec des messages clairs

```bash
# Format du commit (Conventional Commits)
git commit -m "feat(auth): add email verification"
git commit -m "fix(members): prevent crash on empty list"
git commit -m "docs: update DEVELOPER_GUIDE"
```

#### 3. Tester localement

```bash
# Formater
dart format lib/ test/

# Analyser
flutter analyze

# Tests
flutter test

# Vérifier sur device/emulator
flutter run
```

#### 4. Pusher et Pull Request

```bash
# Pusher la branche
git push origin feature/my-awesome-feature

# Créer une PR sur GitHub
```

**Template PR:**

```markdown
## Description
Brève description de ce qui a changé

## Type
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation

## Related Issue
Closes #(issue number)

## Testing
- [ ] Unit tests added/updated
- [ ] Manually tested on Android
- [ ] Manually tested on iOS
- [ ] No new warnings

## Screenshots
(if applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] `dart format` applied
- [ ] `flutter analyze` passes
- [ ] Self-reviewed code
- [ ] Comments added for complex logic
- [ ] Tests pass locally
```

## Processus de review

1. **Automatique**
   - Tests passent-ils?
   - Linting/formatting OK?

2. **Humain**
   - Code review par 1+ maintainer
   - Discussions/demandes de changement?

3. **Merge**
   - Squash commits si nécessaire
   - Merge dans develop
   - Delete la branche

## Directives de code

### Style

```dart
// ✅ Bon
class MemberService extends GetxService {
  Future<void> createMember(Member member) async {
    validateMember(member);
    await _firestore.collection('members').add(member.toJson());
  }
}

// ❌ Mauvais
class member_service{
  void create_member(m){
    _fs.col('m').a(m.toJ());
  }
}
```

### Tests

```dart
// ✅ Ajouter des tests pour chaque nouvelle feature
void main() {
  group('MemberController', () {
    test('should add member successfully', () {
      // ...
    });

    test('should validate member data', () {
      // ...
    });
  });
}
```

### Documentation

```dart
/// Crée un nouveau membre
///
/// Valide les données avant création.
/// Sauvegarde en Firestore et Hive pour offline.
///
/// Parameters:
///   member: L'instance Member à créer
///
/// Throws:
///   ValidationException: si données invalides
///   FirebaseException: si sauvegarde échoue
///
/// Returns: L'ID du membre créé
Future<String> createMember(Member member) async {
  validateMember(member);
  return await _saveToFirebase(member);
}
```

## Structure des PR optimale

```
1 commit = 1 changement logique
│
├── feat: ajout d'une feature
│   └── Changements reliés
│
├── fix: correction
│   └── Uniquement le fix, pas de refactor
│
├── docs: documentation
│   └── Modifications documentation/comments
│
└── refactor: refactorisation
    └── Aucun changement de comportement
```

## Exemple workflow complet

```bash
# 1. Fork et clone
git clone https://github.com/YOUR_USERNAME/fivondronana.git
cd fivondronana

# 2. Créer branche
git checkout -b feature/member-validation

# 3. Développer
# ... modifier les fichiers ...

# 4. Tests et linting
flutter analyze
dart format lib/ test/
flutter test

# 5. Commit
git add .
git commit -m "feat(members): add comprehensive validation"

# 6. Push
git push origin feature/member-validation

# 7. Créer PR sur GitHub
# ... remplir le template ...

# 8. Attendre review et merge
```

## Bonnes pratiques

### ✅ À faire

- [ ] Petites PR (< 400 lignes de code)
- [ ] Une feature par PR
- [ ] Commits atomiques
- [ ] Messages de commit descriptifs
- [ ] Tests pour chaque changement
- [ ] Respecter les conventions
- [ ] Demander de l'aide si incertain

### ❌ À ne pas faire

- [ ] Gigantesques PR (> 1000 lignes)
- [ ] Mix de features différentes
- [ ] Commits "wip" ou "fix stuff"
- [ ] Code formaté différemment
- [ ] Zéro tests
- [ ] Ignorer les retours de review
- [ ] Pusher directement sur main/develop

## Environnement de développement recommandé

### IDE

- **VS Code**
  - Extensions: Flutter, Dart, GetX, Firebase
  
- **Android Studio**
  - Intégration native Flutter

### Git Tools

```bash
# Configuration initiale
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Pre-commit hook (optionnel)
# Pour formater automatiquement avant commit
```

### Commandes utiles

```bash
# Voir les fichiers changés
git status

# Diff détaillé
git diff

# Logs avec graph
git log --oneline --graph --all

# Rebase interactif (before PR)
git rebase -i main
```

## Ressources

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [How to Write Good Commit Messages](https://tbaggery.com/write-small-commits.html)

## Questions?

- Ouvrir une discussion dans GitHub Discussions
- Contacter les mainteneurs
- Consulter les docs du projet

---

**Merci pour votre contribution!** 🙏

Version: 1.0.0
Dernière mise à jour: Janvier 2026
