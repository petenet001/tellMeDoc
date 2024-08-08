import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doctor_list_tile.dart';

class TopDoctorsSection extends ConsumerWidget {
  const TopDoctorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topDoctorsAsyncValue = ref.watch(topDoctorsProvider);

    return Center(
      child: topDoctorsAsyncValue.when(
        data: (doctors) => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return DoctorListTile(
              doctor: doctor,
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
