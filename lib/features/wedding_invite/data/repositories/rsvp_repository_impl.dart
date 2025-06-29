// import 'package:flutter/foundation.dart';
// import '../../domain/entities/rsvp.dart';
// import '../../domain/repositories/rsvp_repository.dart';

// class FakeRsvpRepository implements RsvpRepository {
//   @override
//   Future<void> saveRsvp(Rsvp rsvp) async {
//     await Future.delayed(const Duration(milliseconds: 300)); // Simula latencia
//     debugPrint('✅ RSVP recibida:');
//     debugPrint('👤 Nombre: ${rsvp.name}');
//     debugPrint('🎉 Asiste: ${rsvp.isAttending ? "Sí" : "No"}');
//     debugPrint('🍽️ Alergias: ${rsvp.allergies}');
//     debugPrint('🎵 Peticiones musicales: ${rsvp.songRequests}');
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/rsvp.dart';
import '../../domain/repositories/rsvp_repository.dart';

class RsvpRepositoryImpl implements RsvpRepository {
  final String baseUrl =
      'https://weddinginviteappback-production.up.railway.app';

  @override
  Future<void> submitRSVP(Rsvp rsvp) async {
    final url = Uri.parse('$baseUrl/guests/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': rsvp.name,
        'isAttending': rsvp.isAttending,
        'bus': rsvp.bus,
        'allergies': rsvp.allergies,
        'songRequests': rsvp.songRequests,
        'companionName': rsvp.companionName,
        'children': rsvp.children,
        'childrenNames': rsvp.childrenNames,
        "childrenAges": rsvp.childrenAges,
        'tomorrowland': rsvp.tomorrowland,
        'createdAt': rsvp.createdAt,
      }),
    );

    if (response.statusCode != 200) {
      print('❌ Error del backend: ${response.statusCode} - ${response.body}');
      throw Exception('Fallo al enviar el RSVP');
    }
  }
}
