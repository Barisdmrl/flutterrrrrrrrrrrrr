import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductUploadScreen extends StatefulWidget {
  const ProductUploadScreen({super.key});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  // Form anahtarı - doğrulama için kullanılacak
  final _formKey = GlobalKey<FormState>();
  
  // Form değerleri
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String _selectedCondition = 'Used'; // Varsayılan değer
  String _swapType = 'Direct Swap'; // Varsayılan değer
  
  // Resim seçimi için
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  
  // Doğrulama hatalarını izleme
  bool _submitted = false;
  String? _nameError;
  String? _categoryError;
  String? _descriptionError;
  String? _imagesError;
  
  // Kategori seçenekleri
  final List<String> _categories = [
    'Elektronik',
    'Giyim',
    'Kitap',
    'Mobilya', 
    'Spor',
    'Oyuncak',
    'Diğer'
  ];

  // Form değerlerini doğrulama
  void _validateForm() {
    setState(() {
      // Doğrulama hatalarını sıfırla
      _nameError = null;
      _categoryError = null;
      _descriptionError = null;
      _imagesError = null;
      
      // Form alanlarını doğrula
      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Ürün adı boş olamaz';
      } else if (_nameController.text.trim().length < 3) {
        _nameError = 'Ürün adı en az 3 karakter olmalıdır';
      }
      
      if (_selectedCategory == null) {
        _categoryError = 'Bir kategori seçmelisiniz';
      }
      
      if (_descriptionController.text.trim().isEmpty) {
        _descriptionError = 'Açıklama boş olamaz';
      } else if (_descriptionController.text.trim().length < 10) {
        _descriptionError = 'Açıklama en az 10 karakter olmalıdır';
      }
      
      if (_selectedImages.isEmpty) {
        _imagesError = 'En az 1 resim seçmelisiniz';
      }
    });
  }

  // Resim seçme işlevi
  Future<void> _pickImages(ImageSource source) async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 5 resim seçebilirsiniz')),
      );
      return;
    }

    try {
      if (source == ImageSource.camera) {
        // Kameradan tek resim seç
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
      } else {
        // Galeriden çoklu resim seç
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            // Toplam 5 resmi geçmeyecek şekilde ekle
            final int remainingSlots = 5 - _selectedImages.length;
            final int itemsToAdd = images.length > remainingSlots ? remainingSlots : images.length;
            _selectedImages.addAll(images.take(itemsToAdd));
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçme hatası: $e')),
      );
    }
  }

  // Resim seçme menüsünü göster
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImages(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImages(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Seçilen resimleri göster
  Widget _buildSelectedImagesGrid() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: _submitted && _imagesError != null 
            ? Colors.red.shade50 
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _submitted && _imagesError != null 
              ? Colors.red 
              : Colors.grey.shade300,
        ),
      ),
      child: _selectedImages.isEmpty
          ? InkWell(
              onTap: _showImageSourceDialog,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: _submitted && _imagesError != null 
                          ? Colors.red 
                          : Colors.grey.shade500,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resim Ekle (0/5)',
                      style: TextStyle(
                        color: _submitted && _imagesError != null 
                            ? Colors.red 
                            : Colors.grey.shade700,
                      ),
                    ),
                    if (_submitted && _imagesError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _imagesError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Seçilen resimleri göster
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length < 5 
                          ? _selectedImages.length + 1 
                          : _selectedImages.length,
                      itemBuilder: (context, index) {
                        // Ek resim ekle butonu
                        if (index == _selectedImages.length && _selectedImages.length < 5) {
                          return InkWell(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_photo_alternate, size: 30),
                              ),
                            ),
                          );
                        }
                        
                        // Seçilen resmi göster
                        final image = _selectedImages[index];
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Ürün Ekle',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Klavyeyi kapat
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ürün Adı
              const Text(
                'Ürün Adı',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ürününüzün adını girin',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _submitted && _nameError != null
                          ? Colors.red
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _submitted && _nameError != null
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorText: _submitted ? _nameError : null,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              
              // Kategori Seçimi
              const Text(
                'Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _submitted && _categoryError != null
                        ? Colors.red
                        : Colors.grey.shade300,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Kategori seçin'),
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ),
              if (_submitted && _categoryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(
                    _categoryError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              
              // Açıklama
              const Text(
                'Açıklama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ürününüzü detaylı bir şekilde açıklayın',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _submitted && _descriptionError != null
                          ? Colors.red
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _submitted && _descriptionError != null
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorText: _submitted ? _descriptionError : null,
                ),
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 20),
              
              // Resim Seçimi
              const Text(
                'Fotoğraflar (En fazla 5)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildSelectedImagesGrid(),
              const SizedBox(height: 20),
              
              // Ürün Durumu
              const Text(
                'Ürün Durumu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  _buildConditionChip('New', 'Yeni'),
                  _buildConditionChip('Like New', 'Az Kullanılmış'),
                  _buildConditionChip('Used', 'Kullanılmış'),
                ],
              ),
              const SizedBox(height: 20),
              
              // Takas Tipi
              const Text(
                'Takas Tipi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile(
                title: const Text('Direkt Takas'),
                subtitle: const Text('Sadece ürün takası'),
                value: 'Direct Swap',
                groupValue: _swapType,
                onChanged: (value) {
                  setState(() {
                    _swapType = value as String;
                  });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile(
                title: const Text('Takas + Para'),
                subtitle: const Text('Ürün takası + para farkı'),
                value: 'Swap + Cash',
                groupValue: _swapType,
                onChanged: (value) {
                  setState(() {
                    _swapType = value as String;
                  });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 30),
              
              // Gönder Butonu
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _submitted = true;
                  });
                  _validateForm();
                  
                  // Tüm alanlar geçerliyse form gönder
                  if (_nameError == null && _categoryError == null && 
                      _descriptionError == null && _imagesError == null) {
                    // Form gönderme işlemi burada yapılacak
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ürün başarıyla yüklendi')),
                    );
                    
                    // Ana sayfaya geri dön
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'İLAN YAYINLA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Durum seçme çipi
  Widget _buildConditionChip(String value, String label) {
    final bool isSelected = _selectedCondition == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCondition = value;
        });
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
        ),
      ),
    );
  }
} 