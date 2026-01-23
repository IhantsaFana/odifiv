# Structure de la Base de Données (Harambato)

## 1. 📂 Collection : `members` (Mpikambana)
Individus de la fivondronana (beazina et mpiandraikitra).

**Champs :**
- `uid` (String) : ID unique.
- `photoUrl` (String) : URL de la photo de profil.
- `fullName` (String) : Nom complet.
- `totemOrNickname` (String) : Totem ou prénom préféré.
- `role` (String) : beazina, mpiandraikitra, ray_aman_dreny, comite.
- `branch` (String) : mavo, maitso, mena, mpanazava, groupe.
- `function` (String) : Ex: "Chef de Patrouille", "Akela", etc.
- `phone` (String).
- `email` (String, optionnel).
- `birthDate` (Timestamp).
- `entryDateScout` (Timestamp).
- `promiseDateScout` (Timestamp).
- `progression` (Array of Maps) : `[{ title: "Badge Secourisme", date: Timestamp, place: "Antsirabe" }]`.
- `isAssurancePaid` (Boolean) : Status pour l'année en cours.
- `status` (String) : active, inactive.

## 2. 📂 Collection : `events` (Tetiandro)
Calendrier et Présences.

**Champs :**
- `id` (String).
- `title` (String).
- `description` (String).
- `type` (String) : meeting, camp, training.
- `dateStart` (Timestamp).
- `dateEnd` (Timestamp).
- `targetBranches` (Array).
- `isAttendanceDone` (Boolean).
- `presentMemberIds` (Array).
- `absentMemberIds` (Array).

## 3. 📂 Collection : `assurance_payments`
Historique des paiements d'assurance.

**Champs :**
- `id` (String).
- `memberId` (String).
- `year` (Int) : Ex: 2025.
- `status` (String) : "paid".
- `paymentDate` (Timestamp).
- `receivedBy` (String) : ID du responsable.

## 4. 📂 Collection : `ai_programs`
Programmes générés par l'IA.

## 5. 📂 Collection : `dashboard_stats`
Stats agrégées pour la performance.
