import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class QuantumEnergyPage extends StatefulWidget {
  const QuantumEnergyPage({super.key});

  @override
  State<QuantumEnergyPage> createState() => _QuantumEnergyPageState();
}

class _QuantumEnergyPageState extends State<QuantumEnergyPage> {
  int _maxN = 5;
  int _n1 = 3;
  int _n2 = 2;
  final List<FlSpot> _energyLevels = [];
  final List<Map<String, dynamic>> _transitions = [];

  @override
  void initState() {
    super.initState();
    _calculateEnergyLevels();
    _calculateTransitions();
  }

  void _calculateEnergyLevels() {
    _energyLevels.clear();
    for (int n = 1; n <= _maxN; n++) {
      double energy = -13.6 / (n * n);
      _energyLevels.add(FlSpot(1, energy));
    }
  }

  void _calculateTransitions() {
    _transitions.clear();
    for (int i = 1; i <= _maxN; i++) {
      for (int j = i + 1; j <= _maxN; j++) {
        double eHigh = -13.6 / (i * i);
        double eLow = -13.6 / (j * j);
        double deltaE = eHigh - eLow;
        double wavelength = 1240 / deltaE;
        if (wavelength > 0 && wavelength < 2000) {
          _transitions.add({
            'from': j,
            'to': i,
            'energy': deltaE,
            'wavelength': wavelength,
            'series': _getSeriesName(i),
          });
        }
      }
    }
  }

  String _getSeriesName(int n) {
    switch (n) {
      case 1: return 'Lyman';
      case 2: return 'Balmer';
      case 3: return 'Paschen';
      default: return 'Series $n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Energy Levels'),
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
                      'Hydrogen Atom Energy Levels',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Eₙ = -13.6 / n² eV',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildSlider('Maximum Energy Level (n)', _maxN.toDouble(), 2, 10, (v) {
                      setState(() {
                        _maxN = v.toInt();
                        _calculateEnergyLevels();
                        _calculateTransitions();
                      });
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
                    Text(
                      'Energy Level Diagram',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 0,
                          minY: -14,
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text('Energy (eV)'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('Energy Level'),
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int n = value.toInt();
                                  if (n >= 1 && n <= _maxN) {
                                    return Text(
                                      'n=$n',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: List.generate(_maxN, (index) {
                            int n = index + 1;
                            double energy = -13.6 / (n * n);
                            return BarChartGroupData(
                              x: n,
                              barRods: [
                                BarChartRodData(
                                  toY: energy,
                                  color: _getEnergyColor(energy),
                                  width: 30,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }),
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
                      'Spectral Transitions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildSlider('From Level (n₂)', _n2.toDouble(), 1, _maxN.toDouble() - 1, (v) {
                      setState(() {
                        _n2 = v.toInt();
                        _calculateTransitions();
                      });
                    }),
                    _buildSlider('To Level (n₁)', _n1.toDouble(), 1, _maxN.toDouble() - 1, (v) {
                      setState(() {
                        _n1 = v.toInt();
                        _calculateTransitions();
                      });
                    }),
                    const SizedBox(height: 16),
                    if (_n2 > _n1) ...[
                      _buildTransitionInfo(_n2, _n1),
                    ] else
                      const Text('Select n₂ > n₁ for emission'),
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
                      'Emission Lines',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ..._transitions.take(10).map((t) => _buildTransitionTile(t)),
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
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTransitionInfo(int from, int to) {
    double eFrom = -13.6 / (from * from);
    double eTo = -13.6 / (to * to);
    double deltaE = eTo - eFrom;
    double wavelength = deltaE > 0 ? 1240 / deltaE : 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transition: n=$from → n=$to'),
          Text('Energy Change: ${deltaE.toStringAsFixed(3)} eV'),
          if (wavelength > 0)
            Text('Wavelength: ${wavelength.toStringAsFixed(1)} nm'),
          Text('Series: ${_getSeriesName(to)}'),
        ],
      ),
    );
  }

  Widget _buildTransitionTile(Map<String, dynamic> transition) {
    return ListTile(
      title: Text('n=${transition['from']} → n=${transition['to']}'),
      subtitle: Text('${transition['series']} Series'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${(transition['wavelength'] as double).toStringAsFixed(1)} nm'),
          Container(
            width: 40,
            height: 12,
            decoration: BoxDecoration(
              color: _getWavelengthColor(transition['wavelength']),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEnergyColor(double energy) {
    if (energy > -1) return Colors.red;
    if (energy > -3) return Colors.orange;
    if (energy > -6) return Colors.green;
    if (energy > -10) return Colors.blue;
    return Colors.purple;
  }

  Color _getWavelengthColor(double wavelength) {
    if (wavelength < 380) return Colors.purple;
    if (wavelength < 450) return Colors.blue;
    if (wavelength < 520) return Colors.green;
    if (wavelength < 610) return Colors.orange;
    return Colors.red;
  }
}
