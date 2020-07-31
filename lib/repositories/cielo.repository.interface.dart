import 'dart:async';
import 'package:vendas_mais_manager/models/entities/cielo.entities.dart';

abstract class ICieloRepository {

  Future<CieloData> get();

}