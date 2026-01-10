# 🧪 Firestore Rules Testing Guide

## Overview

Comprehensive guide for testing Firestore Security Rules locally and in production.

**Project**: Fivondronana (`gestion-esmia`)  
**Status**: Ready for testing

---

## 📋 Test Scenarios

### 1. ✅ User Registration & Profile Creation

**Scenario**: New user creates their profile

**Test Steps**:
```dart
// 1. User registers via AuthService
final user = await authService.registerWithEmail(
  email: 'jean@test.com',
  password: 'Test1234',
  displayName: 'Jean Dupont',
);

// 2. Create user profile document
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .set({
    'email': 'jean@test.com',
    'displayName': 'Jean Dupont',
    'role': 'member',
    'division': 'voronkely',
    'createdAt': FieldValue.serverTimestamp(),
  });
```

**Expected Result**: ✅ Success
- User document created
- Role defaults to 'member'
- Timestamp server-set

**Test Permission**: 
- Rule: `allow create: if isAuthenticated() && isOwner(userId)`
- Should: ✅ Allow
- Should NOT allow other users to create this doc

---

### 2. ✅ User Can Read Own Profile

**Test Steps**:
```dart
// User reads their own profile
final doc = await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .get();

print('Email: ${doc.data()!['email']}');
```

**Expected Result**: ✅ Success
- User can read their own profile
- Admin can read any profile

**Rule**: `allow read: if isOwner(userId) || isAdmin(request.auth.uid)`

---

### 3. ❌ User Cannot Read Other Users Profile

**Test Steps**:
```dart
// User tries to read another user's profile
final doc = await FirebaseFirestore.instance
  .collection('users')
  .doc('other-user-id')
  .get();
```

**Expected Result**: ❌ Failure (Permission denied)

**Rule**: `allow read: if isOwner(userId) || isAdmin(request.auth.uid)`

---

### 4. ✅ User Cannot Elevate Own Role

**Test Steps**:
```dart
// User tries to change their role to admin
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .update({
    'role': 'admin',  // ← Attempting privilege escalation
  });
```

**Expected Result**: ❌ Failure (Permission denied)

**Rule**: 
```javascript
allow update: if isAuthenticated() && (
  isOwner(userId) && request.resource.data.role == resource.data.role
)
```

---

### 5. ✅ Admin Can Assign Roles

**Test Steps** (as admin):
```dart
// Admin assigns validator role to user
await FirebaseFirestore.instance
  .collection('users')
  .doc('other-user-id')
  .update({
    'role': 'validator',
    'updatedAt': FieldValue.serverTimestamp(),
  });
```

**Expected Result**: ✅ Success (if caller is admin)

**Rule**: 
```javascript
allow update: if isAuthenticated() && (
  isOwner(userId) || isAdmin(request.auth.uid)
)
```

---

### 6. ✅ User Can Create Members

**Test Steps**:
```dart
// User creates a scout member record
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .collection('members')
  .doc()
  .set({
    'firstName': 'Jean',
    'lastName': 'Dupont',
    'totem': 'Renard',
    'division': 'voronkely',
    'currentSampana': 'Sampana 1',
    'position': 'Leader',
    'createdAt': FieldValue.serverTimestamp(),
  });
```

**Expected Result**: ✅ Success

**Validations**:
- ✅ User owns parent profile
- ✅ Division is valid: ['voronkely', 'mpanazova', 'afo', 'menafify']
- ✅ All required fields present

---

### 7. ❌ Invalid Division Rejected

**Test Steps**:
```dart
// Try to create member with invalid division
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .collection('members')
  .doc()
  .set({
    'firstName': 'Test',
    'lastName': 'User',
    'division': 'invalid-division',  // ← Not in allowed list
    // ... other fields
  });
```

**Expected Result**: ❌ Failure (Field validation failed)

**Rule**:
```javascript
request.resource.data.division in ['voronkely', 'mpanazova', 'afo', 'menafify']
```

---

### 8. ✅ Only Validators Can Create Events

**Test Steps** (as validator):
```dart
// Validator creates an event
await FirebaseFirestore.instance
  .collection('fivondronana')
  .doc('fivondronana-1')
  .collection('events')
  .doc()
  .set({
    'title': 'Scout Gathering',
    'description': 'Monthly gathering',
    'date': Timestamp.fromDate(DateTime.now()),
    'location': 'Scout Hall',
    'createdAt': FieldValue.serverTimestamp(),
  });
```

**Expected Result**: ✅ Success (if caller is validator or admin)

**Rule**:
```javascript
allow create: if isAuthenticated() && isValidator(request.auth.uid)
```

---

### 9. ❌ Member Cannot Create Events

**Test Steps** (as regular member):
```dart
// Member tries to create event
await FirebaseFirestore.instance
  .collection('fivondronana')
  .doc('fivondronana-1')
  .collection('events')
  .doc()
  .set({
    'title': 'My Event',
    // ... fields
  });
```

**Expected Result**: ❌ Failure (Permission denied)

---

### 10. ✅ Offline Sync Data Protected

**Test Steps**:
```dart
// User queues offline change for sync
await FirebaseFirestore.instance
  .collection('offline_sync')
  .doc(user.uid)
  .collection('changes')
  .doc()
  .set({
    'operation': 'create',
    'collection': 'users',
    'data': { 'email': 'new@test.com' },
    'timestamp': FieldValue.serverTimestamp(),
  });
```

**Expected Result**: ✅ Success

**Security**: Only owner can read/write their offline sync queue

---

## 🔧 Testing with Firebase Emulator

### Setup & Start Emulator

```bash
# 1. Install Firebase Emulator Suite
npm install -g firebase-tools

# 2. Start emulator (from project directory)
cd /home/oeka/Documents/projects/fivondronana
firebase emulators:start --only firestore,auth

# 3. Output will show:
# Firestore Emulator running on 127.0.0.1:8080
# Auth Emulator running on 127.0.0.1:9099
```

### Configure Flutter App to Use Emulator

```dart
// In main.dart or test setup:
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only in development/testing
  if (kDebugMode) {
    try {
      // Use Firebase Emulator
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    } catch (e) {
      // Already connected to emulator
    }
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FivondronanaApp());
}
```

### Run Tests Against Emulator

```bash
# Terminal 1: Start emulator
firebase emulators:start --only firestore,auth

# Terminal 2: Run tests
flutter test --verbose

# Or run specific test file:
flutter test test/auth_test.dart

# View Emulator UI
# Open: http://localhost:4000
```

---

## 📝 Dart Test Examples

### Test User Cannot Access Other Profiles

```dart
void main() {
  group('Firestore Rules - Users Collection', () {
    test('User can read own profile', () async {
      final db = FirebaseFirestore.instance;
      
      // Setup: Create test user
      final user = await createTestUser('user1@test.com');
      
      // Expect: User can read own profile
      expect(
        () => db.collection('users').doc(user.uid).get(),
        returnsNormally,
      );
    });

    test('User cannot read other profiles', () async {
      final db = FirebaseFirestore.instance;
      
      // Setup: Create two test users
      final user1 = await createTestUser('user1@test.com');
      final user2 = await createTestUser('user2@test.com');
      
      // Authenticate as user1
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'user1@test.com',
        password: 'Test1234',
      );
      
      // Expect: User1 cannot read user2's profile
      expect(
        () => db.collection('users').doc(user2.uid).get(),
        throwsA(isA<FirebaseException>()),
      );
    });

    test('User cannot elevate own role', () async {
      final db = FirebaseFirestore.instance;
      final user = await createTestUser('user@test.com');
      
      // Try to change role
      expect(
        () => db.collection('users').doc(user.uid).update({
          'role': 'admin',
        }),
        throwsA(isA<FirebaseException>()),
      );
    });
  });
}
```

---

## 🚀 Deployment Testing

### Pre-Deployment Checklist

```bash
# 1. Syntax validation
firebase deploy --only firestore:rules --dry-run

# 2. Check for errors
firebase deploy --only firestore:rules --dry-run 2>&1 | grep -i error

# 3. View current rules
firebase firestore:get-rules

# 4. Create backup before deploy
firebase firestore:get-rules > firestore.rules.backup.$(date +%s)
```

### Deploy Steps

```bash
# 1. Validate locally with emulator
firebase emulators:start --only firestore

# 2. Run tests
flutter test

# 3. Deploy to production
./deploy-rules.sh

# Or manually:
firebase deploy --only firestore:rules
```

### Post-Deployment Verification

```bash
# 1. Check deployment status
firebase firestore:get-rules | head -20

# 2. Monitor for errors
firebase functions:logs --follow

# 3. Check user feedback
# - Monitor error logs in app
# - Check Firestore usage patterns
```

---

## 🐛 Troubleshooting

### Issue: "Missing or insufficient permissions"

**Test**:
```dart
// 1. Check user is authenticated
print('Current user: ${FirebaseAuth.instance.currentUser?.uid}');

// 2. Check user document exists
final userDoc = await FirebaseFirestore.instance
  .collection('users')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .get();
print('User doc exists: ${userDoc.exists}');

// 3. Check user role
print('User role: ${userDoc.data()?['role']}');
```

### Issue: Operation allowed when should be denied

**Debug**:
```javascript
// Add logging to rules:
allow read: if request.auth.uid != null {
  // Log authentication
  debug('User accessing collection', request.auth.uid);
};
```

### Issue: Invalid data type error

**Check**:
```dart
// Ensure types match rule validation
final data = {
  'email': 'test@test.com',        // ← string
  'number': 42,                      // ← int (not string!)
  'createdAt': FieldValue.serverTimestamp(), // ← timestamp
};

// NOT:
final data = {
  'email': 'test@test.com',
  'number': '42',  // ← Wrong! Should be int
};
```

---

## 📊 Test Coverage Matrix

| Feature | Emulator | Staging | Production |
|---------|----------|---------|------------|
| User CRUD | ✅ | ✅ | ✅ |
| Role-based access | ✅ | ✅ | ✅ |
| Member sub-collection | ✅ | ✅ | ✅ |
| Event creation | ✅ | ✅ | ✅ |
| Offline sync | ✅ | ✅ | ✅ |
| Audit logging | ✅ | ✅ | ✅ |

---

## ✅ Final Checklist

Before deploying to production:

- [ ] All tests pass locally
- [ ] Tested with Firebase Emulator
- [ ] Dry-run deployment succeeds
- [ ] Rules syntax validated
- [ ] Role-based access verified
- [ ] Data validation tested
- [ ] Error handling tested
- [ ] Backup of current rules created
- [ ] Team reviewed changes
- [ ] Rollback plan documented

---

## 📚 References

- [Firebase Rules Testing Guide](https://firebase.google.com/docs/firestore/security/rules-query-indexing)
- [Emulator Suite Documentation](https://firebase.google.com/docs/emulator-suite)
- [Best Practices](https://firebase.google.com/docs/firestore/security/rules-patterns)

---

**Status**: ✅ Ready for testing!
