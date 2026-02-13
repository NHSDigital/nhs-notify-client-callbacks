/**
 * Message-level statuses
 */
export type MessageStatus =
  | "CREATED"
  | "PENDING_ENRICHMENT"
  | "ENRICHED"
  | "SENDING"
  | "DELIVERED"
  | "FAILED";

/**
 * Channel-level statuses
 */
export type ChannelStatus =
  | "CREATED"
  | "SENDING"
  | "DELIVERED"
  | "FAILED"
  | "SKIPPED";

/**
 * Supplier-reported statuses
 */
export type SupplierStatus =
  | "DELIVERED"
  | "READ"
  | "NOTIFICATION_ATTEMPTED"
  | "UNNOTIFIED"
  | "REJECTED"
  | "NOTIFIED"
  | "RECEIVED"
  | "PERMANENT_FAILURE"
  | "TEMPORARY_FAILURE"
  | "TECHNICAL_FAILURE"
  | "ACCEPTED"
  | "CANCELLED"
  | "PENDING_VIRUS_CHECK"
  | "VALIDATION_FAILED"
  | "UNKNOWN";
