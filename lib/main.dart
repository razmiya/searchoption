import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//
// // Mock user data
// List<Map<String, dynamic>> users = [
//   {"id": 1, "name": "leanne graham", "username": "Bret", "lastLoggedIn": "2024-05-01"},
//   {"id": 2, "name": "User 2", "status": "Inactive", "lastLoggedIn": "2024-04-30"},
//   {"id": 3, "name": "User 3", "status": "Active", "lastLoggedIn": "2024-05-03"},
//   // Add more users as needed
// ];


void main() {
  runApp(MyApp());
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CONVERSATIONS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<User> _users = [];
  late List<User> _filteredUsers = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _users = data.map((userJson) => User.fromJson(userJson)).toList();
        _filteredUsers = _users;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONVERSATIONS'),
        actions: [
          IconButton(
            icon: Icon(Icons.add,),
            onPressed: () {
              // Add your action here
              print('Add button pressed');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(
                    child: Text(user.id.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profiles',
          ),
        ],
      ),
    );
  }
}
