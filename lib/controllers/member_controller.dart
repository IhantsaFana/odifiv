import 'package:get/get.dart';
import '../models/member_model.dart';
import '../services/member_service.dart';
import 'auth_controller.dart';

class MemberController extends GetxController {
  final MemberService _memberService = MemberService();
  final AuthController _authController = Get.find<AuthController>();
  
  final RxList<MemberModel> allMembers = <MemberModel>[].obs;
  final Rxn<MemberModel> currentMemberProfile = Rxn<MemberModel>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Charger tous les membres en temps réel
    allMembers.bindStream(_memberService.getMembersStream());
    
    // 2. Charger le profil du mpiandraikitra connecté
    loadCurrentMemberProfile();
    
    // On arrête le chargement dès qu'on a les membres
    ever(allMembers, (_) => isLoading.value = false);
  }

  Future<void> loadCurrentMemberProfile() async {
    final user = _authController.currentUser.value;
    if (user != null) {
      final profile = await _memberService.getMember(user.uid);
      currentMemberProfile.value = profile;
    }
  }

  // Mettre à jour son propre profil
  Future<bool> updateProfile(MemberModel member) async {
    final success = await _memberService.updateMember(member);
    if (success) {
      await loadCurrentMemberProfile();
    }
    return success;
  }

  // Liste filtrée selon les règles
  List<MemberModel> get filteredMembers {
    final me = currentMemberProfile.value;
    
    // Si profil non chargé ou si c'est un profil global (ex: Filoha, KP, ou branche "groupe")
    // On affiche TOUT.
    if (me == null || 
        me.branch.toLowerCase() == 'groupe' || 
        me.branch.isEmpty || 
        me.role.toLowerCase() == 'comite') {
      return allMembers;
    }

    // Si c'est un Mpiandraikitra d'une branche spécifique (mavo, maitso, etc.)
    // On affiche uniquement les BEAZINA de sa branche.
    return allMembers.where((m) {
      return m.branch.toLowerCase() == me.branch.toLowerCase() && 
             m.role.toLowerCase() == 'beazina';
    }).toList();
  }

  Future<void> toggleAssurance(MemberModel member) async {
    final success = await _memberService.toggleAssurance(
      member.id!, 
      !member.isAssurancePaid
    );
    if (!success) {
      Get.snackbar('Erreur', 'Impossible de mettre à jour l\'assurance');
    }
  }

  // Ajouter un nouveau membre
  Future<String?> addMember(MemberModel member) async {
    isLoading.value = true;
    final id = await _memberService.addMember(member);
    isLoading.value = false;
    return id;
  }
}
