# Power BI / DAX Measures

The Power BI report uses measures so that the same business definitions can be reused across pages and visuals.

## Total Sales

```DAX
Total Sales =
CALCULATE(
    SUM(Events_updated[net_revenue_usd]),
    Events_updated[event_type] = "order"
)
```

## Average Order Value

```DAX
Average Order Value =
DIVIDE(
    [Total Sales],
    [Total Orders]
)
```

## Repeat Customers

```DAX
Repeat Customers =
COUNTROWS(
    FILTER(
        VALUES(Events_updated[customer_id]),
        CALCULATE(
            COUNTROWS(Events_updated),
            Events_updated[event_type] = "order"
        ) >= 2
    )
)
```

## Repeat Customer Rate

```DAX
Repeat Customer Rate =
DIVIDE(
    [Repeat Customers],
    [Total Customers]
)
```

## Annual Plan Sales

```DAX
Annual Plan Sales =
CALCULATE(
    [Total Sales],
    Products_final__3[billing_cycle] = "Annual"
)
```

## Monthly Plan Sales

```DAX
Monthly Plan Sales =
CALCULATE(
    [Total Sales],
    Products_final__3[billing_cycle] = "Monthly"
)
```

## Refunded Orders

```DAX
Refunded Orders =
CALCULATE(
    COUNTROWS(Events_updated),
    Events_updated[event_type] = "order",
    Events_updated[is_refunded] = "TRUE"
)
```

## Add-on Attach Rate

The numerator counts customers who bought both a base product and an add-on. The denominator counts customers who bought at least one non-add-on/base product.

Final result: **62.26%**.

## Repeat Customer Sales

Repeat customers are identified independently of the product filter so that product-level repeat-customer sales remain accurate.

## Plan Comparison

A disconnected `Plan Type` table is used to switch between annual and monthly measures in the comparison visuals.
