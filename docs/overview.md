## Simple Mermaid Flowchart Example

Below is a basic Mermaid flowchart you can use in MkDocs:

```mermaid
flowchart TD
	A[input.cbl] --> B{update or build?}
	B -- Build --> C[Clean recorded logs to start again]
	B -- Update --> D[Generate recipe delta]
	C --> D	
	D --> E{Is it working?}
	E -- No --> A
	E -- Yes --> F[Create conda environment]
	F --> G[Capture environment libs and versions]
```
