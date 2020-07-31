import "package:dart_amqp/dart_amqp.dart";
import 'package:vendas_mais_manager/models/entities/settings.entity.dart';
import 'package:vendas_mais_manager/repositories/settings.repository.dart';
import 'package:vendas_mais_manager/repositories/settings.repository.interface.dart';
class RabbitMQConfig{

  ISettingsRepository settingsRepository;

  RabbitMQConfig(){
    settingsRepository = new SettingsRepository();
  }
  Future<ConnectionSettings> connect() async{
    SettingsData settingsData = await settingsRepository.getManagerServer();
    ConnectionSettings settings = ConnectionSettings(
        host : settingsData.urlMQ,
        authProvider : new PlainAuthenticator(settingsData.userMQ, settingsData.passwordMQ)
    );

    return settings;
  }
}