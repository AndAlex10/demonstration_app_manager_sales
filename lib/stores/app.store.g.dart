// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$countOrderPendingAtom = Atom(name: '_AppStore.countOrderPending');

  @override
  int get countOrderPending {
    _$countOrderPendingAtom.reportRead();
    return super.countOrderPending;
  }

  @override
  set countOrderPending(int value) {
    _$countOrderPendingAtom.reportWrite(value, super.countOrderPending, () {
      super.countOrderPending = value;
    });
  }

  final _$fbMessagingAtom = Atom(name: '_AppStore.fbMessaging');

  @override
  FirebaseMessaging get fbMessaging {
    _$fbMessagingAtom.reportRead();
    return super.fbMessaging;
  }

  @override
  set fbMessaging(FirebaseMessaging value) {
    _$fbMessagingAtom.reportWrite(value, super.fbMessaging, () {
      super.fbMessaging = value;
    });
  }

  final _$managerAtom = Atom(name: '_AppStore.manager');

  @override
  ManagerEntity get manager {
    _$managerAtom.reportRead();
    return super.manager;
  }

  @override
  set manager(ManagerEntity value) {
    _$managerAtom.reportWrite(value, super.manager, () {
      super.manager = value;
    });
  }

  final _$establishmentAtom = Atom(name: '_AppStore.establishment');

  @override
  EstablishmentData get establishment {
    _$establishmentAtom.reportRead();
    return super.establishment;
  }

  @override
  set establishment(EstablishmentData value) {
    _$establishmentAtom.reportWrite(value, super.establishment, () {
      super.establishment = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$orderListAtom = Atom(name: '_AppStore.orderList');

  @override
  List<OrderData> get orderList {
    _$orderListAtom.reportRead();
    return super.orderList;
  }

  @override
  set orderList(List<OrderData> value) {
    _$orderListAtom.reportWrite(value, super.orderList, () {
      super.orderList = value;
    });
  }

  final _$loadCurrentUserAsyncAction = AsyncAction('_AppStore.loadCurrentUser');

  @override
  Future<bool> loadCurrentUser() {
    return _$loadCurrentUserAsyncAction.run(() => super.loadCurrentUser());
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setLoading(bool loading) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setManager(ManagerEntity manager) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setManager');
    try {
      return super.setManager(manager);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCountOrderPending(int pCountOrderPending) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setCountOrderPending');
    try {
      return super.setCountOrderPending(pCountOrderPending);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEstablishment(EstablishmentData data) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setEstablishment');
    try {
      return super.setEstablishment(data);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
countOrderPending: ${countOrderPending},
fbMessaging: ${fbMessaging},
manager: ${manager},
establishment: ${establishment},
isLoading: ${isLoading},
orderList: ${orderList}
    ''';
  }
}
