## Simple Mermaid Flowchart Example

Below is a basic Mermaid flowchart you can use in MkDocs:

```mermaid
flowchart TD
	A[input.cbl] --> B{update or build?}
	B -- Build --> C[Clean recorded logs to start again]
	C --> E[Generate recipe]
	B -- Update --> D[Fix it]
	D --> E
```
