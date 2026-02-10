/**
 * Channel-specific status change events.
 * Contains fields for callback construction and subscription filtering.
 */

export type Channel = "nhsapp" | "email" | "sms" | "letter";

export type ChannelStatus =
  | "created"
  | "sending"
  | "delivered"
  | "failed"
  | "skipped";

export type SupplierStatus =
  | "delivered"
  | "read"
  | "notification_attempted"
  | "unnotified"
  | "rejected"
  | "notified"
  | "received"
  | "permanent_failure"
  | "temporary_failure"
  | "technical_failure"
  | "accepted"
  | "cancelled"
  | "pending_virus_check"
  | "validation_failed"
  | "unknown";

/**
 * Operational fields (nhsNumber, sendingGroupId, delayedFallback) are NOT included in client callbacks.
 */
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
  previousSupplierStatus?: string;

  nhsNumber?: string;
  sendingGroupId?: string;
  delayedFallback?: boolean;
}
