/**
 * Channel-level status transition event data.
 */
import type { Channel } from "models/channel-types";
import type { ChannelStatus, SupplierStatus } from "models/status-types";

export interface ChannelStatusData {
  messageId: string;
  messageReference: string;
  channel: Channel;
  channelStatus: ChannelStatus;
  channelStatusDescription?: string;
  channelFailureReasonCode?: string;
  supplierStatus: SupplierStatus;
  cascadeType: "primary" | "secondary";
  cascadeOrder: number;
  timestamp: string;
  retryCount: number;

  clientId: string;
  previousChannelStatus?: ChannelStatus;
  previousSupplierStatus?: SupplierStatus;
}
