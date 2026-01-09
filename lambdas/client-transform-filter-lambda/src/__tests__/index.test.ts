import { handler } from "../index";

describe("Lambda handler", () => {

  it("extracts from a stringified event", async () => {
    const eventStr = JSON.stringify({
      body: {
        dataschemaversion: "1.0",
        type: "uk.nhs.notify.client-callbacks.test-sid"
      }
    });

    const result = await handler(eventStr);
    expect(result).toEqual({
      body: {
        dataschemaversion: "1.0",
        type: "uk.nhs.notify.client-callbacks.test-sid"
      }
    });
  });

  it("extracts from an array with nested body", async () => {
    const eventArray = [
      {
        messageId: "123",
        body: JSON.stringify({
          body: {
            dataschemaversion: "1.0",
            type: "uk.nhs.notify.client-callbacks.test-sid"
          }
        })
      }
    ];

    const result = await handler(eventArray);
    expect(result).toEqual({
      body: {
        dataschemaversion: "1.0",
        type: "uk.nhs.notify.client-callbacks.test-sid"
      }
    });
  });

  it("returns empty body if fields are missing", async () => {
    const event = { some: "random" };
    const result = await handler(event);
    expect(result).toEqual({ body: {} });
  });

  it("handles deeply nested fields", async () => {
    const event = {
      level1: {
        level2: {
          body: JSON.stringify({
            body: {
              dataschemaversion: "2.0",
              type: "nested-type"
            }
          })
        }
      }
    };

    const result = await handler(event);
    expect(result).toEqual({
      body: {
        dataschemaversion: "2.0",
        type: "nested-type"
      }
    });
  });

  it("handles invalid JSON gracefully", async () => {
    const eventStr = "{ invalid json ";
    const result = await handler(eventStr);
    expect(result).toEqual({ body: {} });
  });

});
