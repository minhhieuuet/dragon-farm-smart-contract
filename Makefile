migrate:
	truffle migrate
migrate-reset:
	truffle migrate --reset
local-test:
	truffle migrate --reset
	truffle test
remix-ide:
	sudo docker run -p 8089:80 remixproject/remix-ide:latest

	sudo remixd -s /home/hieu/Blockchain/dragonfarm/src  --remix-ide http://localhost:8089