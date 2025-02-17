import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpectedDeliveryScreen extends StatefulWidget {
  const ExpectedDeliveryScreen({super.key});

  @override
  _ExpectedDeliveryScreenState createState() {
    return _ExpectedDeliveryScreenState();
  }
}

class _ExpectedDeliveryScreenState extends State<ExpectedDeliveryScreen> {
  final TextEditingController _lmpController = TextEditingController();
  String _expectedDeliveryDate = '';

  void _calculateExpectedDeliveryDate() {
    DateTime lmp = DateTime.parse(_lmpController.text);
    DateTime expectedDeliveryDate =
        lmp.add(const Duration(days: 280)); // 280 days is roughly 40 weeks
    setState(() {
      _expectedDeliveryDate = expectedDeliveryDate.toString();
    });

    // Call function to send data to Firestore
    _sendDataToFirestore(_expectedDeliveryDate);
  }

  Future<void> _sendDataToFirestore(String expectedDeliveryDate) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        CollectionReference deliveries = FirebaseFirestore.instance
            .collection('Mother Pregnancy Data')
            .doc(userId)
            .collection('Expected Delivery Date');

        await deliveries.add({
          'expectedDeliveryDate': expectedDeliveryDate,
          'timestamp': FieldValue
              .serverTimestamp(), // Optional: include server timestamp
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your Delivery Date is Saved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit delivery date: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Date Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _lmpController,
              decoration: const InputDecoration(
                labelText: 'Enter Your Last Menstrual Period (YYYY-MM-DD)',
                hintText: '2024-02-14',
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateExpectedDeliveryDate,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              _expectedDeliveryDate.isNotEmpty
                  ? 'Expected Delivery Date: $_expectedDeliveryDate'
                  : '',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
