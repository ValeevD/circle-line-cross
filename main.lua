vector = require "lib/vector"

center_x = 400
center_y = 300

radius   = 200
small_radius = 90

player = {x = 0, y = 0, set = false}
new_position = {x = 0, y = 0, set = false}
position_small = {x = 0, y = 0}

function love.load()
end

function love.draw()
	love.graphics.circle("line", center_x, center_y, radius)
	love.graphics.circle("fill", center_x, center_y, 3)

	if player.set then
		love.graphics.circle("fill", player.x, player.y, 5)
		love.graphics.circle("line", player.x, player.y, small_radius)
	end

	if new_position.set then
		love.graphics.setColor(1,0,0)
		love.graphics.line(player.x, player.y, new_position.x, new_position.y)
		love.graphics.circle("fill", new_position.x, new_position.y, 5)
		love.graphics.setColor(1,1,1)

		love.graphics.setColor(1,1,0)
		love.graphics.line(player.x, player.y, position_small.x, position_small.y)
		love.graphics.circle("fill", position_small.x, position_small.y, 5)
		love.graphics.setColor(1,1,1)
	end
end

function love.update()
	if(love.mouse.isDown(1)) then
		local pos = vector(love.mouse.getPosition())

		pos = check_vector(vector(pos.x, pos.y), radius)

		player.x, player.y = pos.x, pos.y
		player.set = true

		new_position.set = false
	end

	if(love.mouse.isDown(2)) then
		if (not player.set) then
			return
		end

		local pos = vector(love.mouse.getPosition())

		pos = check_vector(vector(pos.x, pos.y), small_radius, vector(player.x, player.y))

		position_small.x, position_small.y = pos.x, pos.y

		new_position.set = true

		if (vector(position_small.x - center_x, position_small.y - center_y):len() < radius) then
			new_position.x, new_position.y = pos.x, pos.y
			return;
		end

		new_position.x, new_position.y = get_cross_point(vector(player.x, player.y), vector(pos.x, pos.y))
	end
end

function check_vector(vect, rad, center_vector)

	cent_vector = center_vector or vector(center_x, center_y)
	v = vect - cent_vector

	if(v:len() > rad) then
		v = v:normalized() * rad
	end

	return v + (center_vector or cent_vector)
end

function get_cross_point(v1, v2)
	local vect1 = v1 - vector(center_x, center_y)
	local vect2 = v2 - vector(center_x, center_y)

	local A, B = vect1.y - vect2.y, vect2.x - vect1.x
	local C = vect1.x*vect2.y - vect2.x*vect1.y

	local d = math.sqrt(radius * radius - (C * C / (A * A + B * B)))
	local mult = math.sqrt(d * d / (A * A + B * B))

	local x0, y0 = -A * C / (A * A + B * B), -B * C / (A * A + B * B)

	local x1, y1 = x0 + B * mult, y0 - A * mult
	local x2, y2 = x0 - B * mult, y0 + A * mult

	return x1 + center_x, y1 + center_y
end
