# InnovaChem LabSuite

![InnovaChem LabSuite](https://img.shields.io/badge/Version-1.0.0-blue)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20Linux%20%7C%20macOS-green)
![License](https://img.shields.io/badge/License-MIT-orange)
![Flutter](https://img.shields.io/badge/Flutter-3.24.0-purple)

**InnovaChem LabSuite** is a professional, cross-platform scientific chemistry software platform designed for students, educators, researchers, and chemistry enthusiasts. This application transforms 20 chemistry-focused Jupyter notebooks into a production-ready Flutter application.

## Features

### Module A: Virtual Chemistry Laboratory
- **Interactive pH Titration** - Simulate acid-base titrations with real-time titration curves
- **Gas Law Simulator** - Explore Boyle's, Charles's, and Ideal Gas Laws
- **Reaction Rate Simulator** - Visualize chemical kinetics and rate laws
- **Electrochemistry Cell** - Galvanic cell calculator with standard potentials
- **Chemical Equilibrium Tool** - Le Chatelier's principle simulation

### Module B: Molecular Science Studio
- **3D Molecular Visualizer** - Interactive molecular geometry viewer with VSEPR theory
- **Molecular Docking Score** - Ligand binding affinity visualization
- **VSEPR Geometry Explorer** - Understand molecular shapes

### Module C: Spectroscopy Center
- **UV-Vis Spectroscopy** - Absorption spectrum simulator
- **Spectral Line Explorer** - Emission and absorption spectra visualization

### Module D: Physical Chemistry Laboratory
- **Quantum Energy Levels** - Hydrogen atom energy diagram explorer
- **Thermodynamic Explorer** - Gibbs free energy calculations

### Module E: Scientific Calculation Center
- **Stoichiometry Auto Solver** - Mass, moles, limiting reagent calculations
- **Buffer Calculator** - Henderson-Hasselbalch equation solver
- **Concentration Converter** - Molarity, molality, normality conversions
- **Formula Analyzer** - Chemical formula parsing and molecular weight calculation

### Module F: Learning & Safety Center
- **Periodic Table Explorer** - Interactive periodic table with element properties
- **Lab Safety Guide** - Chemical hazards and safety protocols

### Module G: Smart Chemistry Assistant
- **Offline Chemistry Knowledge Base** - Local chemistry Q&A system (no internet required)

## Technical Architecture

### Clean Architecture
```
lib/
├── core/                    # Shared utilities, constants, theme
│   ├── constants/           # App constants, scientific constants
│   ├── theme/              # Material 3 theming
│   └── utils/               # Chemistry calculations engine
├── features/                # Feature modules
│   ├── periodic_table/      # Periodic table feature
│   ├── ph_titration/       # pH titration feature
│   ├── gas_laws/           # Gas laws feature
│   └── ...
└── main.dart               # Application entry point
```

## Supported Platforms

- **Android** (APK, AAB)
- **iOS**
- **Web** (PWA)
- **Windows**
- **Linux**
- **macOS**

## Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart 3.5.0 or higher
- Android Studio / Xcode (for mobile builds)
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/innovachem-labsuite.git
cd innovachem-labsuite/innovachem_labsuite
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Different Platforms

```bash
# Android APK
flutter build apk --release

# Android AAB
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release
```

## Design System

### Theme
- **Material Design 3** - Modern, clean UI
- **Light & Dark Mode** - Automatic theme switching
- **Responsive Layouts** - Optimized for mobile, tablet, and desktop

### Color Palette
- Primary: Scientific Blue (#1565C0)
- Secondary: Lab Green (#2E7D32)
- Accent: Orange (#FF6D00)
- Chemistry-specific colors for elements and reactions

## Scientific Features

### Offline-First Design
- No login required
- No cloud dependency
- No server dependency
- All functionality works offline
- No subscription required
- No mandatory API integration

### Scientific Calculations
- pH and pOH calculations
- Ideal Gas Law (PV=nRT)
- Gibbs Free Energy (dG = dH - TdS)
- Electrochemical potentials
- Quantum energy levels
- Stoichiometric calculations
- Concentration conversions

## Testing

```bash
# Run all tests
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original Jupyter notebooks from the chemistry-python-notebooks repository
- Flutter team for the amazing cross-platform framework
- All contributors who help improve this project

---

**InnovaChem LabSuite** - Empowering chemistry education through technology.
