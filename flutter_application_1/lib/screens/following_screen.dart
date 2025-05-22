import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';

class FollowingScreen extends StatefulWidget {
  final String userId;
  final String userName;
  
  const FollowingScreen({
    super.key, 
    required this.userId,
    required this.userName,
  });

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _following = [];
  
  @override
  void initState() {
    super.initState();
    _fetchFollowing();
  }
  
  // Takip edilenleri getir
  Future<void> _fetchFollowing() async {
    // Gerçek bir API'den yükleyecek olsaydık burada API çağrısını simüle et
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    try {
      // Örnek takip edilenler - gerçek bir uygulamada API'den gelecek
      setState(() {
        _following = [
          {
            'id': 'user7',
            'name': 'Serkan Öz',
            'username': '@serkanoz',
            'avatar': 'https://i.pravatar.cc/150?img=12',
            'isVerified': true,
            'date': '1 yıl önce katıldı',
          },
          {
            'id': 'user8',
            'name': 'Gamze Arslan',
            'username': '@garslan',
            'avatar': 'https://i.pravatar.cc/150?img=16',
            'isVerified': false,
            'date': '4 ay önce katıldı',
          },
          {
            'id': 'user9',
            'name': 'Oğuz Kara',
            'username': '@okara',
            'avatar': 'https://i.pravatar.cc/150?img=17',
            'isVerified': false,
            'date': '7 ay önce katıldı',
          },
          {
            'id': 'user10',
            'name': 'Selin Akay',
            'username': '@sakay',
            'avatar': 'https://i.pravatar.cc/150?img=20',
            'isVerified': true,
            'date': '2 yıl önce katıldı',
          },
          {
            'id': 'user11',
            'name': 'Can Yücel',
            'username': '@cyucel',
            'avatar': 'https://i.pravatar.cc/150?img=22',
            'isVerified': false,
            'date': '8 ay önce katıldı',
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _following = [];
        _isLoading = false;
      });
      // Hata durumunda boş liste döndür ve hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Takip edilen kullanıcılar yüklenirken bir hata oluştu'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          '${widget.userName} - Takip Edilenler',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _following.isEmpty
              ? _buildEmptyState()
              : _buildFollowingList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline, 
            size: 80, 
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz takip edilen kimse yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kullanıcılar takip edildiğinde burada görünecek',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _following.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final followed = _following[index];
        return _buildUserListItem(followed);
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> user) {
    // Takip edilenler ekranında hepsi zaten takip ediliyor olacak
    final bool isFollowing = true; 
    final String userId = user['id'] ?? '';
    final String name = user['name'] ?? 'İsimsiz Kullanıcı';
    final String username = user['username'] ?? '@kullanici';
    final String avatar = user['avatar'] ?? 'https://via.placeholder.com/150';
    final bool isVerified = user['isVerified'] ?? false;
    final String date = user['date'] ?? 'Katılım tarihi bilinmiyor';
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[200],
        backgroundImage: CachedNetworkImageProvider(avatar),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isVerified)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.verified,
                color: Colors.blue[700],
                size: 16,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: OutlinedButton(
        onPressed: () {
          if (userId.isNotEmpty) {
            setState(() {
              // Takibi bırak işlemi
              _following.removeWhere((item) => item['id'] == userId);
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name takibi bırakıldı'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Takibi Bırak'),
      ),
      onTap: () {
        // Kullanıcı profiline gitme işlemi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name profiline gidiliyor'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
} 