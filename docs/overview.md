# Overview of COBLE

## Workflow

```mermaid
flowchart LR
	INP[input.cbl] --> REC[Make recipe]
	REC --> UPD_BLD{update or build?}
	UPD_BLD -- Update --> DLT[Find recipe delta]
	UPD_BLD -- Build --> CRE[Create conda environment]
	DLT --> CRE	
	CRE --> ERR{Error free?}
	ERR -- No --> INP
	ERR -- Yes --> CAP[Capture environment libs and versions]	
```

```mermaid
flowchart LR
    subgraph "COBLE Workflow"
        subgraph "Local Development"
            A[Write Recipe]
            B[Test Locally]
        end
        subgraph "HPC Cluster"
            C[Submit Job]
            D[Build Package]
        end
    end
    
    B --> C
    D --> E[Deploy]
```

## log and output files
### Inputs
input.cbl # The input definiton of the environment
### Interim
- **input.cbl.recipe.sh** - the cbl transformed into a pure bash script that could be run instead  
- **input.cbl.recipe.sh.delta.sh** - the change in bash that will be run (for updates and resume)  
- **input.cbl.recipe.sh.done.sh** - each bash line that has  succesfull completed in the environment  
- **input.cbl.recipe.sh.old.sh** - backed up when new recipe created  
#### Logs and tracking
- **input.cbl.recipe.sh.log** - each bash line cleans the log file so you can track the current stdout  
- **input.cbl.recipe.sh.err** - each bash line cleans the err file so you can track the current stderr  
- **input.cbl.recipe.sh.summary.txt** - after each install the logs are parsed for important info eg errors or dependencies. This are output along with the timings  
### Catured environment
- **input.cbl.recipe.sh.capture.cml** - The environment is captured, all packages and libs and versions, for reproducibility this could be used to recreate the environment  



