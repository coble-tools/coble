## Simple Mermaid Flowchart Example

Below is a basic Mermaid flowchart you can use in MkDocs:

```mermaid
flowchart TD
	A[Start] --> B{Is it working?}
	B -- Yes --> C[Great!]
	B -- No --> D[Fix it]
	D --> B
```
