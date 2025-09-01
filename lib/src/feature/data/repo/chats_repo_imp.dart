import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../utils/errors/failure.dart';
import '../../domain/repo/chats_repo.dart';
import '../data_source/chats_data_soucre.dart';
import '../models/user_model.dart';

class ChatsRepoImpl implements ChatsRepo {
  final ChatsDataSource dataSource;

  ChatsRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure,bool>> sendMessage(UserModel? receiver, String message,{String? userId,String? userName}) async {
    try {
      if(receiver == null){
        final receiver = UserModel(id: int.parse(userId ?? "0"), name: userName ?? "Unknown", role: "user", isVerified: '1',);
        await dataSource.sendMessage(receiver, message);
      } else {
        await dataSource.sendMessage(receiver, message);
      }
      return Right(true);
    } catch (e) {
      return Left(GeneralError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, QuerySnapshot>> getMessages(String receiverId) async* {
    try {
      final stream = dataSource.getMessages(receiverId);
      yield* stream.map((snapshot) => Right<Failure, QuerySnapshot>(snapshot));
    } catch (e) {
      yield Left(GeneralError(e));
    }
  }

  @override
  Stream<Either<Failure, QuerySnapshot>> getChats() async* {
    try {
      final stream = dataSource.getChats();
      yield* stream.map((snapshot) => Right<Failure, QuerySnapshot>(snapshot));
    } catch (e) {
      yield Left(GeneralError(e));
    }
  }
}