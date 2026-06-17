import 'package:flutter/material.dart';

class ElectrochemistryPage extends StatefulWidget {
  const ElectrochemistryPage({super.key});

  @override
  State<ElectrochemistryPage> createState() => _ElectrochemistryPageState();
}

class _ElectrochemistryPageState extends State<ElectrochemistryPage> {
  String _cathode = 'Cu²⁺/Cu';
  String _anode = 'Zn²⁺/Zn';
  double _cellPotential = 1.10;
  
  final Map<String, double> _standardPotentials = {
    'Li⁺/Li': -3.04,
    'K⁺/K': -2.93,
    'Ca²⁺/Ca': -2.87,
    'Na⁺/Na': -2.71,
    'Mg²⁺/Mg': -2.37,
    'Al³⁺/Al': -1.66,
    'Zn²⁺/Zn': -0.76,
    'Fe²⁺/Fe': -0.44,
    'Ni²⁺/Ni': -0.26,
    'Sn²⁺/Sn': -0.14,
    'Pb²⁺/Pb': -0.13,
    '2H⁺/H₂': 0.00,
    'Cu²⁺/Cu': 0.34,
    'I₂/I⁻': 0.54,
    'Ag⁺/Ag': 0.80,
    'Br₂/Br⁻': 1.07,
    'Cl₂/Cl⁻': 1.36,
    'Au³⁺/Au': 1.50,
    'F₂/F⁻': 2.87,
  };

  @override
  void initState() {
    super.initState();
    _calculateCellPotential();
  }

  void _calculateCellPotential() {
    double cathE = _standardPotentials[_cathode] ?? 0;
    double anE = _standardPotentials[_anode] ?? 0;
    setState(() {
      _cellPotential = cathE - anE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrochemistry Cell'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: _cellPotential > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.bolt, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'E°cell = ${_cellPotential.toStringAsFixed(2)} V',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cellPotential > 0 ? 'Galvanic (Spontaneous)' : 'Electrolytic (Non-spontaneous)',
                      style: TextStyle(
                        color: _cellPotential > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
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
                    Text('Galvanic Cell Setup', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildElectrodeSelector('Cathode (Reduction)', _cathode, (v) {
                      setState(() => _cathode = v);
                      _calculateCellPotential();
                    }),
                    const SizedBox(height: 16),
                    _buildElectrodeSelector('Anode (Oxidation)', _anode, (v) {
                      setState(() => _anode = v);
                      _calculateCellPotential();
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
                    Text('Cell Diagram', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Anode ‖ Anode Solution ‖ Cathode Solution ‖ Cathode\n'
                        '$_anode ‖ ‖ $_cathode',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'monospace'),
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
                    Text('Standard Reduction Potentials', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ..._standardPotentials.entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${e.value >= 0 ? '+' : ''}${e.value.toStringAsFixed(2)} V',
                              style: TextStyle(
                                color: e.value >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (e.value + 3.04) / 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation(
                                e.value >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElectrodeSelector(String label, String value, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: _standardPotentials.keys.map((e) {
            return DropdownMenuItem(value: e, child: Text('$e (${_standardPotentials[e]!.toStringAsFixed(2)} V)'));
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}
