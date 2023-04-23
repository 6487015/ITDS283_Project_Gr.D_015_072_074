import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoList extends StatefulWidget {
  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todos = [];
  Map<String, bool> _completed = {};

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


 void _addTodoItem(String task) {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final userDocRef = _firestore.collection('users').doc(currentUser.uid);
      final taskCollectionRef = userDocRef.collection('tasks');
      taskCollectionRef.add({
      'task': task,
      'completed': false,
      'createdAt': DateTime.now(),
      });
    }
    setState(() {
      _todos.add(task);
      _completed[task] = false;
    });
  }

  void _removeTodoItem(int index, String docId) {
  final currentUser = _firebaseAuth.currentUser;
  if (currentUser != null) { //เอา task ออกจาก cloud
    final userDocRef = _firestore.collection('users').doc(currentUser.uid);
    final taskDocRef = userDocRef.collection('tasks').doc(docId);
    taskDocRef.delete();
  }
  setState(() { //เอา task ออกจาก _todos กับ _completed
    _completed.remove(_todos[index]);
    _todos.removeAt(index);
  });
  }

  Widget _buildTodoList() {
  final currentUser = _firebaseAuth.currentUser;
  if (currentUser != null) {
    final taskCollectionRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tasks');
    return StreamBuilder<QuerySnapshot>(
      stream: taskCollectionRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            _todos.clear();
            _completed.clear();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final docId = doc.id;
                _todos.add(data['task']);
                _completed[data['task']] = data['completed'];
                return _buildTodoItem(data['task'], index, docId);
              },
            );
        }
      },
    );
  } else {
    return Text('Please sign in');
  }
}


  Color getColor(Set<MaterialState> states) {
    const interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.yellow.shade100;
    }
    return Colors.black;
  }

  Widget _buildTodoItem(String todoText, int index, String docId) {
    bool isChecked = _completed[todoText] ?? false;
    return ListTile(
      title: Text(
        todoText,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            _completed[todoText] = value!;
          });
          final currentUser = _firebaseAuth.currentUser;
          if (currentUser != null) { //เก็บเครื่องหมายเช็คเข้า cloud
            final userDocRef = _firestore.collection('users').doc(currentUser.uid);
            final taskDocRef = userDocRef.collection('tasks').doc(docId);
            taskDocRef.update({'completed': value!});
          }
        },
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _promptRemoveTodoItem(index, docId),
      ),
    );
  }

  void _promptRemoveTodoItem(int index, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove "${_todos[index]}" ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                _removeTodoItem(index, docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 242, 125),
        title: Text('To Do List',
        style: TextStyle(color: Colors.pink)),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 242, 125),
        onPressed: _pushAddTodoScreen,
        child: Icon(
          Icons.add,
          color: Colors.pink,),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add New Task',
              style: TextStyle(
                color: Colors.pink
              ),),    
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}









