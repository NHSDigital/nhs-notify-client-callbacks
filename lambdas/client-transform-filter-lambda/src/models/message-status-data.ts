/**
 * Message-level status transition event data.
 */
import type { RoutingPlan } from "models/routing-plan";

export type MessageStatus =
  | "created"
  | "pending_enrichment"
  | "enriched"
  | "sending"
  | "delivered"
  | "failed";

export type Channel = "nhsapp" | "email" | "sms" | "letter";

export interface MessageStatusData {
  messageId: string;
  messageReference: string;
  messageStatus: MessageStatus;
  messageStatusDescription?: string;
  messageFailureReasonCode?: string;
  channels: {
    type: Channel;
    channelStatus: string;
  }[];
  timestamp: string;
  routingPlan: RoutingPlan;

  clientId: string;
  previousMessageStatus?: MessageStatus;
}
