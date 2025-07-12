import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const FacturationApp());
}

class FacturationApp extends StatelessWidget {
  const FacturationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samy Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FactureListScreen(),
    const ServiceScreen(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Samy Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateFactureScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Factures'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class FactureListScreen extends StatelessWidget {
  const FactureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simuler des données de factures
    final factures = [
      {
        'numero': 'SAMY_Services20230712-ABC123',
        'client': 'Jean Dupont',
        'montant': 15000.0,
        'statut': 'payé',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'laveur': 'Mohamed Diallo',
      },
      {
        'numero': 'SAMY_Services20230710-DEF456',
        'client': 'Marie Ndiaye',
        'montant': 20000.0,
        'statut': 'non_payé',
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'laveur': 'Awa Fall',
      },
      {
        'numero': 'SAMY_Services20230708-GHI789',
        'client': 'Paul Sarr',
        'montant': 12000.0,
        'statut': 'en_cours',
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'laveur': 'Ibrahima Diop',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: factures.length,
      itemBuilder: (context, index) {
        final facture = factures[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FactureDetailScreen(facture: facture),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        facture['numero'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(facture['statut'] as String),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatStatus(facture['statut'] as String),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Client: ${facture['client']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Laveur: ${facture['laveur']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA').format(facture['montant'])}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(facture['date'] as DateTime),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'payé':
        return Colors.green;
      case 'non_payé':
        return Colors.red;
      case 'en_cours':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'payé':
        return 'Payé';
      case 'non_payé':
        return 'Non payé';
      case 'en_cours':
        return 'En cours';
      default:
        return status;
    }
  }
}

class FactureDetailScreen extends StatelessWidget {
  final Map<String, dynamic> facture;

  const FactureDetailScreen({super.key, required this.facture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la facture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Imprimer la facture
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Partager la facture
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'FACTURE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Numéro:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(facture['numero'] as String),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(facture['date'] as DateTime),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Statut:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(facture['statut'] as String),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatStatus(facture['statut'] as String),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Client:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(facture['client'] as String),
                    const SizedBox(height: 16),
                    const Text(
                      'Laveur:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(facture['laveur'] as String),
                    const Divider(height: 32),
                    const Text(
                      'Détails du service:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('Service Premium'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                NumberFormat.currency(
                                  locale: 'fr_FR',
                                  symbol: 'FCFA',
                                ).format(15000),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'fr_FR',
                            symbol: 'FCFA',
                          ).format(facture['montant']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Part entreprise:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'fr_FR',
                            symbol: 'FCFA',
                          ).format(10000),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Commission laveur:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'fr_FR',
                            symbol: 'FCFA',
                          ).format(5000),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paiement',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Mode de paiement:'),
                        Text('Espèce'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date de paiement:'),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(facture['date'] as DateTime),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (facture['statut'] != 'payé')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Marquer comme payé
                  },
                  child: const Text('MARQUER COMME PAYÉ'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'payé':
        return Colors.green;
      case 'non_payé':
        return Colors.red;
      case 'en_cours':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'payé':
        return 'Payé';
      case 'non_payé':
        return 'Non payé';
      case 'en_cours':
        return 'En cours';
      default:
        return status;
    }
  }
}

class CreateFactureScreen extends StatefulWidget {
  const CreateFactureScreen({super.key});

  @override
  State<CreateFactureScreen> createState() => _CreateFactureScreenState();
}

class _CreateFactureScreenState extends State<CreateFactureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _montantController = TextEditingController();
  String? _selectedService;
  String? _selectedLaveur;
  String _paymentMode = 'espèce';
  String _status = 'en_cours';

  // Simuler des données
  final List<Map<String, dynamic>> _services = [
    {'id': '1', 'nom': 'Service Standard', 'prix': 10000, 'commission': 4000},
    {'id': '2', 'nom': 'Service Premium', 'prix': 15000, 'commission': 5000},
    {'id': '3', 'nom': 'Service VIP', 'prix': 20000, 'commission': 7000},
  ];

  final List<Map<String, dynamic>> _laveurs = [
    {'id': '1', 'nom': 'Mohamed Diallo'},
    {'id': '2', 'nom': 'Awa Fall'},
    {'id': '3', 'nom': 'Ibrahima Diop'},
  ];

  @override
  void dispose() {
    _clientController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle facture'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _submitForm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _clientController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du client',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom du client';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedService,
                        decoration: const InputDecoration(
                          labelText: 'Service',
                          prefixIcon: Icon(Icons.cleaning_services),
                          border: OutlineInputBorder(),
                        ),
                        items: _services.map((service) {
                          return DropdownMenuItem<String>(
                            value: service['id'],
                            child: Text(
                              '${service['nom']} - ${NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA').format(service['prix'])}',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedService = value;
                            if (value != null) {
                              final selected = _services.firstWhere(
                                (service) => service['id'] == value,
                              );
                              _montantController.text = selected['prix']
                                  .toString();
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner un service';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLaveur,
                        decoration: const InputDecoration(
                          labelText: 'Laveur',
                          prefixIcon: Icon(Icons.people),
                          border: OutlineInputBorder(),
                        ),
                        items: _laveurs.map((laveur) {
                          return DropdownMenuItem<String>(
                            value: laveur['id'],
                            child: Text(laveur['nom']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLaveur = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner un laveur';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _montantController,
                        decoration: const InputDecoration(
                          labelText: 'Montant (FCFA)',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le montant';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Veuillez entrer un montant valide';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paiement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RadioListTile<String>(
                        title: const Text('Espèce'),
                        value: 'espèce',
                        groupValue: _paymentMode,
                        onChanged: (value) {
                          setState(() {
                            _paymentMode = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Mobile Money'),
                        value: 'mobile',
                        groupValue: _paymentMode,
                        onChanged: (value) {
                          setState(() {
                            _paymentMode = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Carte Bancaire'),
                        value: 'carte',
                        groupValue: _paymentMode,
                        onChanged: (value) {
                          setState(() {
                            _paymentMode = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Statut',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'en_cours',
                            child: Text('En cours'),
                          ),
                          DropdownMenuItem(value: 'payé', child: Text('Payé')),
                          DropdownMenuItem(
                            value: 'non_payé',
                            child: Text('Non payé'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text('ENREGISTRER LA FACTURE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Enregistrer la facture
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facture enregistrée avec succès')),
      );
      Navigator.pop(context);
    }
  }
}

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simuler des données de services
    final services = [
      {
        'id': '1',
        'nom': 'Service Standard',
        'prix': 10000.0,
        'commission': 4000.0,
        'description': 'Lavage standard avec cirage',
      },
      {
        'id': '2',
        'nom': 'Service Premium',
        'prix': 15000.0,
        'commission': 5000.0,
        'description': 'Lavage complet avec traitement spécial',
      },
      {
        'id': '3',
        'nom': 'Service VIP',
        'prix': 20000.0,
        'commission': 7000.0,
        'description': 'Lavage VIP avec tous les traitements premium',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['nom'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['description'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prix total:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA').format(service['prix'])}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Commission laveur:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA').format(service['commission'])}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Part entreprise:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA').format((service['prix'] as double) - (service['commission'] as double))}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Statistiques',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          CircularProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 10,
            semanticsLabel: 'Chiffre d\'affaires',
          ),
          const SizedBox(height: 16),
          const Text('70% d\'objectif atteint', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 32),
          const Text(
            'Total ce mois: 450,000 FCFA',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Admin Samy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'admin@samy-services.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Déconnexion
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
