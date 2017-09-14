-- Zamakne niz stevil, na tak nacin, da
-- jih vrti v krogu (ciklicno)
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

-- Narise zid okoli bloka
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

-- Narise zid v notranjosti bloka
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

-- Narise en blok
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

-- Narise vse bloke v pravilnih orientacijah
function drawBlks( width, height, size, permutation, orientation)
	for x=0,width-1 do
		for y=0,height-1 do
			drawBlk( x*size, y*size, size,
					permutation[y*width + x + 1],
					orientation[y*width + x + 1] )
		end
	end
end

-- Generira nize kod, ki dolocajo bloke
function genPermutations( width, height, blk)
	local permutation = {}
	for i=1,width*height do
		table.insert( permutation, blk[m.random( 1, #blk)])
	end
	return permutation
end

-- Generira niz stevil, ki dolocajo orientacijo vseh
-- blokov, podano v eni dimenziji
function genOrientations( width, height)
	local orientation = {}
	for i=1,width*height do
		table.insert( orientation, m.random( 0, 3))
	end
	return orientation
end

-- Preveri evklidsko razdaljo med dvema tockama
function diff( x1, y1, x2, y2)
	return m.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

-- Pridobi x in y pozicijo figurice
function getXYFig( color, number, size)
	if color == "white" then
		return { size/4 + game.whitepos[number].x*size/2, size/4 + game.whitepos[number].y*size/2 }
	else
		return { size/4 + game.blackpos[number].x*size/2, size/4 + game.blackpos[number].y*size/2 }
	end
end

-- Narise eno figuro
function drawFig( pos, size, color)
	love.graphics.setColor( color.r, color.g, color.b)
	love.graphics.circle( "fill", pos.x*(size/2)+size/4, pos.y*(size/2)+size/4, size/8)
end

-- Narisi vse figure na polje
function drawFigs( whitepos, blackpos, selectedFig, turn, size )
	for fig=1,4 do
		drawFig( whitepos[fig], size, game.whiteColor )
		drawFig( blackpos[fig], size, game.blackColor )
	end
	if selectedFig > 0 then
		if turn == "white" then
			drawFig( whitepos[selectedFig], size, game.selectedColor )
		else
			drawFig( blackpos[selectedFig], size, game.selectedColor )
		end
	end
end

-- Premakni figuro
function moveFig( fig, x, y, size )
	if x < 0 or x > game.width*size or y > game.height*size then
		return
	end
	game.selectedFig = 0
end
