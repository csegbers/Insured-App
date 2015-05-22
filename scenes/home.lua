---------------------------------------------------------------------------------------
-- HOME scene
---------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myApp = require( "myapp" )
local common = require( "common" )

local login = require( myApp.classfld .. "classlogin" )

local currScene = (composer.getSceneName( "current" ) or "unknown")
print ("Inxxxxxxxxxxxxxxxxxxxxxxxxxxxxx " .. currScene .. " Scene")

------------------------------------------------------
-- Called first time. May not be called again if we dont recyle
--
-- self.view -> Container -> SCrollvew
------------------------------------------------------
function scene:create(event)
    print ("Create  " .. currScene)
	local group = self.view
    local container = common.SceneContainer()
    group:insert(container)

    local function scrollListener( event )

            local phase = event.phase
            if ( phase == "began" ) then print( "Scroll view was touched" )
            elseif ( phase == "moved" ) then print( "Scroll view was moved" )
            elseif ( phase == "ended" ) then print( "Scroll view was released" )
            end

            -- In the event a scroll limit is reached...
            if ( event.limitReached ) then
                if ( event.direction == "up" ) then print( "Reached top limit" )
                elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
                elseif ( event.direction == "left" ) then print( "Reached left limit" )
                elseif ( event.direction == "right" ) then print( "Reached right limit" )
                end
            end

            return true
    end

    local scrollView = widget.newScrollView
        {
            x = 0,
            y = 0,
            width = myApp.sceneWidth, 
            height =  myApp.sceneHeight,
            listener = scrollListener,
            horizontalScrollDisabled = true,
        }
    container:insert(scrollView)
 
    -- local aline = display.newLine( 0, 0,myApp.sceneWidth, 0)
    --  aline:setStrokeColor( 1, 0, 0, 1 )
    --  aline.strokeWidth = 1
    --  scrollView:insert(aline)


    -- local aline2 = display.newLine( 0, myApp.sceneHeight ,myApp.sceneWidth, myApp.sceneHeight)
    --  aline2:setStrokeColor( 7, 0, 9, 10 )
    --  aline2.strokeWidth = 2
    --  scrollView:insert(aline2)



     -- local container2 = display.newContainer( 100, 100)
     -- local bkgd = display.newImage( "salogo.jpg" )
     -- container2:insert( bkgd, true )
     -- scrollView:insert(container2)
     -- container2:translate( scrollView.width*0.5, scrollView.height*.5 )
     -- transition.to( container2, { rotation=360, transition=easing.inOutExpo} )

--container:insert(scrollView)
-- Create the widget


     local primGroup = display.newGroup(  )
     local aline = display.newLine( 0, 0,myApp.sceneWidth, 0)
     aline:setStrokeColor( 1, 0, 0, 1 )
     aline.strokeWidth = 1
     primGroup:insert(aline)

     scrollView:insert(primGroup)

     

     if myApp.login.loggedin == false then
        scrollView:translate(0,50)
     self.login = login.new({ 
                                 id=1,
                            })
  
     scrollView:insert(self.login:UI())
     end




end

function scene:show( event )

    local group = self.view
    local phase = event.phase
    print ("Show:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
	

end

function scene:hide( event )
    local group = self.view
    local phase = event.phase
    print ("Hide:" .. phase.. " " .. currScene)

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end

end

function scene:destroy( event )
	local group = self.view
    print ("Destroy "   .. currScene)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene