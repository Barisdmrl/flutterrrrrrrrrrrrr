import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../models/trade_offer_model.dart';
import '../services/listing_service.dart';
import '../services/auth_service.dart';

class TradeOfferDialog extends StatefulWidget {
  final Listing targetListing;

  const TradeOfferDialog({Key? key, required this.targetListing}) : super(key: key);

  @override
  _TradeOfferDialogState createState() => _TradeOfferDialogState();
}

class _TradeOfferDialogState extends State<TradeOfferDialog> {
  Listing? _selectedListing;
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listingService = context.watch<ListingService>();
    final authService = context.watch<AuthService>();
    
    final myListings = listingService.listings
        .where((listing) => listing.owner.id == authService.currentUser!.id)
        .where((listing) => listing.status == ListingStatus.active)
        .toList();

    return AlertDialog(
      title: Text('Takas Teklifi Gönder'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teklif etmek istediğiniz ürünü seçin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (myListings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Aktif ilanınız bulunmamaktadır.',
                  style: TextStyle(color: Colors.red),
                ),
              )
            else
              Container(
                height: 200,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: myListings.length,
                  itemBuilder: (context, index) {
                    final listing = myListings[index];
                    return RadioListTile<Listing>(
                      value: listing,
                      groupValue: _selectedListing,
                      title: Text(listing.title),
                      subtitle: Text(
                        '${listing.estimatedValue.toStringAsFixed(2)}₺',
                        style: TextStyle(color: Colors.green),
                      ),
                      onChanged: (Listing? value) {
                        setState(() {
                          _selectedListing = value;
                        });
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Mesajınız (Opsiyonel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        ElevatedButton(
          onPressed: myListings.isEmpty || _selectedListing == null
              ? null
              : () async {
                  final offer = TradeOffer(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    targetListing: widget.targetListing,
                    offeredListing: _selectedListing!,
                    sender: authService.currentUser!,
                    createdAt: DateTime.now(),
                    message: _messageController.text.trim(),
                  );

                  await listingService.sendTradeOffer(offer);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Takas teklifiniz gönderildi'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade400,
          ),
          child: Text('Teklif Gönder'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
} 