import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/review_service.dart';

class UserProfileWidget extends StatelessWidget {
  final User user;

  const UserProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewService = context.watch<ReviewService>();
    final reviews = reviewService.getReviewsForUser(user.id);
    final averageRating = reviewService.getAverageRating(user.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kullanıcı bilgileri
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profileImage ?? 'https://picsum.photos/200'),
          ),
          title: Text(user.username),
          subtitle: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              Text(' ${averageRating.toStringAsFixed(1)} (${reviews.length} değerlendirme)'),
            ],
          ),
        ),
        Divider(),
        // Değerlendirmeler
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Değerlendirmeler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Henüz değerlendirme yapılmamış'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              review.reviewer.profileImage ?? 'https://picsum.photos/200',
                            ),
                            radius: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            review.reviewer.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < review.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(review.comment),
                      SizedBox(height: 4),
                      Text(
                        '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
} 