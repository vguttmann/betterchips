# betterchips

A better, more complete poker helper.

```mermaid
state-diagram-v2
    [*] --> Still
    Still --> [*]
    
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
```
