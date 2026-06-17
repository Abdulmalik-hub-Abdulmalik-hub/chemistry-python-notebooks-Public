import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/chemistry_calculations.dart';

class EquilibriumPage extends StatefulWidget {
  const EquilibriumPage({super.key});

  @override
  State<EquilibriumPage> createState() => _EquilibriumPageState();
}

class _EquilibriumPageState extends State<EquilibriumPage> {
  double _initialA = 1.0;
  double _initialB = 1.0;
  double _kc = 0.1;
  List<FlSpot> _equilibriumCurve = [];

  @override
  void initState() {
    super.initState();
    _calculateEquilibrium();
  }

  void _calculateEquilibrium() {
    List<FlSpot> spots = [];
    for (double k = 0.001; k <= 100; k *= 1.5) {
      double x = _solveEquilibrium(_initialA, _initialB, k);
      spots.add(FlSpot(k, x));
    }
    setState(() => _equilibriumCurve = spots);
  }

  double _solveEquilibrium(double a, double b, double k) {
    double c = 1.0;
    double d = 1.0;
    for (int i = 0; i < 100; i++) {
      double num = k * a * b;
      double den = 1 + k * a + k * b;
      double x = num / den;
      if ((x - c).abs() < 1e-6) break;
      c = x;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chemical Equilibrium')),
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
                    Text('Le Chatelier\'s Principle', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('aA + bB ⇌ cC + dD'),
                    const SizedBox(height: 8),
                    Text('Kc = [C]ᶜ[D]ᵈ / [A]ᵃ[B]ᵇ', style: const TextStyle(fontStyle: FontStyle.italic)),
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
                    Text('Simulation Parameters', style: Theme.of(context).textTheme.titleMedium),
                    _buildSlider('Initial [A]', _initialA, 0.1, 2, (v) {
                      setState(() => _initialA = v);
                      _calculateEquilibrium();
                    }),
                    _buildSlider('Initial [B]', _initialB, 0.1, 2, (v) {
                      setState(() => _initialB = v);
                      _calculateEquilibrium();
                    }),
                    _buildSlider('Equilibrium Constant (Kc)', _kc, 0.001, 10, (v) {
                      setState(() => _kc = v);
                      _calculateEquilibrium();
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
                    Text('Equilibrium vs Kc', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('Kc'),
                              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text('[Product]'),
                              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _equilibriumCurve,
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
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
                    Text('Le Chatelier\'s Principle', style: Theme.of(context).textTheme.titleMedium),
                    _buildPrincipleItem(Icons.add_circle, 'If Kc increases → Shift right (products)'),
                    _buildPrincipleItem(Icons.remove_circle, 'If Kc decreases → Shift left (reactants)'),
                    _buildPrincipleItem(Icons.thermostat, 'Temperature ↑ (endothermic) → Shift right'),
                    _buildPrincipleItem(Icons.thermostat, 'Temperature ↑ (exothermic) → Shift left'),
                    _buildPrincipleItem(Icons.compress, 'Pressure ↑ → Shift toward fewer moles'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(3)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _buildPrincipleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
