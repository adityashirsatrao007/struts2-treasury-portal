# 📈 Financial Workflows

The JPMC Treasury Portal implements standardized banking workflows to ensure regulatory compliance and operational control.

## 1. Maker-Checker Sequential Logic
The interaction between system participants follows a rigid sequence of events.

![Sequence Flow](assets/sequence_flow.png)

## 2. Maker-Checker Financial Lifecycle
To ensure institutional control, money movement requires two distinct roles. A **Maker** initiates the request, and a **Checker** must authorize it after a forensic review.

![Transfer Flow](assets/transfer_flow.png)

## 3. Liquidity Aggregation
The portal provides real-time visibility into global liquidity by aggregating balances across multiple accounts using high-performance Java Streams.
