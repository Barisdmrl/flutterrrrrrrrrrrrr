import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../widgets/trade_offer_dialog.dart';
import '../widgets/animated_button_widget.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;

  const ListingDetailScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animasyonlu resim
            Hero(
              tag: 'listing_image_${listing.id}',
              child: Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  listing.images.first,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${listing.estimatedValue.toStringAsFixed(2)}₺',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Açıklama',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(listing.description),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 4),
                      Text(listing.location),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: listing.tags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                  SizedBox(height: 24),
                  // Animasyonlu takas teklifi butonu
                  Center(
                    child: AnimatedButtonWidget(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TradeOfferDialog(targetListing: listing),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_horiz, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Takas Teklifi Gönder',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 