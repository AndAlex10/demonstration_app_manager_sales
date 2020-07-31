import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';

class EstablishmentData {
  String id;
  String name;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String phone;
  String cnpj;
  String codePostal;
  String instagram;
  String longitude;
  String latitude;
  bool open;

  EstablishmentData();

  EstablishmentData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    address = document.data['address'];
    number = document.data['number'];
    neighborhood = document.data['neighborhood'];
    complement = document.data['complement'];
    city = document.data['city'];
    state = document.data['state'];
    phone = document.data['phone'];
    cnpj = document.data['cnpj'];
    codePostal = document.data['codePostal'];
    instagram = document.data['instagram'];
    longitude = document.data['longitude'];
    latitude = document.data['latitude'];
    open = document.data['open'];

  }


   void refreshAddress(PlacesDetailsResponse detail){
      latitude = detail.result.geometry.location.lat.toString();
      longitude = detail.result.geometry.location.lng.toString();
      for (var i = 0; i < detail.result.addressComponents.length; i++) {
        AddressComponent addressComponent =  detail.result.addressComponents[i];
        for (var h = 0; h <
            addressComponent.types.length; h++) {
          if (addressComponent.types[h] == 'street_number')
            number = addressComponent.longName;

          if (addressComponent.types[h] == 'route')
            address = addressComponent.longName;

          if (addressComponent.types[h] ==
              'sublocality_level_1')
            neighborhood = addressComponent.longName;

          if (addressComponent.types[h] ==
              'administrative_area_level_2')
            city = addressComponent.longName;

          if (addressComponent.types[h] ==
              'administrative_area_level_1')
            state = addressComponent.longName;

          if (addressComponent.types[h] == 'postal_code')
            codePostal = addressComponent.longName;
        }
      }

  }


  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "address": address,
      "number": number,
      "neighborhood": neighborhood,
      "complement": complement,
      "state": state,
      "city": city,
      "phone": phone,
      "codePostal": codePostal,
      "instagram": instagram,
      "cnpj": cnpj,
      "open": open,
      "latitude": latitude,
      "longitude": longitude

    };
  }
}