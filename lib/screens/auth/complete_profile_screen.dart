import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Remis en haut
import '../../controllers/auth_controller.dart';
import '../../models/member_model.dart';
import '../../services/member_service.dart';
import '../../config/app_theme.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  final _memberService = MemberService();

  final _nameController = TextEditingController();
  final _totemController = TextEditingController();
  final _functionController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedRole = 'mpiandraikitra';
  String _selectedBranch = 'groupe';

  @override
  void initState() {
    super.initState();
    // Pré-remplir le nom avec celui du compte social
    _nameController.text = _authController.currentUser.value?.displayName ?? '';
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = _authController.currentUser.value;
      if (user == null) return;

      final myProfile = MemberModel(
        id: user.uid,
        fullName: _nameController.text.trim(),
        email: user.email,
        totemOrNickname: _totemController.text.trim(),
        role: _selectedRole,
        branch: _selectedBranch,
        function: _functionController.text.trim(),
        phone: _phoneController.text.trim(),
        status: 'active',
        isAssurancePaid: false,
      );

      try {
        await FirebaseFirestore.instance
            .collection('members')
            .doc(user.uid)
            .set(myProfile.toFirestore());
        
        // Rafraîchir l'état dans le controller
        await _authController.checkProfileExists(user.uid);
        Get.offAllNamed('/home');
      } catch (e) {
        Get.snackbar('Erreur', 'Tsy tontosa ny famenoana ny mombamomba ise');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fenoy ny mombamomba ise'),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.badge_outlined, size: 80, color: Color(0xFF1a4d7e)),
              const SizedBox(height: 16),
              const Text(
                "Miankina amin'ise ny herin'ny Fivondronantsika. Fenoy ireto mialoha ny idiran'ise ao amin'ny Dashboard.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Anarana feno', prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? 'Fenoy ity azafady' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _totemController,
                decoration: const InputDecoration(labelText: 'Totem na Anaram-bositra', prefixIcon: Icon(Icons.star)),
                validator: (v) => v!.isEmpty ? 'Fenoy ity azafady' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['mpiandraikitra', 'comite'].map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
                decoration: const InputDecoration(labelText: 'Andraikitra (Role)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedBranch,
                items: ['mavo', 'maitso', 'mena', 'mpanazava', 'groupe'].map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!))).toList(),
                onChanged: (v) => setState(() => _selectedBranch = v!),
                decoration: const InputDecoration(labelText: 'Sampana', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _functionController,
                decoration: const InputDecoration(labelText: 'Andraikitra manokana (Ex: Akela, KP, CP...)', prefixIcon: Icon(Icons.work)),
                validator: (v) => v!.isEmpty ? 'Fenoy ity azafady' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Laharana finday', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Fenoy ity azafady' : null,
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.sampanaPrimaryColor),
                  child: const Text('Hanomboka', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
