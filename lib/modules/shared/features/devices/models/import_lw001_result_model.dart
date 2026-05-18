class ImportLw001RowIssue {
  const ImportLw001RowIssue({
    required this.reason,
    required this.row,
    this.deveui,
    this.detail,
  });

  final String reason;
  final int row;
  final String? deveui;
  final String? detail;

  factory ImportLw001RowIssue.fromJson(Map<String, dynamic> json) {
    return ImportLw001RowIssue(
      reason: json['reason'] as String? ?? '',
      row: (json['row'] as num?)?.toInt() ?? 0,
      deveui: json['deveui'] as String?,
      detail: json['detail'] as String?,
    );
  }
}

class ImportLw001ResultModel {
  const ImportLw001ResultModel({
    required this.totalRows,
    required this.created,
    required this.updated,
    required this.duplicateDeveuisInFile,
    required this.warnings,
    required this.errors,
  });

  final int totalRows;
  final int created;
  final int updated;
  final List<String> duplicateDeveuisInFile;
  final List<ImportLw001RowIssue> warnings;
  final List<ImportLw001RowIssue> errors;

  factory ImportLw001ResultModel.fromJson(Map<String, dynamic> json) {
    return ImportLw001ResultModel(
      totalRows: (json['totalRows'] as num?)?.toInt() ?? 0,
      created: (json['created'] as num?)?.toInt() ?? 0,
      updated: (json['updated'] as num?)?.toInt() ?? 0,
      duplicateDeveuisInFile: (json['duplicateDeveuisInFile'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      warnings: _parseIssues(json['warnings']),
      errors: _parseIssues(json['errors']),
    );
  }

  static List<ImportLw001RowIssue> _parseIssues(dynamic value) {
    if (value is! List<dynamic>) return const [];
    return value
        .map((e) => ImportLw001RowIssue.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class DeviceProfileOption {
  const DeviceProfileOption({required this.id, required this.name});

  final String id;
  final String name;

  factory DeviceProfileOption.fromJson(Map<String, dynamic> json) {
    return DeviceProfileOption(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
    );
  }
}
