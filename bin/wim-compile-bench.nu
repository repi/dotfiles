#!/usr/bin/env nu

let start_time = (date now)

cd wim-app
hyperfine --export-json ../tmp-wim-app-bench.json --warmup 0 --runs=1 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' 'cargo build -r -p ark-client' `cargo build -r -p ark-cli`
cd ..

cd wim-mod
hyperfine --export-json ../tmp-wim-mod-bench.json --warmup 0 --runs=1 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' './mbark build'
cd ..

# combine the benchmark outputs to single table
let output_wim_mod = open tmp-wim-mod-bench.json | get results | insert repo wim-mod
let output_wim_app = open tmp-wim-app-bench.json | get results | insert repo wim-app
let combined = $output_wim_mod | append $output_wim_app | move repo --before command

# add machine info for this run
let info = {
    time: ($start_time | debug)
    duration: ((date now) - $start_time | debug)
    os_name: (sys).host.long_os_version
    cpu: (sys).cpu.0.brand
    cpu_cores: (sys | get cpu | length)
    memory: (sys).mem.total
    machine_name: (sys).host.hostname
    user: (do { $env.USER } catch { $env.USERNAME }), # unix & windows handling, can switch to `whoami` once 0.86.1 is out (started thread https://github.com/nushell/nushell/discussions/10979)
    rust: (rustc --version)
}

let entry = $info | insert "results" $combined

# save
$entry | save wim-compile-bench.json --force

# output
$entry