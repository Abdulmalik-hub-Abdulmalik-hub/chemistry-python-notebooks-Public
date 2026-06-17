import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PhTitrationPage extends StatefulWidget {
  const PhTitrationPage({super.key});

  @override
  State<PhTitrationPage> createState() => _PhTitrationPageState();
}

class _PhTitrationPageState extends State<PhTitrationPage> {
  double _acidConcentration = 0.1;
  double _baseConcentration = 0.1;
  double _initialVolume = 50.0;
  List<FlSpot> _titrationCurve = [];

  @override
  void initState() {
    super.initState();
    _calculateTitrationCurve();
  }

  void _calculateTitrationCurve() {
    List<FlSpot> points = [];
    
    for (double v = 0; v <= 60; v += 1) {
      double molesAcid = _acidConcentration * _initialVolume;
      double molesBase = _baseConcentration * v;
      double totalVolume = _initialVolume + v;
      double pH;

      if (molesBase < molesAcid) {
        double hConcentration = (molesAcid - molesBase) / totalVolume;
        if (hConcentration > 0) {
          pH = -log(hConcentration) / log(10);
        } else {
          pH = 14;
        }
      } else if ((molesBase - molesAcid).abs() < 0.0001) {
        pH = 7;
      } else {
        double ohConcentration = (molesBase - molesAcid) / totalVolume;
        if (ohConcentration > 0) {
          pH = 14 + log(ohConcentration) / log(10);
        } else {
          pH = 7;
        }
      }
      
      pH = pH.clamp(0, 14);
      points.add(FlSpot(v, pH));
    }

    setState(() {
      _titrationCurve = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pH Titration Simulator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulation Parameters',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildSlider(
                      'Acid Concentration (M)',
                      _acidConcentration,
                      0.01,
                      1.0,
                      (value) {
                        setState(() => _acidConcentration = value);
                        _calculateTitrationCurve();
                      },
                    ),
                    _buildSlider(
                      'Base Concentration (M)',
                      _baseConcentration,
                      0.01,
                      1.0,
                      (value) {
                        setState(() => _baseConcentration = value);
                        _calculateTitrationCurve();
                      },
                    ),
                    _buildSlider(
                      'Initial Acid Volume (mL)',
                      _initialVolume,
                      10,
                      100,
                      (value) {
                        setState(() => _initialVolume = value);
                        _calculateTitrationCurve();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Titration Curve',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: _titrationCurve.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 2,
                                  verticalInterval: 10,
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: const Text('Volume of Base (mL)'),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: const Text('pH'),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: Colors.grey),
                                ),
                                minY: 0,
                                maxY: 14,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _titrationCurve,
                                    isCurved: true,
                                    color: Theme.of(context).colorScheme.primary,
                                    barWidth: 3,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: [
                                      const FlSpot(0, 7),
                                      const FlSpot(60, 7),
                                    ],
                                    isCurved: false,
                                    color: Colors.green,
                                    barWidth: 2,
                                    dotData: const FlDotData(show: false),
                                    dashArray: [5, 5],
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem('Titration Curve', Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 16),
                        _buildLegendItem('Neutral pH (7)', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Acid Type:', 'Strong Acid (e.g., HCl)'),
                    _buildInfoRow('Base Type:', 'Strong Base (e.g., NaOH)'),
                    _buildInfoRow(
                      'Equivalence Point:',
                      '${((_acidConcentration * _initialVolume) / _baseConcentration).toStringAsFixed(1)} mL',
                    ),
                    _buildInfoRow('Indicator:', 'Phenolphthalein (pH 8.2-10) or Methyl Orange (pH 3.1-4.4)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 100).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
