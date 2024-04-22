set dotenv-load

build: 
  forge build

test:
  forge test -vv

format:
  forge fmt

repl:
 chisel

deploy:
  @echo "DEPLOYING CONTRACT TO $RPC_URL, press CTRL+C to distrupt (10sec left)…"
  sleep 10
  forge script script/BaseGen.s.sol:MyScript --rpc-url $RPC_URL --broadcast --verify -vvvv

create:
  forge create --rpc-url $RPC_URL \
    --constructor-args "Generative" "GEN" 'ipfs://' 'ipfs:\/\/' 2048  \
    --private-key $PRIVATE_KEY \
      src/Generative.sol:Generative

abi:
  @forge build --silent
  @jq '.abi' ./out/Generative.sol/Generative.json > generative.json