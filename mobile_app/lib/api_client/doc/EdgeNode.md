# finops_api.model.EdgeNode

## Load the model package
```dart
import 'package:finops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | 一意のノードID | 
**name** | **String** | ノード（サーバー）名 | 
**region** | **String** | 配置されているリージョン | 
**status** | [**NodeStatus**](NodeStatus.md) | 稼働状況 | 
**monthlyCostUsd** | **num** | 今月の推定クラウドコスト（USD） | 
**bookValueUsd** | **num** | ソフトウェア/ハードウェアの帳簿価格（USD） | 
**createdAt** | [**DateTime**](DateTime.md) | プロビジョニング日時 | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


