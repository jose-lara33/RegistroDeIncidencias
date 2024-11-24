import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class IncidentFormScreen extends StatefulWidget {
  @override
  _IncidentFormScreenState createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classroomController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedProfessor;
  DateTime _selectedDate = DateTime.now();

  // Lista de incidencias con un campo extra "resolved"
  final List<Map<String, dynamic>> _incidents = [];

  final List<String> _professors = [
    'Paco benitez',
    'Don Rafa delgado',
    'Vicente',
  ];

  @override
  void dispose() {
    _classroomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.pink,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addIncident() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _incidents.add({
          'classroom': _classroomController.text,
          'professor': _selectedProfessor!,
          'date': DateFormat('dd/MM/yyyy').format(_selectedDate),
          'description': _descriptionController.text,
          'resolved': false, // Estado inicial: no resuelta
        });

        // Limpiar campos después de enviar
        _classroomController.clear();
        _descriptionController.clear();
        _selectedProfessor = null;
        _selectedDate = DateTime.now();
      });
    }
  }

  void _toggleResolved(int index) {
    setState(() {
      _incidents[index]['resolved'] = !_incidents[index]['resolved'];
    });
  }

  void _deleteIncident(int index) {
    setState(() {
      _incidents.removeAt(index);
    });
  }

 void _signOut() async {
  await FirebaseAuth.instance.signOut();
  context.go('/');  // Navegar a la pantalla de login con GoRouter
  print("Cerrando sesión correctamente");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Otra Incidencia? '),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,  // Aquí se cierra la sesión
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.send),
        onPressed: _addIncident,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiquetas encima de cada campo
                  Text(
                    'Número de Aula',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _classroomController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.pink),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce el número de aula';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nombre Profesor Detecta Incidencia',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedProfessor,
                    items: _professors.map((professor) {
                      return DropdownMenuItem(
                        value: professor,
                        child: Text(professor),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProfessor = value;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    dropdownColor: Colors.black,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecciona un profesor';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fecha Detección Incidencia',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Descripción de Incidencia',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una descripción';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Lista de incidencias
            Expanded(
              child: ListView.builder(
                itemCount: _incidents.length,
                itemBuilder: (context, index) {
                  final incident = _incidents[index];
                  final resolved = incident['resolved'];

                  return Card(
                    color: resolved ? Colors.white : Colors.grey[900],
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Aula: ${incident['classroom']} - Profesor: ${incident['professor']}',
                        style: TextStyle(color: resolved ? Colors.black : Colors.white),
                      ),
                      subtitle: Text(
                        'Fecha: ${incident['date']}\nDescripción: ${incident['description']}',
                        style: TextStyle(color: resolved ? Colors.black54 : Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => _toggleResolved(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteIncident(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
