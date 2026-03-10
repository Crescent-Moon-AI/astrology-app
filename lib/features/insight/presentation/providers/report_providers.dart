import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/report_api.dart';
import '../../domain/models/relationship_report.dart';

final reportApiProvider = Provider<ReportApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ReportApi(dioClient.dio);
});

final reportProductProvider =
    FutureProvider.family<ReportProduct, String>((ref, productId) async {
  final api = ref.watch(reportApiProvider);
  final data = await api.getProduct(productId);
  final payload = data['data'] as Map<String, dynamic>? ?? data;
  return ReportProduct.fromJson(payload);
});

/// Generates a report for [productId], optionally with [friendId].
/// Pass a combined key "productId|friendId" (or just "productId") as the family param.
final createReportProvider =
    FutureProvider.family<RelationshipReport, (String, String?)>(
  (ref, args) async {
    final (productId, friendId) = args;
    final api = ref.watch(reportApiProvider);
    final data = await api.createReport(
      reportProductId: productId,
      friendId: friendId,
    );
    final payload = data['data'] as Map<String, dynamic>? ?? data;
    return RelationshipReport.fromJson(payload);
  },
);

final reportDetailProvider =
    FutureProvider.family<RelationshipReport, String>((ref, reportId) async {
  final api = ref.watch(reportApiProvider);
  final data = await api.getReport(reportId);
  final payload = data['data'] as Map<String, dynamic>? ?? data;
  return RelationshipReport.fromJson(payload);
});

final reportListProvider =
    FutureProvider<List<RelationshipReport>>((ref) async {
  final api = ref.watch(reportApiProvider);
  final data = await api.listReports();
  final payload = data['data'] as Map<String, dynamic>? ?? data;
  final items = payload['items'] as List<dynamic>? ?? [];
  return items
      .map((e) => RelationshipReport.fromJson(e as Map<String, dynamic>))
      .toList();
});
