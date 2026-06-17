import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DockingScorePage extends StatefulWidget {
  const DockingScorePage({super.key});

  @override
  State<DockingScorePage> createState() => _DockingScorePageState();
}

class _DockingScorePageState extends State<DockingScorePage> {
  double _ligand1Score = 8.5;
  double _ligand2Score = 7.2;
  double _ligand3Score = 9.1;
  String _selectedTarget = 'HIV-1 Protease';

  final Map<String, List<Map<String, dynamic>>> _targets = {
    'HIV-1 Protease': [
      {'name': 'Ritonavir', 'score': 8.5, 'interactions': 12},
      {'name': 'Saquinavir', 'score': 7.2, 'interactions': 9},
      {'name': 'Indinavir', 'score': 9.1, 'interactions': 15},
    ],
    'COX-2': [
      {'name': 'Celecoxib', 'score': 8.8, 'interactions': 10},
      {'name': 'Rofecoxib', 'score': 7.5, 'interactions': 8},
      {'name': 'Valdecoxib', 'score': 8.2, 'interactions': 11},
    ],
    'Kinase': [
      {'name': 'Imatinib', 'score': 9.0, 'interactions': 14},
      {'name': 'Dasatinib', 'score': 8.7, 'interactions': 13},
      {'name': 'Nilotinib', 'score': 8.9, 'interactions': 12},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Molecular Docking Score')),
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
                    Text('Target Protein', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _targets.keys.map((t) {
                        return ChoiceChip(
                          label: Text(t),
                          selected: _selectedTarget == t,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedTarget = t);
                          },
                        );
                      }).toList(),
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
                    Text('Docking Scores', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: _buildScoreChart(),
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
                    Text('Ligand Scores', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildScoreSlider('Ligand 1', _ligand1Score, Colors.blue, (v) => setState(() => _ligand1Score = v)),
                    _buildScoreSlider('Ligand 2', _ligand2Score, Colors.green, (v) => setState(() => _ligand2Score = v)),
                    _buildScoreSlider('Ligand 3', _ligand3Score, Colors.orange, (v) => setState(() => _ligand3Score = v)),
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
                    Text('Docking Results', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildResultTile(1, 'Ligand 1', _ligand1Score),
                    _buildResultTile(2, 'Ligand 2', _ligand2Score),
                    _buildResultTile(3, 'Ligand 3', _ligand3Score),
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
                    Text('Understanding Docking Scores', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Text(
                      '• More negative scores indicate stronger binding\n'
                      '• Scores < -7 kcal/mol suggest good binding\n'
                      '• Scores < -9 kcal/mol indicate very strong binding\n'
                      '• Consider both score and number of interactions',
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

  Widget _buildScoreChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        minY: 6,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Score: ${rod.toY.toStringAsFixed(1)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) => Text(
                'L${v.toInt() + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Score (kcal/mol)'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, _) => Text(v.toInt().toString()),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: _ligand1Score, color: Colors.blue, width: 40),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: _ligand2Score, color: Colors.green, width: 40),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: _ligand3Score, color: Colors.orange, width: 40),
          ]),
        ],
      ),
    );
  }

  Widget _buildScoreSlider(String label, double value, Color color, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(label),
            const Spacer(),
            Text('${value.toStringAsFixed(1)} kcal/mol', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: 5,
          max: 10,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildResultTile(int rank, String ligand, double score) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: rank == 1 ? Colors.amber : rank == 2 ? Colors.grey : Colors.brown.shade300,
        child: Text('#$rank'),
      ),
      title: Text(ligand),
      subtitle: const Text('Click to view details'),
      trailing: Text(
        '${score.toStringAsFixed(1)}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: score < 8 ? Colors.red : score < 9 ? Colors.orange : Colors.green,
        ),
      ),
    );
  }
}
