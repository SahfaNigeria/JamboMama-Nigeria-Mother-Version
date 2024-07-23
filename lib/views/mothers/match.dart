import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfessionalsList extends StatelessWidget {
  final String location;

  ProfessionalsList({required this.location});

  Future<List<DocumentSnapshot>> fetchHealthcareProfessionals(
      String location) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Health Professionals')
        .where('position', isEqualTo: 'Doctor')
        .where('villageTown', isEqualTo: location)
        .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Professionals'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchHealthcareProfessionals(location),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No professionals found'));
          } else {
            List<DocumentSnapshot> professionals = snapshot.data!;
            return ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                var professional = professionals[index];
                return ListTile(
                  title: Text(professional['fullName']),
                  subtitle: Text(professional['position']),
                  onTap: () {
                    print(location);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
