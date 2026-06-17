import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class MolecularVisualizerPage extends StatefulWidget {
  const MolecularVisualizerPage({super.key});

  @override
  State<MolecularVisualizerPage> createState() => _MolecularVisualizerPageState();
}

class _MolecularVisualizerPageState extends State<MolecularVisualizerPage> {
  String _selectedMolecule = 'Water (H2O)';
  double _rotation = 0;
  
  final Map<String, Map<String, dynamic>> _molecules = {
    'Water (H2O)': {
      'atoms': [
        {'element': 'O', 'x': 0.0, 'y': 0.0, 'z': 0.0},
        {'element': 'H', 'x': 0.758, 'y': 0.0, 'z': 0.504},
        {'element': 'H', 'x': -0.758, 'y': 0.0, 'z': 0.504},
      ],
      'bonds': [
        [0, 1], [0, 2]
      ],
      'shape': 'Bent',
      'bondAngle': '104.5°',
      'geometry': 'Tetrahedral',
    },
    'Methane (CH4)': {
      'atoms': [
        {'element': 'C', 'x': 0.0, 'y': 0.0, 'z': 0.0},
        {'element': 'H', 'x': 0.629, 'y': 0.629, 'z': 0.629},
        {'element': 'H', 'x': -0.629, 'y': -0.629, 'z': 0.629},
        {'element': 'H', 'x': -0.629, 'y': 0.629, 'z': -0.629},
        {'element': 'H', 'x': 0.629, 'y': -0.629, 'z': -0.629},
      ],
      'bonds': [
        [0, 1], [0, 2], [0, 3], [0, 4]
      ],
      'shape': 'Tetrahedral',
      'bondAngle': '109.5°',
      'geometry': 'Tetrahedral',
    },
    'Ammonia (NH3)': {
      'atoms': [
        {'element': 'N', 'x': 0.0, 'y': 0.0, 'z': 0.0},
        {'element': 'H', 'x': 0.0, 'y': 0.937, 'z': 0.381},
        {'element': 'H', 'x': 0.812, 'y': -0.469, 'z': 0.381},
        {'element': 'H', 'x': -0.812, 'y': -0.469, 'z': 0.381},
      ],
      'bonds': [
        [0, 1], [0, 2], [0, 3]
      ],
      'shape': 'Trigonal Pyramidal',
      'bondAngle': '107°',
      'geometry': 'Tetrahedral',
    },
    'Carbon Dioxide (CO2)': {
      'atoms': [
        {'element': 'C', 'x': 0.0, 'y': 0.0, 'z': 0.0},
        {'element': 'O', 'x': -1.16, 'y': 0.0, 'z': 0.0},
        {'element': 'O', 'x': 1.16, 'y': 0.0, 'z': 0.0},
      ],
      'bonds': [
        [0, 1], [0, 2]
      ],
      'shape': 'Linear',
      'bondAngle': '180°',
      'geometry': 'Linear',
    },
    'Benzene (C6H6)': {
      'atoms': [
        {'element': 'C', 'x': 1.4, 'y': 0.0, 'z': 0.0},
        {'element': 'C', 'x': 0.7, 'y': 1.21, 'z': 0.0},
        {'element': 'C', 'x': -0.7, 'y': 1.21, 'z': 0.0},
        {'element': 'C', 'x': -1.4, 'y': 0.0, 'z': 0.0},
        {'element': 'C', 'x': -0.7, 'y': -1.21, 'z': 0.0},
        {'element': 'C', 'x': 0.7, 'y': -1.21, 'z': 0.0},
      ],
      'bonds': [
        [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 0]
      ],
      'shape': 'Planar Hexagonal',
      'bondAngle': '120°',
      'geometry': 'Trigonal Planar',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Molecular Geometry Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _rotation = 0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Molecule', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _molecules.keys.map((m) {
                        return ChoiceChip(
                          label: Text(m),
                          selected: _selectedMolecule == m,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedMolecule = m);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 300,
                child: _buildMolecularViewer(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.rotate_left),
                    onPressed: () => setState(() => _rotation -= 30),
                  ),
                  Text('Rotate: ${_rotation.toInt()}°'),
                  IconButton(
                    icon: const Icon(Icons.rotate_right),
                    onPressed: () => setState(() => _rotation += 30),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Molecular Properties', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _buildPropertyRow('Shape', _molecules[_selectedMolecule]!['shape']),
                    _buildPropertyRow('Bond Angle', _molecules[_selectedMolecule]!['bondAngle']),
                    _buildPropertyRow('Electron Geometry', _molecules[_selectedMolecule]!['geometry']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VSEPR Theory', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Text(
                      'VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on the repulsion between electron pairs around a central atom.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    _buildVSEPRInfo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMolecularViewer() {
    final molecule = _molecules[_selectedMolecule]!;
    final atoms = molecule['atoms'] as List;
    final bonds = molecule['bonds'] as List;
    
    return CustomPaint(
      painter: MoleculePainter(atoms, bonds, _rotation),
      size: const Size(double.infinity, 300),
    );
  }

  Widget _buildPropertyRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildVSEPRInfo() {
    String shape = _molecules[_selectedMolecule]!['shape'];
    Map<String, String> vseprInfo = {
      'Linear': '2 bonding pairs, 0 lone pairs - e.g., CO2, BeCl2',
      'Bent': '2 bonding pairs, 2 lone pairs - e.g., H2O',
      'Trigonal Pyramidal': '3 bonding pairs, 1 lone pair - e.g., NH3',
      'Tetrahedral': '4 bonding pairs, 0 lone pairs - e.g., CH4',
      'Planar Hexagonal': '6 bonding pairs, 0 lone pairs - e.g., Benzene',
    };
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(vseprInfo[shape] ?? 'Unknown VSEPR shape'),
    );
  }
}

class MoleculePainter extends CustomPainter {
  final List atoms;
  final List bonds;
  final double rotation;
  
  MoleculePainter(this.atoms, this.bonds, this.rotation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.height / 4;
    
    List<Offset> positions = [];
    for (var atom in atoms) {
      double x = (atom['x'] as double) * scale * 0.5;
      double y = (atom['y'] as double) * scale * 0.5;
      double angle = rotation * 3.14159 / 180;
      double newX = x * cos(angle) - y * sin(angle);
      double newY = x * sin(angle) + y * cos(angle);
      positions.add(Offset(centerX + newX, centerY - newY));
    }
    
    for (var bond in bonds) {
      int i = bond[0] as int;
      int j = bond[1] as int;
      canvas.drawLine(
        positions[i],
        positions[j],
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
      );
    }
    
    for (int i = 0; i < atoms.length; i++) {
      var atom = atoms[i];
      String element = atom['element'] as String;
      Color color = _getElementColor(element);
      double radius = _getElementRadius(element);
      
      canvas.drawCircle(
        positions[i],
        radius,
        Paint()..color = color,
      );
      
      canvas.drawCircle(
        positions[i],
        radius,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke,
      );
    }
  }
  
  Color _getElementColor(String element) {
    switch (element) {
      case 'H': return ThemeColors.atomHydrogen;
      case 'C': return ThemeColors.atomCarbon;
      case 'N': return ThemeColors.atomNitrogen;
      case 'O': return ThemeColors.atomOxygen;
      case 'S': return ThemeColors.atomSulfur;
      case 'P': return ThemeColors.atomPhosphorus;
      case 'Cl': return ThemeColors.atomChlorine;
      default: return Colors.grey;
    }
  }
  
  double _getElementRadius(String element) {
    switch (element) {
      case 'H': return 12;
      case 'C': return 18;
      case 'N': return 16;
      case 'O': return 14;
      default: return 16;
    }
  }
  
  @override
  bool shouldRepaint(covariant MoleculePainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
