import 'package:flutter/material.dart';
import '../../../../core/utils/chemistry_calculations.dart';

class StoichiometryPage extends StatefulWidget {
  const StoichiometryPage({super.key});

  @override
  State<StoichiometryPage> createState() => _StoichiometryPageState();
}

class _StoichiometryPageState extends State<StoichiometryPage> {
  final _massController = TextEditingController(text: '18');
  final _molarMassController = TextEditingController(text: '18');
  final _volumeController = TextEditingController(text: '1');
  final _molarityController = TextEditingController(text: '1');
  
  String _moles = '';
  String _mass = '';
  String _molarity = '';

  void _calculate() {
    double mass = double.tryParse(_massController.text) ?? 0;
    double molarMass = double.tryParse(_molarMassController.text) ?? 1;
    double volume = double.tryParse(_volumeController.text) ?? 1;
    double molarity = double.tryParse(_molarityController.text) ?? 0;

    double moles = ChemistryCalculations.calculateMoles(mass, molarMass);
    double calculatedMass = ChemistryCalculations.calculateMass(molarity, volume) * molarMass;
    double calculatedMolarity = ChemistryCalculations.calculateMolarity(moles, volume / 1000);

    setState(() {
      _moles = 'Moles = ${moles.toStringAsFixed(4)} mol';
      _mass = 'Mass = ${calculatedMass.toStringAsFixed(4)} g';
      _molarity = 'Molarity = ${calculatedMolarity.toStringAsFixed(4)} M';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stoichiometry Solver'),
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
                    Text('Mass to Moles', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _massController,
                      decoration: const InputDecoration(labelText: 'Mass (g)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _molarMassController,
                      decoration: const InputDecoration(labelText: 'Molar Mass (g/mol)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    if (_moles.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_moles, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    Text('Molarity Calculator', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _volumeController,
                      decoration: const InputDecoration(labelText: 'Volume (mL)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _molarityController,
                      decoration: const InputDecoration(labelText: 'Molarity (M)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    if (_molarity.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_molarity, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Formulas', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildFormula('n = m / M', 'n = moles, m = mass, M = molar mass'),
                    _buildFormula('C = n / V', 'C = molarity, V = volume in liters'),
                    _buildFormula('m = n × M', 'Calculate mass from moles'),
                    _buildFormula('n = C × V', 'Calculate moles from molarity'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormula(String formula, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formula, style: const TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold)),
          Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
