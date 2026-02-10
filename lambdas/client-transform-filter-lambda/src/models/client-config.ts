/**
 * Client callback subscription configuration.
 * Array of subscription rules (one per event type/channel combination).
 */

export type ClientSubscriptionConfiguration = (
  | MessageStatusSubscriptionConfiguration
  | ChannelStatusSubscriptionConfiguration
)[];

interface SubscriptionConfigurationBase {
  Name: string;
  ClientId: string;
  Description: string;
  EventSource: string;
  EventDetail: string;
  Targets: {
    Type: "API";
    TargetId: string;
    Name: string;
    InputTransformer: {
      InputPaths: string;
      InputHeaders: {
        "x-hmac-sha256-signature": string;
      };
    };
    InvocationEndpoint: string;
    InvocationMethod: "POST";
    InvocationRateLimit: number;
    APIKey: {
      HeaderName: string;
      HeaderValue: string;
    };
  }[];
}

export interface MessageStatusSubscriptionConfiguration
  extends SubscriptionConfigurationBase {
  SubscriptionType: "MessageStatus";
  Statuses: string[];
}

export interface ChannelStatusSubscriptionConfiguration
  extends SubscriptionConfigurationBase {
  SubscriptionType: "ChannelStatus";
  ChannelType: string;
  ChannelStatuses: string[];
  SupplierStatuses: string[];
}
