import 'package:geocoding/geocoding.dart';

String? validateEmail(String? value){
  if(value == null || value.isEmpty){
    return 'indirizzo email richiesto!';
  }else if(!value.contains('@') || !value.contains('.')){
    return 'indirizzo email non valido';
  }
  return null;
}

String? validateName(String? value){
  if(value == null || value.isEmpty){
    return 'nome richiesto!';
  }
  return null;
}

String? validatePassword(String? value){
  if(value == null || value.isEmpty){
    return 'password richiesta!';
  }else if(value.length <= 5){
    return 'password non valida';
  }
  return null;
}

String? validateConfirmPassword(String? value) {
  if(value == null || value.isEmpty){
    return 'per favore ripeti la password!';
  }
  return null;
}