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

