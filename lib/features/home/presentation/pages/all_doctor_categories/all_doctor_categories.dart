import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doctor_category_card.dart';

class AllDoctorCategoriesPage extends ConsumerWidget {
  const AllDoctorCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(doctorCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: categoriesAsyncValue.when(
        data: (categories) {
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return DoctorCategoryCard(
                category: category,
                onTap: () {
                  context.go('/doctors/${category.specialty}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}