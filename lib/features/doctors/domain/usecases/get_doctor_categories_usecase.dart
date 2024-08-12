import 'package:tell_me_doctor/features/doctors/domain/entities/doctor_category.dart';
import 'package:tell_me_doctor/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorCategoriesUsecase {
  final DoctorRepository repository;

  GetDoctorCategoriesUsecase(this.repository);

  Future<List<DoctorCategory>> call() async {
    return await repository.getDoctorCategories();
  }
}
