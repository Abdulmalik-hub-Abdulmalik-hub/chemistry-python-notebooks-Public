import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/chemistry_calculations.dart';

class ThermodynamicsPage extends StatefulWidget {
  const ThermodynamicsPage({super.key});

  @override
  State<ThermodynamicsPage> createState() => _ThermodynamicsPageState();
}

class _ThermodynamicsPageState extends State<ThermodynamicsPage> {
  double _deltaH = -100;
  double _deltaS = -0.2;
  double _temperature = 298;
  double _deltaG = 0;
  bool _isSpontaneous = false;
  List<FlSpot> _gibbsCurve = [];

  @override
  void initState() {
    super.initState();
    _calculateGibbs();
    _calculateGibbsCurve();
  }

  void _calculateGibbs() {
    setState(() {
      _deltaG = ChemistryCalculations.calculateGibbsFreeEnergy(_deltaH, _deltaS, _temperature);
      _isSpontaneous = _deltaG < 0;
    });
  }

  void _calculateGibbsCurve() {
    List<FlSpot> spots = [];
    for (double t = 100; t <= 1000; t += 10) {
      double g = ChemistryCalculations.calculateGibbsFreeEnergy(_deltaH, _deltaS, t);
      spots.add(FlSpot(t, g));
    }
    setState(() {
      _gibbsCurve = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermodynamics Explorer'),
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
                      'Gibbs Free Energy Calculator',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ΔG = ΔH - TΔS',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSlider('ΔH (kJ/mol)', _deltaH, -500, 500, (v) {
                      setState(() => _deltaH = v);
                      _calculateGibbs();
                      _calculateGibbsCurve();
                    }),
                    _buildSlider('ΔS (kJ/mol·K)', _deltaS, -1, 1, (v) {
                      setState(() => _deltaS = v);
                      _calculateGibbs();
                      _calculateGibbsCurve();
                    }),
                    _buildSlider('T (K)', _temperature, 100, 1000, (v) {
                      setState(() => _temperature = v);
                      _calculateGibbs();
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: _isSpontaneous ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      _isSpontaneous ? Icons.check_circle : Icons.cancel,
                      size: 64,
                      color: _isSpontaneous ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ΔG = ${_deltaG.toStringAsFixed(2)} kJ/mol',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSpontaneous ? 'Reaction is SPONTANEOUS' : 'Reaction is NON-SPONTANEOUS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isSpontaneous ? Colors.green : Colors.red,
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
                  children: [
                    Text(
                      'ΔG vs Temperature',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 100,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('Temperature (K)'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9)),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text('ΔG (kJ/mol)'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 9)),
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _gibbsCurve,
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: _gibbsCurve.any((s) => s.y < 0)
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.transparent,
                              ),
                            ),
                            LineChartBarData(
                              spots: [
                                const FlSpot(100, 0),
                                const FlSpot(1000, 0),
                              ],
                              isCurved: false,
                              color: Colors.grey,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                              dashArray: [5, 5],
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
                    Text(
                      'Understanding Gibbs Free Energy',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(Icons.thermostat, 'Enthalpy (ΔH)', 'Heat content change of the system'),
                    _buildInfoItem(Icons.swap_vert, 'Entropy (ΔS)', 'Measure of disorder or randomness'),
                    _buildInfoItem(Icons.balance, 'Temperature (T)', 'Absolute temperature in Kelvin'),
                    _buildInfoItem(Icons.calculate, 'Gibbs (ΔG)', 'Maximum non-expansion work'),
                    const SizedBox(height: 12),
                    const Text(
                      '• ΔG < 0: Spontaneous reaction\n'
                      '• ΔG = 0: System at equilibrium\n'
                      '• ΔG > 0: Non-spontaneous reaction',
                      style: TextStyle(fontSize: 14),
                    ),
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
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
