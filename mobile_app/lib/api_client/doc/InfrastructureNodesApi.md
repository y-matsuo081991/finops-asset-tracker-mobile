# finops_api.api.InfrastructureNodesApi

## Load the API package
```dart
import 'package:finops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getNodesApiV1NodesGet**](InfrastructureNodesApi.md#getnodesapiv1nodesget) | **GET** /api/v1/nodes | インフラノード一覧の取得 (カーソルベースのページネーション対応)


# **getNodesApiV1NodesGet**
> NodeListResponse getNodesApiV1NodesGet(limit, cursor)

インフラノード一覧の取得 (カーソルベースのページネーション対応)

架空のクラウドサーバー（EdgeNode）のリストとコスト情報を取得します。 Cursor-Based Pagination に対応しています。

### Example
```dart
import 'package:finops_api/api.dart';

final api_instance = InfrastructureNodesApi();
final limit = 56; // int | 取得件数
final cursor = cursor_example; // String | 次ページを取得するためのカーソル（最後のノードID）。初回はNone

try {
    final result = api_instance.getNodesApiV1NodesGet(limit, cursor);
    print(result);
} catch (e) {
    print('Exception when calling InfrastructureNodesApi->getNodesApiV1NodesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| 取得件数 | [optional] [default to 20]
 **cursor** | **String**| 次ページを取得するためのカーソル（最後のノードID）。初回はNone | [optional] 

### Return type

[**NodeListResponse**](NodeListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

