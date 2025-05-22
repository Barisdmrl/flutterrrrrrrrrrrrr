import 'package:flutter/material.dart';
import 'user_model.dart';
import 'listing_model.dart';

enum ReportType {
  inappropriateContent,
  spam,
  harassment,
  fraud,
  scam,
  other
}

enum ReportStatus {
  pending,
  underReview,
  investigating,
  resolved,
  dismissed
}

class Report {
  final String id;
  final User reporter;
  final User reportedUser;
  final Listing? reportedListing;
  final ReportType type;
  final String description;
  final DateTime createdAt;
  ReportStatus status;
  String? adminNote;

  Report({
    required this.id,
    required this.reporter,
    required this.reportedUser,
    this.reportedListing,
    required this.type,
    required this.description,
    required this.createdAt,
    this.status = ReportStatus.pending,
    this.adminNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterId': reporter.id,
      'reportedUserId': reportedUser.id,
      'reportedListingId': reportedListing?.id,
      'type': type.toString(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'adminNote': adminNote,
    };
  }
} 