

import 'package:vendas_mais_manager/models/entities/settings.entity.dart';

abstract class ISettingsRepository {

  Future<SettingsData> getManagerServer();
}