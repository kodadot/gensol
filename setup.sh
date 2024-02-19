#!/usr/bin/env bash

if ! which forge &> /dev/null
then
  echo "forge command not found. Installing Foundry..."
  curl -L https://foundry.paradigm.xyz | bash
  forge install OpenZeppelin/openzeppelin-contracts@v5.0.1 --no-commit
fi

echo "Done"
