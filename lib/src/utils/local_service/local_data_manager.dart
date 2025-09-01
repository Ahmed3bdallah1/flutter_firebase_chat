import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../feature/data/models/user_model.dart';
import '../../service_locator.dart';

LocalDataManager dataManager = getIt<LocalDataManager>();

abstract class LocalDataManager {
  T? getValue<T>(String key);

  Future<void> setValue<T>(String key, T value);

  Future deleteValue(String key);

  bool contain(String key);

  Future init();

  Future<void> deleteUser();

  UserData? getUser();

  String? getUserId();

  Future<void> setUser(UserData userModel);

  Future<void> deleteFCMToken();

  String? getFCMToken();

  Future<void> setFCMToken(String? fcmToken);

  bool get isFirstTime;

  Future<void> setSecondTime();
}

abstract class GetStorageManager extends LocalDataManager {
  final GetStorage box = GetStorage("Chat_package_storage", null,);
  final printLog = false;

  @override
  T? getValue<T>(String key) {
    final T? value = box.read(key);
    if (printLog) Get.log("get Value $key => $value");
    return value;
  }

  @override
  bool contain(String key) {
    return box.hasData(key);
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    if (printLog) Get.log("set Value $key => $value");
    return box.write(key, value);
  }

  @override
  Future deleteValue(String key) {
    if (printLog) Get.log("Delete Value $key");
    return box.remove(key);
  }
}

class GetStorageManagerImpl extends GetStorageManager {

  @override
  Future<void> deleteUser() {
    return deleteValue("user");
  }

  @override
  String? getUserId() {
    return getValue<String>("id");
  }

  @override
  UserData? getUser() {
    final res= getValue("user");
    return UserData.fromJson(res);
  }

  @override
  Future<void> setUser(UserData userModel) {
    return setValue("user", userModel.toJson());
  }

  @override
  Future<void> deleteFCMToken() {
    return deleteValue("fcmToken");
  }

  @override
  String? getFCMToken() {
    return getValue<String>("fcmToken");
  }

  @override
  Future<void> setFCMToken(String? fcmToken) {
    return setValue("fcmToken", fcmToken);
  }

  @override
  bool get isFirstTime => getValue("secondTime") != true;

  @override
  Future<void> setSecondTime() {
    return setValue("secondTime", true);
  }

  @override
  Future<LocalDataManager> init() async {
    await GetStorage.init();
    // box.erase();
    return this;
  }
}
