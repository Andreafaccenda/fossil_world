import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mapbox_navigator/model/fossil.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../widgets/costanti.dart';
import '../auth/auth_view_model.dart';

class FossilBag extends StatefulWidget {
  const FossilBag({Key? key}) : super(key: key);

  @override
  State<FossilBag> createState() => _FossilBagState();
}

class _FossilBagState extends State<FossilBag> {
  final viewModel = AuthViewModel();
  late UserModel user;
  List<FossilModel> fossili_catturati = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    print("Size: ${fossili_catturati.length}");
  }

  _getUser()async{
    List<FossilModel> lista = [];
    var prefId = await viewModel.getIdSession();
    user = (await viewModel.getUserFormId(prefId))!;
    for(var id in user.lista_fossili ?? <String>[]) {
      for(var fossile in fossili){
        if(fossile.id == id){
          lista.add(fossile);
        }
      }
    }
    setState(() {
      fossili_catturati = lista;
    });

  }

  Widget builtCard(int index){
    return  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: white,
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0,3),
        )],),
      width: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.asset('assets/image/fossil.png',height: 150,scale: 0.7,),
            ),
            Text(fossili_catturati[index].nome.toString(),style: TextStyle(color: marrone,fontSize: 20,fontWeight: FontWeight.w700),),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/icon_location.png',height: 20,color: marrone,),
                Text(fossili_catturati[index].indirizzo.toString(),
                  overflow: TextOverflow.ellipsis,style:  TextStyle(
                      color: marrone,fontWeight: FontWeight.w500, fontSize: 12),),
              ],
            ),
            const SizedBox(height: 6,),
            RatingBar.builder(
                initialRating:4,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 16,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) =>Icon(
                  Icons.star,
                  color: Colors.red,
                ),
                onRatingUpdate: (index) {})
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey300,
      body: ListWheelScrollView.useDelegate(
                itemExtent: 265,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 0.8,
                /*onSelectedItemChanged: (index) =>
        showToast('Selected item: $index'),*/
                squeeze: 0.95,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: fossili_catturati.length,
                  builder: (context,index) => builtCard(index),
                )
            ),
    );
  }
}
