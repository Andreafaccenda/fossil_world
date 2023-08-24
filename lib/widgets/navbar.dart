import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapbox_navigator/main.dart';
import 'package:mapbox_navigator/model/user_model.dart';
import 'package:mapbox_navigator/screens/auth/login_view.dart';

import '../screens/auth/auth_view_model.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  final viewModel = AuthViewModel();
  UserModel user = UserModel(userId: "", nome: "", email: "", password: "",lista_fossili: []);

  @override
  void initState() {
    super.initState();
    _getuser();
  }
  _getuser() async {
    var prefId = await viewModel.getIdSession();
    var user = await viewModel.getUserFormId(prefId);
    if (user != null) {setState(() {this.user=user;});}

    user?.lista_fossili!.add(fossili[0].id);
    viewModel.updateUser(user!);
  }

  @override
  Widget build(BuildContext context) {
      return Drawer(
        backgroundColor: Colors.grey[100],
        child: ListView(
          padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Username: ${user.nome}',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                accountEmail: Text('Email: ${user.email}',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              currentAccountPicture:  CircleAvatar(
                child: ClipOval(child: Image.asset('assets/image/profile.jpeg'),),
              ),
                decoration: const BoxDecoration(color:  Color.fromRGBO(210, 180, 140, 1),),),

              const ListTile(
                leading: Icon(Icons.backpack,color: Colors.black54,size: 30,),
                title: Text('Zaino',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                //onTap: () => print('Upload tapped'),
              ),
              const ListTile(
                leading: Icon(Icons.workspace_premium,color: Colors.black54,size: 30,),
                title: Text('Sfide',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                //onTap: () => print('Upload tapped'),
              ),
              const Divider(color: Colors.grey),
              const ListTile(
                leading: Icon(Icons.person_pin,color: Colors.black54,size: 30,),
                title: Text('Profilo',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                //onTap: () => print('Upload tapped'),
              ),
              const ListTile(
                leading: Icon(Icons.settings,color: Colors.black54,size: 30,),
                title: Text('Impostazioni',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                //onTap: () => print('Upload tapped'),
              ),
               const Divider(color: Colors.grey),
               ListTile(
                leading: const Icon(Icons.logout,color: Colors.black54,size: 30,),
                title: const Text('Esci',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                onTap: () async {
                  await viewModel.removeSession();
                  exit(0);
                },
              ),
            ],
        ),
      );
    }
}

