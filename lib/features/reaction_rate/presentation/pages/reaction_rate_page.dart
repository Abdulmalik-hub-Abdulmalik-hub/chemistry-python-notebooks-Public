import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReactionRatePage extends StatefulWidget {
  const ReactionRatePage({super.key});

  @override
  State<ReactionRatePage> createState() => _ReactionRatePageState();
}

class _ReactionRatePageState extends State<ReactionRatePage> {
  int _reactionOrder = 1;
  double _rateConstant = 0.5;
  double _initialConcentration = 1.0;
  List<FlSpot> _rateCurve = [];

  @override
  void initState() {
    super.initState();
    _calculateRate();
  }

  void _calculateRate() {
    List<FlSpot> spots = [];
    for (double t = 0; t <= 10; t += 0.1) {
      double concentration;
      if (_reactionOrder == 1) {
        concentration = _initialConcentration * exp(-_rateConstant * t);
      } else if (_reactionOrder == 2) {
        concentration = _initialConcentration / (1 + _rateConstant * t * _initialConcentration);
      } else {
        concentration = _initialConcentration;
      }
      spots.add(FlSpot(t, concentration));
    }
    setState(() => _rateCurve = spots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reaction Rate Simulator')),
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
                    Text('Rate Law', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      _reactionOrder == 1 
                          ? 'Rate = k[A]' 
                          : _reactionOrder == 2 
                              ? 'Rate = k[A]²' 
                              : 'Rate = k',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    _buildSlider('Reaction Order', _reactionOrder.toDouble(), 0, 2, (v) {
                      setState(() => _reactionOrder = v.toInt());
                      _calculateRate();
                    }, divisions: 2),
                    _buildSlider('Rate Constant (k)', _rateConstant, 0.1, 2, (v) {
                      setState(() => _rateConstant = v);
                      _calculateRate();
                    }),
                    _buildSlider('Initial [A]', _initialConcentration, 0.1, 2, (v) {
                      setState(() => _initialConcentration = v);
                      _calculateRate();
                    }),
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
                    Text('Concentration vs Time', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('Time (s)'),
                              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text('[A] (M)'),
                              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _rateCurve,
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    Text('Half-Life Calculator', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildHalfLifeInfo(),
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
                    Text('Integrated Rate Laws', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildRateLaw('Zero Order', 'ln[A] = ln[A]₀ - kt', Colors.red),
                    _buildRateLaw('First Order', 'ln[A] = ln[A]₀ - kt', Colors.blue),
                    _buildRateLaw('Second Order', '1/[A] = 1/[A]₀ + kt', Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged, {int? divisions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(divisions == null ? 2 : 0)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions ?? ((max - min) * 100).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildHalfLifeInfo() {
    double halfLife;
    String formula;
    if (_reactionOrder == 0) {
      halfLife = _initialConcentration / (2 * _rateConstant);
      formula = 't₁/₂ = [A]₀ / 2k';
    } else if (_reactionOrder == 1) {
      halfLife = 0.693 / _rateConstant;
      formula = 't₁/₂ = ln(2) / k = 0.693 / k';
    } else {
      halfLife = 1 / (_rateConstant * _initialConcentration);
      formula = 't₁/₂ = 1 / (k[A]₀)';
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('Half-life: ${halfLife.toStringAsFixed(3)} s', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(formula, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildRateLaw(String order, String equation, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(equation, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
