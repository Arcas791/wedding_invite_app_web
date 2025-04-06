import '../entities/rsvp.dart';
import '../repositories/rsvp_repository.dart';

class ConfirmRsvp {
  final RsvpRepository repository;

  ConfirmRsvp(this.repository);

  Future<void> execute(Rsvp rsvp) async {
    // Aquí podrías validar, transformar o aplicar lógica
    await repository.saveRsvp(rsvp);
  }
}
