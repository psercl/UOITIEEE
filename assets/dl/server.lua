----------------------------------
-- WiFi Connection Verification --
----------------------------------
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      tmr.stop(0)
   end
end)

----------------------
-- Global Variables --
----------------------
led_pin = 4
web_data = [[<!DOCTYPE html>
<html>
<head>
    <title>IEEE Student Branch at UOIT</title>
    <style type="text/css">
    body {
        background-color: #196893;
    }

    center {
        color: #fff;
        font-family: sans-serif;
        font-size: 20pt;
    }

    .controls {
        width: 70%;
        background-color: #fff;
        color: #196893;
        font-size: 50pt;
    }

    input[type=range] {
        -webkit-appearance: none;
        margin: 0 0;
        width: 100%;
    }

    input[type=range]::-webkit-slider-runnable-track {
        height: 20px;
        cursor: pointer;
        background: #196893;
    }

    input[type=range]::-webkit-slider-thumb {
        border: 1px solid #000;
        height: 50px;
        width: 30px;
        background: #fff;
        cursor: pointer;
        -webkit-appearance: none;
        margin-top: -18px;
    }

    .button {
        width: 200px;
        height: 80px;
        background-color: #196893;
        color: #fff;
        margin: 20px 20px;
        cursor: pointer;
    }

    .stop {
      background-color: #F04903;
      font-size: 20pt;
      line-height: 75px;
    }

    .button:hover {
        border-radius: 10px;
    }

    .larger {
        font-size: 30pt;
    }

    </style>
</head>
<body>
    <center>
        <h1>IEEE Student Branch IoT Workshop</h1>
        <form class="controls"><span class="larger" id="hz">Drag the slider</span>
            <input min="1" max="50" value="5" id="ds" type="range" />
            <div class="button" id="set">SET</div>
            <div class="button stop" id="stop">Stop Server</div>
            <hr/>
        </form>
    </center>
    <script type="text/javascript">
    $ = document.querySelector.bind(document);
    $("#ds").oninput = function() {
        $("#hz").innerHTML = $("#ds").value + " Hz";
    };

    $("#set").onclick = function() {
        var req = new XMLHttpRequest();
        req.open("POST", "/changeled", true);
        req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        var params = "pwm=" + $("#ds").value;
        req.send(params);
        req.onload = function() {
            console.log(req.responseText);
        };
    }

    $("#stop").onclick = function() {
      window.location.href = "/stophttpserver";
    }
    </script>
</body>
</html>]]

----------------
-- GPIO Setup --
----------------
print("Setting Up GPIO...")
-- Inable PWM output
pwm.setup(led_pin, 5, 512) -- 5Hz, 50% duty default
pwm.start(led_pin)

----------------
-- Web Server --
----------------
print("Starting Web Server...")
-- Create a server object with 30 second timeout
srv = net.createServer(net.TCP, 30)

-- server listen on 80, 
-- if data received, print data to console,
-- then serve up a sweet little website
srv:listen(80,function(conn)
	conn:on("receive", function(conn, payload)
    print(payload) -- Print data from browser to serial terminal
	
		function esp_update()
      frequency = tonumber(string.sub(payload,frequency[2]+1,#payload))
      pwm.setclock(led_pin, frequency)
      pwm.setduty(led_pin, 512) -- 50% duty cycle
    end

    --parse position POST value from header
    changeled = {string.find(payload, "/changeled")}
    stopserver = {string.find(payload, "/stophttpserver")}
    frequency = {string.find(payload, "pwm=")}
    --If POST value exist, set LED power
    if frequency[2] ~= nil then
      esp_update()
      print("Got post data")
      conn:send("OK!")
    elseif stopserver[2] ~= nil then
      pwm.setduty(led_pin, 1023)
      pwm.close(led_pin)
      conn:send('HTTP/1.1 200 OK\n\n')
      conn:send("Server shutting down...")
      tmr.alarm(1, 300, tmr.ALARM_SINGLE, function() 
        srv:close()
        print("Server shut down.")
      end)
    elseif changeled[2] == nil and stopserver[2] == nil then
      print("No post data found -- sending full document")
      conn:send('HTTP/1.1 200 OK\n\n')
      conn:send(web_data)
    end
  conn:on("sent", function(conn) conn:close() end)
	end)
end)