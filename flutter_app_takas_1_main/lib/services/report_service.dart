import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';

class ReportService extends ChangeNotifier {
  List<Report> _reports = [];
  
  List<Report> get reports => _reports;
  List<Report> get pendingReports => 
      _reports.where((report) => report.status == ReportStatus.pending).toList();
  
  // Yeni rapor oluştur
  Future<void> createReport({
    required User reporter,
    required User reportedUser,
    Listing? reportedListing,
    required ReportType type,
    required String description,
  }) async {
    final report = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reporter: reporter,
      reportedUser: reportedUser,
      reportedListing: reportedListing,
      type: type,
      description: description,
      createdAt: DateTime.now(),
    );
    
    _reports.add(report);
    notifyListeners();
  }
  
  // Rapor durumunu güncelle (admin için)
  Future<void> updateReportStatus(String reportId, ReportStatus newStatus, {String? adminNote}) async {
    final reportIndex = _reports.indexWhere((report) => report.id == reportId);
    if (reportIndex != -1) {
      _reports[reportIndex].status = newStatus;
      if (adminNote != null) {
        _reports[reportIndex].adminNote = adminNote;
      }
      notifyListeners();
    }
  }
  
  // Kullanıcının raporlarını getir
  List<Report> getReportsForUser(String userId) {
    return _reports.where((report) => report.reportedUser.id == userId).toList();
  }
  
  // Test verileri
  void loadTestData() {
    final testUser = User(
      id: '1',
      username: 'test_user',
      email: 'test@example.com',
      phoneNumber: '+90 555 555 5555',
    );

    final testUser2 = User(
      id: '2',
      username: 'ahmet_yilmaz',
      email: 'ahmet@example.com',
      phoneNumber: '+90 555 444 3333',
      profileImage: 'https://picsum.photos/200?random=2',
    );

    final testListing = Listing(
      id: '3',
      title: 'PlayStation 5',
      description: 'Kutulu PS5',
      category: 'Elektronik',
      location: 'İzmir',
      images: ['https://picsum.photos/200?random=3'],
      owner: testUser,
      createdAt: DateTime.now(),
      estimatedValue: 18000,
      tags: ['konsol', 'playstation'],
    );

    _reports = [
      Report(
        id: '1',
        reporter: testUser,
        reportedUser: testUser2,
        reportedListing: testListing,
        type: ReportType.inappropriateContent,
        description: 'Ürün açıklaması yanıltıcı ve uygunsuz içerik barındırıyor.',
        status: ReportStatus.pending,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Report(
        id: '2',
        reporter: testUser2,
        reportedUser: testUser,
        type: ReportType.harassment,
        description: 'Kullanıcı rahatsız edici mesajlar gönderiyor.',
        status: ReportStatus.underReview,
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
      ),
      Report(
        id: '3',
        reporter: testUser,
        reportedUser: testUser2,
        type: ReportType.fraud,
        description: 'Sahte ürün satmaya çalışıyor.',
        status: ReportStatus.resolved,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
    ];
    
    notifyListeners();
  }
} 