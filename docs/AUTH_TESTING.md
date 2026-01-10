# 🧪 Quick Testing Guide - Auth Implementation

## ✅ Pre-flight Checklist

```bash
# 1. Check code compiles
cd /home/oeka/Documents/projects/fivondronana
flutter analyze
# Expected: "No issues found!"

# 2. Get latest packages
flutter pub get

# 3. Verify Firebase is connected
# Check that firebase_options.dart has real credentials
cat lib/config/firebase_options.dart | grep "projectId"
# Expected: projectId: 'gestion-esmia'
```

---

## 🚀 Running the App

### Web (Easiest for testing)
```bash
flutter run -d chrome
```

### Android (if emulator running)
```bash
flutter run -d emulator-5554
```

### iOS (if simulator running)
```bash
flutter run -d iPhone
```

---

## 🧬 Test Scenarios

### Test 1: Registration Flow ✅

**Steps**:
1. App launches → LoginScreen
2. Tap "Créer un compte" → RegisterScreen
3. Fill in:
   - Name: "Jean Dupont"
   - Email: "jean@test.com"
   - Password: "Test1234" (Watch criteria turn green in real-time!)
   - Confirm: "Test1234"
   - Check "J'accepte les conditions"
4. Tap "Créer un compte"

**Expected Result**:
- ✅ Loading spinner appears
- ✅ Success dialog after 2-3 seconds
- ✅ Tapping OK → HomeScreen (authenticated)
- ✅ User can see "Bienvenue à Fivondronana"

**Check Logs**:
```
[DEBUG] Registering user with email: jean@test.com
[DEBUG] User registered successfully: jean@test.com
```

---

### Test 2: Login with Same Account ✅

**Steps**:
1. From HomeScreen, logout (if button exists)
2. LoginScreen appears
3. Enter:
   - Email: "jean@test.com"
   - Password: "Test1234"
4. Tap "Connexion"

**Expected Result**:
- ✅ Loading spinner
- ✅ Auto-redirect to HomeScreen
- ✅ No errors

**Check Logs**:
```
[DEBUG] Logging in user: jean@test.com
[DEBUG] User logged in successfully: jean@test.com
```

---

### Test 3: Wrong Password Error ✅

**Steps**:
1. LoginScreen
2. Email: "jean@test.com"
3. Password: "WrongPassword"
4. Tap "Connexion"

**Expected Result**:
- ✅ Loading spinner
- ✅ Error dialog: "Mot de passe incorrect" (in French!)
- ✅ Stay on LoginScreen
- ✅ Can retry

---

### Test 4: Invalid Email ✅

**Steps**:
1. LoginScreen or RegisterScreen
2. Enter invalid email (e.g., "notanemail")
3. Try to submit

**Expected Result**:
- ✅ Form validation error: "Email invalide"
- ✅ Button disabled until fixed
- ✅ No network request made

---

### Test 5: Password Too Short ✅

**RegisterScreen**:
1. Name: "Test"
2. Email: "test@test.com"
3. Password: "abc" (less than 6)
4. Try to submit

**Expected Result**:
- ✅ Form validation error: "Le mot de passe doit contenir au moins 6 caractères"
- ✅ Button disabled

---

### Test 6: Password Strength Indicator ✅

**RegisterScreen**:
1. As you type password, watch the criteria list:
   ```
   ✓ Au moins 6 caractères        (green when ≥6)
   ○ Au moins une lettre majuscule (green when [A-Z])
   ○ Au moins une lettre minuscule (green when [a-z])
   ○ Au moins un chiffre           (green when [0-9])
   ```

2. Type "Test1234"
   - After "Test" → Still need number
   - After "Test1" → All green! ✅

**Expected Result**:
- ✅ Checkmark icon for valid criteria
- ✅ Radio button icon for invalid
- ✅ Colors: Green (#2ECC71) when valid, Gray when not
- ✅ Updates in real-time as you type

---

### Test 7: Password Mismatch ✅

**RegisterScreen**:
1. Password: "Test1234"
2. Confirm: "Test1234" (correct first)
3. Change to "DifferentPass"

**Expected Result**:
- ✅ Form validation error: "Les mots de passe ne correspondent pas"
- ✅ Button disabled
- ✅ Fix by typing same confirmation

---

### Test 8: Missing Terms Acceptance ✅

**RegisterScreen**:
1. Fill all fields correctly
2. DO NOT check "J'accepte les conditions"
3. Tap "Créer un compte"

**Expected Result**:
- ✅ Error dialog: "Vous devez accepter les conditions d'utilisation"
- ✅ No account created
- ✅ Form stays visible

---

### Test 9: Nonexistent User Login ✅

**LoginScreen**:
1. Email: "nonexistent@test.com"
2. Password: "Test1234"
3. Submit

**Expected Result**:
- ✅ Error dialog: "Utilisateur non trouvé"
- ✅ Stay on LoginScreen

---

### Test 10: Logout & Back to Login ✅

**HomeScreen** (after successful login):
1. Look for logout button (may need to add)
2. OR manually test: Modify home button to include logout:
   ```dart
   FloatingActionButton(
     onPressed: () => Get.find<AuthController>().logout(),
     child: Icon(Icons.logout),
   )
   ```
3. Tap logout

**Expected Result**:
- ✅ User logged out
- ✅ AuthWrapper detects `isAuthenticated = false`
- ✅ Auto-redirect to LoginScreen
- ✅ Can't use back button to go to HomeScreen

---

## 🔍 Debugging Tips

### Check Current Auth State
In Chrome DevTools Console:
```javascript
// Can't directly access Flutter, but watch network tab
// Look for Firebase auth requests to gestion-esmia.firebaseapp.com
```

### Check Local Cache
```dart
// In any screen:
final offline = Get.find<OfflineService>();
print(offline.getData('currentUser_email'));
// Should print user email if logged in
```

### Watch Logger Output
```
[DEBUG] User logged in: jean@test.com
[DEBUG] ✓ [main.dart] Firebase initialized
[DEBUG] ✓ [offline_service.dart] Offline storage initialized
```

### Enable More Verbose Logging
In `main.dart`:
```dart
// Add at top of main()
Logger.level = Level.trace; // Show all logs
```

---

## 🐛 Common Issues & Fixes

### Issue: "No internet connection" Error
**Cause**: Running on device without internet
**Fix**: 
- For registration/login, internet required for Firebase
- OfflineService caches, so subsequent offline use works
- Test on web first (guaranteed internet)

### Issue: App crashes on startup
**Cause**: GetX services not initialized in correct order
**Fix**: Check `main.dart`, ensure OfflineService before AuthController
```dart
Get.put<OfflineService>(OfflineService());      // ← FIRST
Get.put<ConnectivityService>(ConnectivityService());
Get.put<AuthController>(AuthController());      // ← USES OfflineService
```

### Issue: Firebase credentials not found
**Cause**: `firebase_options.dart` is empty/wrong
**Fix**: 
```bash
# Regenerate with real credentials
rm -rf lib/config/firebase_options.dart
flutterfire configure --platforms=web,android,ios,linux,macos,windows
```

### Issue: "Email already in use" error immediately
**Cause**: Created account in previous test
**Fix**: Use different email or delete test account in Firebase Console
```
Firebase Console → Authentication → Find test@test.com → Delete
```

### Issue: Validation works but submit does nothing
**Cause**: Missing `onPressed` or wrong navigation
**Fix**: Check that `_handleLogin()` and `_handleRegister()` are called
```dart
onPressed: authController.isLoading.value ? null : _handleLogin,
```

---

## ✨ Advanced Tests

### Test Email Uniqueness
```dart
// Test 1: Register with "adam@test.com"
// Test 2: Try to register again with same email
// Expected: "Cet email est déjà utilisé"
```

### Test Firebase Backend
```bash
# Check Firebase Console
# 1. Go to gestion-esmia project
# 2. Authentication → Users tab
# 3. Should see created test accounts with email and creation date
```

### Test Offline Cache
```dart
// Add to main.dart for testing
onInit() {
  final cached = offlineService.getData('currentUser_email');
  logger.i('Cached user: $cached');
}
```

---

## 📊 Success Criteria

| Feature | Status | Test |
|---------|--------|------|
| Registration | ✅ | Create account, success dialog |
| Login | ✅ | Login with created account |
| Password strength | ✅ | See criteria updates in real-time |
| Validation | ✅ | Try invalid inputs, see errors |
| Navigation | ✅ | Auth state → HomeScreen auto-redirect |
| Error handling | ✅ | All errors in French |
| Loading states | ✅ | See spinner during auth |
| Logout | ✅ | Back to LoginScreen |

---

## 🎬 Recording a Test Session

For documentation:
```bash
# 1. Start app in chrome
flutter run -d chrome

# 2. Open DevTools (F12)
# 3. Go to Performance tab
# 4. Record 30 seconds while doing auth flow
# 5. Export as video/report

# Or use:
flutter run -d chrome --profile
# This gives performance metrics
```

---

## 📝 Test Report Template

```markdown
## Auth System Test Report

**Date**: [TODAY]
**Tester**: [YOUR NAME]
**Build**: flutter --version

### Tests Passed ✅
- [ ] Registration flow
- [ ] Login flow
- [ ] Password strength indicator
- [ ] Form validation
- [ ] Error messages (French)
- [ ] Navigation

### Bugs Found 🐛
(List any issues)

### Notes
(Add observations)

### Next Steps
- [ ] Test on physical device
- [ ] Test with slow internet
- [ ] Test with Firebase offline mode
```

---

## 🎯 Final Checklist Before Merge

- [ ] `flutter analyze` returns "No issues found!"
- [ ] `flutter test` passes all tests (if applicable)
- [ ] Tested on Chrome (web)
- [ ] Tested on Android (if possible)
- [ ] Registration works
- [ ] Login works
- [ ] Logout works
- [ ] Error messages are in French
- [ ] No sensitive data in logs
- [ ] App doesn't crash on auth errors
- [ ] Navigation flows correctly
- [ ] Firebase Console shows created users

---

**Status**: Ready for testing! 🚀
