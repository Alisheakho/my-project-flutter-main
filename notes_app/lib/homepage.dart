import 'package:flutter/material.dart';
import 'package:notes_app/sqlf.dart';
import 'package:jiffy/jiffy.dart';
import 'adding_note.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SqlDb hadisql = SqlDb();
  List all_notes = [];
  bool botn = false;
  List selectd = [];
  getData()async{
    all_notes = await hadisql.readData("SELECT * FROM 'notes'");
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: Text("Notes" , style:TextStyle(color: Colors.amber)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            if(botn) IconButton( 
              icon:  Icon(Icons.close),
              color: Colors.amber,
              onPressed: (){
                for(var i = 0 ; i < selectd.length ; i++){
                  if(selectd[i] == 999){
                    selectd[i] = all_notes[i]["id"];
                  }
                }
                botn = false;
                setState(() {});
              },
              ),
            if(botn) IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: ()async{
                for(var i = 0 ; i < selectd.length ; i++){
                  if(selectd[i] == 999){
                    var res = await hadisql.deleteData( 'DELETE FROM notes WHERE id = ${all_notes[i]["id"]} ' );
                  }
                };
                Navigator.pushNamed(context, "home");
              }
              ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: all_notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context,i){
              selectd.add(all_notes[i]["id"]);
              return InkWell(
                onTap: (){
                  //print(all_notes[i]["id"]);
                  if(botn){
                    selectd[i]= 999 ;
                    setState(() {});
                  }else{
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => AddingNote(
                        id: all_notes[i]["id"],
                        edit: true,
                        )
                      ) 
                    );
                  }
                },
                onLongPress: (){
                  selectd[i]= 999 ;
                  botn = true;
                  setState(() {});
                },
                child: Container(
                  
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectd[i]== 999 ? Colors.amber : Color.fromARGB(66, 204, 204, 204),
                      width: 3
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${all_notes[i]["title"]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              ),
                            ),
                            const Divider(),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${all_notes[i]['note']}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(color: Colors.black54,fontSize: 16),
                        ),
                      ),
                      const Divider(color: Colors.white,),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(Jiffy(all_notes[i]['deta_note']).fromNow(),
                          style: TextStyle(fontSize: 12,color: Colors.black54),
                          )
                        )
                  ],
                  ),
                ),
              );
            },
            ),
        ), 
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.white,size: 35,),
          onPressed: (() {
            Navigator.pushReplacementNamed(context, "adding_note");
          }),
        ),
      );
  }
}
