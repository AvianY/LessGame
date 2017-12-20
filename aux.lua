m =  require "math"
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
function drawBlk( x, y, size, wallCode)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle( "line", x         , y         , size, size)
	love.graphics.line( x + size/2 , y         , x + size/2, y + size)
	love.graphics.line( x          , y + size/2, x + size  , y + size/2)

	-- local blkCode = blkRotate( wallCode, orientation)
	local blkOuter = wallCode:sub( 1, 8 )
	local blkInner = wallCode:sub( 9, 12 )

	drawOuter( x, y, size, blkOuter )
	drawInner( x, y, size, blkInner )

end

-- Generira matriko, ki vsebuje kode zidov, z upostevanjem orientacije
function genBlockCodes( width, height, permutation, orientation )
	local blkCodes = { {}, {}, {} }
	for x=0,width - 1 do
		for y=0,height - 1 do
			blkCodes[x+1][y+1] = blkRotate( permutation[y*width + x + 1],
										orientation[y*width + x + 1])
		end
	end
	return blkCodes
end

-- Narise vse bloke v pravilnih orientacijah
-- Shrani kode zidov za vse bloke
function drawBlks( width, height, size, permutation, orientation)
	blkCodes = genBlockCodes( width, height, permutation, orientation )
	for x=0,width-1 do
		for y=0,height-1 do
			drawBlk( x*size, y*size, size,
					blkCodes[x+1][y+1] )
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
function moveFig( fig, turn, x, y, wpos, bpos, width, height, size)
	-- Preveri, ce je kliknjeno na plosco
	if x < 0 or x > game.width*size or y > game.height*size then
		game.selectedFig = 0
		return
	end
	local oldPos = getOldPos( fig, turn)
	local newPos = getNewPos( x, y, size)
	-- Preveri, ce je izbrano polje po diagonali
	if m.abs( oldPos.x - newPos.x ) > 0 and m.abs( oldPos.y - newPos.y ) > 0  then
		game.selectedFig = 0
		return
	end
	-- Preveri, ce je izbrano polje ze zasedeno
	for ifig=1,4 do
		if (wpos[ifig].x == newPos.x and wpos[ifig].y == newPos.y) or
				(bpos[ifig].x == newPos.x and bpos[ifig].y == newPos.y) then
			game.selectedFig = 0
			return
		end
	end
	-- Preveri, ce je polje stran za vec kot dve mesti
	if m.abs( oldPos.x - newPos.x ) > 2 or
			m.abs( oldPos.y - newPos.y ) > 2 then
		game.selectedFig = 0
		return
	end
	-- Preveri, ce preskakujemo figuro ali ne
	if m.abs( oldPos.x - newPos.x ) == 2 or m.abs( oldPos.y - newPos.y ) == 2 then
		if not isFigure( (oldPos.x + newPos.x)/2, (oldPos.y + newPos.y)/2, size ) then
			game.selectedFig = 0
			return
		end
		-- Ce je zid na poti, prekini potezo
		if numWall( oldPos, newPos )>0 then
			game.selectedFig = 0
			return
		end
	end
	-- Premakni figuro
	if turn == "white" then
		if game.whiteMoves > numWall( oldPos, newPos ) then
			game.whiteMoves = game.whiteMoves - numWall( oldPos, newPos ) - 1
			game.whitepos[fig].x = newPos.x
			game.whitepos[fig].y = newPos.y
			if game.whiteMoves == 0 then
				game.turn = "black"
				game.blackMoves = 3
			end
		else
			game.selectedFig = 0
			return
		end
	else
		if game.blackMoves > numWall( oldPos, newPos ) then
			game.blackMoves = game.blackMoves - numWall( oldPos, newPos ) - 1
			game.blackpos[fig].x = newPos.x
			game.blackpos[fig].y = newPos.y
			if game.blackMoves == 0 then
				game.turn = "white"
				game.whiteMoves = 3
			end
		else
			game.selectedFig = 0
			return
		end
	end
end

-- Pridobi pozicijo (koordinate) figure na plosci glede na x,y
function getNewPos( x, y, size)
	return { x=m.floor(x/(size/2)), y=m.floor(y/(size/2)) }
end

-- Pridobi pozicijo (koordinate) figure na plosci glede na stevilko
-- figure
function getOldPos( fig, turn )
	if turn == "white" then
		return { x=game.whitepos[fig].x, y=game.whitepos[fig].y }
	else
		return { x=game.blackpos[fig].x, y=game.blackpos[fig].y }
	end
end

-- Preveri ali obstaja figura na nekem specificnem mestu
function isFigure( xpos, ypos, size)
	for fig=1,4 do
		if game.whitepos[fig].x == xpos and game.whitepos[fig].y == ypos then
			return true
		end
		if game.blackpos[fig].x == xpos and game.blackpos[fig].y == ypos then
			return true
		end
	end
	return false
end

-- Pridobi stevilo zidov na poti od zacetka do konca
function numWall( oldpos, newpos )
	local N = m.max( m.abs(newpos.x - oldpos.x), m.abs(newpos.y - oldpos.y) )
	-- Pridobimo korak (en od njiju je itak enak 0), delimo z N, ker hočemo dobit enko
	local xdiff = (newpos.x - oldpos.x)/N
	local ydiff = (newpos.y - oldpos.y)/N
	local sumwall = 0
	local oldIncPos = { x = oldpos.x, y = oldpos.y}
	local newIncPos = { x = oldpos.x + xdiff, y = oldpos.y + ydiff }
	for step=1,N do
		sumwall = sumwall + numWallSingle( oldIncPos, newIncPos )
		oldIncPos = { x=newIncPos.x, y=newIncPos.y }
		newIncPos = { x=oldIncPos.x + step*xdiff, y=oldIncPos.y + step*ydiff }
	end
	return sumwall
end

-- Pridobi stevilo zidov na enem koraku
function numWallSingle( op, np )
	-- t_op = Truncated _ old/new position
	-- old/new blk = blk-Coordinates of a block
	-- dir = direction of moving (pozitive or negative
	local oldblk = { x = m.floor(op.x/2), y = m.floor(op.y/2) }
	local newblk = { x = m.floor(np.x/2), y = m.floor(np.y/2) }
	local t_op = { x = op.x % 2, y = op.y % 2 }
	local t_np = { x = np.x % 2, y = np.y % 2 }
	local dir = ( np.x - op.x ) + ( np.y - op.y )
	if (oldblk.x == newblk.x) and (oldblk.y == newblk.y) then
		if t_op.x == 0 and t_np.x == 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(9,9)
		elseif t_op.y == 1 and t_np.y == 1 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(10,10)
		elseif t_op.x == 1 and t_np.x == 1 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(11,11)
		elseif t_op.y == 0 and t_np.y == 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(12,12)
		else
			print("Pravilno slutis!!!")
		end
	else
		if t_op.x == 0 and t_np.x == 0 and dir > 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(3,3) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(8,8)
		end
		if t_op.x == 0 and t_np.x == 0 and dir < 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(8,8) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(3,3)
		end
		if t_op.y == 1 and t_np.y == 1 and dir > 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(5,5) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(2,2)
		end
		if t_op.y == 1 and t_np.y == 1 and dir < 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(2,2) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(5,5)
		end
		if t_op.x == 1 and t_np.x == 1 and dir > 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(4,4) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(7,7)
		end
		if t_op.x == 1 and t_np.x == 1 and dir < 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(7,7) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(4,4)
		end
		if t_op.y == 0 and t_np.y == 0 and dir > 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(6,6) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(1,1)
		end
		if t_op.y == 0 and t_np.y == 0 and dir < 0 then
			return blkCodes[oldblk.x+1][oldblk.y+1]:sub(1,1) +
					blkCodes[newblk.x+1][newblk.y+1]:sub(6,6)
		end
		print( "Something is terribly wrong")
		return -1
	end
end
