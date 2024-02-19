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
  forge create --rpc-url $RPC_URL \
   --constructor-args "Generative" "GEN" 'ipfs://' 'ipfs:\/\/' 2048  \
   --private-key $PRIVATE_KEY \
    src/Generative.sol:Generative