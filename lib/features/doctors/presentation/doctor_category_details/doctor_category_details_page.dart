import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doc_grid_tile.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/hospital_list_tile.dart';
import 'package:tell_me_doctor/features/doctors/data/models/health_center_model.dart';

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
          onPressed: (){
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
                ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: doctors.length,
              itemBuilder: (context, index) => DoctorGridTile(doctor: doctors[index]),
            )
                : const Center(child: Text('No doctors available')),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          hospitalsAsyncValue.when(
            data: (hospitals) {
              // Vérifiez que vous traitez des objets de type HealthCenterModel
              final structures = hospitals.where((hospital) => hospital is HealthCenterModel).toList();
              return structures.isNotEmpty
                  ? ListView.builder(
                itemCount: structures.length,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final healthCenter = structures[index] as HealthCenterModel;
                  return HospitalListTile(hospital: healthCenter);
                },
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
