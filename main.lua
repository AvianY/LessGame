-- Narejeno na verziji Löve 0.10.2
--

require "init"
require "aux"
m = require "math"

function love.load()
	m.randomseed( os.time())
	game.whitepos = { { x = 0, y = 0   },   { x = 0, y = 1 },   { x = 1, y = 0 },   { x = 1, y = 1 } }
	game.blackpos = { { x = 5, y = 5 },   { x = 5, y = 4 }, { x = 4, y = 5 }, { x = 4, y = 4 } }
	game.size = 200
	game.width = 3
	game.height = 3
	game.whiteColor = { r = 245, g = 222, b = 179 }
	game.blackColor = { r = 139, g = 69, b = 19 }
	game.permutation = genPermutations( game.width, game.height, blk)
	game.orientation = genOrientations( game.width, game.height)
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

	for _,fig in ipairs(game.whitepos) do
		drawFig( fig, game.size, game.whiteColor )
	end
	for _,fig in ipairs(game.blackpos) do
		drawFig( fig, game.size, game.blackColor )
	end
end

function love.keypressed( key, scancode, isrepeat )
	if scancode == 'q' then
		love.event.quit()
	end
end

function love.mousepressed( x, y, button, istouch)
	if button == 1 then
		print("to je 1")
	end
	if button == 2 then
		print("to je 2")
	end
end
