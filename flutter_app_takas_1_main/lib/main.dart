import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/auth_service.dart';
import 'services/listing_service.dart';
import 'services/review_service.dart';
import 'services/report_service.dart';
import 'services/theme_service.dart';
import 'services/localization_service.dart';
import 'services/social_auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/trade_offer_dialog.dart';
import 'models/listing_model.dart';
import 'models/trade_offer_model.dart';
import 'models/user_model.dart';
import 'models/report_model.dart';
import 'screens/listing_detail_screen.dart';
import 'widgets/animated_button_widget.dart';

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService()..autoLogin(),
        ),
        ChangeNotifierProvider(
          create: (_) => ListingService()..loadTestData(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewService()..loadTestData(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportService()..loadTestData(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocialAuthService(),
        ),
      ],
      child: ModaApp(),
    ),
  );
}

class ModaApp extends StatelessWidget {
  const ModaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final localizationService = context.watch<LocalizationService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeService.currentTheme,
      locale: localizationService.currentLocale,
      supportedLocales: localizationService.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<String> profileImages = [];

  @override
  void initState() {
    super.initState();
    _initializeProfileImages();
  }

  Future<void> _initializeProfileImages() async {
    List<String> tempImages = [];
    for (int i = 0; i < 7; i++) {
      final response = await http.get(Uri.parse('https://picsum.photos/200?random=$i'));
      if (response.statusCode == 200) {
        tempImages.add(response.request!.url.toString());
      }
    }
    setState(() {
      profileImages = tempImages;
    });
  }

  Future<void> _pickOrDownloadImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Resim Seçin"),
        content: Text("Galeriden resim seçmek veya rastgele bir resim indirmek ister misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'gallery'),
            child: Text("Galeri"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'random'),
            child: Text("Rastgele Resim"),
          ),
        ],
      ),
    );

    if (result == 'gallery') {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          profileImages[index] = image.path;
        });
      }
    } else if (result == 'random') {
      final response = await http.get(Uri.parse('https://picsum.photos/200?random=${DateTime.now().millisecondsSinceEpoch}'));
      if (response.statusCode == 200) {
        setState(() {
          profileImages[index] = response.request!.url.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final listingService = context.watch<ListingService>();
    final localizationService = context.watch<LocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 0,
        title: Text(
          "SWAP",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (authService.isLoggedIn)
            PopupMenuButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(authService.currentUser?.profileImage ?? 'https://picsum.photos/200'),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(localizationService.getString('profile')),
                  value: 'profile',
                ),
                PopupMenuItem(
                  child: Text(localizationService.getString('my_offers')),
                  value: 'offers',
                ),
                PopupMenuItem(
                  child: Text(localizationService.getString('settings')),
                  value: 'settings',
                ),
                PopupMenuItem(
                  child: Text(localizationService.getString('logout')),
                  value: 'logout',
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  authService.logout();
                  context.read<SocialAuthService>().signOut();
                } else if (value == 'offers') {
                  _showTradeOffers(context);
                } else if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                }
              },
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    localizationService.getString('login'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    localizationService.getString('register'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBar(),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.deepPurple.shade50,
                  height: 180,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(profileImages.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () => _pickOrDownloadImage(index),
                          child: listeElemani(profileImages[index]),
                        ),
                      );
                    }),
                  ),
                ),
                // İlanlar listesi
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Son İlanlar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listingService.listings.length,
                        itemBuilder: (context, index) {
                          final listing = listingService.listings[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListingDetailScreen(listing: listing),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Hero(
                                  tag: 'listing_image_${listing.id}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      listing.images.first,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(listing.title),
                                subtitle: Text(
                                  '${listing.estimatedValue.toStringAsFixed(2)}₺\n${listing.location}',
                                ),
                                trailing: AnimatedButtonWidget(
                                  onPressed: () => _showTradeOfferDialog(context, listing),
                                  child: const Icon(Icons.swap_horiz),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Kategori butonları
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      kategoriButonu('Elektronik', Icons.devices, Colors.blue),
                      kategoriButonu('Giyim', Icons.shopping_bag, Colors.pink),
                      kategoriButonu('Kitap', Icons.book, Colors.green),
                      kategoriButonu('Spor', Icons.sports_soccer, Colors.orange),
                      kategoriButonu('Oyuncak', Icons.toys, Colors.purple),
                      kategoriButonu('Diğer', Icons.flutter_dash_outlined, Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTradeOfferDialog(BuildContext context, Listing listing) {
    showDialog(
      context: context,
      builder: (context) => TradeOfferDialog(targetListing: listing),
    );
  }

  void _showTradeOffers(BuildContext context) {
    final listingService = context.read<ListingService>();
    final authService = context.read<AuthService>();
    final reviewService = context.read<ReviewService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Takas Tekliflerim'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listingService.tradeOffers.length,
            itemBuilder: (context, index) {
              final offer = listingService.tradeOffers[index];
              final isSender = offer.sender.id == authService.currentUser!.id;
              final otherUser = isSender ? offer.targetListing.owner : offer.sender;
              
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        isSender
                            ? 'Teklif: ${offer.targetListing.title}'
                            : 'Gelen Teklif: ${offer.offeredListing.title}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Durum: ${offer.status.toString().split('.').last}'),
                          if (offer.message != null && offer.message!.isNotEmpty)
                            Text('Mesaj: ${offer.message}'),
                        ],
                      ),
                      trailing: !isSender && offer.status == TradeOfferStatus.pending
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    listingService.respondToTradeOffer(offer.id, true);
                                    Navigator.pop(context);
                                    _showReviewDialog(context, otherUser, offer);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    listingService.respondToTradeOffer(offer.id, false);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          : offer.status == TradeOfferStatus.accepted &&
                                  !reviewService.reviews.any((review) =>
                                      review.tradeOffer.id == offer.id &&
                                      review.reviewer.id == authService.currentUser!.id)
                              ? TextButton(
                                  onPressed: () => _showReviewDialog(context, otherUser, offer),
                                  child: Text('Değerlendir'),
                                )
                              : null,
                    ),
                    if (offer.status != TradeOfferStatus.pending)
                      TextButton(
                        onPressed: () => _showReportDialog(context, otherUser, offer.targetListing),
                        child: Text('Raporla', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, User reviewedUser, TradeOffer offer) {
    final _ratingController = TextEditingController();
    double _rating = 3.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kullanıcıyı Değerlendir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${reviewedUser.username} kullanıcısını değerlendirin'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    _rating = index + 1.0;
                    (context as Element).markNeedsBuild();
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Yorumunuz',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final reviewService = context.read<ReviewService>();
              final authService = context.read<AuthService>();
              
              reviewService.addReview(
                reviewer: authService.currentUser!,
                reviewedUser: reviewedUser,
                tradeOffer: offer,
                rating: _rating,
                comment: _ratingController.text,
              );
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Değerlendirmeniz kaydedildi')),
              );
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, User reportedUser, [Listing? reportedListing]) {
    final _descriptionController = TextEditingController();
    ReportType _selectedType = ReportType.other;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Raporla'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ReportType>(
              value: _selectedType,
              items: ReportType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                _selectedType = value!;
              },
              decoration: InputDecoration(
                labelText: 'Rapor Türü',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final reportService = context.read<ReportService>();
              final authService = context.read<AuthService>();
              
              reportService.createReport(
                reporter: authService.currentUser!,
                reportedUser: reportedUser,
                reportedListing: reportedListing,
                type: _selectedType,
                description: _descriptionController.text,
              );
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Raporunuz alındı'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  Widget listeElemani(String imagePath) {
    return Column(
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(
              color: Colors.deepPurple.shade200,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(42),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade200),
                        ),
                      );
                    },
                  )
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Takip Et",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget kategoriButonu(String kategoriAdi, IconData ikon, Color renk) {
    return InkWell(
      onTap: () {
        print('$kategoriAdi kategorisine tıklandı');
      },
      child: Container(
        decoration: BoxDecoration(
          color: renk,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              kategoriAdi,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}