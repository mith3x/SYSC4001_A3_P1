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
.\bin\interrupts_EP.exe .\test2.txt
.\bin\interrupts_EP.exe .\test3.txt
.\bin\interrupts_EP.exe .\test4.txt

Get-Content .\execution1.txt
Get-Content .\execution2.txt
Get-Content .\execution3.txt
Get-Content .\execution4.txt
```


