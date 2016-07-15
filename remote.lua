-- umoznuje pripojit se telnetem a ovladat cely NodeMCU

local currentConnection = nil

local function onReceive(connection, text)
	node.input(text)
end	

local function onDisconnection(onnection)
	currentConnection = nil
	node.output(nil)
end

function netOutput(text)
	if currentConnection ~= nil then
		-- mozna nahradit konce radku drsnejsim <cr><lf>
		currentConnection:send(text)
	end
end

local function onConnection(connection)
	currentConnection = connection
	node.output(netOutput, 1)
	connection:on("receive", onReceive)
	connection:on("disconnection", onDisconnection)
end

server = net.createServer(net.TCP)
server:listen(2323, onConnection)
