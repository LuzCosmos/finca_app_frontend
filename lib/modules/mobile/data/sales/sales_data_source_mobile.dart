import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/daos/cattle_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/provider_dao.dart';
import 'package:finca_app_frontend/core/data/database/daos/sale_dao.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';

class SalesDataSourceMobile implements ISalesDataSource {
  final AppDatabase db;
  late final SaleDao saleDao;
  late final ProviderDao providerDao;
  late final CattleDao cattleDao;

  SalesDataSourceMobile(this.db) {
    saleDao = SaleDao(db);
    providerDao = ProviderDao(db);
    cattleDao = CattleDao(db);
  }

  @override
  Future<List<dynamic>> getProviders(String type) async {
    return await providerDao.getProvidersByType(type);
  }

  @override
  Future<dynamic> getCattleByNumber(String number) async {
    return await cattleDao.getCattleByNumber(number);
  }
  
  @override
  Future<void> saveSale(SaleModel sale) async {
    final saleCompanion = SaleLocalCompanion(
        id: Value(sale.id),
        idTenant: Value(sale.idTenant),
        transactionDate: Value(sale.transactionDate),
        buyerId: Value(sale.buyerId),
        transporterId: Value(sale.transporterId),
        minWeightConfig: Value(sale.minWeightConfig),
        valuePerKgConfig: Value(sale.valuePerKgConfig),
        totalAmount: Value(sale.totalAmount),
        totalWeight: Value(sale.totalWeight),
        totalCount: Value(sale.totalCount),
        notes: Value(sale.notes),
        isSynced: Value(false),
    );
    
    final details = sale.details.map((d) => SaleDetailLocalCompanion(
        id: Value(d.id),
        saleId: Value(sale.id),
        cattleId: Value(d.cattleId),
        measuredWeight: Value(d.measuredWeight),
        price: Value(d.price),
        isApproved: Value(d.isApproved),
        rejectionReason: Value(d.rejectionReason),
        trackerRemoved: Value(d.trackerRemoved)
    )).toList();
    
    await saleDao.insertSale(saleCompanion, details);
  }

  @override
  Future<List<SaleModel>> getUnsyncedSales() async {
     final salesData = await saleDao.getUnsyncedSales();
     
     List<SaleModel> models = [];
     for (final s in salesData) {
       final detailsData = await saleDao.getDetailsForSale(s.id);
       final details = detailsData.map((d) => SaleDetailModel(
         id: d.id,
         saleId: d.saleId,
         cattleId: d.cattleId,
         measuredWeight: d.measuredWeight,
         price: d.price,
         isApproved: d.isApproved,
         rejectionReason: d.rejectionReason,
         trackerRemoved: d.trackerRemoved,
       )).toList();
       
       models.add(SaleModel(
         id: s.id,
         idTenant: s.idTenant,
         transactionDate: s.transactionDate,
         buyerId: s.buyerId,
         transporterId: s.transporterId,
         minWeightConfig: s.minWeightConfig,
         valuePerKgConfig: s.valuePerKgConfig,
         totalAmount: s.totalAmount,
         totalWeight: s.totalWeight,
         totalCount: s.totalCount,
         notes: s.notes,
         isSynced: s.isSynced,
         details: details
       ));
     }
     return models;
  }

  @override
  Future<void> syncSales() async {
    final pendingSales = await getUnsyncedSales();
    if (pendingSales.isEmpty) return;
    
    final baseUrl = BasicApiService.baseUrl; 
    if (baseUrl == null) {
      throw Exception('API_URL not configured');
    }
    
    final token = await SessionService.getToken();
    if (token == null) {
       throw Exception('No valid session');
    }

    for (final sale in pendingSales) {
       try {
         final payload = {
            "transactionDate": sale.transactionDate.toIso8601String(),
            "buyerId": sale.buyerId,
            "transporterId": sale.transporterId,
            "minWeightConfig": sale.minWeightConfig, 
            "valuePerKgConfig": sale.valuePerKgConfig,
            "totalAnimalCount": sale.totalCount,
            "totalWeightKg": sale.totalWeight,
            "totalAmount": sale.totalAmount,
            "notes": sale.notes,
            "details": sale.details.map((d) => {
               "cattleId": d.cattleId,
               "measuredWeight": d.measuredWeight,
               "isApproved": d.isApproved,
               "rejectionReason": d.rejectionReason,
               "trackerRemoved": d.trackerRemoved,
               "calculatedPrice": d.price
            }).toList()
         };
         
         final response = await http.post(
           Uri.parse('$baseUrl/sales'),
           headers: {
             'Authorization': 'Bearer $token',
             'Content-Type': 'application/json',
           },
           body: jsonEncode(payload),
         );
         
         if (response.statusCode == 200 || response.statusCode == 201) {
            await saleDao.markSaleAsSynced(sale.id);
         } else {
            // Log error or continue
            print('Failed to sync sale ${sale.id}: ${response.body}');
         }
       } catch (e) {
         print('Exception syncing sale ${sale.id}: $e');
         // continue to next
       }
    }
  }

  @override
  Future<void> fetchCatalogs() async {
    final baseUrl = BasicApiService.baseUrl;
    if (baseUrl == null) return;
    final token = await SessionService.getToken();
    if (token == null) return;
    
    // Providers
    try {
      final res = await http.get(Uri.parse('$baseUrl/providers'), headers: {'Authorization': 'Bearer $token'});
      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(res.body);
        for (final p in list) {
          await providerDao.insertOrUpdateProvider(ProviderLocalCompanion(
             id: Value(p['id']),
             idTenant: Value(p['idTenant'] ?? ''), // Ensure field mapping
             name: Value(p['name']),
             nit: Value(p['nit']),
             type: Value(p['type'] ?? 'OTHER'),
             address: Value(p['address']),
             phone: Value(p['phone']),
             email: Value(p['email'])
          ));
        }
      }
    } catch(e) { print('Error fetching providers: $e'); }

    // Cattle
    try {
      final res = await http.get(Uri.parse('$baseUrl/cattle'), headers: {'Authorization': 'Bearer $token'});
      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(res.body);
        for (final c in list) {
           await cattleDao.insertOrUpdateCattle(CattleLocalCompanion(
              id: Value(c['id']),
              idTenant: Value(c['idTenant'] ?? ''),
              number: Value(c['number']),
              weight: Value(c['lastWeight'] != null ? (c['lastWeight'] as num).toDouble() : null),
              status: Value(c['status'] ?? 'ACTIVE'),
              idDevice: Value(c['idDevice'])
           ));
        }
      }
    } catch(e) { print('Error fetching cattle: $e'); }
  }

  @override
  Future<PaginatedSales> getSales(SalesQuery query) async {
    final baseUrl = BasicApiService.baseUrl;
    final token = await SessionService.getToken();
    if (baseUrl == null || token == null) {
      // Offline fallback? Return empty for now.
      return PaginatedSales(items: [], total: 0);
    }

    try {
      final uri = Uri.parse('$baseUrl/sales').replace(queryParameters: query.toQueryParameters());
      final res = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (res.statusCode == 200) {
        return PaginatedSales.fromJson(jsonDecode(res.body));
      }
    } catch (e) {
      print('Error fetching sales online: $e');
    }
    // Fallback to local?
    // Local DB query for advanced filters is hard. 
    // Just return empty or maybe local all if no filter? 
    // For now, return empty if offline/fail.
    return PaginatedSales(items: [], total: 0);
  }

  @override
  Future<void> updateSale(String id, Map<String, dynamic> updates) async {
    final baseUrl = BasicApiService.baseUrl;
    final token = await SessionService.getToken();
    if (baseUrl == null || token == null) throw Exception('Offline or No session');

    final res = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update sale: ${res.body}');
    }
  }
}
