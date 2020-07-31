
class ManagerEntity {
  String name;
  String idEstablishment;

  ManagerEntity();

  ManagerEntity.create(this.name);
  ManagerEntity.fromMap(Map data){
    this.name = data["name"];
    this.idEstablishment = data["idEstablishment"];
  }


  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "idEstablishment": this.idEstablishment
    };

  }
}