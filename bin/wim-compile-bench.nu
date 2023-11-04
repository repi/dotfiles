#!/usr/bin/env nu

cd wim-app
hyperfine --export-json /tmp/wim-app-bench.json --warmup 0 --runs=2 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' 'cargo build -r -p ark-client'
cd ..

cd wim-mod
hyperfine --export-json /tmp/wim-mod-bench.json --warmup 0 --runs=2 --setup 'cargo fetch' --prepare 'cargo clean' 'cargo check' 'cargo clippy' 'cargo build -r' './mbark build'

# combine the benchmark outputs to single table
let output_wim_mod = open /tmp/wim-mod-bench.json | get results | insert repo wim-mod
let output_wim_app = open /tmp/wim-app-bench.json | get results | insert repo wim-app
let combined = $output_wim_mod | merge $output_wim_app

$combined | save bench.json

$combined