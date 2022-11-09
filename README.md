# betterchips

A better, more complete poker helper.

```mermaid
stateDiagram-v2
    [*] --> Bet: Initial Bet
    Still --> [*]
    
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
```
