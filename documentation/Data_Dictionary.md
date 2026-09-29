# Data Dictionary

This document focuses on the fields used in the analysis rather than reproducing every field from the original challenge documentation.

## Events

| Field | Description | Used For |
|---|---|---|
| `event_id` | Unique event identifier | Data validation |
| `event_type` | Event classification such as order or invoice | Purchase definition |
| `event_date` | Event timestamp | Time analysis |
| `customer_id` | Customer identifier | Customer analysis |
| `product_id` | Product identifier | Product analysis |
| `country` | Country associated with the event | Geographic analysis |
| `region` | Geographic region | Regional analysis |
| `channel` | Sales channel | Channel performance |
| `currency` | Transaction currency | Currency analysis |
| `quantity` | Quantity associated with the event | Sales validation |
| `unit_price_local` | Unit price in local currency | Revenue validation |
| `discount_local` | Discount amount in local currency | Discount analysis |
| `tax_local` | Tax amount in local currency | Revenue validation |
| `net_revenue_local` | Net revenue in local currency | Revenue validation |
| `fx_rate_to_usd` | FX conversion rate | Revenue validation |
| `net_revenue_usd` | Net revenue normalized to USD | Main sales metric |
| `is_refunded` | Refund indicator | Refund analysis |
| `refund_datetime` | Refund timestamp | Refund analysis |
| `refund_reason` | Recorded reason for refund | Refund analysis |

## Products

| Field | Description | Used For |
|---|---|---|
| `product_id` | Unique product identifier | Joining products to events |
| `product_name` | Product name | Product performance |
| `category` | Product category | Category analysis |
| `subscription` | Indicates subscription product | Subscription analysis |
| `billing_cycle` | Annual, Monthly, or One-time | Plan analysis |
| `base_price` | Product base price | Product context |
| `vendor` | Vendor information | Product context |
| `resale_model` | Resale model | Product context |
| `product_version` | Product version | Product context |
| `base_product_key` | Base-product relationship | Add-on analysis |

## Customers

Customer-level context includes customer ID, signup date, region, currency, segment, acquisition channel, age band, and country.

Signup date was not used as the source of first-purchase timing because of the inconsistency documented in `Data_Quality_Notes.md`.
