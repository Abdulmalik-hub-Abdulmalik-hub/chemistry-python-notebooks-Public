import 'package:flutter/material.dart';

class FormulaAnalyzerPage extends StatefulWidget {
  const FormulaAnalyzerPage({super.key});

  @override
  State<FormulaAnalyzerPage> createState() => _FormulaAnalyzerPageState();
}

class _FormulaAnalyzerPageState extends State<FormulaAnalyzerPage> {
  final _formulaController = TextEditingController(text: 'H2SO4');
  Map<String, int> _composition = {};
  double _molarMass = 0;

  final Map<String, double> _atomicMasses = {
    'H': 1.008, 'He': 4.003, 'Li': 6.941, 'Be': 9.012, 'B': 10.81,
    'C': 12.01, 'N': 14.01, 'O': 16.00, 'F': 19.00, 'Ne': 20.18,
    'Na': 22.99, 'Mg': 24.31, 'Al': 26.98, 'Si': 28.09, 'P': 30.97,
    'S': 32.07, 'Cl': 35.45, 'Ar': 39.95, 'K': 39.10, 'Ca': 40.08,
    'Fe': 55.85, 'Cu': 63.55, 'Zn': 65.38, 'Br': 79.90, 'Ag': 107.87,
    'I': 126.90, 'Au': 196.97, 'Hg': 200.59, 'Pb': 207.2,
  };

  @override
  void initState() {
    super.initState();
    _analyzeFormula();
  }

  void _analyzeFormula() {
    String formula = _formulaController.text.trim();
    Map<String, int> comp = {};
    double mass = 0;
    int i = 0;
    
    while (i < formula.length) {
      if (formula[i] == '(') {
        int j = i + 1;
        String group = '';
        int count = 1;
        while (j < formula.length && count > 0) {
          if (formula[j] == '(') count++;
          if (formula[j] == ')') count--;
          group += formula[j];
          j++;
        }
        j++;
        String numStr = '';
        while (j < formula.length && RegExp(r'[0-9]').hasMatch(formula[j])) {
          numStr += formula[j];
          j++;
        }
        int groupCount = numStr.isEmpty ? 1 : int.parse(numStr);
        Map<String, int> groupComp = _parseGroup(group);
        for (var e in groupComp.entries) {
          comp[e.key] = (comp[e.key] ?? 0) + e.value * groupCount;
        }
        i = j;
      } else if (RegExp(r'[A-Z]').hasMatch(formula[i])) {
        String elem = formula[i];
        i++;
        while (i < formula.length && RegExp(r'[a-z]').hasMatch(formula[i])) {
          elem += formula[i];
          i++;
        }
        String numStr = '';
        while (i < formula.length && RegExp(r'[0-9]').hasMatch(formula[i])) {
          numStr += formula[i];
          i++;
        }
        int count = numStr.isEmpty ? 1 : int.parse(numStr);
        comp[elem] = (comp[elem] ?? 0) + count;
      } else {
        i++;
      }
    }
    
    for (var e in comp.entries) {
      if (_atomicMasses.containsKey(e.key)) {
        mass += _atomicMasses[e.key]! * e.value;
      }
    }
    
    setState(() {
      _composition = comp;
      _molarMass = mass;
    });
  }

  Map<String, int> _parseGroup(String group) {
    Map<String, int> comp = {};
    int i = 0;
    while (i < group.length) {
      if (RegExp(r'[A-Z]').hasMatch(group[i])) {
        String elem = group[i];
        i++;
        while (i < group.length && RegExp(r'[a-z]').hasMatch(group[i])) {
          elem += group[i];
          i++;
        }
        String numStr = '';
        while (i < group.length && RegExp(r'[0-9]').hasMatch(group[i])) {
          numStr += group[i];
          i++;
        }
        int count = numStr.isEmpty ? 1 : int.parse(numStr);
        comp[elem] = (comp[elem] ?? 0) + count;
      } else {
        i++;
      }
    }
    return comp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formula Analyzer')),
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
                    Text('Chemical Formula', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _formulaController,
                      decoration: InputDecoration(
                        labelText: 'Enter formula (e.g., H2SO4, Ca(OH)2)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (_) => _analyzeFormula(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Molar Mass', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      '${_molarMass.toStringAsFixed(2)} g/mol',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
                    Text('Element Composition', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    if (_composition.isEmpty)
                      const Text('Enter a valid formula')
                    else
                      ..._composition.entries.map((e) {
                        double percent = (_atomicMasses[e.key] ?? 0) * e.value / _molarMass * 100;
                        return _buildCompositionRow(e.key, e.value, percent);
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompositionRow(String element, int count, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(element, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          SizedBox(
            width: 40,
            child: Text('×$count'),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey[300],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text('${percent.toStringAsFixed(1)}%'),
          ),
        ],
      ),
    );
  }
}
