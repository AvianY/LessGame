-- Narejeno na verziji Löve 0.10.2
--

require "init"

function love.load()
	game.whitepos = { { x = 0, y = 0   },   { x = 0, y = 1 },   { x = 1, y = 0 },   { x = 1, y = 1 } }
	game.blackpos = { { x = 5, y = 5 },   { x = 5, y = 4 }, { x = 4, y = 5 }, { x = 4, y = 4 } }
	game.size = 200
	game.whiteColor = { r = 245, g = 222, b = 179 }
	game.blackColor = { r = 139, g = 69, b = 19 }
	xmidPressed = 0
	ymidPressed = 0
	xmouse = 0
	ymouse = 0
end

function love.update( dt )
	if love.mouse.isDown( 3 ) then
		xmouse, ymouse = love.mouse.getPosition()
	end
end

function love.draw()
	love.graphics.translate( xmouse - xmidPressed, ymouse - ymidPressed)

	drawBlk( 0, 0, game.size, blk.TB, 3)
	drawBlk( game.size, 0, game.size, blk.ZZ, 3)
	drawBlk( 0, game.size, game.size, blk.ZZ, 2)
	drawBlk( game.size, game.size, game.size, blk.TB, 0)
	drawBlk( 2*game.size, 0, game.size, blk.TB, 0)
	drawBlk( 2*game.size, game.size, game.size, blk.TB, 0)
	drawBlk( 2*game.size, 2*game.size, game.size, blk.TB, 0)
	drawBlk( 0, 2*game.size, game.size, blk.TB, 0)
	drawBlk( game.size, 2*game.size, game.size, blk.TB, 0)

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
	if button == 3 then
		xmidPressed,ymidPressed = love.mouse.getPosition()
	end
end
