# 🚀 Firestore Rules - Quick Start

## 📋 What You Need to Know

Firestore Security Rules configure **who can access what data**.

**Project**: `gestion-esmia`  
**Status**: Ready to deploy  
**Time to deploy**: ~5 minutes

---

## 🎯 Quick Deploy (5 minutes)

### Option 1: Automated Script (Recommended)

```bash
cd /home/oeka/Documents/projects/fivondronana
./deploy-rules.sh
```

This script will:
1. ✅ Validate syntax
2. ✅ Show what will be deployed
3. ✅ Ask for confirmation
4. ✅ Deploy to Firebase
5. ✅ Show success message

### Option 2: Firebase CLI

```bash
# Install Firebase CLI (one-time)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy
firebase deploy --only firestore:rules

# Verify
firebase firestore:get-rules
```

### Option 3: Firebase Console (Manual)

1. Open: https://console.firebase.google.com/project/gestion-esmia/firestore/rules
2. Copy content from `firestore.rules` file
3. Paste into Rules editor
4. Click **"Publish"**

---

## 🔑 What Rules Do

| User Type | Can Do | Cannot Do |
|-----------|--------|-----------|
| **Member** (default) | Read own profile, Create members, Create activities | Read others, Create events, Delete users |
| **Validator** | + Create events, Create sampana, View audit logs | Delete users, Assign roles |
| **Admin** | Everything | Undefined (can do all) |

---

## 🔒 Key Rules

### ✅ Users can read their own profile
```javascript
match /users/{userId} {
  allow read: if request.auth.uid == userId;
}
```

### ❌ Users cannot read others' profiles
```javascript
// Only you can read your profile
// Or admin can read any profile
```

### ✅ Users create own members
```javascript
match /users/{userId}/members/{memberId} {
  allow create: if request.auth.uid == userId;
}
```

### ✅ Only validators can create events
```javascript
match /fivondronana/{fivondronanaId}/events/{eventId} {
  allow create: if isValidator(request.auth.uid);
}
```

### ✅ Admin has full control
```javascript
allow delete: if isAdmin(request.auth.uid);
```

---

## 📚 Collections Protected

| Collection | Owner | Read | Write | Delete |
|----------|-------|------|-------|--------|
| `users/` | Self | Self+Admin | Self+Admin | Admin |
| `users/{id}/members/` | User | User+Admin | User | User+Admin |
| `fivondronana/` | System | All | Admin | Admin |
| `fivondronana/{id}/events/` | System | All | Validator+ | Admin |
| `offline_sync/` | User | User | User | User+Admin |
| `audit_log/` | System | Validator+ | None | Admin |

---

## 🧪 Test Before Deploying

### Using Emulator (Recommended)

```bash
# 1. Start emulator
firebase emulators:start --only firestore,auth

# 2. In another terminal, run tests
flutter test

# 3. View Emulator UI
# Open: http://localhost:4000
```

### Quick Manual Test

1. Deploy rules
2. Create test account in app
3. Try to read own profile → ✅ Should work
4. Try to read another user's profile → ❌ Should fail
5. Try to create event as member → ❌ Should fail
6. Make account validator, try again → ✅ Should work

---

## 📋 Rules File Breakdown

### Helper Functions
```javascript
function isAuthenticated() {
  return request.auth != null;
}

function isOwner(userId) {
  return request.auth.uid == userId;
}

function isAdmin(userId) {
  return get(/databases/$(database)/documents/users/$(userId))
    .data.role == 'admin';
}

function isValidator(userId) {
  return get(/databases/$(database)/documents/users/$(userId))
    .data.role in ['admin', 'validator'];
}
```

### Default Deny
```javascript
// At the end of rules:
match /{document=**} {
  allow read, write: if false;  // Deny all by default
}
```

---

## 🔄 Update Workflow

When changing rules:

```bash
# 1. Edit firestore.rules
# 2. Test locally
firebase emulators:start --only firestore

# 3. Run tests
flutter test

# 4. Review changes
git diff firestore.rules

# 5. Deploy
./deploy-rules.sh

# 6. Verify
firebase firestore:get-rules
```

---

## 🚨 Common Issues

### "Permission denied"
- Check user is authenticated
- Verify user document exists
- Check user has required role
- Review rule conditions

### Rule changes not working
- Browser cache? → Clear cache + logout
- Still not working? → Wait 5 mins for propagation
- Check rules deployed? → `firebase firestore:get-rules`

### Need to rollback
```bash
# Restore from backup
cp firestore.rules.backup.XXXXX firestore.rules
firebase deploy --only firestore:rules
```

---

## 📞 Support

| Need | File |
|------|------|
| Deep technical details | `docs/FIRESTORE_RULES_GUIDE.md` |
| Testing strategies | `docs/FIRESTORE_TESTING.md` |
| Implementation overview | `FIRESTORE_COMPLETE.md` |
| Quick reference | This file |

---

## ✅ Pre-Deployment Checklist

- [ ] Read through `firestore.rules`
- [ ] Understand role-based access
- [ ] Test locally with emulator
- [ ] Review test scenarios
- [ ] Create backup: `cp firestore.rules firestore.rules.backup`
- [ ] Deploy: `./deploy-rules.sh`
- [ ] Verify in Firebase Console
- [ ] Test with actual app

---

## 🎯 Next: How to Use in Flutter

After deploying rules, your app will automatically enforce them:

```dart
// This will work (user owns their profile)
await db.collection('users').doc(userId).get(); // ✅

// This will fail (user doesn't own other profile)
await db.collection('users').doc('other-id').get(); // ❌ Permission denied

// This will work (validators can create)
if (user.role == 'validator') {
  await db.collection('fivondronana').doc(id)
    .collection('events').add(event); // ✅
}

// This will fail (members can't create events)
if (user.role == 'member') {
  await db.collection('fivondronana').doc(id)
    .collection('events').add(event); // ❌ Permission denied
}
```

---

## 🚀 Deploy Now!

```bash
./deploy-rules.sh
```

**Time**: ~2-5 minutes  
**Risk**: Low (non-breaking to existing code)  
**Benefit**: Database security + data protection

---

**Status**: ✅ Ready to deploy!
