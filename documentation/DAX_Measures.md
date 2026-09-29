# Key DAX Measures

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

## Refund Rate
```DAX
Refund Rate =
DIVIDE(
    [Refunded Orders],
    [Total Orders]
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
```DAX
Add-on Attach Rate =
DIVIDE(
    [Add-on Customers],
    [Base Product Customers]
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
