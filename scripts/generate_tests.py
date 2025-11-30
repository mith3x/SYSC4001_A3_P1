#!/usr/bin/env python3
"""
Generate 20 test input files for the interrupts simulator.
Files are placed in ./tests_generated/ and named testgen_<idx>_<category>.txt
Category is one of: cpu, io, mixed
"""
import os
import random

OUTDIR = os.path.join(os.path.dirname(__file__), '..', 'tests_generated')
os.makedirs(OUTDIR, exist_ok=True)

random.seed(42)

def make_process(pid, arrival, proc_time, io_freq, io_dur):
    # Format matches existing test files: PID, size, arrival_time, processing_time, io_freq, io_duration
    size = random.randint(1, 10)
    return f"{pid}, {size}, {arrival}, {proc_time}, {io_freq}, {io_dur}"

def gen_io_bound(idx):
    lines = []
    num = random.randint(3,6)
    base_arrival = 0
    for i in range(num):
        pid = idx*100 + i + 1
        arrival = base_arrival + random.randint(0,5)
        proc_time = random.randint(8,30)
        # frequent IOs
        io_freq = random.randint(2,5)
        io_dur = random.randint(2,6)
        lines.append(make_process(pid, arrival, proc_time, io_freq, io_dur))
    return lines

def gen_cpu_bound(idx):
    lines = []
    num = random.randint(3,6)
    base_arrival = 0
    for i in range(num):
        pid = idx*100 + i + 1
        arrival = base_arrival + random.randint(0,5)
        proc_time = random.randint(15,60)
        # no IO
        io_freq = 0
        io_dur = 0
        lines.append(make_process(pid, arrival, proc_time, io_freq, io_dur))
    return lines

def gen_mixed(idx):
    lines = []
    num = random.randint(3,6)
    base_arrival = 0
    for i in range(num):
        pid = idx*100 + i + 1
        arrival = base_arrival + random.randint(0,5)
        proc_time = random.randint(6,40)
        io_freq = random.choice([0,3,6,10])
        io_dur = 0 if io_freq==0 else random.randint(1,4)
        lines.append(make_process(pid, arrival, proc_time, io_freq, io_dur))
    return lines

def main():
    total = 20
    categories = []
    # distribute categories: 7 cpu, 7 io, 6 mixed
    categories += ['cpu']*7
    categories += ['io']*7
    categories += ['mixed']*6

    for idx, cat in enumerate(categories, start=1):
        if cat == 'cpu':
            lines = gen_cpu_bound(idx)
        elif cat == 'io':
            lines = gen_io_bound(idx)
        else:
            lines = gen_mixed(idx)

        fname = os.path.join(OUTDIR, f"testgen_{idx}_{cat}.txt")
        with open(fname, 'w') as f:
            f.write('\n'.join(lines))
        print(f"Wrote {fname} ({len(lines)} procs)")

if __name__ == '__main__':
    main()
