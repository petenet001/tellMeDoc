import '../entities/doctor_category.dart';
import '../repositories/doctor_repository.dart';

class GetDoctorCategoriesUsecase {
  final DoctorRepository repository;

  GetDoctorCategoriesUsecase(this.repository);

  Future<List<DoctorCategory>> call() async {
    return await repository.getDoctorCategories();
  }
}