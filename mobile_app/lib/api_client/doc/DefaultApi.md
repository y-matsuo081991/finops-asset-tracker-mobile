# finops_api.api.DefaultApi

## Load the API package
```dart
import 'package:finops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthCheckHealthGet**](DefaultApi.md#healthcheckhealthget) | **GET** /health | Health Check


# **healthCheckHealthGet**
> Object healthCheckHealthGet()

Health Check

システムの正常稼働を確認するためのヘルスチェックエンドポイント

### Example
```dart
import 'package:finops_api/api.dart';

final api_instance = DefaultApi();

try {
    final result = api_instance.healthCheckHealthGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->healthCheckHealthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

