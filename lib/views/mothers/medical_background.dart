import 'package:flutter/material.dart';

class MedicalBackgroundForm extends StatefulWidget {
  const MedicalBackgroundForm({super.key});

  @override
  _MedicalBackgroundFormState createState() => _MedicalBackgroundFormState();
}

class _MedicalBackgroundFormState extends State<MedicalBackgroundForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _age = 0;
  String _bloodType = '';
  String _allergies = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Background'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  prefixIcon: Icon(Icons.opacity),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your blood type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bloodType = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  prefixIcon: Icon(Icons.health_and_safety),
                ),
                validator: (value) {
                  // No validation for allergies, can be left blank
                  return null;
                },
                onSaved: (value) {
                  _allergies = value!;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      // Submit form logic can go here
                      print(
                          'Name: $_name, Age: $_age, Blood Type: $_bloodType, Allergies: $_allergies');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
