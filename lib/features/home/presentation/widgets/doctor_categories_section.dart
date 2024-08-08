import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doctor_category_card.dart';
import 'package:tell_me_doctor/features/home/presentation/widgets/see_more_category_card.dart';

class DoctorCategoriesSection extends ConsumerWidget {
  const DoctorCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(doctorCategoriesProvider);

    return SizedBox(
      height: 300, // Ajustez cette hauteur selon vos besoins
      child: categoriesAsyncValue.when(
        data: (categories) {
          final displayedCategories = categories.take(3).toList();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: displayedCategories.length + 1, // +1 pour le bouton "Voir plus"
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index < displayedCategories.length) {
                final category = displayedCategories[index];
                return DoctorCategoryCard(
                  category: category,
                  onTap: () {
                    context.go('/doctors/${category.specialty}');
                  },
                );
              } else {
                // Bouton "Voir plus"
                return SeeMoreCategoryCard(
                  onTap: () {
                    context.push('/all-categories'); // Assurez-vous d'avoir cette route dans votre configuration
                  },
                );
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}