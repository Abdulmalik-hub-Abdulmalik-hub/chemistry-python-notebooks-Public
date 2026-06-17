import 'package:equatable/equatable.dart';

enum ElementCategory {
  alkaliMetal,
  alkalineEarthMetal,
  transitionMetal,
  postTransitionMetal,
  metalloid,
  nonmetal,
  halogen,
  nobleGas,
  lanthanide,
  actinide,
  unknown,
}

class ChemicalElement extends Equatable {
  final int atomicNumber;
  final String symbol;
  final String name;
  final double atomicMass;
  final ElementCategory category;
  final int? group;
  final int period;
  final String block;
  final String electronConfiguration;
  final double? electronegativity;
  final int atomicRadius;
  final int ionizationEnergy;
  final int electronAffinity;
  final List<int> oxidationStates;
  final String standardState;
  final double meltingPoint;
  final double boilingPoint;
  final double density;
  final int discoveryYear;

  const ChemicalElement({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    this.group,
    required this.period,
    required this.block,
    required this.electronConfiguration,
    this.electronegativity,
    required this.atomicRadius,
    required this.ionizationEnergy,
    required this.electronAffinity,
    required this.oxidationStates,
    required this.standardState,
    required this.meltingPoint,
    required this.boilingPoint,
    required this.density,
    required this.discoveryYear,
  });

  String get categoryDisplayName {
    switch (category) {
      case ElementCategory.alkaliMetal:
        return 'Alkali Metal';
      case ElementCategory.alkalineEarthMetal:
        return 'Alkaline Earth Metal';
      case ElementCategory.transitionMetal:
        return 'Transition Metal';
      case ElementCategory.postTransitionMetal:
        return 'Post-Transition Metal';
      case ElementCategory.metalloid:
        return 'Metalloid';
      case ElementCategory.nonmetal:
        return 'Nonmetal';
      case ElementCategory.halogen:
        return 'Halogen';
      case ElementCategory.nobleGas:
        return 'Noble Gas';
      case ElementCategory.lanthanide:
        return 'Lanthanide';
      case ElementCategory.actinide:
        return 'Actinide';
      case ElementCategory.unknown:
        return 'Unknown';
    }
  }

  @override
  List<Object?> get props => [atomicNumber, symbol];
}
