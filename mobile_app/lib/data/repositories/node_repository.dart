import 'package:finops_api/api.dart';

class NodeRepository {
  final InfrastructureNodesApi _api;

  NodeRepository(this._api);

  Future<NodeListResponse> getNodes({required int limit, String? cursor}) async {
    final response = await _api.getNodesApiV1NodesGet(limit: limit, cursor: cursor);
    if (response == null) {
      throw Exception('Failed to fetch nodes from API');
    }
    return response;
  }
}
