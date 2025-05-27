import 'package:aurelius/models/task.dart';
import 'package:hive_ce/hive.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 3;

  @override
  Category read(BinaryReader reader) {
    return Category.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.write(obj.index);
  }
}
