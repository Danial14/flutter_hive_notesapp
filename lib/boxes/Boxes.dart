import 'package:hive/hive.dart';
import 'package:notes_app/model/notes_model.dart';

class Boxes{
  static Box<NotesModel> getBoxes(){
    return Hive.box<NotesModel>("notes");
  }
}