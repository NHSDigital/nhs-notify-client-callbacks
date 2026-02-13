/**
 * Message/Channel Status Callback payload delivered to client webhooks.
 */

import type { RoutingPlan } from "models/routing-plan";
import type { Channel } from "models/channel-types";
import type {
  ChannelStatus,
  MessageStatus,
  SupplierStatus,
} from "models/status-types";

export type ClientChannel = Lowercase<Channel>;
export type ClientMessageStatus = Lowercase<MessageStatus>;
export type ClientChannelStatus = Lowercase<ChannelStatus>;
export type ClientSupplierStatus = Lowercase<SupplierStatus>;

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
  messageStatus: ClientMessageStatus;
  messageStatusDescription?: string;
  messageFailureReasonCode?: string;
  channels: {
    type: ClientChannel;
    channelStatus: ClientChannelStatus;
  }[];
  timestamp: string;
  routingPlan: RoutingPlan;
}

export interface ChannelStatusAttributes {
  messageId: string;
  messageReference: string;
  cascadeType: "primary" | "secondary";
  cascadeOrder: number;
  channel: ClientChannel;
  channelStatus: ClientChannelStatus;
  channelStatusDescription?: string;
  channelFailureReasonCode?: string;
  supplierStatus: ClientSupplierStatus;
  timestamp: string;
  retryCount: number;
}
