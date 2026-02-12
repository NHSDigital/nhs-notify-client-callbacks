/**
 * Message-level status change events.
 * Contains fields for callback construction and subscription filtering.
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

/**
 * Operational fields (nhsNumber, sendingGroupId) are NOT included in client callbacks.
 */
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

  nhsNumber?: string;
}
