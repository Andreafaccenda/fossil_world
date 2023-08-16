import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../screens/auth/auth_view_model.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final viewModel = AuthViewModel();
  UserModel user = UserModel(userId: "", nome: "", email: "", password: "");

  @override
  void initState() {
    super.initState();
    _getuser();
  }
  _getuser() async {
    var prefId = await viewModel.getIdSession();
    var user = await viewModel.getUserFormId(prefId);
    if (user != null) {setState(() {this.user=user;});}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:288,
        height: double.infinity,
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(CupertinoIcons.person,color: Colors.white,),
                ),
                title: Text('Username: ${user.nome}',style: const TextStyle(color: Colors.white),),
                subtitle: Text('Email: ${user.email}',style: const TextStyle(color: Colors.white),),
              ),
              Padding(padding: EdgeInsets.only(left: 24,top: 32,bottom: 16),
                child: Text('Browse'.toUpperCase(),style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),),),
              const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Divider(color: Colors.white24,height: 1,),
                  ),
                   ListTile(
                    leading: Icon(Icons.backpack,color: Colors.black54,size: 30,),
                    title: Text('Zaino',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.bold),),
                    //onTap: () => print('Upload tapped'),
                  ),

                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
