
import 'package:vendas_mais_manager/enums/cielo.card.status.enum.dart';

class CieloResponse {
  bool success = false;
  String message;

  CieloResponse(String status){
    success = CieloStatusReturn.verifyProcess(status);
    message = CieloStatusReturn.messageReturn(status);
  }
}