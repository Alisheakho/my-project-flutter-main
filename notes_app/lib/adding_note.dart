import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notes_app/sqlf.dart';
import 'dart:ffi';
class AddingNote extends StatefulWidget {
  const AddingNote({super.key, required this.id, required this.edit});
  final int id ;
  final bool edit ;
  @override
  State<AddingNote> createState() => _AddingNoteState(id: id,edit: edit);
}

class _AddingNoteState extends State<AddingNote> {
   _AddingNoteState({required this.id, required this.edit});

  final bool edit;
  final int id;

  SqlDb sqldb  = SqlDb();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  DateTime dtime = DateTime.now();

  String times = "2003-1-1";
  getdata() async{
    var note_edit = await sqldb.readData('SELECT * FROM notes WHERE id = $id');
    //print(note_edit[0]["title"]);
    title.text = note_edit[0]["title"];
    note.text = note_edit[0]["note"];
    times = note_edit[0]["deta_note"] ;
    setState(() {});
  }


  @override
  void initState() {
    if (edit){
      getdata();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  Colors.transparent ,
        shadowColor: Colors.transparent,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.done), 
              onPressed: () async {
                if(!edit){
                  var respons = await sqldb.insertData("""
                  INSERT INTO 'notes' (title,note,deta_note) 
                  VALUES ('${title.text}','${note.text}','$dtime') 
                  """);
                  //print(respons);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "home");
                }else{
                  var rs = await sqldb.updateData("""
                  UPDATE notes SET
                  title = '${title.text}',
                  note = '${note.text}',
                  deta_note = '$dtime'
                  WHERE id = $id
                  """);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "home");
                }
              }, 
              ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                child: Text(Jiffy(edit ? "$times" :"$dtime").fromNow(),style: TextStyle(fontSize: 11),),
                alignment: Alignment.centerLeft,),
              TextFormField(
                controller: title,
                minLines: 1,
                cursorRadius: const Radius.circular(99),
                cursorWidth: 3,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600
                ),
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(fontWeight: FontWeight.normal),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                ),
              ),
              const Divider(),
              TextFormField(
                controller: note,
                cursorRadius: const Radius.circular(99),
                cursorWidth: 2,
                cursorHeight: 20,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Start typing",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}