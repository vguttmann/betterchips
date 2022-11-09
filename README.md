# betterchips

A better, more complete poker helper.

```mermaid
stateDiagram-v2
    [*] --> Bet: Initial Bet
    
    Bet --> Moving
    Moving --> Bet
    Moving --> Crash
```
