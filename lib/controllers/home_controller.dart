import 'package:get/get.dart';

class HomeController extends GetxController {
  // Index de l'onglet actif
  final RxInt currentIndex = 0.obs;

  // Titres des pages pour le header
  final List<String> pageTitles = [
    'Accueil',
    'Calendrier',
    'Membres', // Ou Annuaire
    'Profil',
  ];

  // Change l'onglet actif
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Getter pour le titre actuel
  String get currentTitle => pageTitles[currentIndex.value];
}
