/// Central registry for Hive type IDs to avoid collisions across models.
abstract class HiveTypeIds {
  HiveTypeIds._();

  static const int hiveUser = 0;
  static const int appSettings = 1;
  static const int userModel = 2;
}
