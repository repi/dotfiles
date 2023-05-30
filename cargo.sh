#!/bin/bash

export CARGO_INSTALL_OPTS=--locked
export INSTA_TEST_RUNNER=nextest
export CARGO_INCREMENTAL=1
export CARGO_PROFILE_RELEASE_DEBUG=0

alias cc="cargo clippy"
alias cbr="cargo build --release"
alias cnr="cargo nextest run"
alias cnra="INSTA_FORCE_PASS=1 INSTA_UPDATE=always cargo nextest run"
alias crr="cargo run --release"
alias citr="cargo insta test --review"
alias cita="cargo insta test --accept"
