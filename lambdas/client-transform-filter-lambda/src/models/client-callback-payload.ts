/**
 * Message/Channel Status Callback payload delivered to client webhooks.
 */

import type {
  Channel,
  ChannelStatus,
  MessageStatus,
  SupplierStatus,
} from "models/status-transition-event";
import type { RoutingPlan } from "models/routing-plan";

export interface ClientCallbackPayload {
  data: CallbackItem[];
}

export interface CallbackItem {
  type: "MessageStatus" | "ChannelStatus";
  attributes: MessageStatusAttributes | ChannelStatusAttributes;
  links: {
    message: string;
  };
  meta: {
    idempotencyKey: string;
  };
}

export interface MessageStatusAttributes {
  messageId: string;
  messageReference: string;
  messageStatus: MessageStatus;
  messageStatusDescription?: string;
  messageFailureReasonCode?: string;
  channels: {
    type: Channel;
    channelStatus: "delivered" | "failed";
  }[];
  timestamp: string;
  routingPlan: RoutingPlan;
}

export interface ChannelStatusAttributes {
  messageId: string;
  messageReference: string;
  cascadeType: "primary" | "secondary";
  cascadeOrder: number;
  channel: Channel;
  channelStatus: ChannelStatus;
  channelStatusDescription?: string;
  channelFailureReasonCode?: string;
  supplierStatus: SupplierStatus;
  timestamp: string;
  retryCount: number;
}
