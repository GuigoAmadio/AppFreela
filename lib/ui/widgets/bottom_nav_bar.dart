import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isFreelancer;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isFreelancer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: isFreelancer
            ? _freelancerItems()
            : _empresaItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _freelancerItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Início',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'Vagas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        activeIcon: Icon(Icons.map),
        label: 'Mapa',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.description_outlined),
        activeIcon: Icon(Icons.description),
        label: 'Candidaturas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];
  }

  List<BottomNavigationBarItem> _empresaItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Início',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        activeIcon: Icon(Icons.add_circle),
        label: 'Criar Vaga',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'Minhas Vagas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline),
        activeIcon: Icon(Icons.people),
        label: 'Candidatos',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];
  }
}

