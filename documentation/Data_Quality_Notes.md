# Data Quality & Preparation Notes

## Overall Assessment

The supplied dataset was relatively clean and did not require extensive data cleaning. The main preparation work was validation, date conversion, business-rule definition, and consistency checks.

## Checks Performed

- Checked duplicate `event_id` values.
- Checked missing customer and product identifiers.
- Checked quantity, price, and revenue values for invalid negatives.
- Checked the distribution of event types.
- Validated the relationship between quantity, price, discount, tax, and revenue.
- Checked USD conversion using the supplied FX rate.
- Checked refund fields and refund reasons.
- Converted `event_date` from text (`DD-MM-YYYY HH:MM`) to datetime for chronological analysis.

## Event Types

The event table contains `order` and `invoice` events.

For purchase-based analysis:

- `order` = new purchase
- `invoice` = renewal/billing activity

This distinction is important because counting invoices as purchases would distort repeat-purchase metrics.

## Signup Date Inconsistency

A significant portion of event records occurred before the recorded customer signup date. Because of this inconsistency, signup date was not used to determine first purchase or purchase tenure.

Instead, the earliest qualifying `order` event was used as the first purchase for behavioural analysis.

## Missing Region Values

Some event records have missing region information, particularly for US and Canada-related records. These transactions were not discarded simply because the event-level region was missing; customer-level geographic information was available for context.

## Refund Analysis

Refund metrics were calculated specifically on `order` events. This is important because the full event table also contains invoices.

The final dashboard therefore uses the order-level refund rate of **2.05%** and **689 refunded orders**.

## Conclusion

The dataset did not require heavy cleaning. The important work was making sure the data was interpreted correctly and that SQL and Power BI used the same business logic.
