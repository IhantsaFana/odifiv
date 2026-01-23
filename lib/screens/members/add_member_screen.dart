import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/member_controller.dart';
import '../../models/member_model.dart';
import '../../config/app_theme.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final MemberController controller = Get.find<MemberController>();

  // Controllers
  final _nameController = TextEditingController();
  final _totemController = TextEditingController();
  final _functionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Dates
  DateTime? _birthDate;
  DateTime? _entryDate;
  DateTime? _promiseDate;

  // Dropdowns
  String _selectedRole = 'beazina';
  String _selectedBranch = 'mavo';

  @override
  void initState() {
    super.initState();
    // Pré-remplir la branche si le mpiandraikitra connecté en a une
    final myProfile = controller.currentMemberProfile.value;
    if (myProfile != null && myProfile.branch.toLowerCase() != 'groupe') {
      _selectedBranch = myProfile.branch.toLowerCase();
    }
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (type == 'birth') _birthDate = picked;
        if (type == 'entry') _entryDate = picked;
        if (type == 'promise') _promiseDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newMember = MemberModel(
        fullName: _nameController.text.trim(),
        totemOrNickname: _totemController.text.trim(),
        role: _selectedRole,
        branch: _selectedBranch,
        function: _functionController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.isEmpty ? null : _emailController.text.trim(),
        birthDate: _birthDate,
        entryDateScout: _entryDate,
        promiseDateScout: _promiseDate,
        isAssurancePaid: false,
        status: 'active',
      );

      final success = await Get.find<MemberController>().addMember(newMember);
      if (success != null) {
        Get.back();
        Get.snackbar('Fahombiazana', 'Voasoratra soa aman-tsara ny mpikambana');
      } else {
        Get.snackbar('Erreur', 'Nisy olana teo am-panoratana');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanoratra mpikambana'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identité Section
              _buildSectionTitle('Mombamomba ity olona ity'),
              const SizedBox(height: 16),
              _buildTextField(_nameController, "Anarana feno", Icons.person, (v) => v!.isEmpty ? 'Fenoy anarana' : null),
              const SizedBox(height: 16),
              _buildTextField(_totemController, "Totem na Anaram-bositra", Icons.star, null),
              const SizedBox(height: 16),
              _buildDatePicker("Andro nahaterahana", _birthDate, () => _selectDate(context, 'birth')),

              const SizedBox(height: 32),
              
              // Scoutisme Section
              _buildSectionTitle('Eo anivon\'ny Scout'),
              const SizedBox(height: 16),
              _buildDropdown("Andraikitra / Role", ['beazina', 'mpiandraikitra', 'ray_aman_dreny', 'comite'], _selectedRole, (v) => setState(() => _selectedRole = v!)),
              const SizedBox(height: 16),
              _buildDropdown("Sampana", ['mavo', 'maitso', 'mena', 'mpanazava', 'groupe'], _selectedBranch, (v) => setState(() => _selectedBranch = v!)),
              const SizedBox(height: 16),
              _buildTextField(_functionController, "Andraikitra manokana (ex: KP, Chef...)", Icons.work_outline, null),
              const SizedBox(height: 16),
              _buildDatePicker("Andro nidirana scoutismo", _entryDate, () => _selectDate(context, 'entry')),
              const SizedBox(height: 16),
              _buildDatePicker("Andro nanaovana promesse", _promiseDate, () => _selectDate(context, 'promise')),

              const SizedBox(height: 32),

              // Contact Section
              _buildSectionTitle('Fifandraisana'),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, "Laharana finday", Icons.phone, (v) => v!.isEmpty ? 'Vidio finday' : null, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_emailController, "Email", Icons.email, null, keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sampanaPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Tehirizina', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: AppTheme.sampanaPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? Function(String?)? validator, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(date == null ? "Safidio ny daty" : DateFormat('dd/MM/yyyy').format(date), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
