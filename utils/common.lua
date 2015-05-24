local myApp = require( "myapp" )
local socket = require( "socket" )
-------------------------------------------------------
-- common functions used in any app
-------------------------------------------------------
local M = { }

function M.SceneBackground()
    
    local background = display.newRect(0,0,myApp.cW, myApp.cH)
    background:setFillColor(235/myApp.colorDivisor, 235/myApp.colorDivisor, 225/myApp.colorDivisor, 255/myApp.colorDivisor)
    background:setFillColor(myApp.sceneBackground.r,myApp.sceneBackground.g,myApp.sceneBackground.b,myApp.sceneBackground.a)
    background.x = myApp.cW / 2
    background.y = myApp.cH / 2
    return background
end

function M.SceneContainer()
    local container = display.newContainer(myApp.sceneWidth,myApp.sceneHeight)
    container:insert(M.SceneBackground())
    container.y = myApp.sceneHeight  /2 + myApp.sceneStartTop
    container.x = myApp.sceneWidth / 2  
    return container
end

function M.testNetworkConnection()
    local netConn = socket.connect('www.google.com', 80)
    if netConn == nil then
         return false
    end
    netConn:close()
    return true
end

function M.fitImage( displayObject, fitWidth, enlarge )
    --
    -- first determine which edge is out of bounds
    --
    local scaleFactor = fitWidth / displayObject.width 
    displayObject:scale( scaleFactor, scaleFactor )
end

function M.newTextField(options)
    local customOptions = options or {}
    local opt = {}

    --
    -- Core parameters
    --
    opt.left = customOptions.left or 0
    opt.top = customOptions.top or 0
    opt.x = customOptions.x or 0
    opt.y = customOptions.y or 0
    opt.width = customOptions.width or (display.contentWidth * 0.75)
    opt.height = customOptions.height or 20
    opt.id = customOptions.id
    opt.listener = customOptions.listener or nil
    opt.text = customOptions.text or nil
    opt.inputType = customOptions.inputType or "default"
    --Possible string values are:
--"default" — the default keyboard, supporting general text, numbers and punctuation.
--"--number" — a numeric keypad.
--"decimal" — a keypad for entering decimal values.
--"phone" — a keypad for entering phone numbers.
--"url" — a keyboard for entering website URLs.
--"email" — a keyboard for entering email addresses.
    opt.font = customOptions.font or native.systemFont
    opt.fontSize = customOptions.fontSize or opt.height * 0.67
    opt.placeholder = customOptions.placeholder or nil
    opt.isSecure = customOptions.isSecure  or false 

    -- Vector options
    opt.strokeWidth = customOptions.strokeWidth or 2
    opt.cornerRadius = customOptions.cornerRadius or opt.height * 0.33 or 10
    opt.strokeColor = customOptions.strokeColor or {0, 0, 0}
    opt.backgroundColor = customOptions.backgroundColor or {1, 1, 1}
 
    --
    -- Create the display portion of the widget and position it.
    --

    local field = display.newGroup()

    local background = display.newRoundedRect( 0, 0, opt.width, opt.height, opt.cornerRadius )
    background:setFillColor(unpack(opt.backgroundColor))
    background.strokeWidth = opt.strokeWidth
    background.stroke = opt.strokeColor
    field:insert(background)

    if opt.x then
        field.x = opt.x
    elseif opt.left then
        field.x = opt.left + opt.width * 0.5
    end
    if opt.y then
        field.y = opt.y
    elseif opt.top then
        field.y = opt.top + opt.height * 0.5
    end

    -- create the native.newTextField to handle the input

    field.textField = native.newTextField(0, 0, opt.width - opt.cornerRadius, opt.height - opt.strokeWidth * 2)
    field.textField.x = field.x
    field.textField.y = field.y
    field.textField.hasBackground = false
    field.textField.inputType = opt.inputType
    field.textField.text = opt.text
    field.textField.placeholder = opt.placeholder
    field.textField.isSecure = opt.isSecure

    if opt.listener and type(opt.listener) == "function" then
        field.textField:addEventListener("userInput", opt.listener)
    end

    --
    -- Handle setting the text parameters for the native field.
    --

   -- local deviceScale = (display.pixelWidth / display.contentWidth) * 0.5
    
   -- field.textField.font = native.newFont( opt.font )
    --field.textField.size = opt.fontSize * deviceScale
    field.textField:resizeFontToFitHeight()

    --
    -- Sync the position of the native object and the display object.
    -- A 60 fps app will make this smoother than a 30 fps app
    -- 
    -- You could add in things to handle other properties like alpha, .isVisible etc.
    -- that both objects support.
    --

    local function syncFields(event)
        field.textField.x = field.x
        field.textField.y = field.y
    end
    Runtime:addEventListener( "enterFrame", syncFields )

    --
    -- Handle cleaning up the native object when the display object is destroyed.
    --
    function field:finalize( event )
        event.target.textField:removeSelf()
    end

    field:addEventListener( "finalize" )

    return field
end 

return M