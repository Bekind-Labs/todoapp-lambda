import { vi, describe, it, expect } from "vitest";
import { randomUUID } from "node:crypto";
import { TodoItem } from "../src";
import {
  APIGatewayClient,
  GetRestApisCommand,
} from "@aws-sdk/client-api-gateway";

const AWS_REGION = process.env.AWS_REGION ?? "ap-northeast-1";
const REST_API_NAME = "todo_api";
const REST_API_STAGE_NAME = "dev";

const config = {
  endpoint: "http://localhost:4566",
  region: "ap-northeast-1",
  credentials: {
    accessKeyId: "xxx",
    secretAccessKey: "yyy",
  },
};

const makeRandomText = () => {
  return `text-${randomUUID()}`;
};

describe("TODO endpoint", async () => {
  const client = new APIGatewayClient(config);
  const resGetRestApis = await client.send(new GetRestApisCommand());
  const apiId = resGetRestApis.items!.find(
    (item) => item.name === REST_API_NAME,
  )!.id!;

  const LAMBDA_ENDPOINT = `http://${apiId}.execute-api.${AWS_REGION}.localstack.localhost:4566/${REST_API_STAGE_NAME}`;
  const TODO_ENDPOINT = `${LAMBDA_ENDPOINT}/todos`;

  it("Basic CRUD flow", async () => {
    // GET all
    const getAllResponse0 = await fetch(TODO_ENDPOINT);
    expect(getAllResponse0.ok).toBe(true);
    const items0 = (await getAllResponse0.json()) as TodoItem[];

    // Add a new item.
    const text1 = makeRandomText();
    const postResponse = await fetch(TODO_ENDPOINT, {
      method: "POST",
      body: JSON.stringify({ text: text1 }),
    });
    expect(postResponse.ok).toBe(true);
    const id = await postResponse.text();

    // The new item must exist.
    const getAllResponse1 = await fetch(TODO_ENDPOINT);
    expect(getAllResponse1.ok).toBe(true);
    const items1 = (await getAllResponse1.json()) as TodoItem[];
    expect(items1.length).toBe(items0.length + 1);
    expect(items1).toContainEqual({ id: id, text: text1 });

    // Update the item.
    const text2 = makeRandomText();
    const putResponse = await fetch(`${TODO_ENDPOINT}/${id}`, {
      method: "PUT",
      body: JSON.stringify({ text: text2 }),
    });
    expect(putResponse.ok).toBe(true);

    // The item text must be changed.
    const getOneResponse = await fetch(`${TODO_ENDPOINT}/${id}`);
    expect(getOneResponse.ok).toBe(true);
    const item1 = (await getOneResponse.json()) as TodoItem;
    expect(item1.text).toBe(text2);

    // Delete the item.
    const deleteResponse = await fetch(`${TODO_ENDPOINT}/${id}`, {
      method: "DELETE",
    });
    expect(deleteResponse.ok).toBe(true);

    // The item must not exist.
    const getAllResponse2 = await fetch(TODO_ENDPOINT);
    expect(getAllResponse2.ok).toBe(true);
    const items2 = (await getAllResponse2.json()) as TodoItem[];
    expect(items2.length).toBe(items1.length - 1);
    expect(items2.map((item) => item.id)).not.toContain(id);
  });
});
