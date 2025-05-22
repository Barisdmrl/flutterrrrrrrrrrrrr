import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<Map<String, dynamic>> _chatRooms;
  final String _currentUserId = MockData.currentUser['id'];

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    setState(() {
      _chatRooms = MockData.getUserChatRooms(_currentUserId);
      // Tarihe göre sırala - en son mesaj üstte
      _chatRooms.sort((a, b) {
        final DateTime aTime = DateTime.parse(a['lastMessageTime'] as String);
        final DateTime bTime = DateTime.parse(b['lastMessageTime'] as String);
        return bTime.compareTo(aTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Mesajlarım',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment, color: Colors.white),
            onPressed: () {
              final products = MockData.products;
              if (products.isNotEmpty) {
                final product = products.first;
                final chatId = MockData.createChatRoom(product['id'], 'user2');
                MockData.addMessage(chatId, 'user2', 'Merhaba, ürününüz hala satılık mı?');
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatId: chatId,
                      productId: product['id'],
                    ),
                  ),
                ).then((_) {
                  _loadChatRooms();
                });
              }
            },
          ),
        ],
      ),
      body: _chatRooms.isEmpty
          ? _buildEmptyChatList()
          : ListView.builder(
              itemCount: _chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = _chatRooms[index];
                return _buildChatRoomItem(chatRoom);
              },
            ),
    );
  }

  Widget _buildEmptyChatList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz mesajınız yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Takas teklifleri gönderdiğinizde veya\naldığınızda burada görünecek.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomItem(Map<String, dynamic> chatRoom) {
    // Mesaj zamanını formatlama
    final DateTime messageTime = DateTime.parse(chatRoom['lastMessageTime'] as String);
    final String formattedTime = _formatChatTime(messageTime);
    
    // Karşı tarafın bilgilerini alma
    final bool isUserSeller = chatRoom['sellerId'] == _currentUserId;
    final String otherUserId = isUserSeller ? chatRoom['buyerId'] : chatRoom['sellerId'];
    final otherUser = MockData.users.firstWhere((user) => user['id'] == otherUserId);
    
    // Okunmamış mesaj sayısı
    final int unreadCount = chatRoom['unreadCount'] as int;
    
    // Takas durumu
    final String offerStatus = chatRoom['offerStatus'] as String;
    
    // Diğer kullanıcının profiline gitme fonksiyonu
    void _goToUserProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: otherUserId),
        ),
      );
    }
    
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chatRoom['id'],
              productId: chatRoom['productId'],
            ),
          ),
        ).then((_) {
          // Ekrandan döndüğünde mesajları güncelle
          _loadChatRooms();
        });
      },
      leading: GestureDetector(
        onTap: _goToUserProfile, // Avatar'a tıklandığında profil sayfasına git
        child: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: CachedNetworkImageProvider(
                otherUser['avatarUrl'],
              ),
            ),
            if (!chatRoom['isActive'])
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.block,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _goToUserProfile, // Kullanıcı adına tıklandığında profil sayfasına git
              child: Text(
                otherUser['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0 ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Row(
            children: [
              // Ürün bilgisi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  chatRoom['productTitle'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Takas durumu
              if (offerStatus != 'pending')
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: offerStatus == 'accepted'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offerStatus == 'accepted' ? 'Kabul Edildi' : 'Reddedildi',
                    style: TextStyle(
                      fontSize: 10,
                      color: offerStatus == 'accepted' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  chatRoom['lastMessage'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: unreadCount > 0
                        ? Colors.black87
                        : Colors.grey.shade600,
                    fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
  
  String _formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // Bugün
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      // Dün
      return 'Dün';
    } else if (difference.inDays < 7) {
      // Son bir hafta içinde
      final Map<int, String> weekdays = {
        1: 'Pazartesi',
        2: 'Salı',
        3: 'Çarşamba',
        4: 'Perşembe',
        5: 'Cuma',
        6: 'Cumartesi',
        7: 'Pazar',
      };
      return weekdays[dateTime.weekday]!;
    } else {
      // Bir haftadan eski
      return DateFormat('dd.MM.yyyy').format(dateTime);
    }
  }
} 