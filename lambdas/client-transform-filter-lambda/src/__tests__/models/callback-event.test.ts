import { EventTypes } from "models/status-change-event";

// coverage purposes
describe("EventTypes", () => {
  it("should match the expected event type values", () => {
    expect(EventTypes).toEqual({
      MESSAGE_STATUS_TRANSITIONED:
        "uk.nhs.notify.client-callbacks.message.status.transitioned.v1",
      CHANNEL_STATUS_TRANSITIONED:
        "uk.nhs.notify.client-callbacks.channel.status.transitioned.v1",
    });
  });
});
