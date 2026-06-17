import 'package:flutter/material.dart';

class LabSafetyPage extends StatefulWidget {
  const LabSafetyPage({super.key});

  @override
  State<LabSafetyPage> createState() => _LabSafetyPageState();
}

class _LabSafetyPageState extends State<LabSafetyPage> {
  String _selectedCategory = 'Chemicals';
  
  final Map<String, List<Map<String, String>>> _safetyData = {
    'Chemicals': [
      {'name': 'HCl', 'hazard': 'Corrosive', 'precaution': 'Wear gloves and goggles. Use in fume hood.'},
      {'name': 'H₂SO₄', 'hazard': 'Corrosive, Dehydrating', 'precaution': 'Add acid to water slowly. Never add water to acid.'},
      {'name': 'NaOH', 'hazard': 'Caustic', 'precaution': 'Wear protective clothing. Avoid skin contact.'},
      {'name': 'Ethanol', 'hazard': 'Flammable', 'precaution': 'Keep away from flames. Use in ventilated area.'},
      {'name': 'Acetone', 'hazard': 'Highly Flammable', 'precaution': 'Store away from heat sources. No open flames.'},
      {'name': 'Benzene', 'hazard': 'Carcinogenic', 'precaution': 'Use only in fume hood. Minimize exposure.'},
      {'name': 'Methanol', 'hazard': 'Toxic, Flammable', 'precaution': 'Do not ingest. Keep away from ignition sources.'},
      {'name': 'Ammonia', 'hazard': 'Toxic, Irritant', 'precaution': 'Use in well-ventilated area. Wear mask.'},
    ],
    'Equipment': [
      {'name': 'Bunsen Burner', 'hazard': 'Fire Hazard', 'precaution': 'Keep flammable materials away. Never leave unattended.'},
      {'name': 'Glassware', 'hazard': 'Breakage, Cuts', 'precaution': 'Inspect for cracks. Handle with care.'},
      {'name': 'Centrifuge', 'hazard': 'Mechanical', 'precaution': 'Balance tubes. Wait for complete stop before opening.'},
      {'name': 'Autoclave', 'hazard': 'High Pressure', 'precaution': 'Release pressure before opening. Wear heat gloves.'},
    ],
    'General Rules': [
      {'name': 'PPE', 'hazard': 'Required', 'precaution': 'Always wear lab coat, safety goggles, and gloves.'},
      {'name': 'Food/Drink', 'hazard': 'Contamination', 'precaution': 'Never eat or drink in the laboratory.'},
      {'name': 'Spills', 'hazard': 'Various', 'precaution': 'Know location of spill kit. Report all spills.'},
      {'name': 'Emergency', 'hazard': 'Various', 'precaution': 'Know emergency exits, eyewash, and shower locations.'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Safety Guide'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: _safetyData.keys.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _safetyData[_selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _safetyData[_selectedCategory]![index];
                return _buildSafetyCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: _getHazardIcon(item['hazard'] ?? ''),
        title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getHazardColor(item['hazard'] ?? '').withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item['hazard'] ?? '',
            style: TextStyle(color: _getHazardColor(item['hazard'] ?? ''), fontSize: 12),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: _getHazardColor(item['hazard'] ?? '')),
                    const SizedBox(width: 8),
                    const Text('Hazard:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['hazard'] ?? ''),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.health_and_safety, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Safety Precaution:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['precaution'] ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Icon _getHazardIcon(String hazard) {
    if (hazard.toLowerCase().contains('flammable') || hazard.toLowerCase().contains('fire')) {
      return const Icon(Icons.local_fire_department, color: Colors.orange);
    } else if (hazard.toLowerCase().contains('corrosive') || hazard.toLowerCase().contains('caustic')) {
      return const Icon(Icons.warning, color: Colors.red);
    } else if (hazard.toLowerCase().contains('toxic') || hazard.toLowerCase().contains('carcinogenic')) {
      return const Icon(Icons.dangerous, color: Colors.purple);
    } else if (hazard.toLowerCase().contains('mechanical')) {
      return const Icon(Icons.settings, color: Colors.grey);
    }
    return const Icon(Icons.info, color: Colors.blue);
  }

  Color _getHazardColor(String hazard) {
    if (hazard.toLowerCase().contains('flammable') || hazard.toLowerCase().contains('fire')) {
      return Colors.orange;
    } else if (hazard.toLowerCase().contains('corrosive') || hazard.toLowerCase().contains('caustic')) {
      return Colors.red;
    } else if (hazard.toLowerCase().contains('toxic') || hazard.toLowerCase().contains('carcinogenic')) {
      return Colors.purple;
    }
    return Colors.blue;
  }
}
