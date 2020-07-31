
import 'package:vendas_mais_manager/constants/error.message.constants.dart';

class ValidateResponse {
  bool success = false;
  String message;

  failConnect(){
    success = false;
    message = ErrorMessages.connectInternet;
  }
}