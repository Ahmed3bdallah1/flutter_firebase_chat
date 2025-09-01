import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../utils/errors/failure.dart';
import '../../data/models/user_model.dart';

abstract class ChatsRepo {
  Future<Either<Failure,bool>> sendMessage(UserModel? receiver, String message,{String? userId,String? userName});
  Stream<Either<Failure,QuerySnapshot>> getMessages(String receiverId);
  Stream<Either<Failure,QuerySnapshot>> getChats();
}