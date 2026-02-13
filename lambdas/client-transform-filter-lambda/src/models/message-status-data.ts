/**
 * Message-level status transition event data.
 */
import type { RoutingPlan } from "models/routing-plan";
import type { Channel } from "models/channel-types";
import type { MessageStatus } from "models/status-types";

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
