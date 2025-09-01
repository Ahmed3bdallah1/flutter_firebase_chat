import 'package:flutter_firebase_chat/src/feature/data/data_source/chats_data_soucre.dart';
import 'package:flutter_firebase_chat/src/feature/data/models/user_model.dart';
import 'package:flutter_firebase_chat/src/feature/data/repo/chats_repo_imp.dart';
import 'package:flutter_firebase_chat/src/feature/domain/repo/chats_repo.dart';
import 'package:flutter_firebase_chat/src/utils/local_service/local_data_manager.dart';
import 'package:flutter_firebase_chat/src/utils/style.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class ChatServiceInit {
  static UserData _userUser = UserData(id: 1);
  static Style _style = Style();

  static void initialize({required UserData userData, Style? style}) {
    ChatServiceInit._userUser = userData;
    ChatServiceInit._style = style ?? Style();

    dataManager.setUser(userData);
  }

  UserData? get userModel => ChatServiceInit._userUser;

  Style get style => ChatServiceInit._style;
}

Future flutterFirebaseChatLocator() async {
  final local = await GetStorageManagerImpl().init();
  getIt.registerSingleton<LocalDataManager>(local);

  getIt.registerLazySingletonAsync<ChatsDataSource>(() async {
    await getIt.isReady<LocalDataManager>();
    return ChatServices();
  });

  getIt.registerLazySingleton<ChatsRepo>(
    () => ChatsRepoImpl(dataSource: getIt<ChatsDataSource>()),
  );
}
