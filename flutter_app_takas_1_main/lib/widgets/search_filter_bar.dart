import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/listing_service.dart';
import 'animated_button_widget.dart';

class SearchFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listingService = context.watch<ListingService>();
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Arama çubuğu
          TextField(
            onChanged: (value) => listingService.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'İlan başlığı, açıklama veya etiket ara...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: listingService.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => listingService.setSearchQuery(''),
                  )
                : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.deepPurple.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.deepPurple.shade400),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Filtre butonları
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AnimatedButtonWidget(
                  onPressed: () => _showCategoryDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.category, size: 20, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        listingService.selectedCategory ?? 'Kategori',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                AnimatedButtonWidget(
                  onPressed: () => _showLocationDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        listingService.selectedLocation ?? 'Konum',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                AnimatedButtonWidget(
                  onPressed: () => _showPriceRangeDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attach_money, size: 20, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Fiyat',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                AnimatedButtonWidget(
                  onPressed: () => _showTagsDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tag, size: 20, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Etiketler',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                if (listingService.searchQuery.isNotEmpty ||
                    listingService.selectedCategory != null ||
                    listingService.selectedLocation != null ||
                    listingService.priceRange != null ||
                    listingService.selectedTags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AnimatedButtonWidget(
                      onPressed: () => listingService.resetFilters(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.clear_all, size: 20, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Filtreleri Temizle',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Aktif filtreler
          if (listingService.selectedTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 8,
                children: listingService.selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => listingService.toggleTag(tag),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    final listingService = context.read<ListingService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kategori Seçin'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...listingService.allCategories.map((category) => ListTile(
                title: Text(category),
                selected: listingService.selectedCategory == category,
                onTap: () {
                  listingService.setCategory(
                    listingService.selectedCategory == category ? null : category
                  );
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    final listingService = context.read<ListingService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konum Seçin'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...listingService.allLocations.map((location) => ListTile(
                title: Text(location),
                selected: listingService.selectedLocation == location,
                onTap: () {
                  listingService.setLocation(
                    listingService.selectedLocation == location ? null : location
                  );
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showPriceRangeDialog(BuildContext context) {
    final listingService = context.read<ListingService>();
    RangeValues currentRangeValues = listingService.priceRange ?? RangeValues(0, 50000);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Fiyat Aralığı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RangeSlider(
                values: currentRangeValues,
                min: 0,
                max: 50000,
                divisions: 50,
                labels: RangeLabels(
                  '${currentRangeValues.start.round()}₺',
                  '${currentRangeValues.end.round()}₺',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    currentRangeValues = values;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${currentRangeValues.start.round()}₺'),
                  Text('${currentRangeValues.end.round()}₺'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                listingService.setPriceRange(const RangeValues(0, 50000));
                Navigator.pop(context);
              },
              child: Text('Temizle'),
            ),
            TextButton(
              onPressed: () {
                listingService.setPriceRange(currentRangeValues);
                Navigator.pop(context);
              },
              child: Text('Uygula'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTagsDialog(BuildContext context) {
    final listingService = context.read<ListingService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Etiket Seçin'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            children: listingService.allTags.map((tag) {
              final isSelected = listingService.selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) {
                  listingService.toggleTag(tag);
                },
              );
            }).toList(),
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
} 