import 'package:flutter/material.dart';

class ChemistryAssistantPage extends StatefulWidget {
  const ChemistryAssistantPage({super.key});

  @override
  State<ChemistryAssistantPage> createState() => _ChemistryAssistantPageState();
}

class _ChemistryAssistantPageState extends State<ChemistryAssistantPage> {
  final _searchController = TextEditingController();
  List<_ChemistryQuestion> _questions = [];
  List<_ChemistryQuestion> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _filteredQuestions = _questions;
  }

  void _loadQuestions() {
    _questions = [
      _ChemistryQuestion(
        question: 'What is the molar mass of H2O?',
        answer: 'Molar mass of H2O = 18.015 g/mol\n'
            '• Hydrogen (H): 2 × 1.008 = 2.016 g/mol\n'
            '• Oxygen (O): 1 × 16.00 = 16.00 g/mol\n'
            '• Total: 2.016 + 16.00 = 18.015 g/mol',
        category: 'Stoichiometry',
      ),
      _ChemistryQuestion(
        question: 'How do you balance chemical equations?',
        answer: 'Steps to balance chemical equations:\n'
            '1. Write the unbalanced equation\n'
            '2. Count atoms of each element\n'
            '3. Add coefficients to balance atoms\n'
            '4. Start with elements appearing once\n'
            '5. Balance hydrogen and oxygen last\n'
            '6. Verify all atoms are balanced',
        category: 'General',
      ),
      _ChemistryQuestion(
        question: 'What is Avogadro\'s number?',
        answer: 'Avogadro\'s number (NA) = 6.022 × 10²³ particles/mol\n\n'
            '• Named after Amedeo Avogadro\n'
            '• Defines the number of particles in one mole\n'
            '• Used to convert between moles and particles\n'
            '• One mole of any substance contains NA particles',
        category: 'General',
      ),
      _ChemistryQuestion(
        question: 'How to calculate pH?',
        answer: 'pH Calculation:\n'
            '• pH = -log[H⁺]\n'
            '• pOH = -log[OH⁻]\n'
            '• pH + pOH = 14\n'
            '• [H⁺] = 10^(-pH)\n\n'
            'Examples:\n'
            '• pH 7 = neutral\n'
            '• pH < 7 = acidic\n'
            '• pH > 7 = basic',
        category: 'Acids & Bases',
      ),
      _ChemistryQuestion(
        question: 'What is the ideal gas law?',
        answer: 'PV = nRT\n\n'
            'Where:\n'
            '• P = Pressure (atm or Pa)\n'
            '• V = Volume (L or m³)\n'
            '• n = Number of moles\n'
            '• R = Gas constant (0.0821 L·atm/mol·K or 8.314 J/mol·K)\n'
            '• T = Temperature (K)\n\n'
            'Standard conditions:\n'
            '• STP: 0°C (273.15K), 1 atm\n'
            '• SATP: 25°C (298.15K), 1 bar',
        category: 'Gases',
      ),
      _ChemistryQuestion(
        question: 'What is Hess\'s Law?',
        answer: 'Hess\'s Law: The enthalpy change of a reaction is independent of the path taken.\n\n'
            'Applications:\n'
            '• Calculate ΔH from known reactions\n'
            '• Use formation enthalpies\n'
            '• Combine reactions algebraically\n'
            '• Remember to multiply coefficients',
        category: 'Thermodynamics',
      ),
      _ChemistryQuestion(
        question: 'How to name organic compounds?',
        answer: 'IUPAC Naming Rules:\n'
            '1. Find longest carbon chain\n'
            '2. Number from end giving substituents lowest numbers\n'
            '3. Name substituents with prefixes\n'
            '4. Use suffixes for functional groups\n\n'
            'Common suffixes:\n'
            '• -ane: alkanes\n'
            '• -ene: alkenes\n'
            '• -yne: alkynes\n'
            '• -ol: alcohols\n'
            '• -al: aldehydes\n'
            '• -one: ketones',
        category: 'Organic Chemistry',
      ),
      _ChemistryQuestion(
        question: 'What are oxidation numbers?',
        answer: 'Oxidation Number Rules:\n'
            '• Free elements: 0\n'
            '• Monatomic ions: charge\n'
            '• Oxygen: -2 (except peroxides: -1)\n'
            '• Hydrogen: +1 (except metal hydrides: -1)\n'
            '• Sum of all oxidation numbers = charge\n\n'
            'Redox:\n'
            '• Oxidation = increase in oxidation number (loss of electrons)\n'
            '• Reduction = decrease in oxidation number (gain of electrons)',
        category: 'Redox',
      ),
      _ChemistryQuestion(
        question: 'How to calculate equilibrium constant?',
        answer: 'For aA + bB ⇌ cC + dD\n\n'
            'Kc = [C]ᶜ[D]ᵈ / [A]ᵃ[B]ᵇ\n\n'
            'Kp = P(C)ᶜP(D)ᵈ / P(A)ᵃP(B)ᵇ\n\n'
            '• K > 1: Products favored\n'
            '• K < 1: Reactants favored\n'
            '• K = 1: Neither favored',
        category: 'Equilibrium',
      ),
      _ChemistryQuestion(
        question: 'What is Le Chatelier\'s Principle?',
        answer: 'When a system at equilibrium is disturbed, it shifts to counteract the change.\n\n'
            'Factors affecting equilibrium:\n'
            '• Concentration: Add → shift away\n'
            '• Temperature: Increase → shift toward heat\n'
            '• Pressure: Increase → shift toward fewer moles\n'
            '• Catalyst: No effect on position',
        category: 'Equilibrium',
      ),
    ];
  }

  void _filterQuestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredQuestions = _questions;
      } else {
        _filteredQuestions = _questions.where((q) =>
            q.question.toLowerCase().contains(query.toLowerCase()) ||
            q.answer.toLowerCase().contains(query.toLowerCase()) ||
            q.category.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemistry Assistant'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chemistry topics...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterQuestions,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: _questions.map((q) => Chip(
                label: Text(q.category, style: const TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredQuestions.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(_filteredQuestions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(_ChemistryQuestion q) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(_getCategoryIcon(q.category), color: Theme.of(context).colorScheme.primary),
        title: Text(q.question, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(q.category, style: const TextStyle(fontSize: 11)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(q.answer, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Stoichiometry': return Icons.calculate;
      case 'Acids & Bases': return Icons.science;
      case 'Gases': return Icons.air;
      case 'Thermodynamics': return Icons.thermostat;
      case 'Equilibrium': return Icons.balance;
      case 'Organic Chemistry': return Icons.hexagon;
      case 'Redox': return Icons.bolt;
      default: return Icons.help;
    }
  }
}

class _ChemistryQuestion {
  final String question;
  final String answer;
  final String category;

  _ChemistryQuestion({
    required this.question,
    required this.answer,
    required this.category,
  });
}
