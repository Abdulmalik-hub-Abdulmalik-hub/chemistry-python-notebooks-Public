import 'package:flutter/material.dart';

class ConcentrationConverterPage extends StatefulWidget {
  const ConcentrationConverterPage({super.key});

  @override
  State<ConcentrationConverterPage> createState() => _ConcentrationConverterPageState();
}

class _ConcentrationConverterPageState extends State<ConcentrationConverterPage> {
  double _molarity = 1.0;
  double _molality = 0;
  double _normality = 1.0;
  double _ppm = 1000;
  double _massPercent = 10;
  double _molarMass = 58.44;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Concentration Converter')),
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
                    Text('Input', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildInputField('Molarity (M)', _molarity, (v) {
                      setState(() {
                        _molarity = v;
                        _convertFromMolarity();
                      });
                    }),
                    _buildInputField('Molar Mass (g/mol)', _molarMass, (v) {
                      setState(() {
                        _molarMass = v;
                        _convertFromMolarity();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Conversions', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildResultTile('Molarity', _molarity.toStringAsFixed(4), 'M', Colors.blue),
                    _buildResultTile('Molality', _molality.toStringAsFixed(4), 'm', Colors.green),
                    _buildResultTile('Normality', _normality.toStringAsFixed(4), 'N', Colors.orange),
                    _buildResultTile('PPM', _ppm.toStringAsFixed(2), 'ppm', Colors.purple),
                    _buildResultTile('Mass Percent', _massPercent.toStringAsFixed(2), '%', Colors.red),
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
                    Text('Formulas', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildFormula('Molarity (M)', 'moles / volume (L)'),
                    _buildFormula('Molality (m)', 'moles / mass (kg solvent)'),
                    _buildFormula('Normality (N)', 'M × n (equivalents)'),
                    _buildFormula('PPM', 'mg / L solution'),
                    _buildFormula('Mass %', 'g solute / 100 g solution'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _convertFromMolarity() {
    setState(() {
      _molality = _molarity / (1 + _molarity * _molarMass / 1000);
      _normality = _molarity;
      _ppm = _molarity * _molarMass;
      _massPercent = (_molarity * _molarMass) / 10;
    });
  }

  Widget _buildInputField(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          suffixText: label.contains('Mass') ? 'g/mol' : 'M',
        ),
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: value.toStringAsFixed(2)),
        onChanged: (v) {
          double val = double.tryParse(v) ?? 0;
          onChanged(val);
        },
      ),
    );
  }

  Widget _buildResultTile(String label, String value, String unit, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Text(unit, style: TextStyle(color: color))),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFormula(String label, String formula) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(formula, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
