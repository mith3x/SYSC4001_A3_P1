# PowerShell script to compile and run all three schedulers on generated tests
Set-StrictMode -Version Latest

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $root

if (-not (Test-Path .\bin)) { New-Item -ItemType Directory -Path .\bin | Out-Null }

Write-Host "Compiling C++ simulators..."
g++ -std=c++17 -Wall -Wextra interrupts_101262467_101236818_EP.cpp   -o .\bin\interrupts_EP.exe
g++ -std=c++17 -Wall -Wextra interrupts_101262467_101236818_RR.cpp   -o .\bin\interrupts_RR.exe
g++ -std=c++17 -Wall -Wextra interrupts_101262467_101236818_EP_RR.cpp -o .\bin\interrupts_EP_RR.exe

if ($LASTEXITCODE -ne 0) { Write-Error "Compilation failed (see messages above)."; Exit 1 }

Write-Host "Generating tests..."
python .\scripts\generate_tests.py

$testdir = Join-Path $root 'tests_generated'
$tests = Get-ChildItem -Path $testdir -Filter '*.txt' | Sort-Object Name

foreach ($t in $tests) {
    $infile = $t.FullName
    $inbase = $t.BaseName
    Write-Host "Running schedulers on $($t.Name)"

    # Run each scheduler and rename/move any generated execution*.txt file to include scheduler label
    $schedulers = @(
        @{exe='.\\bin\\interrupts_EP.exe'; label='EP'},
        @{exe='.\\bin\\interrupts_RR.exe'; label='RR'},
        @{exe='.\\bin\\interrupts_EP_RR.exe'; label='EP_RR'}
    )

    foreach ($s in $schedulers) {
        # record existing execution files (names)
        $before = Get-ChildItem -Path $root -Filter 'execution*' -ErrorAction SilentlyContinue | ForEach-Object Name
        # run scheduler
        Write-Host "  Running $($s.label)"
        & $s.exe $infile
        Start-Sleep -Milliseconds 50
        # find any new execution* files and rename them to include scheduler label
        $after = Get-ChildItem -Path $root -Filter 'execution*' -ErrorAction SilentlyContinue
        $new = @()
        if ($after) {
            foreach ($f in $after) {
                if ($before -notcontains $f.Name) { $new += $f }
            }
        }
        if ($new.Count -gt 0) {
            foreach ($f in $new) {
                $dest = Join-Path $root ($f.BaseName + "_" + $s.label + $f.Extension)
                Move-Item -Path $f.FullName -Destination $dest -Force
                Write-Host "  Renamed $($f.Name) -> $(Split-Path $dest -Leaf)"
            }
        } else {
            Write-Host "  Warning: no NEW execution* file found for $($t.Name) by $($s.label) (existing: $($before -join ', '))"
        }
    }
}

Write-Host "All runs finished. Now computing metrics..."
python .\scripts\compute_metrics.py

Write-Host "Done. See results_summary.csv and report.md in repository root."
Pop-Location
