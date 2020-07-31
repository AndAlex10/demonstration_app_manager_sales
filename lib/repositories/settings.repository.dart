
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/settings.entity.dart';
import 'package:vendas_mais_manager/repositories/settings.repository.interface.dart';

class SettingsRepository implements ISettingsRepository {
  @override
  Future<SettingsData> getManagerServer() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();

    SettingsData settingsData = SettingsData.fromDocument(snapshot);
    return settingsData;
  }
}