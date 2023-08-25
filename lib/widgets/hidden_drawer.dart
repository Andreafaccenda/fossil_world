
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_navigator/screens/fossili/fossils_map.dart';

import '../main.dart';
import '../model/user_model.dart';
import '../screens/auth/auth_view_model.dart';
import '../screens/location.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  final viewModel = AuthViewModel();
  UserModel user = UserModel(userId: "", nome: "", email: "", password: "",lista_fossili: []);
  List<ScreenHiddenDrawer> _pages = [];



  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(ItemHiddenMenu(
        baseStyle: TextStyle(
          color: Colors.white,
        ),
        selectedStyle: TextStyle(color: Colors.white), name: 'Homepage',
      ),
      const Location(),
      ),
    ];
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
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromRGBO(210, 180, 140, 1),
      screens: _pages,
      initPositionSelected: 0,

    );
  }
}
