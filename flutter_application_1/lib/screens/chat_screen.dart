import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import 'profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String productId;
  
  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.productId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Map<String, dynamic> _chatRoom;
  late List<Map<String, dynamic>> _messages;
  late String _currentUserId;
  late Map<String, dynamic> _otherUser;
  late Map<String, dynamic> _product;
  bool _isLoading = true;
  bool _showOfferActions = false;

  @override
  void initState() {
    super.initState();
    _currentUserId = MockData.currentUser['id'];
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  // Sohbet verilerini yükleme
  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    
    // Sohbet odası bilgilerini al
    _chatRoom = MockData.chatRooms.firstWhere((chat) => chat['id'] == widget.chatId);
    
    // Ürün bilgilerini al
    _product = MockData.products.firstWhere((product) => product['id'] == widget.productId);
    
    // Diğer kullanıcının bilgilerini al
    final bool isUserSeller = _chatRoom['sellerId'] == _currentUserId;
    final String otherUserId = isUserSeller ? _chatRoom['buyerId'] : _chatRoom['sellerId'];
    _otherUser = MockData.users.firstWhere((user) => user['id'] == otherUserId);
    
    // Mesajları al ve sırala
    _messages = MockData.getChatMessages(widget.chatId);
    _messages.sort((a, b) {
      final DateTime aTime = DateTime.parse(a['timestamp'] as String);
      final DateTime bTime = DateTime.parse(b['timestamp'] as String);
      return aTime.compareTo(bTime);
    });
    
    // Mesajları okundu olarak işaretle
    MockData.markChatAsRead(widget.chatId, _currentUserId);
    
    // Teklif durumunu kontrol et
    _showOfferActions = 
        _chatRoom['offerStatus'] == 'pending' && 
        _chatRoom['sellerId'] == _currentUserId;
    
    setState(() {
      _isLoading = false;
    });
    
    // Mesaj listesinin en altına kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  // Mesaj gönderme
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    // Mesaj gönderme simülasyonu
    final messageId = MockData.addMessage(widget.chatId, _currentUserId, text);
    _messageController.clear();
    
    _loadData(); // Mesajları yenile
    
    // Mesaj iletildi simülasyonu
    Future.delayed(const Duration(seconds: 1), () {
      MockData.updateMessageStatus(messageId, 'delivered');
      setState(() {}); // UI'ı güncelle
    });
  }
  
  // Takas teklifini kabul et
  void _acceptOffer() {
    MockData.updateOfferStatus(widget.chatId, 'accepted');
    
    // Kabul mesajı gönder
    MockData.addMessage(
      widget.chatId, 
      _currentUserId, 
      'Takas teklifinizi kabul ediyorum. Detayları konuşalım.'
    );
    
    _loadData(); // Verileri yenile
  }
  
  // Takas teklifini reddet
  void _rejectOffer() {
    MockData.updateOfferStatus(widget.chatId, 'rejected');
    
    // Red mesajı gönder
    MockData.addMessage(
      widget.chatId, 
      _currentUserId, 
      'Üzgünüm, takas teklifinizi kabul edemiyorum.'
    );
    
    _loadData(); // Verileri yenile
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Yükleniyor...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            // Karşı tarafın profil sayfasına git
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: _otherUser['id']),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(_otherUser['avatarUrl']),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _otherUser['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _chatRoom['isActive'] 
                          ? 'Çevrimiçi'
                          : 'Son görülme: ${_formatLastSeen()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Profil görüntüleme butonu
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Konuştuğumuz kişinin profil sayfasına yönlendir
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: _otherUser['id']),
                ),
              );
            },
          ),
          // Diğer seçenekler
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'block',
                child: Text('Engelle'),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Text('Rapor Et'),
              ),
            ],
            onSelected: (value) {
              if (value == 'block') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kullanıcı engellendi')),
                );
              } else if (value == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kullanıcı rapor edildi')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Ürün bilgisi
          _buildProductInfo(),
          
          // Teklif durumu
          if (_showOfferActions) _buildOfferActions(),
          
          // Mesajlar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: const AssetImage('assets/images/chat_bg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.03), // Çok hafif mavi filtre
                    BlendMode.srcOver,
                  ),
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool isMe = message['senderId'] == _currentUserId;
                  return _buildMessageBubble(message, isMe);
                },
              ),
            ),
          ),
          
          // Mesaj girişi
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Ürün bilgisi kısmı
  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Ürün resmi
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: _product['images'][0],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Ürün bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _product['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _product['swapValue'],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _product['condition'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _chatRoom['offerStatus'] == 'pending'
                            ? 'Beklemede'
                            : _chatRoom['offerStatus'] == 'accepted'
                                ? 'Kabul Edildi'
                                : 'Reddedildi',
                        style: TextStyle(
                          fontSize: 10,
                          color: _chatRoom['offerStatus'] == 'pending'
                              ? Colors.orange
                              : _chatRoom['offerStatus'] == 'accepted'
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Teklif işlem butonları
  Widget _buildOfferActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Bu ürün için bir takas teklifi var',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Takas teklifini kabul edebilir veya reddedebilirsiniz.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: _rejectOffer,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('REDDET'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _acceptOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('KABUL ET'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Mesaj balonu
  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    final DateTime messageTime = DateTime.parse(message['timestamp'] as String);
    final String formattedTime = DateFormat('HH:mm').format(messageTime);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Karşı tarafın avatarı (eğer mesaj bize aitse gösterme)
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(_otherUser['avatarUrl']),
            ),
            const SizedBox(width: 8),
          ],
          
          // Mesaj balonu
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isMe 
                  ? Colors.blue
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 15,
                    fontFamily: 'Roboto', // Tüm Unicode karakterleri destekleyen font
                    locale: const Locale('tr', 'TR'), // Türkçe dil ayarı
                    height: 1.3, // Satır yüksekliği
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      // Mesaj durumu göstergesi
                      _buildMessageStatusIndicator(message),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Kullanıcının avatarı (sadece karşı taraf için gösterdiğimizden, burada göstermeye gerek yok)
          if (isMe) const SizedBox(width: 24), // Avatar genişliği kadar boşluk bırak
        ],
      ),
    );
  }
  
  // Mesaj durumu göstergesi
  Widget _buildMessageStatusIndicator(Map<String, dynamic> message) {
    final String status = message['status'] ?? 'sent';
    
    if (status == 'sent') {
      return const Icon(
        Icons.done,
        size: 14,
        color: Colors.white38,
      );
    } else if (status == 'delivered') {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.white70,
      );
    } else if (status == 'read') {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.white,
      );
    }
    
    return const Icon(
      Icons.access_time,
      size: 14,
      color: Colors.white38,
    );
  }
  
  // Mesaj giriş alanı
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Ekstra özellikler butonu
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dosya ekleme özelliği eklenecek')),
              );
            },
            color: Colors.blue.shade300,
            iconSize: 22,
          ),
          
          // Mesaj giriş alanı
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                ),
                // Yazım sırasında öneriler için
                prefixIcon: null,
                suffixIcon: _messageController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _messageController.clear();
                          setState(() {});
                        },
                      ) 
                    : null,
              ),
              // Otomatik odaklanma (klavyeyi otomatik açma) - genelde false olarak ayarlanır
              // kullanıcı deneyimi için, ancak test için true yapabilirsiniz
              autofocus: false,
              // İlk harf büyük yapma
              textCapitalization: TextCapitalization.sentences,
              // Klavye türü - normal metin
              keyboardType: TextInputType.text,
              // Klavyede gönder tuşu
              textInputAction: TextInputAction.send,
              // Gönder tuşuna basıldığında
              onSubmitted: (_) => _sendMessage(),
              // Yazım sırasında yeniden çizim için
              onChanged: (text) {
                setState(() {});
              },
              // Çoklu satır desteği
              maxLines: 3,
              minLines: 1,
              // Yazım kontrolü
              enableSuggestions: true,
              // Otomatik düzeltme
              autocorrect: true,
              // Klavye dönüşleri
              keyboardAppearance: Brightness.light,
              // Stil
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Gönder butonu - mesaj varsa rengi daha koyu yap
          CircleAvatar(
            backgroundColor: _messageController.text.isNotEmpty
                ? Colors.blue
                : Colors.blue.withOpacity(0.7),
            radius: 22,
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              color: Colors.white,
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
  
  // Son görülme zamanını formatlama
  String _formatLastSeen() {
    // Mock veriler için sabit bir değer
    return "Bugün 12:30";
  }
} 