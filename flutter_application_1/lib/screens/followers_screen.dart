import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';

class FollowersScreen extends StatefulWidget {
  final String userId;
  final String userName;
  
  const FollowersScreen({
    super.key, 
    required this.userId,
    required this.userName,
  });

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _followers = [];
  Set<String> _followingIds = {}; // Takip edilen kullanıcı ID'leri
  
  @override
  void initState() {
    super.initState();
    _fetchFollowers();
  }
  
  // Takipçileri getir
  Future<void> _fetchFollowers() async {
    // Gerçek bir API'den yükleyecek olsaydık burada API çağrısını simüle et
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    try {
      // Örnek takipçiler - gerçek bir uygulamada API'den gelecek
      // Başlangıçta bazı kullanıcıları takip ediyoruz
      setState(() {
        _followingIds = {'user3', 'user5'};
        _followers = [
          {
            'id': 'user1',
            'name': 'Ahmet Yılmaz',
            'username': '@ahmetyilmaz',
            'avatar': 'https://i.pravatar.cc/150?img=1',
            'isVerified': true,
            'date': '2 yıl önce katıldı',
          },
          {
            'id': 'user2',
            'name': 'Ayşe Demir',
            'username': '@aysedemir',
            'avatar': 'https://i.pravatar.cc/150?img=5',
            'isVerified': false,
            'date': '1 yıl önce katıldı',
          },
          {
            'id': 'user3',
            'name': 'Mehmet Kaya',
            'username': '@mehmetkaya',
            'avatar': 'https://i.pravatar.cc/150?img=3',
            'isVerified': true,
            'date': '3 yıl önce katıldı',
          },
          {
            'id': 'user4',
            'name': 'Zeynep Çelik',
            'username': '@zeynepcelik',
            'avatar': 'https://i.pravatar.cc/150?img=4',
            'isVerified': false,
            'date': '6 ay önce katıldı',
          },
          {
            'id': 'user5',
            'name': 'Burak Aydın',
            'username': '@burakaydin',
            'avatar': 'https://i.pravatar.cc/150?img=6',
            'isVerified': true,
            'date': '8 ay önce katıldı',
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _followers = [];
        _isLoading = false;
      });
      
      // Hata durumunda boş liste döndür ve hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Takipçiler yüklenirken bir hata oluştu'),
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
          '${widget.userName} - Takipçiler',
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
          : _followers.isEmpty
              ? _buildEmptyState()
              : _buildFollowersList(),
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
            'Henüz takipçi yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sizi takip eden kullanıcılar burada görünecek',
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

  Widget _buildFollowersList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _followers.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final follower = _followers[index];
        return _buildUserListItem(follower);
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> user) {
    final String userId = user['id'] ?? '';
    final String name = user['name'] ?? 'İsimsiz Kullanıcı';
    final String username = user['username'] ?? '@kullanici';
    final String avatar = user['avatar'] ?? 'https://via.placeholder.com/150';
    final bool isVerified = user['isVerified'] ?? false;
    final String date = user['date'] ?? 'Katılım tarihi bilinmiyor';
    
    final bool isFollowing = userId.isNotEmpty && _followingIds.contains(userId);
    
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
              if (isFollowing) {
                // Takibi bırak
                _followingIds.remove(userId);
              } else {
                // Takip et
                _followingIds.add(userId);
              }
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isFollowing 
                  ? '$name takibi bırakıldı' 
                  : '$name takip edilmeye başlandı'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isFollowing ? Colors.black87 : Colors.white,
          backgroundColor: isFollowing ? Colors.white : Colors.blue[700],
          side: BorderSide(color: isFollowing ? Colors.grey[300]! : Colors.blue[700]!),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(isFollowing ? 'Takibi Bırak' : 'Takip Et'),
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