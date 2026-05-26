//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NodeListResponse {
  /// Returns a new [NodeListResponse] instance.
  NodeListResponse({
    required this.totalCount,
    this.nodes = const [],
    this.hasNext = false,
  });

  /// 総ノード数
  int totalCount;

  /// ノードのリスト
  List<EdgeNode> nodes;

  /// 次のページが存在するか
  bool hasNext;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NodeListResponse &&
    other.totalCount == totalCount &&
    _deepEquality.equals(other.nodes, nodes) &&
    other.hasNext == hasNext;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalCount.hashCode) +
    (nodes.hashCode) +
    (hasNext.hashCode);

  @override
  String toString() => 'NodeListResponse[totalCount=$totalCount, nodes=$nodes, hasNext=$hasNext]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'total_count'] = this.totalCount;
      json[r'nodes'] = this.nodes;
      json[r'has_next'] = this.hasNext;
    return json;
  }

  /// Returns a new [NodeListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NodeListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'total_count'), 'Required key "NodeListResponse[total_count]" is missing from JSON.');
        assert(json[r'total_count'] != null, 'Required key "NodeListResponse[total_count]" has a null value in JSON.');
        assert(json.containsKey(r'nodes'), 'Required key "NodeListResponse[nodes]" is missing from JSON.');
        assert(json[r'nodes'] != null, 'Required key "NodeListResponse[nodes]" has a null value in JSON.');
        return true;
      }());

      return NodeListResponse(
        totalCount: mapValueOfType<int>(json, r'total_count')!,
        nodes: EdgeNode.listFromJson(json[r'nodes']),
        hasNext: mapValueOfType<bool>(json, r'has_next') ?? false,
      );
    }
    return null;
  }

  static List<NodeListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NodeListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NodeListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NodeListResponse> mapFromJson(dynamic json) {
    final map = <String, NodeListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NodeListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NodeListResponse-objects as value to a dart map
  static Map<String, List<NodeListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NodeListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NodeListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total_count',
    'nodes',
  };
}

