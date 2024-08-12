import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/doctors/presentation/riverpod/doctor_providers.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/doc_grid_tile.dart';
import 'package:tell_me_doctor/features/doctors/presentation/widgets/hospital_list_tile.dart';

class AllDoctorsPage extends ConsumerStatefulWidget {
  final String city;

  const AllDoctorsPage({super.key, required this.city});

  @override
  AllDoctorsPageState createState() => AllDoctorsPageState();
}

class AllDoctorsPageState extends ConsumerState<AllDoctorsPage> with SingleTickerProviderStateMixin {
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
    final doctorsAsyncValue = ref.watch(doctorsByCityProvider(widget.city));
    final hospitalsAsyncValue = ref.watch(hospitalsByCityProvider(widget.city));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.city} All Doctors'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Doctors'),
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
              return hospitals.isNotEmpty
                  ? ListView.builder(
                itemCount: hospitals.length,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) => HospitalListTile(hospital: hospitals[index]),
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
