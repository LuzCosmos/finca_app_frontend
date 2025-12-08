import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';

class PaginatedSales {
  final List<SaleModel> items;
  final int total;

  PaginatedSales({required this.items, required this.total});

  factory PaginatedSales.fromJson(Map<String, dynamic> json) {
    return PaginatedSales(
      items: (json['items'] as List).map((e) => SaleModel.fromJson(e)).toList(),
      total: json['total'],
    );
  }
}

class SalesQuery {
  final int skip;
  final int take;
  final String? orderBy;
  final String? order;
  final String? startDate;
  final String? endDate;
  final String? buyerId;
  final String? status;

  const SalesQuery({
    this.skip = 0,
    this.take = 10,
    this.orderBy,
    this.order,
    this.startDate,
    this.endDate,
    this.buyerId,
    this.status,
  });

  Map<String, String> toQueryParameters() {
    final map = <String, String>{
      'skip': skip.toString(),
      'take': take.toString(),
    };
    if (orderBy != null) map['orderBy'] = orderBy!;
    if (order != null) map['order'] = order!;
    if (startDate != null) map['startDate'] = startDate!;
    if (endDate != null) map['endDate'] = endDate!;
    if (buyerId != null) map['buyerId'] = buyerId!;
    if (status != null) map['status'] = status!;
    return map;
  }
}
