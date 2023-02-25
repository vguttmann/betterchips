# betterchips

A better, more complete poker helper.

```mermaid
stateDiagram-v2
    [*] --> Bet: raise
    [*] --> Fold: notraise
    Bet --> Raise: raise
    Bet --> Match: match
    Bet --> Fold: notraise
    Match --> Match: match
    Match --> Reraise: raise
    Match --> Knock: notraise
    Raise --> Match: match
    Raise --> Reraise: raise
    Raise --> Knock: notraise
    Reraise --> Reraise: raise
    Reraise --> Match: match
    Reraise --> Knock: notraise
    Knock --> Knock: notraise
    Knock --> Match: match
    Knock --> Reraise: raise 
```
