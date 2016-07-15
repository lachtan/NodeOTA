-- A simple http client

conn = net.createConnection(net.TCP, false) 
conn:on("receive", function(conn, pl) print(pl) end)
conn:connect(80, "192.168.3.28")
conn:send("GET /~lachtan/nodemcu/ HTTP/1.1\r\nHost: devlin\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
