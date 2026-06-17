import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/periodic_table/presentation/pages/periodic_table_page.dart';
import 'features/ph_titration/presentation/pages/ph_titration_page.dart';
import 'features/gas_laws/presentation/pages/gas_laws_page.dart';
import 'features/quantum_energy/presentation/pages/quantum_energy_page.dart';
import 'features/thermodynamics/presentation/pages/thermodynamics_page.dart';
import 'features/stoichiometry/presentation/pages/stoichiometry_page.dart';
import 'features/lab_safety/presentation/pages/lab_safety_page.dart';
import 'features/spectroscopy/presentation/pages/spectroscopy_page.dart';
import 'features/electrochemistry/presentation/pages/electrochemistry_page.dart';
import 'features/equilibrium/presentation/pages/equilibrium_page.dart';
import 'features/buffer_calculator/presentation/pages/buffer_calculator_page.dart';
import 'features/concentration_converter/presentation/pages/concentration_converter_page.dart';
import 'features/formula_analyzer/presentation/pages/formula_analyzer_page.dart';
import 'features/molecular_visualizer/presentation/pages/molecular_visualizer_page.dart';
import 'features/docking_score/presentation/pages/docking_score_page.dart';
import 'features/reaction_rate/presentation/pages/reaction_rate_page.dart';
import 'features/chemistry_assistant/presentation/pages/chemistry_assistant_page.dart';

void main() {
  runApp(const InnovaChemLabSuiteApp());
}

class InnovaChemLabSuiteApp extends StatelessWidget {
  const InnovaChemLabSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'InnovaChem LabSuite',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.science,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildListDelegate([
                _buildModuleCard(
                  context,
                  'Virtual Lab',
                  'Interactive pH Titration, Gas Laws, Electrochemistry',
                  Icons.biotech,
                  Colors.blue,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhTitrationPage())),
                ),
                _buildModuleCard(
                  context,
                  'Molecular Studio',
                  '3D Visualizer, Docking Scores, VSEPR Geometry',
                  Icons.bubble_chart,
                  Colors.purple,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MolecularVisualizerPage())),
                ),
                _buildModuleCard(
                  context,
                  'Spectroscopy',
                  'UV-Vis Spectra, Emission & Absorption Lines',
                  Icons.show_chart,
                  Colors.orange,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpectroscopyPage())),
                ),
                _buildModuleCard(
                  context,
                  'Physical Chemistry',
                  'Quantum Energy, Thermodynamics',
                  Icons.thermostat,
                  Colors.red,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuantumEnergyPage())),
                ),
                _buildModuleCard(
                  context,
                  'Calculations',
                  'Stoichiometry, Buffers, Concentrations, Formulas',
                  Icons.calculate,
                  Colors.green,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoichiometryPage())),
                ),
                _buildModuleCard(
                  context,
                  'Learning Center',
                  'Periodic Table, Lab Safety Guide',
                  Icons.school,
                  Colors.teal,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PeriodicTablePage())),
                ),
                _buildModuleCard(
                  context,
                  'Smart Assistant',
                  'Offline Chemistry Knowledge Base',
                  Icons.psychology,
                  Colors.indigo,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChemistryAssistantPage())),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
