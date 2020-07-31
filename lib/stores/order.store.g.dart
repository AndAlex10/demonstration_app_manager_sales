// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrderStore on _OrderStore, Store {
  final _$activeDateAtom = Atom(name: '_OrderStore.activeDate');

  @override
  bool get activeDate {
    _$activeDateAtom.reportRead();
    return super.activeDate;
  }

  @override
  set activeDate(bool value) {
    _$activeDateAtom.reportWrite(value, super.activeDate, () {
      super.activeDate = value;
    });
  }

  final _$startDateAtom = Atom(name: '_OrderStore.startDate');

  @override
  Timestamp get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(Timestamp value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  final _$endDateAtom = Atom(name: '_OrderStore.endDate');

  @override
  Timestamp get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(Timestamp value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  final _$statusAtom = Atom(name: '_OrderStore.status');

  @override
  List<dynamic> get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(List<dynamic> value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$tagsAtom = Atom(name: '_OrderStore.tags');

  @override
  List<String> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(List<String> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  final _$listAllAtom = Atom(name: '_OrderStore.listAll');

  @override
  List<OrderData> get listAll {
    _$listAllAtom.reportRead();
    return super.listAll;
  }

  @override
  set listAll(List<OrderData> value) {
    _$listAllAtom.reportWrite(value, super.listAll, () {
      super.listAll = value;
    });
  }

  final _$listFilteredAtom = Atom(name: '_OrderStore.listFiltered');

  @override
  List<OrderData> get listFiltered {
    _$listFilteredAtom.reportRead();
    return super.listFiltered;
  }

  @override
  set listFiltered(List<OrderData> value) {
    _$listFilteredAtom.reportWrite(value, super.listFiltered, () {
      super.listFiltered = value;
    });
  }

  final _$amountAtom = Atom(name: '_OrderStore.amount');

  @override
  double get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(double value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  final _$_OrderStoreActionController = ActionController(name: '_OrderStore');

  @override
  dynamic setListOrderAll(List<OrderData> list) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setListOrderAll');
    try {
      return super.setListOrderAll(list);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setListOrderFiltered(List<OrderData> list) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setListOrderFiltered');
    try {
      return super.setListOrderFiltered(list);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmount() {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setAmount');
    try {
      return super.setAmount();
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTags(List<String> tags) {
    final _$actionInfo =
        _$_OrderStoreActionController.startAction(name: '_OrderStore.setTags');
    try {
      return super.setTags(tags);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime dateTime) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setStartDate');
    try {
      return super.setStartDate(dateTime);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(DateTime dateTime) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setEndDate');
    try {
      return super.setEndDate(dateTime);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setActiveDate(bool value) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
        name: '_OrderStore.setActiveDate');
    try {
      return super.setActiveDate(value);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
activeDate: ${activeDate},
startDate: ${startDate},
endDate: ${endDate},
status: ${status},
tags: ${tags},
listAll: ${listAll},
listFiltered: ${listFiltered},
amount: ${amount}
    ''';
  }
}
