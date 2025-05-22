import 'package:aurelius/models/task.dart';
import 'package:aurelius/models/user.dart';
import 'package:hive_ce/hive.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final username = reader.read() as String;
    final uid = reader.read() as String;
    final email = reader.read() as String;
    final tasks = (reader.read() as List).cast<TaskModel>();
    return UserModel(username: username, uid: uid, email: email, tasks: tasks);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.write(obj.username);
    writer.write(obj.uid);
    writer.write(obj.email);
    writer.write(obj.tasks);
  }
}
