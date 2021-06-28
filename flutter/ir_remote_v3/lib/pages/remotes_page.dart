import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ir_remote_v3/pages/devices_page.dart';
import 'package:ir_remote_v3/pages/config_remote_page.dart';
import 'package:ir_remote_v3/pages/pages.dart';
import 'package:ir_remote_v3/pages/paired_devices_page.dart';
import 'package:ir_remote_v3/pages/receive_remote_page.dart';
import 'package:ir_remote_v3/pages/send_remote_page.dart';
import 'package:sqflite/sqflite.dart';
import '../Storage.dart';
import '../remote.dart';

const bottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(10),
  ),
);

class RemotesPage extends StatefulWidget{
  final Database database;
  const RemotesPage({Key? key, required this.database}) : super(key: key);
  @override
  _RemotesPageState createState() => _RemotesPageState();
}
class _RemotesPageState extends State<RemotesPage> {
  RemoteDb? remoteDb;
  var renameController = TextEditingController();
  var renameRemoteFormKey = GlobalKey<FormState>();
  var addRemoteFormKey = GlobalKey<FormState>();

  var selectedRemoteTypeIndex = 0; // for add remote
  var remotes = <Remote>[];

  @override initState(){
    super.initState();
    remoteDb = RemoteDb(widget.database);
    refreshRemotes(0);
  }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showMenu(addButtonOptionsMenu),
            tooltip: 'new remote',
          ),  // add button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: goToSettingsScreen,
            tooltip: 'settings',
          ),  // settings button
        ],
      ),
      body: ListView(
        children: [
          remotes.length > 0 ?
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) => Let(
              let: remotes[index],
              builder: (Remote remote) => ListTileTheme(
                style: ListTileStyle.list,
                child: ListTile(
                  // selected: remote.selected,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    child: Icon(
                      remote.remoteType == RemoteType.ac ? Icons.ac_unit :
                      remote.remoteType == RemoteType.music_player ? Icons.music_note :
                      Icons.tv,),
                  ),
                  title: Text(remote.name),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => showMenu(() => remoteOptionMenu(remote)),
                  ),
                  onTap: (){
                    Storage.address.then((value) {
                      {
                        Navigator
                            .of(context)
                            .push(
                            MaterialPageRoute(builder: (_) =>
                            value.isNotEmpty ?
                            RemotePage(remote: remote,) :
                            DevicesPage(),),);
                      }
                    });
                  },
                  // onLongPress: (){
                  //   setState(() {
                  //     remote.selected = !remote.selected;
                  //   });
                  //   Clipboard.setData(ClipboardData(text: json.encode(remote.toMap())));
                  //   Clipboard.getData('text/plain').then((value) => print(value!.text));
                  // },
                ),
              ),
            ),
            itemCount: remotes.length,
          ) : // remotes list
          ListView(
            shrinkWrap: true,
            children: [
              addRemoteTile(showAddScreen),
              receiveTile(goToReceiveScreen),
            ],
          ),
          Divider(indent: 0, endIndent: 0, color: Colors.white38), //suggestion separator
          ListTile(
            dense: true,
            leading: Icon(Icons.info_outlined,),
            title: Text(
              remotes.length > 0 ?
              'Select to open remote' :
              'No remotes found, try creating one',
              style: Theme.of(context).textTheme.caption,),
          ),  // suggestion
        ],
      ),
    );
  }
  //options tile
  ListTile receiveTile(void Function()? onTap){
    return ListTile(
      // leading: Icon(Icons.sync_alt),
      leading: Icon(Icons.file_download_outlined),
      title: Text('Receive from other device'),
      onTap: onTap,
    );
  }
  ListTile addRemoteTile(void Function()? onTap){
    return ListTile(
      leading: Icon(Icons.add),
      title: Text('Add new Remote'),
      onTap: onTap,
    );
  }
  ListTile remoteTitleTile(Remote remote){
    return ListTile(
      leading: Icon(
        remote.remoteType == RemoteType.ac ?
        Icons.ac_unit :
        remote.remoteType == RemoteType.music_player ?
        Icons.music_note :
        Icons.tv,
        color: Theme.of(context).colorScheme.primary,),
      title: Text(remote.name),
    );
  }
  ListTile deleteConfirmTile(Remote remote){
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Delete'),
      onTap: () => remoteDb!.delete(remote)!.then(refreshRemotes).then((value) => Navigator.pop(context)),
    );
  }
  ListTile cancelTile(){
    return ListTile(
      leading: Icon(Icons.close),
      title: Text('Cancel'),
      onTap: (){
        Navigator.pop(context);
      },
    );
  }
  // show bottom sheet
  void showMenu(List<Widget> Function() children, {ShapeBorder? shape}){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: shape ?? bottomSheetShape,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children(),
        ),
      ),
    );
  }

  //menu
  // remote options
  List<Widget> remoteOptionMenu(Remote remote){
    return [
      remoteTitleTile(remote), //title
      Divider(),
      ListTile(
        leading: Icon(Icons.drive_file_rename_outline_rounded),
        title: Text('Rename'),
        onTap: () {
          Navigator.pop(context);
          renameController.text = remote.name;
          showMenu(() => renameMenu(remote));
        },
      ),  // rename
      ListTile(
        leading: Icon(Icons.share),
        title: Text('Send'),
        onTap: () => goToSendScreen(remote), //send
      ),  // send
      ListTile(
        leading: Icon(Icons.tune),
        title: Text('Configure'),
        onTap: () => goToEditScreen(remote),
      ),  // edit
      ListTile(
        leading: Icon(Icons.delete),
        title: Text('Delete'),
        onTap: () {
          Navigator.pop(context);
          showMenu(() => deleteMenu(remote));
        },
      ),  // delete
    ];
  }
  List<Widget> renameMenu(Remote remote) {
    return [
      Form(
        key: renameRemoteFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextFormField(
            controller: renameController,
            decoration: InputDecoration(
              hintText: 'Remote name',
              errorStyle: TextStyle(
                color: Colors.red[300],
              ),
              hintStyle: TextStyle(color: Colors.white70),
              isDense: true,
            ),
            autofocus: true,
            validator: (value){
              if (value!.isEmpty) return 'This field cannot be empty';
              else{
                remoteDb!
                    .update(remote .. name = value)!
                    .then(refreshRemotes)
                    .then((value) => Navigator.pop(context));
                return null;
              }
            },
          ),
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.drive_file_rename_outline_rounded),
        title: Text('Rename'),
        onTap: ()=> renameRemoteFormKey.currentState!.validate(),
      ),
      cancelTile(),
    ];
  }
  List<Widget> deleteMenu(Remote remote) {
    return [
      ListTile(
        title: Text('Delete remote?'),
      ),
      Divider(),
      deleteConfirmTile(remote),
      cancelTile(),
    ];
  }

  //add button menu
  List<Widget> addButtonOptionsMenu(){
    return [
      addRemoteTile(showAddScreenOnBack),
      receiveTile(goToReceiveScreenOnBack),
    ];
  }
  List<Widget> addScreen(){
    return [
      Divider(),
      Form(
        key: addRemoteFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Remote name',
                  suffixIcon: Icon(Icons.edit_rounded),
                  prefixIcon: Icon(Icons.title),
                  errorStyle: TextStyle(
                    color: Colors.red[300],
                  ),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                validator: (value){
                  if (value!.isEmpty) return 'This field cannot be empty';
                  remoteDb!
                      .add(Remote.newRemote(value, RemoteType.values[selectedRemoteTypeIndex]))!
                      .then(refreshRemotes)
                      .then((value) => Navigator.pop(context));
                  return null;
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: DropdownButtonFormField(
                value: remoteTypes[selectedRemoteTypeIndex],
                decoration: InputDecoration(
                  hintText: 'Remote type',
                  prefixIcon: Icon(Icons.settings_remote),
                ),
                items: remoteTypes.map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                )).toList(),
                onChanged: (value) =>
                    setState(() => selectedRemoteTypeIndex = remoteTypes.indexOf(value.toString())),
              ),
            ),
          ],
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.add),
        title: Text('Add'),
        onTap: ()=> addRemoteFormKey.currentState!.validate(),
      ),
      ListTile(
        leading: Icon(Icons.close),
        title: Text('Cancel'),
        onTap: ()=> Navigator.pop(context),
      ),
    ];
  }
  //show screens
  showAddScreen(){
    showMenu(addScreen);
  }
  showAddScreenOnBack(){
    Navigator.pop(context);
    showMenu(addScreen);
  }
  goToReceiveScreen(){
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (_) => ReceiveRemotePage(), fullscreenDialog: true))
        .then((value) => value == null ? print('error') : (value as List)
        .forEach((element) => remoteDb!.add(element as Remote)!.then(refreshRemotes)));
  }
  goToReceiveScreenOnBack(){
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) =>
        ReceiveRemotePage(), fullscreenDialog: true))
        .then((value) => value == null ? print('error') : (value as List)
        .forEach((element) => remoteDb!.add(element as Remote)!.then(refreshRemotes)));
  }
  goToSendScreen(Remote remote){
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) =>
        SendRemotePage(remotes: [remote],), fullscreenDialog: true,),)
        .then((value) => ScaffoldMessenger
        .of(context)
        .showSnackBar(
        SnackBar(content: Text(value != null && value == true ? 'send success' : 'send cancelled'))));
  }
  goToEditScreen(Remote remote){
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => ConfigRemotePage(remote: remote,), fullscreenDialog: true,),)
        .then((value) {
          if(value !=null) {
            print('new settings');
            print(remote.toMap());
            // updateRemote(remote);
            remoteDb!.update(remote)!.then(refreshRemotes);
          }
        });
  }
  goToSettingsScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PairedDevicesPage(),
      ),
    );
  }
  // database operations
  refreshRemotes(_)=> remoteDb?.remotes()!.then((value) => setState(() => remotes = value));
}

class RemoteDb{
  final Database? database;
  final String table = 'remotes';
  RemoteDb(this.database);
  Future<int>? clear()=> database?.delete(table);
  Future<List<Remote>>? remotes()=> database
      ?.query('remotes')
      .then((value) => value
      .map((e) => Remote.fromDynamic(e))
      .toList());
  Future<int>? update(Remote remote)=> database
      ?.update('remotes', remote.toMap(), where: 'id = ?', whereArgs: [remote.id]);
  Future<int>? delete(Remote remote)=> database
      ?.delete('remotes', where: 'id = ?', whereArgs: [remote.id]);
  Future<int>? add(Remote remote)=> database
      ?.insert('remotes', remote.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
}

