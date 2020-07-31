
enum StatusOrder {
  PENDING,
  IN_PRODUCTION,
  READY_FOR_DELIVERY,
  DELIVERY_ARRIVED_ESTABLISHMENT,
  OUT_FOR_DELIVERY,
  DELIVERY_ARRIVED_CLIENT,
  CONCLUDED,
  CANCELED
}

class StatusOrderText {

  static String getTitle(StatusOrder status){
    switch (status){
      case StatusOrder.PENDING: {
        return "PENDENTE";
      }
      case StatusOrder.IN_PRODUCTION: {
        return "EM PRODUÇÃO";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "PRONTO PARA RETIRADA";
      }
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "ENTREGADOR CHEGOU NO ESTABELECIMENTO";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "SAIU PARA ENTREGA";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "ENTREGADOR CHEGOU NO CLIENTE";
      }
      case StatusOrder.CONCLUDED: {
        return "CONCLUÍDO";
      }
      case StatusOrder.CANCELED: {
        return "CANCELADO";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

  static String getNextStatus(StatusOrder status){
    switch (status){
      case StatusOrder.IN_PRODUCTION: {
        return "PRONTO PARA RETIRADA";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "ESPERANDO ENTREGADOR";
      }
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "ENTREGADOR CHEGOU NO ESTABELECIMENTO";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "ENTREGADOR CHEGOU NO CLIENTE";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "SAIU PARA ENTREGA";
      }
      default: {
        return "NOT FOUND";
      }

    }
  }

  static String getTitleNotify(StatusOrder status){
    switch (status){
      case StatusOrder.IN_PRODUCTION: {
        return "Seu Pedido está em produção!";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "Pedido está pronto para entrega!";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "Seu Pedido saiu para entrega!";
      }
      case StatusOrder.CONCLUDED: {
        return "Seu Pedido foi entregue!";
      }
      case StatusOrder.CANCELED: {
        return "Seu Pedido foi rejeitado!";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

  static String getSubjectNotify(StatusOrder status, String codeOrder){
    switch (status){
      case StatusOrder.IN_PRODUCTION: {
        return "Seu Pedido $codeOrder está em produção!";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "Seu Pedido $codeOrder está pronto para entrega!";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "Seu pedido $codeOrder saiu para entrega!";
      }
      case StatusOrder.CONCLUDED: {
        return "Seu Pedido $codeOrder foi entregue!";
      }
      case StatusOrder.CANCELED: {
        return "Seu pedido $codeOrder foi rejeitado!";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

}