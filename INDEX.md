# 📑 Index Documentation - Fivondronana

Bienvenue! Voici un guide pour naviguer dans la documentation du projet.

---

## 🚀 Commencer en 5 minutes

**👉 Commencez ici:** [QUICKSTART.md](QUICKSTART.md)

- Installation rapide
- Commandes essentielles
- Troubleshooting basique

**Temps estimé:** 5 minutes

---

## 📚 Documentation Complète

### 1. 🎯 Guide Développeur - Architecture
**Fichier:** [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)

Pour comprendre l'architecture globale du projet.

**Contient:**
- Vue d'ensemble du projet
- Architecture en couches
- Structure des dossiers
- Modèles de données
- Services et fonctionnalités
- Workflow développement
- Déploiement

**Pour:** Tous les développeurs  
**Temps:** 20-30 minutes

---

### 2. 🔥 Configuration Firebase
**Fichier:** [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

Guide détaillé pour configurer Firebase.

**Contient:**
- Créer un projet Firebase
- Ajouter Android/iOS/Web
- Activer Authentication
- Configurer Firestore Database
- Cloud Storage
- Règles de sécurité
- Test de configuration

**Pour:** Devs et DevOps  
**Temps:** 30-45 minutes  
**Importance:** ⚠️ **OBLIGATOIRE**

---

### 3. 📝 Conventions de Code
**Fichier:** [CONVENTIONS.md](CONVENTIONS.md)

Standards de code et conventions du projet.

**Contient:**
- Convention des commits Git
- Stratégie de branches
- Nommage Dart
- Structure des classes
- Tests unitaires
- Gestion d'état GetX
- Styles et thèmes
- Workflow Pull Request

**Pour:** Tous les développeurs  
**Temps:** 15-20 minutes  
**Important:** À lire avant le premier commit

---

### 4. 👥 Guide Contributeurs
**Fichier:** [CONTRIBUTING.md](CONTRIBUTING.md)

Comment contribuer au projet.

**Contient:**
- Code of Conduct
- Signaler les bugs
- Proposer des features
- Processus de code review
- Directives de code
- Workflow complet

**Pour:** Contributeurs externes  
**Temps:** 15 minutes

---

### 5. ✅ Configuration Complète
**Fichier:** [SETUP_COMPLETE.md](SETUP_COMPLETE.md)

Résumé de la configuration effectuée.

**Contient:**
- Checklist configuration
- Points clés
- Prochaines étapes
- Configurations ajustées
- Documentation créée

**Pour:** Chefs de projet  
**Temps:** 5-10 minutes

---

## 🗺️ Roadmap de Lecture

### Pour débuter rapidement

```
1. QUICKSTART.md (5 min)
   ↓
2. DEVELOPER_GUIDE.md (20 min)
   ↓
3. FIREBASE_SETUP.md (30 min) ← OBLIGATOIRE
   ↓
4. CONVENTIONS.md (15 min) ← Avant le premier code
   ↓
🚀 Prêt à coder!
```

### Pour les contributeurs externes

```
1. QUICKSTART.md (5 min)
   ↓
2. CONTRIBUTING.md (15 min)
   ↓
3. CONVENTIONS.md (15 min)
   ↓
4. Créer une branche et commencer
```

### Pour les chefs de projet

```
1. README.md (projet) (5 min)
   ↓
2. SETUP_COMPLETE.md (10 min)
   ↓
3. DEVELOPER_GUIDE.md (20 min - optionnel)
```

---

## 📂 Structure Fichiers Créés

### Configuration
```
lib/config/
├── firebase_config.dart      → Initialisation Firebase
├── app_theme.dart            → Thème et styles
└── app_constants.dart        → Constantes métier
```

### Modèles
```
lib/models/
├── member_model.dart         → Entité Scout
└── fivondronana_model.dart   → Entité Structure admin
```

### Services
```
lib/services/
├── offline_service.dart      → Gestion Hive (local)
└── connectivity_service.dart → Gestion réseau
```

### Structure Dossiers (à remplir)
```
lib/
├── controllers/              → GetX Controllers
├── screens/                  → Pages de l'app
├── widgets/                  → Composants réutilisables
└── utils/                    → Utilitaires
```

### Assets
```
assets/
├── images/                   → Images app
└── icons/                    → Icônes
```

### Configuration Fichiers
```
.env.example                  → Variables d'env template
pubspec.yaml                  → Mis à jour avec dépendances
```

---

## 🎯 Points de Départ par Profil

### 👨‍💻 Développeur Flutter Débutant

1. Lire [QUICKSTART.md](QUICKSTART.md)
2. Lire [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#architecture)
3. Lire [CONVENTIONS.md](CONVENTIONS.md#structure-des-classes)
4. Créer une branche et démarrer

### 👨‍💼 Développeur Expérimenté

1. Parcourir [QUICKSTART.md](QUICKSTART.md)
2. Configurer Firebase ([FIREBASE_SETUP.md](FIREBASE_SETUP.md))
3. Lire [CONVENTIONS.md](CONVENTIONS.md) rapidement
4. Commencer à développer

### 🔧 DevOps/Infrastructure

1. [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Configuration Firebase
2. [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#déploiement) - Déploiement
3. [CONVENTIONS.md](CONVENTIONS.md#workflow-pull-request) - CI/CD

### 📊 Chef de Projet

1. [README.md](README.md) - Vue projet
2. [SETUP_COMPLETE.md](SETUP_COMPLETE.md) - Statut setup
3. [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) - Architecture (optionnel)

---

## 💡 Décisions Architecturales Clés

### Stack Technologique

- **Framework:** Flutter (multi-plateforme)
- **Backend:** Firebase (Auth + Firestore + Storage)
- **State Management:** GetX (simple et puissant)
- **Local Storage:** Hive (NoSQL, offline-first)

### Architecture Layered

```
UI Layer (Screens)
    ↓
State Management (GetX Controllers)
    ↓
Services (Logique métier)
    ↓
Data Layer (Firebase + Hive)
```

### Semi-Offline

L'app fonctionne même sans internet:
1. Données sauvegardées localement
2. Sync automatique quand connexion revient
3. Pas de perte de données

---

## 🔑 Constantes Métier

Voir [lib/config/app_constants.dart](lib/config/app_constants.dart)

### Hiérarchie SAMPATI

```
Foibe (National)
  ↓
Faritany (Province)
  ↓
Faritra (Région)
  ↓
Fivondronana (Zone)
  ↓
Sampana (Groupe)
```

### Divisions & Sampana

**Mpanazava (Filles):**
- Voronkely (6-12) - Jaune
- Mpanazova (12-16) - Vert
- Afo (+16) - Rouge

**Tily (Garçons):**
- Lovitao (6-12) - Jaune
- Tily (12-16) - Vert
- Mpiandalana (16-21) - Rouge
- Menafify (+21) - Grenat

---

## ⚙️ Configuration Effectuée

✅ Dépendances Flutter (15 packages)  
✅ Structure dossiers (7 dossiers)  
✅ Fichiers configuration (3 fichiers)  
✅ Modèles de données (2 modèles)  
✅ Services essentiels (2 services)  
✅ Documentation complète (5 docs)  

---

## 🚀 Prochaines Étapes

### Phase 1: Setup Firebase (OBLIGATOIRE)
```bash
flutterfire configure
# ou configuration manuelle (voir FIREBASE_SETUP.md)
```

### Phase 2: Implémentation Services
- [ ] AuthService
- [ ] MemberService
- [ ] SyncService

### Phase 3: Développement Features
- [ ] Authentication screens
- [ ] Member management
- [ ] Photo upload

### Phase 4: Tests & Déploiement
- [ ] Unit tests
- [ ] Integration tests
- [ ] Deploy à Play Store/App Store

---

## 📞 Questions Fréquentes

### "Par où commencer?"
→ Lire [QUICKSTART.md](QUICKSTART.md)

### "Comment fonctionne l'architecture?"
→ Voir [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#architecture)

### "Quelles conventions respecter?"
→ Consulter [CONVENTIONS.md](CONVENTIONS.md)

### "Comment configurer Firebase?"
→ Suivre [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### "Comment contribuer?"
→ Lire [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🌐 Ressources Externes

- [Flutter Official Docs](https://flutter.dev/docs)
- [Firebase Flutter Guide](https://firebase.flutter.dev/)
- [GetX Documentation](https://github.com/jonataslaw/getx/wiki)
- [Hive Database](https://docs.hivedb.dev/)
- [Dart Language Guide](https://dart.dev/guides/language/language-tour)

---

## 📊 Statut Projet

**Configuration:** ✅ 100% complète  
**Documentation:** ✅ 100% complète  
**Prêt pour:** 🚀 Développement features  

---

## 👨‍💼 Contact & Support

- 📧 Email: [project contact]
- 💬 Discussions: GitHub Discussions
- 🐛 Bugs: GitHub Issues
- 📝 PR: GitHub Pull Requests

---

## 📄 Fichiers Documentation

| Fichier | Taille | Temps lecture | Priorité |
|---------|--------|---------------|----------|
| [QUICKSTART.md](QUICKSTART.md) | 2 min | 5 min | 🔴 HAUTE |
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | 5 min | 20 min | 🔴 HAUTE |
| [FIREBASE_SETUP.md](FIREBASE_SETUP.md) | 5 min | 30 min | 🔴 HAUTE |
| [CONVENTIONS.md](CONVENTIONS.md) | 4 min | 15 min | 🟠 MOYENNE |
| [CONTRIBUTING.md](CONTRIBUTING.md) | 3 min | 15 min | 🟡 BASSE |
| [SETUP_COMPLETE.md](SETUP_COMPLETE.md) | 2 min | 10 min | 🟡 BASSE |

---

**Navigation:** Vous êtes dans INDEX.md  
**Version:** 1.0.0  
**Dernière mise à jour:** Janvier 2026

👉 **Prêt à commencer?** [Aller au QUICKSTART](QUICKSTART.md)
