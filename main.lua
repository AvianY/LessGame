-- Narejeno na verziji Löve 0.10.2

-- Koda za zapis zidu ima 8 števil za zunanje ter 4 za notranje povezave.
blk = { FS ="110000000000", --Full Side
		HS ="010000000000", --Half Side
		ZZ ="100000001100", --ZigZag
		TB ="110000001000", --T-block
		TLL="100000001000", --TopLeft L
		TRL="000000000011", --TopRight L
		BRL="000100000100"  --BottomRight L
	}
	
game = {}

function drawFig( pos, size, color)
	love.graphics.setColor( color.r, color.g, color.b)
	love.graphics.circle( "fill", pos.x*(size/2)+size/4, pos.y*(size/2)+size/4, size/8)
end

function charShift( string, n )
	return string:sub( n+1 )..string:sub( 1, n )
end

-- Moram priznat, da nikoli vec v zivljenju ne bom
-- naredu tako elegantne funkcije za specificen problem,
-- kot je tale :D ... funkcija rotira blok
function blkRotate( wallCode, orientation )
	local outer = charShift( wallCode:sub( 1, 8 ), 2*orientation)
	local inner = charShift( wallCode:sub( 9, 12 ), orientation)
	return outer..inner
end

function drawOuter( x, y, size, blkOuter)
	love.graphics.setColor(0,0,255)
	local iter = 0
	for c in blkOuter:gmatch"." do
		if c == "1" then
			if iter < 2 then
				love.graphics.rectangle( "fill", x, y + (iter%2)*size/2, size/16, size/2);
			elseif iter < 4 then
				love.graphics.rectangle( "fill", x + (iter%2)*size/2, y + 15*size/16, size/2, size/16);
			elseif iter < 6 then
				love.graphics.rectangle( "fill", x + 15*size/16, y + size - (iter%2 + 1)*size/2, size/16, size/2);
			elseif iter < 8 then
				love.graphics.rectangle( "fill", x + size - (iter%2 + 1)*size/2, y, size/2, size/16);
			end
		end
		iter = iter + 1
	end
end

function drawInner( x, y, size, blkInner)
	love.graphics.setColor(0,0,255)
	local iter = 0
	for c in blkInner:gmatch"." do
		if c == "1" then
			if iter == 0 then
				love.graphics.rectangle( "fill", x, y + size/2 - size/32, size/2 + size/32, size/16);
			elseif iter == 1 then
				love.graphics.rectangle( "fill", x + size/2 - size/32, y + size/2 - size/32, size/16, size/2 + size/32);
			elseif iter == 2 then
				love.graphics.rectangle( "fill", x + size/2 - size/32, y + size/2 - size/32, size/2 + size/32, size/16);
			elseif iter == 3 then
				love.graphics.rectangle( "fill", x + size/2 - size/32, y, size/16, size/2 + size/32);
			end
		end
		iter = iter + 1
	end
end

function drawBlk( x, y, size, wallCode, orientation)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle( "line", x         , y         , size, size)
	love.graphics.line( x + size/2 , y         , x + size/2, y + size)
	love.graphics.line( x          , y + size/2, x + size  , y + size/2)

	local blkCode = blkRotate( wallCode, orientation)
	local blkOuter = blkCode:sub( 1, 8 )
	local blkInner = blkCode:sub( 9, 12 )

	drawOuter( x, y, size, blkOuter )
	drawInner( x, y, size, blkInner )

end

function love.load()
	game.whitepos = { { x = 0, y = 0   },   { x = 0, y = 1 },   { x = 1, y = 0 },   { x = 1, y = 1 } }
	game.blackpos = { { x = 5, y = 5 },   { x = 5, y = 4 }, { x = 4, y = 5 }, { x = 4, y = 4 } }
	game.size = 200
	game.whiteColor = { r = 245, g = 222, b = 179 }
	game.blackColor = { r = 139, g = 69, b = 19 }
end

function love.update( dt )
end

function love.draw()
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
