import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_navigator/model/fossil.dart';
import 'package:mapbox_navigator/screens/fossili/dettagli_fossile.dart';
import 'package:mapbox_navigator/screens/fossili/fossil_view_model.dart';
import '../../main.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';


class FossilsList extends StatefulWidget {
  const FossilsList({Key? key}) : super(key: key);

  @override
  State<FossilsList> createState() => _FossilsListState();
}

class _FossilsListState extends State<FossilsList> {

  final viewModel = FossilViewModel();
  late List<FossilModel> lista_fossili;

  @override
  void initState() {
    super.initState();
    lista_fossili = fossili;
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
      height: 550,
      child: ListView.separated(
        itemCount: lista_fossili.length,
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
                          child: Image.network(lista_fossili[index].immagine.toString(),
                            fit: BoxFit.cover,),
                        ),),
                      const SizedBox(width: 10 ,),
                      AspectRatio(aspectRatio: 4/3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(lista_fossili[index].nome.toString(),style: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.bold),),
                            const SizedBox(height: 2,),
                            Text("${lista_fossili[index]
                                .descrizione}",style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 5,),
                            cardButtons(Icons.location_on, 'Map'),
                            ],),),
                      const SizedBox(width: 27,),
                      IconButton(onPressed: (){
                        Get.to(
                        DettagliFossile(model: lista_fossili[index]));},
                          icon: const Icon(Icons.arrow_circle_right_sharp,color:Color.fromRGBO(210, 180, 140, 1),size: 30,)),
                    ],),),),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(width: 20,),),
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
      lista_fossili = listaFiltrata;
    });
  }

  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        customAlertDialog(context),);
  }
}





