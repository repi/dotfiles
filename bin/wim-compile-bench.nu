#!/usr/bin/env nu

cd wim-app
hyperfine --export-json /tmp/wim-app-bench.json --warmup 0 --runs=1 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' 'cargo build -r -p ark-client' `cargo build -r -p ark-cli`
cd ..

cd wim-mod
hyperfine --export-json /tmp/wim-mod-bench.json --warmup 0 --runs=1 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' './mbark build'

# combine the benchmark outputs to single table
let output_wim_mod = open /tmp/wim-mod-bench.json | get results | insert repo wim-mod
let output_wim_app = open /tmp/wim-app-bench.json | get results | insert repo wim-app
let combined = $output_wim_mod | append $output_wim_app | move repo --before command

$combined | save bench.json --force

$combined