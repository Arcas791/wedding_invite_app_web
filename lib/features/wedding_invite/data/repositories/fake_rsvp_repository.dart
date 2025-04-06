import 'package:flutter/foundation.dart';
import '../../domain/entities/rsvp.dart';
import '../../domain/repositories/rsvp_repository.dart';

class FakeRsvpRepository implements RsvpRepository {
  @override
  Future<void> saveRsvp(Rsvp rsvp) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula latencia
    debugPrint('✅ RSVP recibida:');
    debugPrint('👤 Nombre: ${rsvp.name}');
    debugPrint('🎉 Asiste: ${rsvp.isAttending ? "Sí" : "No"}');
    debugPrint('🍽️ Alergias: ${rsvp.allergies}');
    debugPrint('🎵 Peticiones musicales: ${rsvp.songRequests}');
  }
}
