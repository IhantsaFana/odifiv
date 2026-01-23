import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/member_controller.dart';
import '../../models/member_model.dart';
import '../../config/app_theme.dart';

import 'add_member_screen.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Injection du contrôleur
    final controller = Get.put(MemberController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddMemberScreen());
        },
        backgroundColor: AppTheme.sampanaPrimaryColor,
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = controller.filteredMembers;
        final myProfile = controller.currentMemberProfile.value;

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Tsy misy mpikambana hita',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Petit bandeau d'information sur le filtre
            if (myProfile != null && myProfile.branch.toLowerCase() != 'groupe')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: _getBranchColor(myProfile.branch).withValues(alpha: 0.1),
                child: Text(
                  'Lisitry ny Beazina - Sampana ${myProfile.branch.capitalizeFirst}',
                  style: TextStyle(
                    color: _getBranchColor(myProfile.branch),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final member = list[index];
                  return _buildMemberCard(member, controller);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMemberCard(MemberModel member, MemberController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          // TODO: Détails du membre
        },
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'avatar-${member.id}',
          child: CircleAvatar(
            radius: 28,
            backgroundColor: _getBranchColor(member.branch).withValues(alpha: 0.1),
            backgroundImage: member.photoUrl != null 
                ? NetworkImage(member.photoUrl!) 
                : null,
            child: member.photoUrl == null
                ? Text(
                    member.fullName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _getBranchColor(member.branch),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
        ),
        title: Text(
          member.totemOrNickname.isNotEmpty 
              ? member.totemOrNickname 
              : member.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${member.role.capitalizeFirst} • ${member.branch.capitalizeFirst}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            if (member.function.isNotEmpty)
              Text(
                member.function,
                style: TextStyle(
                  color: AppTheme.sampanaPrimaryColor.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: InkWell(
          onTap: () => controller.toggleAssurance(member),
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                member.isAssurancePaid ? Icons.verified_user : Icons.gpp_maybe_rounded,
                color: member.isAssurancePaid ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                member.isAssurancePaid ? 'Assuré' : 'Non payé',
                style: TextStyle(
                  fontSize: 10,
                  color: member.isAssurancePaid ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBranchColor(String branch) {
    switch (branch.toLowerCase()) {
      case 'mavo': return Colors.yellow[700]!;
      case 'maitso': return Colors.green[700]!;
      case 'mena': return Colors.red[700]!;
      case 'mpanazava': return Colors.blue[700]!;
      default: return AppTheme.sampanaPrimaryColor;
    }
  }
}
