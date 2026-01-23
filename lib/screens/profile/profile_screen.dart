import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/member_controller.dart';
import '../../models/member_model.dart';
import '../../config/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final memberController = Get.find<MemberController>();
    
    return Scaffold(
      backgroundColor: Colors.grey[50], 
      body: Obx(() {
        final profile = memberController.currentMemberProfile.value;
        
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // En-tête Utilisateur (Carte Premium)
            _buildProfileCard(profile, memberController),
            
            const SizedBox(height: 32),
            const Text(
              'Fombafomba (Préférences)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            
            // Menu List
            _buildSettingsItem(
              Icons.notifications_outlined, 
              'Fampandrenesana (Notifications)', 
              () => _showComingSoon('Fampandrenesana'),
              color: Colors.blue,
            ),
            _buildSettingsItem(
              Icons.language, 
              'Teny (Langue)', 
              () => _showComingSoon('Teny'),
              color: Colors.orange,
            ),
            _buildSettingsItem(
              Icons.dark_mode_outlined, 
              'Theme', 
              () => _showComingSoon('Theme'),
              color: Colors.purple,
            ),
            _buildSettingsItem(
              Icons.info_outline, 
              'Mombamomba ny App (À propos)', 
              () => _showAboutDialog(context),
              color: Colors.teal,
            ),

            const SizedBox(height: 48),
            
            // Bouton Déconnexion
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context, authController),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Hivoaka (Se déconnecter)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }

  Widget _buildProfileCard(MemberModel profile, MemberController controller) {
    final branchColor = _getBranchColor(profile.branch);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner Background (Branch Color)
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: branchColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.security, 
                    size: 100, 
                    color: branchColor.withValues(alpha: 0.05)
                  ),
                ),
              ],
            ),
          ),
          
          // Profile Info
          Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                   CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: branchColor.withValues(alpha: 0.1),
                      child: profile.photoUrl != null 
                        ? ClipOval(child: Image.network(profile.photoUrl!, fit: BoxFit.cover))
                        : Text(
                            profile.fullName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: branchColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (profile.totemOrNickname.isNotEmpty)
                    Text(
                      '"${profile.totemOrNickname}"',
                      style: TextStyle(
                        fontSize: 16, 
                        color: branchColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  // Stats / Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoItem(Icons.category_rounded, profile.branch.capitalizeFirst!, 'Sampana'),
                      Container(width: 1, height: 30, color: Colors.grey[200]),
                      _buildInfoItem(Icons.workspace_premium_rounded, profile.function, 'Andraikitra'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(),
                  
                  // Quick Actions
                  TextButton.icon(
                    onPressed: () => _showEditProfileDialog(profile, controller),
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('Hanova ny mombamomba'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.sampanaPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'Mbola an-dalam-pivoarana',
      'Tsy mbola azo ampiasaina ny $feature amin\'izao fotoana izao.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Harambato',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset('assets/images/logo.png', width: 50),
      children: [
        const Text(
          "Ity application ity dia natao hanampiana ny mpiandraikitra ao amin'ny fivondronana Harambato faha 420 hitantana ny mpikambana sy ny tetiandro.",
        ),
        const SizedBox(height: 10),
        const Text("Nataon'i OEKA Mikofo."),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hivoaka'),
        content: const Text('Te hivoaka tokoa ve ise ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tsia'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Eny, hivoaka'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(MemberModel profile, MemberController controller) {
    final totemController = TextEditingController(text: profile.totemOrNickname);
    final functionController = TextEditingController(text: profile.function);
    final phoneController = TextEditingController(text: profile.phone);
    String selectedBranch = profile.branch;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Hanova ny mombamomba',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: totemController,
                decoration: const InputDecoration(
                  labelText: 'Totem na Anaram-bositra',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: selectedBranch,
                items: ['mavo', 'maitso', 'mena', 'mpanazava', 'groupe']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!)))
                    .toList(),
                onChanged: (v) => selectedBranch = v!,
                decoration: const InputDecoration(
                  labelText: 'Sampana',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: functionController,
                decoration: const InputDecoration(
                  labelText: 'Andraikitra manokana',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Laharana finday',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final updatedProfile = MemberModel(
                      id: profile.id,
                      fullName: profile.fullName,
                      email: profile.email,
                      photoUrl: profile.photoUrl,
                      totemOrNickname: totemController.text.trim(),
                      role: profile.role,
                      branch: selectedBranch,
                      function: functionController.text.trim(),
                      phone: phoneController.text.trim(),
                      birthDate: profile.birthDate,
                      entryDateScout: profile.entryDateScout,
                      promiseDateScout: profile.promiseDateScout,
                      progression: profile.progression,
                      isAssurancePaid: profile.isAssurancePaid,
                      status: profile.status,
                    );
                    
                    final success = await controller.updateProfile(updatedProfile);
                    if (success) {
                      Get.back();
                      Get.snackbar('Fahombiazana', 'Voahova ny mombamomba ise');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sampanaPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tehirizina', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Color _getBranchColor(String branch) {
    switch (branch.toLowerCase()) {
      case 'mavo': return Colors.yellow[700]!;
      case 'maitso': return Colors.green[700]!;
      case 'mena': return Colors.red[700]!;
      case 'mpanazava': return Colors.blue[700]!;
      default: return const Color(0xFF1a4d7e);
    }
  }
}
