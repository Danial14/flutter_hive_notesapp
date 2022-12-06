import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/model/notes_model.dart';

import '../boxes/Boxes.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}
class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes app"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getBoxes().listenable(),
        builder: (ctx, box, _){
          var data = box.values.toList().reversed.cast<NotesModel>().toList();
          return ListView.builder(itemBuilder: (ctx, index){
            return Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(data[index].title),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            delete(data[index]);
                          },
                          child: Icon(Icons.delete, color: Colors.red,),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                        child: Icon(Icons.edit),
                          onTap: (){
                          _showMyEditDialog(data[index], data[index].title, data[index].description);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(data[index].description)
                  ],
                ),
              ),
            );
          },
          itemCount: box.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _showMyDialog() async{
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    return showDialog(barrierDismissible: false,context: context, builder: (ctx){
      return AlertDialog(
        title: Text("My notes"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "title",
                  border: OutlineInputBorder(

                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "description",
                    border: OutlineInputBorder(

                    )
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () async{
            var notesModel = NotesModel(title: titleController.text, description: descriptionController.text);
            var box = await Boxes.getBoxes();
            await box.add(notesModel);
            notesModel.save();
            print(box);
            titleController.clear();
            descriptionController.clear();
            Navigator.of(context).pop();
          }, child: Text("Add")),
          TextButton(onPressed: () async{
            Navigator.of(context).pop();
          }, child: Text("Edit"))
        ],
      );
    });
  }
  void delete(NotesModel notesModel) async{
    await notesModel.delete();
  }
  Future<void> _showMyEditDialog(NotesModel notesModel, String title, String description) async{
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(barrierDismissible: false,context: context, builder: (ctx){
      return AlertDialog(
        title: Text("My notes"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "title",
                  border: OutlineInputBorder(

                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "description",
                    border: OutlineInputBorder(

                    )
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () async{
            Navigator.of(context).pop();
          }, child: Text("Cancel")),
          TextButton(onPressed: () async{
            //var notesModel = NotesModel(title: titleController.text, description: descriptionController.text);
            //var box = await Boxes.getBoxes();
            notesModel.title = titleController.text;
            notesModel.description = descriptionController.text;
            notesModel.save();
            //print(box);
            titleController.clear();
            descriptionController.clear();
            Navigator.of(context).pop();
          }, child: Text("Edit"))
        ],
      );
    });
  }
}