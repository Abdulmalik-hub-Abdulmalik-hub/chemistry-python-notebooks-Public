import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpectroscopyPage extends StatefulWidget {
  const SpectroscopyPage({super.key});

  @override
  State<SpectroscopyPage> createState() => _SpectroscopyPageState();
}

class _SpectroscopyPageState extends State<SpectroscopyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMolecule = 'Benzene';
  List<String> _molecules = ['Benzene', 'Water', 'Acetone', 'Ethanol', 'Formaldehyde'];
  Map<String, List<Map<String, double>>> _spectra = {
    'Benzene': [
      {'wavelength': 254, 'absorbance': 0.9},
      {'wavelength': 280, 'absorbance': 0.7},
      {'wavelength': 300, 'absorbance': 0.3},
      {'wavelength': 350, 'absorbance': 0.1},
    ],
    'Water': [
      {'wavelength': 200, 'absorbance': 0.8},
      {'wavelength': 250, 'absorbance': 0.2},
      {'wavelength': 300, 'absorbance': 0.05},
      {'wavelength': 400, 'absorbance': 0.0},
    ],
    'Acetone': [
      {'wavelength': 265, 'absorbance': 0.85},
      {'wavelength': 300, 'absorbance': 0.4},
      {'wavelength': 350, 'absorbance': 0.1},
    ],
    'Ethanol': [
      {'wavelength': 200, 'absorbance': 0.6},
      {'wavelength': 250, 'absorbance': 0.1},
    ],
    'Formaldehyde': [
      {'wavelength': 210, 'absorbance': 0.95},
      {'wavelength': 280, 'absorbance': 0.5},
      {'wavelength': 340, 'absorbance': 0.05},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectroscopy Center'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'UV-Vis Spectra'),
            Tab(text: 'Spectral Lines'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUVVisTab(),
          _buildSpectralLinesTab(),
        ],
      ),
    );
  }

  Widget _buildUVVisTab() {
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
                  Text('Select Molecule', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _molecules.map((m) {
                      return ChoiceChip(
                        label: Text(m),
                        selected: _selectedMolecule == m,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedMolecule = m);
                          }
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
                  Text('UV-Vis Absorption Spectrum', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: _buildAbsorptionChart(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('UV Region (<400nm)', Colors.purple),
                      const SizedBox(width: 16),
                      _buildLegendItem('Visible Region', Colors.orange),
                    ],
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
                  Text('Spectrum Information', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildInfoRow('Molecule', _selectedMolecule),
                  _buildInfoRow('λmax', '${_getLambdaMax()} nm'),
                  _buildInfoRow('λmax Type', _getLambdaMax() < 400 ? 'UV' : 'Visible'),
                  _buildInfoRow('Absorption', _getLambdaMax() < 400 ? 'π→π* or n→π*' : 'Electronic'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpectralLinesTab() {
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
                  Text('Hydrogen Emission Spectrum', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _buildHydrogenSpectrumChart(),
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
                  Text('Spectral Series', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildSeriesTile('Lyman Series', 'n=1', 'UV', Colors.purple, '121.6 nm - 400 nm'),
                  _buildSeriesTile('Balmer Series', 'n=2', 'Visible', Colors.green, '364.6 nm - 656.3 nm'),
                  _buildSeriesTile('Paschen Series', 'n=3', 'IR', Colors.red, '820.4 nm - 1875 nm'),
                  _buildSeriesTile('Brackett Series', 'n=4', 'Far IR', Colors.orange, '1458 nm - 4050 nm'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsorptionChart() {
    final data = _spectra[_selectedMolecule] ?? [];
    List<FlSpot> spots = [];
    
    for (int i = 200; i <= 800; i += 5) {
      double absorbance = 0;
      for (var peak in data) {
        double wavelength = peak['wavelength']!;
        double peakAbs = peak['absorbance']!;
        double diff = (i - wavelength).abs();
        if (diff < 50) {
          absorbance = peakAbs * (1 - diff / 50);
        }
      }
      spots.add(FlSpot(i.toDouble(), absorbance));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Wavelength (nm)'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9)),
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Absorbance'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1), style: const TextStyle(fontSize: 9)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red],
            ),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.purple.withOpacity(0.3), Colors.red.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrogenSpectrumChart() {
    List<FlSpot> spots = [];
    for (int i = 100; i <= 800; i++) {
      spots.add(FlSpot(i.toDouble(), 0));
    }
    
    Map<String, Map<String, dynamic>> lines = {
      'Lyman-α': {'wavelength': 121.6, 'color': Colors.purple},
      'Balmer-α': {'wavelength': 656.3, 'color': Colors.red},
      'Balmer-β': {'wavelength': 486.1, 'color': Colors.green},
      'Balmer-γ': {'wavelength': 434.0, 'color': Colors.blue},
      'Paschen-α': {'wavelength': 1875.1, 'color': Colors.orange},
    };

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: CustomPaint(
            painter: SpectrumPainter(lines),
            size: const Size(double.infinity, 100),
          ),
        ),
        const SizedBox(height: 16),
        ...lines.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(width: 20, height: 12, decoration: BoxDecoration(color: e.value['color'] as Color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text('${e.key}: ${(e.value['wavelength'] as double).toStringAsFixed(1)} nm'),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSeriesTile(String series, String level, String region, Color color, String range) {
    return ListTile(
      leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.show_chart, color: color)),
      title: Text(series),
      subtitle: Text('n₁=$level, $region'),
      trailing: Text(range, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  double _getLambdaMax() {
    final data = _spectra[_selectedMolecule] ?? [];
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => (a['absorbance'] ?? 0) > (b['absorbance'] ?? 0) ? a : b)['wavelength'] ?? 0;
  }
}

class SpectrumPainter extends CustomPainter {
  final Map<String, Map<String, dynamic>> lines;
  
  SpectrumPainter(this.lines);
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var entry in lines.entries) {
      double wavelength = entry.value['wavelength'] as double;
      Color color = entry.value['color'] as Color;
      double x = ((wavelength - 100) / 700) * size.width;
      if (x >= 0 && x <= size.width) {
        canvas.drawRect(Rect.fromLTWH(x - 3, 0, 6, size.height), Paint()..color = color);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
