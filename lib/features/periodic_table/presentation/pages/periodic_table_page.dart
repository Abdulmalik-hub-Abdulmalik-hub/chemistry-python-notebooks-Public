import 'package:flutter/material.dart';
import '../../data/datasources/periodic_table_data.dart';
import '../../domain/entities/element_entity.dart';
import '../../../../core/constants/theme_constants.dart';

class PeriodicTablePage extends StatefulWidget {
  const PeriodicTablePage({super.key});

  @override
  State<PeriodicTablePage> createState() => _PeriodicTablePageState();
}

class _PeriodicTablePageState extends State<PeriodicTablePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredElements = _searchQuery.isEmpty
        ? PeriodicTableData.allElements
        : PeriodicTableData.searchElements(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Periodic Table Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showLegend,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, symbol, or atomic number',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults(filteredElements)
                : _buildPeriodicTableGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<ChemicalElement> elements) {
    if (elements.isEmpty) {
      return const Center(
        child: Text('No elements found'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) {
        return _buildElementTile(elements[index]);
      },
    );
  }

  Widget _buildPeriodicTableGrid() {
    final elements = PeriodicTableData.allElements;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainTable(elements),
              const SizedBox(height: 20),
              _buildLanthanidesActinides(elements),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTable(List<ChemicalElement> elements) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (var element in elements.take(118))
          if (element.category != ElementCategory.lanthanide && 
              element.category != ElementCategory.actinide)
            _buildElementTile(element),
      ],
    );
  }

  Widget _buildLanthanidesActinides(List<ChemicalElement> elements) {
    final lanthanides = elements.where((e) => e.category == ElementCategory.lanthanide).toList();
    final actinides = elements.where((e) => e.category == ElementCategory.actinide).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lanthanides', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: lanthanides.map((e) => _buildElementTile(e)).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Actinides', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: actinides.map((e) => _buildElementTile(e)).toList(),
        ),
      ],
    );
  }

  Widget _buildElementTile(ChemicalElement element) {
    return GestureDetector(
      onTap: () => _showElementDetails(element),
      child: Container(
        width: 60,
        height: 70,
        decoration: BoxDecoration(
          color: _getCategoryColor(element.category),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${element.atomicNumber}',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
            Text(
              element.symbol,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              element.name.length > 8 
                  ? '${element.name.substring(0, 7)}.' 
                  : element.name,
              style: const TextStyle(fontSize: 7),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(ElementCategory category) {
    switch (category) {
      case ElementCategory.alkaliMetal:
        return ThemeColors.accentRed.withOpacity(0.3);
      case ElementCategory.alkalineEarthMetal:
        return ThemeColors.accentOrange.withOpacity(0.3);
      case ElementCategory.transitionMetal:
        return ThemeColors.primaryBlue.withOpacity(0.3);
      case ElementCategory.postTransitionMetal:
        return ThemeColors.primaryBlueLight.withOpacity(0.3);
      case ElementCategory.metalloid:
        return ThemeColors.accentTeal.withOpacity(0.3);
      case ElementCategory.nonmetal:
        return ThemeColors.secondaryGreen.withOpacity(0.3);
      case ElementCategory.halogen:
        return ThemeColors.accentPurple.withOpacity(0.3);
      case ElementCategory.nobleGas:
        return ThemeColors.chartPalette[6].withOpacity(0.3);
      case ElementCategory.lanthanide:
        return Colors.pink.withOpacity(0.3);
      case ElementCategory.actinide:
        return Colors.deepPurple.withOpacity(0.3);
      case ElementCategory.unknown:
        return Colors.grey.withOpacity(0.3);
    }
  }

  void _showElementDetails(ChemicalElement element) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(element.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${element.atomicNumber}', 
                            style: const TextStyle(fontSize: 12)),
                        Text(element.symbol,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Text('${element.atomicMass.toStringAsFixed(3)}',
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(element.name,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text(element.categoryDisplayName,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Atomic Number', '${element.atomicNumber}'),
              _buildDetailRow('Atomic Mass', '${element.atomicMass.toStringAsFixed(4)} g/mol'),
              _buildDetailRow('Electron Configuration', element.electronConfiguration),
              if (element.electronegativity != null)
                _buildDetailRow('Electronegativity', '${element.electronegativity}'),
              _buildDetailRow('Atomic Radius', '${element.atomicRadius} pm'),
              _buildDetailRow('Ionization Energy', '${element.ionizationEnergy} kJ/mol'),
              _buildDetailRow('Standard State', element.standardState),
              _buildDetailRow('Melting Point', '${element.meltingPoint} K'),
              _buildDetailRow('Boiling Point', '${element.boilingPoint} K'),
              _buildDetailRow('Density', '${element.density} g/cm³'),
              _buildDetailRow('Oxidation States', element.oxidationStates.join(', ')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showLegend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Element Categories'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ElementCategory.values.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(ChemicalElement(
                      atomicNumber: 1,
                      symbol: '',
                      name: '',
                      atomicMass: 0,
                      category: category,
                      period: 1,
                      block: '',
                      electronConfiguration: '',
                      atomicRadius: 0,
                      ionizationEnergy: 0,
                      electronAffinity: 0,
                      oxidationStates: [],
                      standardState: '',
                      meltingPoint: 0,
                      boilingPoint: 0,
                      density: 0,
                      discoveryYear: 0,
                    ).categoryDisplayName),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
