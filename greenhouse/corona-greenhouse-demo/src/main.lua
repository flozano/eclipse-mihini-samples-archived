--require('debugger')('127.0.0.1', 10000, 'corona-sim');
display.setStatusBar( display.HiddenStatusBar )

local MQTT = require("mqtt.mqtt_library")

local SENSOR_LIFESPAN = 25000 -- in ms

system.activate( "multitouch" )

-----------------------------------------------
-- Initialize static UI elements
-----------------------------------------------
local bkg = display.newImage( "bg.jpg", true )
bkg.width = display.contentWidth
bkg.height = display.contentHeight
bkg.x = display.contentWidth/2
bkg.y = display.contentHeight/2

humidityGauge = display.newRect(display.contentWidth/2 - 200, display.contentHeight/2 - 42, 270, 260)
humidityGauge.yReference = display.contentHeight/2 - 42 - 340
humidityGauge.strokeWidth = 0
humidityGauge:setFillColor(20, 20, 240)
humidityGauge.alpha = 0.8

local flower = display.newImage( "flower.png", true )
flower.width = 411
flower.height = 625
flower.x = display.contentWidth/2 - 70
flower.y = display.contentHeight/2 + 195
--flower.alpha = 0.8

local lightBtnOff = display.newImage( "light_off.png", true )
lightBtnOff.width = 208
lightBtnOff.height = 208
lightBtnOff.x = 600
lightBtnOff.y = 350

local lightBtnOn = display.newImage( "light_on.png", true )
lightBtnOn.width = 208
lightBtnOn.height = 208
lightBtnOn.x = 600
lightBtnOn.y = 350
lightBtnOn.isVisible = false

local sensorsLabel = display.newText( "Greenhouse demo", 0, 0, native.systemFont, 36 )
sensorsLabel:setTextColor( 0, 0, 0 )
sensorsLabel.x = display.contentWidth/2 + 140
sensorsLabel.y = 140

local temperatureLabel= display.newText( "Temperature: 00.00 °C", 0, 0, native.systemFont, 36 )
temperatureLabel:setTextColor( 0, 0, 0 )
temperatureLabel.x = 292
temperatureLabel.y = 290

local luminosityLabel= display.newText( "Luminosity: 00.00 lx", 0, 0, native.systemFont, 36 )
luminosityLabel:setTextColor( 0, 0, 0 )
luminosityLabel.x = 280
luminosityLabel.y = 340

local sensorGroups = {}

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function updateHumidity (humidity)
	humidityGauge.yScale = tonumber(humidity) / 100. + 0.01
end

local function updateTemperature(temperature)
	temperatureLabel.text = 'Temperature: ' .. round(tonumber(temperature), 2) .. ' °C'
end

local function updateLuminosity(luminosity)
	luminosityLabel.text = 'Luminosity: ' .. round(tonumber(luminosity), 2) .. ' lx'
end

local function updateLightSwitch(lightState)
	if (lightBtnOn.isVisible and lightState == "0") then
		lightBtnOn.isVisible = false
		lightBtnOff.isVisible = true
		system.vibrate()
	elseif (lightBtnOff.isVisible and lightState == "1") then
		lightBtnOn.isVisible = true
		lightBtnOff.isVisible = false
		system.vibrate()
	end
end


local function split(path,sep)
	local t = {}
	for w in string.gfind(path, "[^"..sep.."]+")do
		table.insert(t, w)
	end
	return t
end

-- MQTT callback
function callback(topic,payload)
	local values = split(payload, '#')
	local topicSegments = split(topic, '/')

	if(topicSegments[#topicSegments] == 'humidity') then
		updateHumidity(payload)
	end
	
	if(topicSegments[#topicSegments] == 'light') then
		updateLightSwitch(payload)
	end
	
	if(topicSegments[#topicSegments] == 'temperature') then
		updateTemperature(payload)
	end
	
	if(topicSegments[#topicSegments] == 'luminosity') then
		updateLuminosity(payload)
	end
	
	
end

-- Register MQTT client
mqtt_client = MQTT.client.create("m2m.eclipse.org", 1883, callback)
mqtt_client:connect(system.getInfo( "deviceID" ))
mqtt_client.KEEP_ALIVE_TIME = 120
mqtt_client:subscribe({ "/eclipsecon/demo-mihini/data/#" })


local function onTouch( event )
	 if event.phase == "began" then
		 if (event.target == lightBtnOn) then
			mqtt_client:publish("/eclipsecon/demo-mihini/command/light", "0")
		else
			mqtt_client:publish("/eclipsecon/demo-mihini/command/light", "1")
		end
		system.vibrate()
	end
	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

lightBtnOff:addEventListener( "touch", onTouch )
lightBtnOn:addEventListener( "touch", onTouch )

timer.performWithDelay(500, function(event) mqtt_client:handler() end, 0)
