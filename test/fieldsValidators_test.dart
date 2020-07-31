
import 'package:flutter_test/flutter_test.dart';
import 'package:vendas_mais_manager/utils/validators.fields.dart';



void main(){
  test("Validation not found string", (){
    var result = FieldValidator.validateName("");
    expect(result, "Nome Inválido!");
  });

  test("Validation not valide email", (){
    var result = FieldValidator.validateEmail("email");
    expect(result, "Usuário inválido!");
  });

  test("Validation correct email", (){
    var result = FieldValidator.validateEmail("email@gmail.com");
    expect(result, null);
  });

  test("Not valide password", (){
    var result = FieldValidator.validatePassword("12");
    expect(result, "Senha inválida!");
  });

  test("Validation correct password", (){
    var result = FieldValidator.validatePassword("12345678");
    expect(result, null);
  });

  test("Not valide name", (){
    var result = FieldValidator.validateName("");
    expect(result, "Nome Inválido!");
  });

  test("Not valide phone", (){
    var result = FieldValidator.validatePhone("");
    expect(result, "Telefone inválido!");
  });

  test("Validation correct email", (){
    var result = FieldValidator.validatePhone("12345678");
    expect(result, null);
  });
}