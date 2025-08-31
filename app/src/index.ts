import {
  DynamoDBClient,
  type DynamoDBClientConfig,
} from "@aws-sdk/client-dynamodb";
import {
  DeleteCommand,
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
  ScanCommand,
} from "@aws-sdk/lib-dynamodb";
import type { APIGatewayEvent, Callback, Context } from "aws-lambda";
import type { APIGatewayProxyStructuredResultV2 } from "aws-lambda/trigger/api-gateway-proxy";

export type HttpMethod = "GET" | "POST" | "PUT" | "DELETE";

export const basePath = "/todos";

export type Config = {
  dynamoDBClientConfig: DynamoDBClientConfig;
  dynamoDBTableName: string;
};

export type TodoItem = {
  id: string;
  text: string;
};

const getDefaultConfig = (): Config => {
  return {
    dynamoDBClientConfig: {},
    dynamoDBTableName: process.env.DYNAMODB_TABLE_NAME!,
  };
};

const getLastPathComponent = (path: string): string => {
  const components = path.split("/");
  return components[components.length - 1];
};

export const handler = async (
  event: APIGatewayEvent,
  context: Context,
  _callback: Callback,
  defaultConfig?: Config,
): Promise<APIGatewayProxyStructuredResultV2> => {
  const config = defaultConfig ?? getDefaultConfig(); // Not tested
  console.debug({ config, event, context });

  const tableName = config.dynamoDBTableName;
  const client = new DynamoDBClient(config.dynamoDBClientConfig);
  const docClient = DynamoDBDocumentClient.from(client);

  const method = event.httpMethod;
  const path = event.path;

  if (method === "POST" && path === basePath) {
    const request = JSON.parse(event.body || "{}");
    const id = crypto.randomUUID();
    const command = new PutCommand({
      TableName: tableName,
      Item: {
        id: id,
        text: request.text,
      },
    });
    await docClient.send(command);
    return {
      statusCode: 200,
      body: id,
    };
  } else if (method === "GET" && path === basePath) {
    const command = new ScanCommand({
      TableName: tableName,
    });
    const response = await docClient.send(command);
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(response.Items),
    };
  } else if (method === "GET" && path.startsWith(`${basePath}/`)) {
    const id = getLastPathComponent(path);
    const command = new GetCommand({
      TableName: tableName,
      Key: {
        id: id,
      },
    });
    const response = await docClient.send(command);
    const item = response.Item;
    if (item === undefined) {
      return {
        statusCode: 404,
        body: `not found: ${id}`,
      };
    } else {
      return {
        statusCode: 200,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(response.Item),
      };
    }
  } else if (method === "DELETE" && path.startsWith(`${basePath}/`)) {
    const id = getLastPathComponent(path);
    const command = new DeleteCommand({
      TableName: tableName,
      Key: {
        id: id,
      },
    });
    await docClient.send(command);
    return {
      statusCode: 200,
      body: id,
    };
  } else if (method === "PUT" && path.startsWith(`${basePath}/`)) {
    const id = getLastPathComponent(path);
    const request = JSON.parse(event.body || "{}");
    const command = new PutCommand({
      TableName: tableName,
      Item: {
        id: id,
        text: request.text,
      },
    });
    await docClient.send(command);
    return {
      statusCode: 200,
      body: id,
    };
  } else {
    return {
      statusCode: 400,
      body: JSON.stringify("bad request"),
    };
  }
};
