import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueSection extends StatelessWidget {
  const VenueSection({super.key});

  final String mapsUrl = 'https://www.google.com/maps?rlz=1C1CHBF_esES878ES878&um=1&ie=UTF-8&fb=1&gl=es&sa=X&geocode=KV_EukngWGANMRsOywHA8aks&daddr=Av.+del+Turia,+1,+46190+Riba-roja+de+T%C3%BAria,+Valencia';

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
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFECE4DB),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'La Masía',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D6875),
            ),
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
          const Text(
            'Masía El Encanto\nCarrer de l\'Amor, 123\nValencia',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _launchMaps,
            icon: const Icon(Icons.map),
            label: const Text('Ver en Google Maps'),
          ),
          const SizedBox(height: 20),
          const Text(
            '🅿 Parking gratuito disponible\n🛏 Alojamiento cercano recomendado\n👗 Ropa elegante (informal formal)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
