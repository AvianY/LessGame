-- Narejeno na verziji Löve 0.10.2

-- Koda za zapis zidu
blk = { FS ="110000000000", --Full Side
		HS ="010000000000", --Hald Side
		ZZ ="100000001100", --ZigZag
		TB ="110000001000", --T-block
		TLL="100000001000", --TopLeft L
		TRL="000000000011", --TopRight L
		BRL="000100000100"  --BottomRight L
	}

function drawBlk( x, y, size, orientation, wallCode)
	love.graphics.rectangle( "line", x, y, size/2, size/2)
	love.graphics.rectangle( "line", x + size/2, y, size/2, size/2)
	love.graphics.rectangle( "line", x, y + size/2, size/2, size/2)
	love.graphics.rectangle( "line", x + size/2, y + size/2, size/2, size/2)
end

function love.load()
end

function love.update( dt )
end

function love.draw()
	drawBlk( 0, 0, 100, 0, blk.FS)
end

function love.keypressed( key, scancode, isrepeat )
	if scancode == 'q' then
		love.event.quit()
	end
end
