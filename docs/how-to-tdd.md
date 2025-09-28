# Lambdaで快適なTDDを!

(プレゼン資料)

## はじめに

Lambdaを使った簡単なTODOアプリのバックエンドを
TDDで作成する方法を紹介します。 

- 構成: Lambda + DynamoDB + API Gateway
- 使用言語: TypeScript + Vitest

## AWS Lambdaとは?

AWSの有名なサーバレス環境。

- Pro: デプロイが簡単。
- Pro: 動いた分しか課金されない。
− Con: 重い処理には向かない。
- Con: 単体でできることは少ないので、AWSの他サービスと密に連携する。
  - → 「ピタゴラスイッチ」ができやすい。 
- Con: ベンダーロックイン。

## なぜAWS SAMを使わないの?

Lambdaの開発キットとしては AWS SAM が有名だが、今回は使わないことにした。

- 多様なユースケースをサポートしているため、重いし複雑。
  - いろいろ設定を書かなければならない。
- 文書もわかりにくい。
- ローカル環境だけでテストできない。
  - Lambda以外のサービスに関しては、結局AWS本体を使わねばならない。
- IaC として CloudFormationを使っており、Terraformと互換性がない。
- 結論: SAM使ってるだけで、すでに技術負債。

## じゃあどうする?

よく知っているテクノロジーを組み合わせてなんとかならないか?

- Docker
- Terraform
- LocalStack
  - ローカル環境で動くAWSエミュレータ
  - S3 + DynamoDB + EventBridge + API Gateway + ... + Lambda

LocalStack使えば、全部ローカルでLambdaの統合テストができるんじゃ?

## サンプル TODOアプリ

Repo: https://github.com/Bekind-Labs/todoapp-lambda

- ローカル環境だけで開発＋テスト＋E2Eテスト可能。
- テストも本番も同じTerraformで一発デプロイ可能。

## テスト戦略はどうする?

たとえば、DynamoDBテーブルへの書き込みは以下のようにしておこなうが...

```typescript
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient();
const docClient = DynamoDBDocumentClient.from(client);
const command = new PutCommand({
  TableName: "todo_table",
  Item: { id: "123", data: "hello" }
});
await docClient.send(command);
```

これを test doubles を使ってテストしようとすると、正直ツライ。
最初からDynamoDBの仕様をきちんと理解してないと書けない。

むしろ、こんなふうにテストしたい:

```
// 準備 (Arrange)
DynamoDBテーブルを空にしておく。
// 実行 (Act)
await handler(...);
// 検証 (Assert)
DynamoDBテーブルを見て、実際に書き込まれたかチェック。
```

## どうやって統合テストを書く?

API Gatewayから起動する関数は、以下の署名になっている:

```typescript
export const handler = async (
   event: APIGatewayEvent,
   context: Context,
   callback: Callback,
): Promise<APIGatewayProxyStructuredResultV2> => {
...
}
```

これにオプション引数を使ってテスト環境を注入すればよい:

```typescript
// テスト時に変更したいものを入れる
type Config = {
  dynamoDBClientConfig: ...
  dynamoDBTableName: ...
}
```

こうすると、テスト時にLocalStackのDynamoDBを使わせることが可能:

```typescript
const config = {
  dynamoDBClientConfig: {
    endpoint: "http://localhost:4566",
  }
}
// 実行 (Act)
await handler(..., config);
```

## ビルドとデプロイ

ローカル環境 (LocalStack) へのデプロイは超簡単:
```
make deploy
```
基本的に、やっていることはこんだけ。
https://docs.aws.amazon.com/lambda/latest/dg/typescript-package.html#aws-cli-ts

本物AWSへのデプロイも簡単:
```
make deploy AWSCLI=aws
```

SAM必要ないじゃん!

## E2Eテスト

実際にHTTP経由でアクセスできるため、本番に近い環境でテスト可能。

- ローカル環境にデプロイして普通にHTTPでアクセスするだけ。
- 今回はバックエンドだけなので、テスト自体は vitest で書いた。
- フロントエンドがある場合は、Playwrightで普通にテストできる。

## まとめ

簡単なアプリならLambdaバックエンドはおすすめ。
だからといって、快適なTDDをあきらめる必要はない。

- いまのところ、JavaScript + API Gateway に限られている。
- 別種のLambdaを書きたい場合は E2E テストは不可能。
- LocalStackでサポートされていないサービスを使いたい場合は面倒くさい。
  - WiremockなどでHTTPレベルでmockするという手もあるかも。
