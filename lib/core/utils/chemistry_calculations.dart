import 'dart:math';
import '../constants/app_constants.dart';

class ChemistryCalculations {
  static const double ln10 = 2.302585092994046;
  static const double ln2 = 0.6931471805599453;

  static double calculatePH(double hConcentration) {
    if (hConcentration <= 0) return 14.0;
    return -log(hConcentration) / ln10;
  }

  static double calculatePOH(double ohConcentration) {
    if (ohConcentration <= 0) return 14.0;
    return -log(ohConcentration) / ln10;
  }

  static double calculateHConcentration(double pH) {
    return pow(10, -pH).toDouble();
  }

  static double calculateOHConcentration(double pOH) {
    return pow(10, -pOH).toDouble();
  }

  static double calculatePHFromPKa(double pKa, double acidConc, double conjugateBaseConc) {
    return pKa + log(conjugateBaseConc / acidConc) / ln10;
  }

  static double calculateIdealGasPressure(double moles, double temperature, double volume) {
    if (volume == 0) return 0;
    return (moles * AppConstants.gasConstant * temperature) / volume;
  }

  static double calculateIdealGasVolume(double moles, double temperature, double pressure) {
    if (pressure == 0) return 0;
    return (moles * AppConstants.gasConstant * temperature) / pressure;
  }

  static double calculateIdealGasTemperature(double pressure, double volume, double moles) {
    if (moles == 0) return 0;
    return (pressure * volume) / (moles * AppConstants.gasConstant);
  }

  static double calculateIdealGasMoles(double pressure, double volume, double temperature) {
    return (pressure * volume) / (AppConstants.gasConstant * temperature);
  }

  static double boylesLawP2(double p1, double v1, double v2) {
    if (v2 == 0) return 0;
    return (p1 * v1) / v2;
  }

  static double charlesLawV2(double v1, double t1, double t2) {
    if (t1 == 0) return 0;
    return (v1 * t2) / t1;
  }

  static double calculateGibbsFreeEnergy(double deltaH, double deltaS, double temperature) {
    return deltaH - (temperature * deltaS);
  }

  static double calculateEquilibriumConstant(double deltaG, double temperature) {
    if (deltaG == 0) return 1;
    return exp(-deltaG * 1000 / (AppConstants.gasConstant * temperature));
  }

  static double calculateDeltaGFromK(double k, double temperature) {
    if (k <= 0) return double.infinity;
    return -AppConstants.gasConstant * temperature * log(k) / 1000;
  }

  static double calculateCellPotential(double cathodePotential, double anodePotential) {
    return cathodePotential - anodePotential;
  }

  static double calculateNernstPotential(double standardPotential, double temperature,
      int electrons, double concentrationRatio) {
    if (concentrationRatio <= 0 || electrons == 0) return standardPotential;
    return standardPotential - (AppConstants.gasConstant * temperature * log(concentrationRatio))
        / (electrons * AppConstants.faradayConstant);
  }

  static double calculatePhotonEnergy(double wavelength) {
    if (wavelength == 0) return 0;
    return (AppConstants.planckConstant * AppConstants.speedOfLight) / wavelength;
  }

  static double calculateHydrogenEnergyLevel(int n) {
    if (n == 0) return 0;
    return -13.6 / (n * n);
  }

  static double calculateEmissionWavelength(int n1, int n2) {
    if (n1 <= 0 || n2 <= 0 || n1 <= n2) return 0;
    final wavelength = 1 / (AppConstants.rydbergConstant * (1/(n2*n2) - 1/(n1*n1)));
    return wavelength * 1e9;
  }

  static double calculateMoles(double mass, double molarMass) {
    if (molarMass == 0) return 0;
    return mass / molarMass;
  }

  static double calculateMass(double moles, double molarMass) {
    return moles * molarMass;
  }

  static double calculateMolarity(double moles, double volumeLiters) {
    if (volumeLiters == 0) return 0;
    return moles / volumeLiters;
  }

  static double calculateMolality(double moles, double massKg) {
    if (massKg == 0) return 0;
    return moles / massKg;
  }

  static double calculateNormality(double molarity, int equivalents) {
    return molarity * equivalents;
  }

  static double calculateMassPercent(double soluteMass, double solutionMass) {
    if (solutionMass == 0) return 0;
    return (soluteMass / solutionMass) * 100;
  }

  static double calculateReactionRate(double k, double concentration, int order) {
    return k * pow(concentration, order);
  }

  static double calculateHalfLife(double k, int order) {
    if (k == 0) return double.infinity;
    switch (order) {
      case 1:
        return ln2 / k;
      case 2:
        return 1 / k;
      default:
        return double.infinity;
    }
  }

  static double molarityToMolality(double molarity, double density, double molarMass) {
    if (density == 0 || molarMass == 0) return 0;
    return molarity / (density - molarity * molarMass / 1000);
  }

  static double molarityToNormality(double molarity, int equivalents) {
    return molarity * equivalents;
  }

  static double ppmToMolarity(double ppm, double molarMass) {
    return (ppm * 1000) / molarMass;
  }
}
