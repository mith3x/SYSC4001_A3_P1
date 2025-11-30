# Simulation Analysis Report

This document summarises the results of an experimental evaluation of three scheduler implementations included in the repository:

- EP (priority-based)
- RR (round-robin)
- EP+RR (priority with round-robin time-slicing)

We generated 20 distinct input scenarios programmatically (see `scripts/generate_tests.py`) across three workload categories: CPU-bound, I/O-bound and Mixed. For each scenario the three schedulers were executed and their execution logs saved as `executiongen_<id>_<cat>_<sched>.txt`.

The metrics computed from logs are:

- Throughput = terminated processes / simulation time (processes / ms)
- Average Wait Time = mean time spent in READY state per process (ms)
- Average Turnaround = mean(completion_time - arrival_time) (ms)
- Average Response (arrival->first RUNNING) = mean initial response time (ms)
- Average I/O Duration = mean WAITING duration observed (ms)

All raw parsed results are in `results_summary.csv`. Below we summarise aggregated numbers and provide an interpretation of the behaviour observed across schedulers and workload types.

## High-level aggregated findings

Across the 60 executions (20 scenarios × 3 schedulers) the three schedulers produced broadly similar overall throughput on average, but they differ in wait time, turnaround and response depending on workload mix. Key trends:

- CPU-bound workloads produce the worst throughput and highest average wait/turnaround for every scheduler (long CPU bursts dominate the processor).
- I/O-bound workloads produce higher throughput and lower turnaround because processes frequently block on I/O and release the CPU.
- RR and EP+RR improve fairness and initial response for short/interactive jobs, while EP helps meet priority requirements but can increase wait for lower-priority tasks unless fairness mechanisms are present.

## Per-category behaviour (summary)

The CSV `results_summary.csv` contains per-run metrics; the scripts aggregated these internally to produce per-scheduler and per-category averages. Representative observations:

- CPU-bound (average across CPU-heavy tests): throughput ≈ 0.029 processes/ms; avg wait and turnaround are substantially larger than in I/O-bound tests (waits in the tens to low hundreds of ms depending on exact burst lengths).
- I/O-bound: throughput ≈ 0.04 processes/ms; avg wait is much lower (often < 25 ms) and average I/O durations observed match the inputs (verifying correct WAITING->READY timing logging).
- Mixed: intermediate values; EP+RR often achieves a better balance by avoiding extremes of starvation while still giving priority preference.

Concrete examples from the generated runs (refer to `results_summary.csv` for exact values):

- `executiongen_6_cpu_*` (CPU-heavy): average waits ~90–95 ms and throughputs ≈ 0.025 processes/ms across schedulers.
- `executiongen_8_io_*` (I/O-bound): throughputs ≈ 0.04–0.045 processes/ms and avg waits ≈ 19–24 ms.
- `executiongen_16_mixed_*` (mixed): EP+RR shows a trade-off where time-slicing slightly increases average wait in some runs but reduces tail latencies for long tasks.

## Interpretation and why the results match expectations

- Throughput: Strongly influenced by processing-time demand. CPU-bound jobs occupy the CPU for longer, reducing number of completions per unit time.
- Wait and Turnaround: Queueing discipline matters. RR reduces head-of-line blocking for short jobs, improving their response; EP can reduce response for high-priority jobs at the expense of others.
- I/O Durations: The measured average WAITING durations in the logs match the I/O durations configured in the test inputs. This confirms the simulator correctly records the WAITING → READY transitions and timing.

## Methodology notes and assumptions

- Input format: each line is `PID, size, arrival_time, processing_time, io_freq, io_duration`.
- Arrival times are taken from the NEW→READY transition if present; waiting time is computed by summing durations where a process is in the READY state (between READY→RUNNING and READY→something transitions as recorded in the logs).
- Response (arrival->first run) is computed using the timestamp of NEW→READY and the first READY→RUNNING transition.

## Limitations and suggested improvements

- Number of scenarios and variance: 20 scenarios per scheduler give good initial coverage but more scenarios and repetitions would reduce noise. I recommend running 50–100 random scenarios in a longer experiment to produce confidence intervals.
- Visualisation: adding bar charts and boxplots per metric (throughput, wait, turnaround) will make comparisons clearer — I can produce these using matplotlib and embed them into the report.
- Per-process logging: adding a CSV output summarising per-process metrics at the end of each simulation run would simplify parsing and reduce the possibility of miscalculating durations from transition logs.

## Practical recommendations

- Use RR or EP+RR for interactive workloads where per-request latency matters. These provide better initial response and fairness for short tasks.
- Use EP (priority) for systems that must favour certain classes (e.g., real-time); however, add aging or time-slicing to avoid starvation of lower-priority work.

## Artifacts produced

- `tests_generated/` — generated input files (20 scenarios)
- `executiongen_*_<cat>_<sched>.txt` — execution traces for each scheduler and scenario
- `results_summary.csv` — numeric metrics parsed from traces
- `report_final.md` — this final report

## Next steps (pick one and I will run it)

1) Produce plots (matplotlib) from `results_summary.csv` (histograms/boxplots per metric and scheduler) and attach PNGs to the report.
2) Increase the number of generated scenarios (e.g., 100) and re-run the full experiment to reduce variance and produce confidence intervals.

Which would you like me to do next? I can generate the plots now (option 1) or run more scenarios (option 2) and then update the report with charts and more robust statistics.

*** End of report
