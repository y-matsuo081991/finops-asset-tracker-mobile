//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EdgeNode {
  /// Returns a new [EdgeNode] instance.
  EdgeNode({
    required this.id,
    required this.name,
    required this.region,
    required this.status,
    required this.monthlyCostUsd,
    required this.bookValueUsd,
    required this.createdAt,
  });

  /// 一意のノードID
  String id;

  /// ノード（サーバー）名
  String name;

  /// 配置されているリージョン
  String region;

  /// 稼働状況
  NodeStatus status;

  /// 今月の推定クラウドコスト（USD）
  num monthlyCostUsd;

  /// ソフトウェア/ハードウェアの帳簿価格（USD）
  num bookValueUsd;

  /// プロビジョニング日時
  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EdgeNode &&
    other.id == id &&
    other.name == name &&
    other.region == region &&
    other.status == status &&
    other.monthlyCostUsd == monthlyCostUsd &&
    other.bookValueUsd == bookValueUsd &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (region.hashCode) +
    (status.hashCode) +
    (monthlyCostUsd.hashCode) +
    (bookValueUsd.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'EdgeNode[id=$id, name=$name, region=$region, status=$status, monthlyCostUsd=$monthlyCostUsd, bookValueUsd=$bookValueUsd, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'region'] = this.region;
      json[r'status'] = this.status;
      json[r'monthly_cost_usd'] = this.monthlyCostUsd;
      json[r'book_value_usd'] = this.bookValueUsd;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [EdgeNode] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EdgeNode? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "EdgeNode[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "EdgeNode[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "EdgeNode[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "EdgeNode[name]" has a null value in JSON.');
        assert(json.containsKey(r'region'), 'Required key "EdgeNode[region]" is missing from JSON.');
        assert(json[r'region'] != null, 'Required key "EdgeNode[region]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "EdgeNode[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "EdgeNode[status]" has a null value in JSON.');
        assert(json.containsKey(r'monthly_cost_usd'), 'Required key "EdgeNode[monthly_cost_usd]" is missing from JSON.');
        assert(json[r'monthly_cost_usd'] != null, 'Required key "EdgeNode[monthly_cost_usd]" has a null value in JSON.');
        assert(json.containsKey(r'book_value_usd'), 'Required key "EdgeNode[book_value_usd]" is missing from JSON.');
        assert(json[r'book_value_usd'] != null, 'Required key "EdgeNode[book_value_usd]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'), 'Required key "EdgeNode[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null, 'Required key "EdgeNode[created_at]" has a null value in JSON.');
        return true;
      }());

      return EdgeNode(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        region: mapValueOfType<String>(json, r'region')!,
        status: NodeStatus.fromJson(json[r'status'])!,
        monthlyCostUsd: num.parse('${json[r'monthly_cost_usd']}'),
        bookValueUsd: num.parse('${json[r'book_value_usd']}'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
      );
    }
    return null;
  }

  static List<EdgeNode> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EdgeNode>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EdgeNode.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EdgeNode> mapFromJson(dynamic json) {
    final map = <String, EdgeNode>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EdgeNode.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EdgeNode-objects as value to a dart map
  static Map<String, List<EdgeNode>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EdgeNode>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EdgeNode.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'region',
    'status',
    'monthly_cost_usd',
    'book_value_usd',
    'created_at',
  };
}

