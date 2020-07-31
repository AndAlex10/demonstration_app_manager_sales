import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';


class GraphicMonthlyView extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GraphicMonthlyView(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory GraphicMonthlyView.withSampleData(Map json) {
    return new GraphicMonthlyView(
      _createSampleData(json),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
      new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),

    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<SalesMonthly, String>> _createSampleData(Map json) {
    final data = [
      new SalesMonthly((DateTime.now().month).toString(), double.parse(json['month1'].toString())),
      new SalesMonthly((DateTime.now().month - 1).toString(), double.parse(json['month2'].toString())),
      new SalesMonthly((DateTime.now().month -2).toString(), double.parse(json['month3'].toString())),
    ];

    return [
      new charts.Series<SalesMonthly, String>(
          id: 'Vendas',

          domainFn: (SalesMonthly sales, _) => sales.month,
          measureFn: (SalesMonthly sales, _) => sales.amount,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (SalesMonthly sales, _) =>
          'Mês ${sales.month}: R\$${sales.amount.toStringAsFixed(2)}')
    ];
  }
}

/// Sample ordinal data type.
class SalesMonthly {
  final String month;
  final double amount;

  SalesMonthly(this.month, this.amount);
}





