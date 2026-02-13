/**
 * CloudEvents-compliant event structure for callback delivery.
 * Events carry complete payloads to avoid additional lookups.
 */

import type { MessageStatusData } from "models/message-status-data";
import type { ChannelStatusData } from "models/channel-status-data";

export interface NotifyMetadata {
  teamResponsible: "Team 1" | "Team 2" | "Team 3";
  notifyDomain: "Ordering" | "Delivering" | "Reporting" | "Enquiries";
  microservice: string;
  repositoryUrl: string;
  accountId: string;
  environment: "development" | "testing" | "staging" | "production";
  instance: string;
  microserviceInstanceId: string;
  microserviceVersion: string;
}

export interface StatusTransitionEvent<
  T = MessageStatusData | ChannelStatusData,
> {
  profileversion: string;
  profilepublished: string;
  specversion: string;
  id: string;
  source: string;
  subject: string;
  type: string;
  time: string;
  recordedtime: string;
  datacontenttype: string;
  dataschema: string;
  severitynumber: number;
  severitytext: string;
  traceparent: string;

  data: {
    "notify-payload": {
      "notify-data": T;
      "notify-metadata": NotifyMetadata;
    };
  };
}

export const EventTypes = {
  MESSAGE_STATUS_TRANSITIONED:
    "uk.nhs.notify.client-callbacks.message.status.transitioned.v1",
  CHANNEL_STATUS_TRANSITIONED:
    "uk.nhs.notify.client-callbacks.channel.status.transitioned.v1",
} as const;

export { type MessageStatusData } from "./message-status-data";
export { type Channel, type MessageStatus } from "models/message-status-data";
export {
  type ChannelStatus,
  type SupplierStatus,
  type ChannelStatusData,
} from "models/channel-status-data";
