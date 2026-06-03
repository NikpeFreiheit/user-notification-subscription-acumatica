
## Topics description

| Topic name | Business Context | Producer (Name / SLA / Idempotency / ACKs) | Consumer name |
| --- | --- | --- | --- |
| **ML-ADS-NEW** | Topic for incoming messages from ML Model which create ads for New Customers | <br>**ADS-NEW-KAFKA-PRODUCER** <br> Latency: 0 ms <br>Idempotency: yes <br>Acknowledgment: all | <br>**STORE-NEW-KAFKA-CONSUMER**|
| **ML-ADS-RET** | Topic for incoming messages from ML Model which create ads for Returning Customers | <br>**ADS-RET-KAFKA-PRODUCER** <br> Latency: 0 ms <br>Idempotency: yes <br>Acknowledgment: all | <br>**STORE-RET-KAFKA-CONSUMER** |

---

## Topics configuration 

| Topic name | Partition count | Replication Factor |Retention Bytes | Retention Ms |
| --- | --- | --- | --- | --- |
| **ML-ADS-NEW** | 3 | 4 | 100 | 1 |
| **ML-ADS-RET** | 3 | 4 | 100 | 1 |

---

## Message payload schema for topic ML-ADS-NEW

Payload template
```json
{}
```
Json Schema

```json
{}
```

## Message payload schema for topic ML-ADS-RET

Payload template

```json
{}
```
Json Schema

```json
{}
```