import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueSection extends StatelessWidget {
  const VenueSection({super.key});

  final String mapsUrl =
      'https://www.google.com/maps?rlz=1C1CHBF_esES878ES878&um=1&ie=UTF-8&fb=1&gl=es&sa=X&geocode=KV_EukngWGANMRsOywHA8aks&daddr=Av.+del+Turia,+1,+46190+Riba-roja+de+T%C3%BAria,+Valencia';

  Future<void> _launchMaps() async {
    final Uri uri = Uri.parse(mapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el mapa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'La Masía',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/masia.jpg',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mas d\'Alzedo',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'Esta masía, en Riba-roja de Túria, es un sitio que nos ha enamorado desde el primer momento que la vismos; creemos que es un lugar con mucho encanto donde celebraremos cada momento de este día tan especial con todos vosotros 🤗🤗🤗.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _launchMaps,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ver en Google Maps'),
          ),
        ],
      ),
    );
  }
}
