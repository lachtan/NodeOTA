print("running ledhall.lua")

function connected(connection)
    print("connected callback")
    m:subscribe("home/#", 0)
end

function newMessage(client, topic, data)
    value = tonumber(data)
    if value ~= nil and value >= 0 and value < 1024 then
        pwm.setduty(ledPin, value)
    end
end

ledPin = 1
pwm.setup(ledPin, 1000, 50)
pwm.start(ledPin)

m = mqtt.Client("hall_led", 120, "", "")
m:on("connect", function() print("on connected") end )
m:on("message", newMessage)
m:connect("192.168.4.101", connected)
