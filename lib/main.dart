import 'package:flutter/material.dart';
import 'package:nexus_finance/screens/create_screen.dart';
import 'package:nexus_finance/screens/update_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nexus Finance",
      home: MyHomePage(),
    ); 
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // DatabaseInstance? databaseInstance;
  // @override
  // void initState() {
  //   databaseInstance = DatabaseInstance();
  //   initDatabase();
  //   super.initState();
  // }

  // Future initDatabase(){
  //   await databaseInstance!.database();
  //   setState((){});
  // }

  showAlertDialog(BuildContext contex){
    Widget okButtonn = TextButton(
      child: Text("Yakin"),
      onPressed: (){

      },
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan!"),
      content: Text("Anda yakin akan menghapus ?"),
      actions: [okButtonn],
    );

    showDialog(
      context: contex, 
      builder: (BuildContext context){
      return alertDialog;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home nexus finance"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CreateScreen()));
            },
            )
          ],
      ),
      body: SafeArea(
          child: Column(
      children: [
        SizedBox(height: 20,),
        Text("Total pemasukkan :  Rp. 10000"),
        SizedBox(height: 20,),
        Text("Total pengeluaran : Rp. 1000"),
        ListTile(
          title: Text("Makan Siang"),
          subtitle: Text("Rp. 500"),
          leading: Icon(
            Icons.download,
            color: Colors.green,
            ),
            trailing: Wrap(
              children: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=> UpdateScreen()));
              }, 
              icon: Icon(Icons.edit,
              color: Colors.grey,)),
              SizedBox(
                width: 20,
                ),
              IconButton(onPressed: (){
                showAlertDialog(context);
              }, icon: Icon(Icons.delete, color: Colors.red,))
              ],
            )),
        ],
      )),
    );
  }
}