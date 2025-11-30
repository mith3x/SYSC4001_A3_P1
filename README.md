# SYSC4001 — Assignment 3 Part 1 (Interrupts simulator)

This repository contains three scheduler implementations (EP, RR, EP+RR) for a small interrupts/process simulator used in SYSC4001 assignment.

Files of interest
- `interrupts_student1_student2_EP.cpp` — Priority-based (EP) scheduler
- `interrupts_student1_student2_RR.cpp` — Round-Robin (RR) scheduler
- `interrupts_student1_student2_EP_RR.cpp` — Priority + RR combined scheduler
- `interrupts_student1_student2.hpp` — Simulator helpers, PCB definition, and I/O/partition logic
- `test1.txt`..`test4.txt` — Example test inputs (you may create or overwrite these)

Build & run (Windows PowerShell)
```powershell
cd C:\Users\mithu\Downloads\part1
if (-not (Test-Path .\bin)) { New-Item -ItemType Directory -Path .\bin | Out-Null }
g++ -std=c++17 -Wall -Wextra interrupts_student1_student2_EP.cpp   -o .\bin\interrupts_EP.exe
g++ -std=c++17 -Wall -Wextra interrupts_student1_student2_RR.cpp   -o .\bin\interrupts_RR.exe
g++ -std=c++17 -Wall -Wextra interrupts_student1_student2_EP_RR.cpp -o .\bin\interrupts_EP_RR.exe

# Run one scheduler on a test file
.\bin\interrupts_EP.exe .\test1.txt
Get-Content .\execution.txt
```

Pushing to GitHub
- Create a repo on github.com (or use `gh repo create`) and push your local git repo. See the repository `Makefile` for build hints.

Notes
- The simulator writes `execution.txt` by default; copy or rename it after each run to avoid overwriting.
- If you see BOM-related parsing errors, recreate test files with UTF-8 without BOM (PowerShell examples included earlier).
