local module = {}

pinStb = 7
pinClk = 6
pinDio = 5

font = { }

local function setupFont()
    font[" "] = '0x00'
    font['0'] = '0x3F'
    font['1'] = '0x06'
    font['2'] = '0x5B'
    font['3'] = '0x4F'
    font['4'] = '0x66'
    font['5'] = '0x6D'
    font['6'] = '0x7D'
    font['7'] = '0x07'
    font['8'] = '0x7F'
    font['9'] = '0x6F'
    font['A'] = '0x77'
    font['B'] = '0x7C'
    font['C'] = '0x39'
    font['D'] = '0x5E'
    font['E'] = '0x79'
    font['F'] = '0x71'
    font["H"] = '0x76'
    font["'"] = '0x63'
    font["-"] = '0x20'
end

local function send(byte)
    mask = 0x1
    for i=0,7 do
        gpio.write(pinClk, gpio.LOW)
        if bit.band(byte, mask) > 0 then
            gpio.write(pinDio, gpio.HIGH)
        else
            gpio.write(pinDio, gpio.LOW)
        end
        mask = bit.lshift(mask, 1)
        gpio.write(pinClk, gpio.HIGH)
    end
end

local function sendCommand(cmd)
    gpio.write(pinStb, gpio.LOW)
    send(cmd)
    gpio.write(pinStb, gpio.HIGH)
end

local function sendData(address, data)
    sendCommand(0x44)
    gpio.write(pinStb, gpio.LOW)
    send(bit.bor(0xC0, address))
    send(data)
    gpio.write(pinStb, gpio.HIGH)
end

function module.sendChar(address, char, dot)
    data = font[char];
    if data then
        if dot then
            data = bit.bor(data, 0x80)        
        end    
    else 
        data = 0;
    end
    
    address = bit.lshift(address, 1)
    sendData(address, data)
end

function module.setup()
    setupFont()

    gpio.mode(pinStb, gpio.OUTPUT)
    gpio.mode(pinClk, gpio.OUTPUT)
    gpio.mode(pinDio, gpio.OUTPUT)

    gpio.write(pinClk, gpio.HIGH)
    gpio.write(pinStb, gpio.HIGH)

    sendCommand(0x40)
    sendCommand(bit.bor(0x80, 8, 8))

    gpio.write(pinStb, gpio.LOW)
    send(0xC0)
    for i=0,15 do
        send(0x00)
    end
    gpio.write(pinStb, gpio.HIGH)
end
