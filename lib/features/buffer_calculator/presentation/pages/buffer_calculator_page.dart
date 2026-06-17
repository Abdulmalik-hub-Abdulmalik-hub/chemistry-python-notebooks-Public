import 'package:flutter/material.dart';
import '../../../../core/utils/chemistry_calculations.dart';

class BufferCalculatorPage extends StatefulWidget {
  const BufferCalculatorPage({super.key});

  @override
  State<BufferCalculatorPage> createState() => _BufferCalculatorPageState();
}

class _BufferCalculatorPageState extends State<BufferCalculatorPage> {
  double _pKa = 4.76;
  double _acidConcentration = 0.1;
  double _baseConcentration = 0.1;
  double _pH = 0;
  double _bufferCapacity = 0;

  @override
  void initState() {
    super.initState();
    _calculatePH();
  }

  void _calculatePH() {
    setState(() {
      _pH = ChemistryCalculations.calculatePHFromPKa(_pKa, _acidConcentration, _baseConcentration);
      _bufferCapacity = (_acidConcentration + _baseConcentration) / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buffer Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.science, size: 48, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'pH = ${_pH.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Henderson-Hasselbalch Equation',
                      style: Theme.of(context).textTheme.bodyMedium,
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
                    Text('Buffer Parameters', style: Theme.of(context).textTheme.titleMedium),
                    _buildSlider('pKa', _pKa, 2, 12, (v) {
                      setState(() => _pKa = v);
                      _calculatePH();
                    }),
                    _buildSlider('Acid Concentration (M)', _acidConcentration, 0.01, 1, (v) {
                      setState(() => _acidConcentration = v);
                      _calculatePH();
                    }),
                    _buildSlider('Conjugate Base Concentration (M)', _baseConcentration, 0.01, 1, (v) {
                      setState(() => _baseConcentration = v);
                      _calculatePH();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Results', style: Theme.of(context).textTheme.titleMedium),
                    _buildResultRow('pH', _pH.toStringAsFixed(2)),
                    _buildResultRow('pOH', (14 - _pH).toStringAsFixed(2)),
                    _buildResultRow('[H⁺]', '${(1e-7).toStringAsExponential(2)} M'),
                    _buildResultRow('Buffer Capacity', '${(_bufferCapacity * 100).toStringAsFixed(1)}%'),
                    _buildResultRow('pH - pKa', '${(_pH - _pKa).toStringAsFixed(2)}'),
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
                    Text('Henderson-Hasselbalch Equation', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Text('pH = pKa + log([A⁻]/[HA])', style: TextStyle(fontFamily: 'monospace', fontSize: 18)),
                    const SizedBox(height: 12),
                    const Text(
                      'Where:\n'
                      '• pKa = negative log of acid dissociation constant\n'
                      '• [A⁻] = concentration of conjugate base\n'
                      '• [HA] = concentration of weak acid',
                      style: TextStyle(fontSize: 12),
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
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
