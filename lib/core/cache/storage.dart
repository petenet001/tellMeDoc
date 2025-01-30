abstract class StorageService {
  Future<void> save(String key, dynamic value);
  Future<String?> get(String key);
  Future<void> remove(String key);
  Future<void> clear();
}