import 'package:vendas_mais_manager/models/entities/payments.entity.dart';
import 'package:vendas_mais_manager/models/response/validate.response.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.dart';
import 'package:vendas_mais_manager/components/connect.component.dart';
import 'package:vendas_mais_manager/repositories/payment.repository.interface.dart';
import 'package:vendas_mais_manager/view_model/payment.view.model.dart';

class PaymentController {
  IPaymentRepository repository;
  ConnectComponent connect;

  PaymentController(){
    repository = new PaymentRepository();
    connect = new ConnectComponent();
  }

  PaymentController.tests(this.repository, this.connect);

  Future<PaymentViewModel> getAll(String id) async {
    PaymentViewModel viewModel = PaymentViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(id);
    }
    return viewModel;
  }

  Future<ValidateResponse> update(String idEstablishment, Payments data, bool active) async{
    var response = new ValidateResponse();
    if(await connect.checkConnect()) {
      data.active = active;
      repository.update(idEstablishment, data);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }
}