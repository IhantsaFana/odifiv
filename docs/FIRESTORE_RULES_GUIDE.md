# 🔐 Firestore Security Rules - Configuration Guide

## Overview

Firestore Security Rules pour le projet **Fivondronana** (Scout Protestant digitalization).

**File**: `firestore.rules`  
**Project**: `gestion-esmia`  
**Status**: Ready to deploy

---

## 📋 Collections & Permissions

### 1. **users/** - User Profiles

**Purpose**: Store user account information and profile data

**Structure**:
```
users/
├── {userId}/
│   ├── email: string
│   ├── displayName: string
│   ├── photoURL: string (optional)
│   ├── role: 'member' | 'validator' | 'admin'
│   ├── division: string
│   ├── position: string
│   ├── createdAt: timestamp
│   └── members/{memberId}/ (sub-collection)
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | User reads own doc OR admin reads any |
| Create | User creates own profile during registration |
| Update | User updates own OR admin can update any |
| Delete | Admin only |

**Security Features**:
- ✅ Users can only create their own profile
- ✅ Role defaults to 'member' (can't elevate themselves)
- ✅ Only admin can assign roles
- ✅ Timestamp validated server-side

---

### 2. **users/{userId}/members/** - Scout Members

**Purpose**: Store scout member records linked to user account

**Structure**:
```
users/{userId}/members/
├── {memberId}/
│   ├── firstName: string
│   ├── lastName: string
│   ├── totem: string
│   ├── division: 'voronkely' | 'mpanazova' | 'afo' | 'menafify'
│   ├── currentSampana: string
│   ├── position: string
│   ├── talents: array
│   ├── phone: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | User owns parent OR admin |
| Create | User owns parent, validates division |
| Update | User owns parent, updates timestamp |
| Delete | User owns parent OR admin |

**Validations**:
- ✅ Division must be one of Scout divisions
- ✅ All required fields present
- ✅ Types validated (string, array)

---

### 3. **users/{userId}/activities/** - Activity Log

**Purpose**: Store user activities for offline sync and audit

**Structure**:
```
users/{userId}/activities/
├── {activityId}/
│   ├── type: string ('login', 'created_member', 'updated_profile', etc.)
│   ├── timestamp: timestamp
│   ├── data: object (activity-specific data)
│   └── synced: boolean (default: false)
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | User owns OR admin |
| Create | User owns, timestamp validated |
| Update | User can mark as synced |
| Delete | User owns OR admin |

**Purpose**: Track user actions for analytics and offline support

---

### 4. **fivondronana/** - Scout Administrative Structure

**Purpose**: Store geographic and administrative divisions

**Structure**:
```
fivondronana/
├── {fivondronanaId}/
│   ├── name: string
│   ├── number: integer
│   ├── faritra: string (region)
│   ├── faritany: string (province)
│   ├── foibe: string (district)
│   ├── createdAt: timestamp
│   └── sampana/{sampanaId}/ (sub-collection)
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | Authenticated users |
| Create | Admin only |
| Update | Admin only |
| Delete | Admin only |

**Purpose**: Reference data, readable by all authenticated users

---

### 5. **fivondronana/{fivondronanaId}/sampana/** - Groups/Sections

**Purpose**: Store sampana (group/section) information

**Structure**:
```
sampana/
├── {sampanaId}/
│   ├── name: string
│   ├── type: string ('voronkely' | 'mpanazova' | 'afo' | 'menafify')
│   ├── members: array of user IDs
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | Authenticated |
| Create | Validator+ |
| Update | Validator+ |
| Delete | Admin only |

---

### 6. **fivondronana/{fivondronanaId}/events/** - Events

**Purpose**: Store Scout activities and events

**Structure**:
```
events/
├── {eventId}/
│   ├── title: string
│   ├── description: string
│   ├── date: timestamp
│   ├── location: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | Authenticated |
| Create | Validator+ |
| Update | Validator+ |
| Delete | Admin only |

---

### 7. **offline_sync/{userId}/** - Offline Sync Queue

**Purpose**: Store pending changes for offline-first apps

**Structure**:
```
offline_sync/
├── {userId}/
│   └── {syncId}/
│       ├── operation: 'create' | 'update' | 'delete'
│       ├── collection: string (target collection)
│       ├── data: object (document data)
│       ├── timestamp: timestamp
│       └── synced: boolean
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | User owns OR admin |
| Create | User owns |
| Delete | User owns OR admin after synced |

**Purpose**: Queue for offline operations, auto-sync when online

---

### 8. **audit_log/** - Admin Audit Trail

**Purpose**: Immutable audit log of admin operations

**Structure**:
```
audit_log/
├── {logId}/
│   ├── timestamp: timestamp
│   ├── actor: string (admin user ID)
│   ├── action: string ('delete_user', 'create_admin', etc.)
│   ├── target: string (affected user/document)
│   ├── changes: object
│   └── ipAddress: string (optional)
```

**Permissions**:
| Action | Condition |
|--------|-----------|
| Read | Validator+ |
| Create | System only (via Cloud Functions) |
| Delete | Admin only (after review) |

**Purpose**: Track admin actions for compliance and debugging

---

## 🔑 Role-Based Access Control

### Roles Hierarchy

```
Admin
├── Can create/delete users
├── Can assign roles
├── Can delete any document
├── Can view audit logs
└── Can manage Firestore rules

Validator
├── Can create events
├── Can create sampana
├── Can approve offline sync
└── Can view audit logs (read-only)

Member (default)
├── Can create/update own profile
├── Can create own members
├── Can sync offline changes
└── Can view all public data
```

### Role Assignment

```dart
// Only admin can set this:
users/{userId}.role = 'admin'
users/{userId}.role = 'validator'
users/{userId}.role = 'member'
```

---

## 🚀 Deployment Instructions

### Option 1: Firebase CLI (Recommended)

```bash
# 1. Install Firebase CLI if not already installed
npm install -g firebase-tools

# 2. Login to Firebase
firebase login

# 3. Navigate to project directory
cd /home/oeka/Documents/projects/fivondronana

# 4. Deploy rules
firebase deploy --only firestore:rules

# 5. Verify deployment
firebase firestore:describe
```

### Option 2: Firebase Console

```
1. Go to Firebase Console → gestion-esmia project
2. Navigate to Firestore → Rules tab
3. Copy content from firestore.rules file
4. Paste into Rules editor
5. Click "Publish"
6. Confirm publication
```

### Option 3: Update firebase.json

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  }
}
```

Then run: `firebase deploy --only firestore:rules`

---

## 🧪 Testing Rules

### Using Firebase Emulator (Local Development)

```bash
# 1. Start Firebase Emulator
firebase emulators:start --only firestore

# 2. In your Flutter app, connect to emulator:
final settings = FirebaseFirestoreSettings();
settings.host = '127.0.0.1:8080'; // Emulator host
settings.sslEnabled = false;
FirebaseFirestore.instance.settings = settings;

# 3. Test operations:
# - Register new user → creates users/{uid}
# - Add member → creates users/{uid}/members/{id}
# - Create event → requires validator role
```

### Unit Tests for Rules

Example test pattern:

```javascript
// In firestore.rules tests
describe('User Collection Rules', () => {
  test('User can read own profile', () => {
    // Allow read if isOwner
    assertSucceeds(
      db.collection('users').doc(auth.uid).get()
    );
  });

  test('User cannot read other profiles', () => {
    // Deny read if not owner and not admin
    assertFails(
      db.collection('users').doc('other-uid').get()
    );
  });

  test('User cannot elevate own role', () => {
    // Deny update if trying to change role (non-admin)
    assertFails(
      db.collection('users').doc(auth.uid)
        .update({ role: 'admin' })
    );
  });
});
```

---

## 🔒 Security Checklist

- ✅ Default: Deny all access
- ✅ Authentication required for all collections
- ✅ Users can only access own data
- ✅ Roles properly validated
- ✅ Timestamps server-side validated
- ✅ Data types validated
- ✅ Field whitelisting (only allowed fields)
- ✅ Sensitive operations restricted to roles
- ✅ Audit logging for admin actions
- ✅ Offline sync queue secured

---

## 📝 Common Patterns Used

### 1. **Ownership Check**
```javascript
function isOwner(userId) {
  return request.auth.uid == userId;
}

match /users/{userId} {
  allow read: if isOwner(userId);
}
```

### 2. **Role-Based Access**
```javascript
function isAdmin(userId) {
  return get(/databases/$(database)/documents/users/$(userId))
    .data.role == 'admin';
}

allow delete: if isAdmin(request.auth.uid);
```

### 3. **Data Validation**
```javascript
allow create: if 
  request.resource.data.keys().hasOnly(['field1', 'field2']) &&
  request.resource.data.field1 is string &&
  request.resource.data.field2 is int;
```

### 4. **Timestamp Validation**
```javascript
allow create: if 
  request.resource.data.createdAt == request.time;
```

### 5. **Array Constraints**
```javascript
allow create: if
  request.resource.data.division in ['voronkely', 'mpanazova', 'afo', 'menafify'];
```

---

## 🐛 Troubleshooting

### Issue: "Missing or insufficient permissions"

**Common causes**:
1. User not authenticated
2. User doesn't have required role
3. Document doesn't exist
4. Path mismatch (case-sensitive!)

**Debug**:
```
1. Check auth.uid is not null
2. Verify user has role document: users/{uid}
3. Check Firestore logs for specific rule failures
4. Use Firebase Emulator for local testing
```

### Issue: "Field validation failed"

**Check**:
- All required fields present
- Field types match schema (string, int, timestamp, etc.)
- No extra fields sent (hasOnly constraint)
- Timestamps use request.time

### Issue: Rules deployed but still getting errors

**Solutions**:
1. Clear browser cache
2. Log out and log in again
3. Wait 5-10 minutes for rule propagation
4. Check Firestore → Rules tab in Firebase Console
5. Verify Firebase project ID matches

---

## 🔄 Rule Updates

When updating rules:

```bash
# 1. Edit firestore.rules
# 2. Test locally with emulator
# 3. Review changes
firebase firestore:get-rules # See current rules

# 4. Deploy
firebase deploy --only firestore:rules

# 5. Monitor for errors
firebase functions:logs
```

---

## 📚 References

- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Rule Language Reference](https://firebase.google.com/docs/reference/rules/firestore)
- [Common Patterns](https://firebase.google.com/docs/firestore/security/rules-patterns)
- [Emulator Suite](https://firebase.google.com/docs/emulator-suite)

---

## ⚠️ Important Notes

1. **Rules are not filters** - They deny access, not filter results
   - `query.where('hidden', '==', false)` won't bypass rules
   - Rules must allow the operation

2. **Careful with wildcards**
   - `match /{document=**}` matches ALL documents
   - Place specific rules before wildcard rules

3. **Performance considerations**
   - `get()` in rules counts as read operation
   - Avoid deep nested `get()` calls
   - Cache user roles at session level

4. **Testing is critical**
   - Always test in emulator first
   - Test negative cases (should fail)
   - Test positive cases (should succeed)

---

**Status**: ✅ **Ready to Deploy**

Rules follow Firebase best practices and are optimized for the Fivondronana Scout structure.
