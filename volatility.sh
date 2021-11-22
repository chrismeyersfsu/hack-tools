#!/bin/zsh
function volatility() {
  docker run --rm --user=$(id -u):$(id -g) -v "$(pwd)":/dumps:ro,Z -ti phocean/volatility $@
}
