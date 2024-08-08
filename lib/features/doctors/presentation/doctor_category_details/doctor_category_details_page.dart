import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doctor_list_tile.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/hospital_list_tile.dart';

class DoctorCategoryDetailsPage extends ConsumerStatefulWidget {
  final String category;

  const DoctorCategoryDetailsPage({super.key, required this.category});

  @override
  DoctorCategoryDetailsPageState createState() => DoctorCategoryDetailsPageState();
}

class DoctorCategoryDetailsPageState extends ConsumerState<DoctorCategoryDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorsAsyncValue = ref.watch(doctorsBySpecialtyProvider(widget.category));
    final hospitalsAsyncValue = ref.watch(hospitalsBySpecialtyProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Specialists'),
        leading: BackButton(
          onPressed: () {
            context.go('/home');
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Doctors'),
            Tab(text: 'Hospitals/Clinics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          doctorsAsyncValue.when(
            data: (doctors) => doctors.isNotEmpty
                ? ListView.builder(
              itemCount: doctors.length,
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              itemBuilder: (context, index) => DoctorListTile(doctor: doctors[index]),
            )
                : const Center(child: Text('No doctors available')),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          hospitalsAsyncValue.when(
            data: (hospitals) {
              // Filtrer les structures et médecins individuels
              final structures = hospitals.where((doc) => doc.placeType != 'Individual').toList();
              return structures.isNotEmpty
                  ? ListView.builder(
                itemCount: structures.length,
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                itemBuilder: (context, index) => HospitalListTile(hospital: structures[index]),
              )
                  : const Center(child: Text('No hospitals or clinics available'));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
