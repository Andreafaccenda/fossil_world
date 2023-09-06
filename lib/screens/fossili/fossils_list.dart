import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_navigator/model/fossil.dart';
import 'package:mapbox_navigator/model/user_model.dart';
import 'package:mapbox_navigator/screens/fossili/dettagli_fossile.dart';
import 'package:mapbox_navigator/screens/fossili/fossil_view_model.dart';
import '../../main.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';
import 'fossil_polyline.dart';
import '../ar_flutter/guideToCatchFossil.dart';
import '../auth/auth_view_model.dart';

late UserModel user;
class FossilsList extends StatefulWidget {
  const FossilsList({Key? key}) : super(key: key);

  @override
  State<FossilsList> createState() => _FossilsListState();
}

class _FossilsListState extends State<FossilsList> {

  final viewModel = FossilViewModel();
  late List<FossilModel> lista;
  final viewModelAuth = AuthViewModel();

  @override
  void initState(){
    super.initState();
    lista = fossili;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: WillPopScope(onWillPop: showExitDialog,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  searchText(),
                  const SizedBox(height: 15),
                  _listViewFossils(),
                ],
              ),
            ),
          )),
      ),);
  }
  Widget _listViewFossils() {
    return SizedBox(
      height: 600,
      child: ListView.separated(
        itemCount: lista.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
            },
            child: Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 20),
              child: AspectRatio(
                aspectRatio: 3/1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      AspectRatio(aspectRatio: 1/1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(lista[index].immagine.toString(),
                            fit: BoxFit.cover,),
                        ),),
                      const SizedBox(width: 10 ,),
                      AspectRatio(aspectRatio: 4/3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(lista[index].nome.toString(),style: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.bold),),
                            const SizedBox(height: 2,),
                            Text("${lista[index]
                                .descrizione}",style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(onTap: () {
                                  Get.to(FossilPolyline(model: lista[index]));
                                },
                                  child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                                    child:  Column(
                                      children: [
                                        Image.asset('assets/image/icon_location.png',height: 30,color: black54,),
                                      ],
                                    ),),),
                                const SizedBox(width: 15,),
                                GestureDetector(onTap: () {
                                  Get.to(GuideToCatchFossil(model: lista[index],));
                                },
                                  child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                                    child:  Column(
                                      children: [
                                        Image.asset('assets/image/pickage.png',height: 30,),
                                      ],
                                    ),),),
                              ],
                            ),
                            ],),),
                      const SizedBox(width: 27,),
                      GestureDetector(onTap:() {Get.to(DettagliFossile(model: lista[index]));},
                        child: Image.asset('assets/image/arrow.png',height: 30,color: black54,),
                        ),
                    ],),),),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(width: 20,),),
    );
  }
  Widget cardButtons(String path) {
    return SizedBox(
      width: 45,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(7),
            minimumSize: Size.zero,
            backgroundColor: marrone,
          ),
          child: Image.asset(path,height: 20,color: white,),
        ),

    );
  }
  Widget searchText(){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.0, offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )],),
        child: TextFormField(onChanged: (value) =>{filtraLista(value), setState(() {}), },
          decoration: const InputDecoration(hintText: 'Ricerca fossili', hintStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400), border: InputBorder.none, prefixIcon: Icon(Icons.search, color: Colors.black54,),), style: const TextStyle(color: Colors.black54),),),);
    }
  void filtraLista(String text) {
    List<FossilModel> listaCompleta = viewModel.fossilModel;
    List<FossilModel> listaFiltrata = [];
    for (int i = 0; i < listaCompleta.length; i++) {
      if (listaCompleta[i].nome.toString().toLowerCase().startsWith(
          text.toLowerCase())) {
        listaFiltrata.add(listaCompleta[i]);
      }
    }
    setState(() {
      lista = listaFiltrata;
    });
  }

  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        customAlertDialog(context),);
  }
}





