import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GasLawsPage extends StatefulWidget {
  const GasLawsPage({super.key});

  @override
  State<GasLawsPage> createState() => _GasLawsPageState();
}

class _GasLawsPageState extends State<GasLawsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  double _pressure = 1.0;
  double _volume = 1.0;
  double _temperature = 300.0;
  double _moles = 1.0;
  
  String _result = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _gasConstant => 8.314;

  void _calculateIdealGas() {
    double p = _pressure * 101325;
    double v = _volume / 1000;
    double t = _temperature;
    double n = _moles;
    
    double calculatedP = (n * _gasConstant * t) / v;
    double calculatedV = (n * _gasConstant * t) / p;
    double calculatedT = (p * v) / (n * _gasConstant);
    double calculatedN = (p * v) / (_gasConstant * t);
    
    setState(() {
      _result = '''
Ideal Gas Law: PV = nRT

Given:
  P = $_pressure atm (${(_pressure * 101325).toStringAsFixed(0)} Pa)
  V = $_volume mL (${(_volume / 1000).toStringAsFixed(4)} L)
  T = $_temperature K
  n = $_moles mol

Calculated Values:
  Pressure (P) = ${(calculatedP / 101325).toStringAsFixed(4)} atm
  Volume (V) = ${(calculatedV * 1000).toStringAsFixed(2)} mL
  Temperature (T) = ${calculatedT.toStringAsFixed(2)} K
  Moles (n) = ${calculatedN.toStringAsFixed(4)} mol
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Law Simulator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ideal Gas'),
            Tab(text: "Boyle's Law"),
            Tab(text: "Charles's Law"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIdealGasTab(),
          _buildBoyleTab(),
          _buildCharlesTab(),
        ],
      ),
    );
  }

  Widget _buildIdealGasTab() {
    return SingleChildScrollView(
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
                  const Text(
                    'PV = nRT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'P = Pressure, V = Volume, n = Moles, R = Gas Constant, T = Temperature',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  _buildSlider('Pressure (atm)', _pressure, 0.1, 10, (v) => setState(() => _pressure = v)),
                  _buildSlider('Volume (mL)', _volume, 1, 1000, (v) => setState(() => _volume = v)),
                  _buildSlider('Temperature (K)', _temperature, 100, 1000, (v) => setState(() => _temperature = v)),
                  _buildSlider('Moles (n)', _moles, 0.1, 10, (v) => setState(() => _moles = v)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calculateIdealGas,
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_result.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBoyleTab() {
    return _buildSimulationTab(
      title: "Boyle's Law: P₁V₁ = P₂V₂",
      description: 'At constant temperature, pressure is inversely proportional to volume.',
      chartBuilder: () {
        List<FlSpot> spots = [];
        for (double v = 1; v <= 10; v += 0.5) {
          double p = (_pressure * _volume) / v;
          spots.add(FlSpot(v, p));
        }
        return spots;
      },
      xLabel: 'Volume (mL)',
      yLabel: 'Pressure (atm)',
      extraWidgets: [
        _buildSlider('Initial Pressure (atm)', _pressure, 0.1, 10, (v) => setState(() => _pressure = v)),
        _buildSlider('Initial Volume (mL)', _volume, 1, 100, (v) => setState(() => _volume = v)),
      ],
    );
  }

  Widget _buildCharlesTab() {
    return _buildSimulationTab(
      title: "Charles's Law: V₁/T₁ = V₂/T₂",
      description: 'At constant pressure, volume is directly proportional to temperature.',
      chartBuilder: () {
        List<FlSpot> spots = [];
        for (double t = 200; t <= 600; t += 20) {
          double v = (_volume * t) / _temperature;
          spots.add(FlSpot(t, v));
        }
        return spots;
      },
      xLabel: 'Temperature (K)',
      yLabel: 'Volume (mL)',
      extraWidgets: [
        _buildSlider('Initial Volume (mL)', _volume, 1, 100, (v) => setState(() => _volume = v)),
        _buildSlider('Initial Temperature (K)', _temperature, 200, 600, (v) => setState(() => _temperature = v)),
      ],
    );
  }

  Widget _buildSimulationTab({
    required String title,
    required String description,
    required List<FlSpot> Function() chartBuilder,
    required String xLabel,
    required String yLabel,
    required List<Widget> extraWidgets,
  }) {
    return SingleChildScrollView(
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
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 16),
                  ...extraWidgets,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text(xLabel),
                        sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text(yLabel),
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartBuilder(),
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
