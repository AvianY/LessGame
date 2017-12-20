-- Narejeno na verziji Löve 0.10.2
--

require "init"
require "aux"
m = require "math"

function love.load()
	m.randomseed( os.time())
	game.whitepos = { { x = 0, y = 0 },   { x = 0, y = 1 }, { x = 1, y = 0 }, { x = 1, y = 1 } }
	game.blackpos = { { x = 5, y = 5 },   { x = 5, y = 4 }, { x = 4, y = 5 }, { x = 4, y = 4 } }
	game.size = 200
	game.width = 3
	game.height = 3
	game.whiteColor = { r = 245, g = 222, b = 179 }
	game.blackColor = { r = 139, g = 69, b = 19 }
	game.whiteMoves = 3
	game.blackMoves = 0
	game.selectedColor = { r = 0, g = 255, b = 0 }
	game.selectedFig = 0 -- Ce je vec od nic, pove katera figura je izbrana, sicer pa da ni nobena
	game.permutation = genPermutations( game.width, game.height, blk)
	game.orientation = genOrientations( game.width, game.height)
	game.turn = "white"
	xpos = 0
	ypos = 0
end

function love.update( dt )
	-- if love.mouse.isDown( 3 ) then
	-- 	xpos, ypos = love.mouse.getPosition()
	-- end
end

function love.draw()
	-- love.graphics.translate( xpos, ypos)

	drawBlks( game.width, game.height, game.size, game.permutation, game.orientation)

	-- drawBlks( 3, 3, game.size,
	-- 		{ blk.TB, blk.HS, blk.FS, blk.TLL, blk.BRL, blk.ZZ, blk.TRL, blk.TLL, blk.HS},
	-- 		{ 2,3,1,0,2,3,1,1,2 })

	drawFigs( game.whitepos, game.blackpos, game.selectedFig, game.turn, game.size )
	
	love.graphics.setColor( 255, 0, 0 )
	if game.turn == "white" then
		love.graphics.print( "White to move", game.size*game.width, 0 )
	else
		love.graphics.print( "Black to move", game.size*game.width, 0 )
	end
	love.graphics.print( game.whiteMoves+game.blackMoves, game.size*game.width, 10 )

end

function love.keypressed( key, scancode, isrepeat )
	if scancode == 'q' then
		love.event.quit()
	end
end

function love.mousepressed( x, y, button, istouch)
	if button == 1 then
		-- V kombinaciji s for zanko, ki ga lahko iznici
		local clickOnFig = 0
		for fig=1,4 do
			local pos = getXYFig( game.turn, fig, game.size)
			if diff( x, y, pos[1], pos[2] ) < game.size/8 then
				game.selectedFig = fig
				clickOnFig = 1
			end
		end
		if clickOnFig == 0 and game.selectedFig > 0 then
			moveFig( game.selectedFig, game.turn, x, y, game.whitepos, game.blackpos, game.width, game.height, game.size)
		end
	end
	if button == 2 then
		print("to je 2")
	end
end
