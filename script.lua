--480x272  240x136
os.autofps(60)
beige = color.new(255,218,185)
green = color.new(80, 220, 100)
chaoStats = {"name", "age", "mood", "belly", "swim", "fly", "run", "power", "stamina", "rings"}
itemStats = {"mood", "belly", "swim", "fly", "run", "power", "stamina", "all"}
shopOn = false
buttonTimer = 0
images = {["egg"] = image.load("images/egg.png"),
		  ["cursor"] = image.load("images/cursor.png"),
		  ["grab"] = image.load("images/cursorGrab.png"),
		  ["rub"] = image.load("images/cursorRub.png"),
		  ["title"] = image.load("images/title.png"),
		  ["swim"] = image.load("images/swim.png"),
		  ["fly"] = image.load("images/fly.png"),
		  ["run"] = image.load("images/run.png"),
		  ["power"] = image.load("images/power.png"),
		  ["stamina"] = image.load("images/stamina.png"),
		  ["all"] = image.load("images/all.png"),
		  ["background"] = image.load("images/background.png")
}
chao = {["img"] = images["egg"],
		["x"] = 100,
		["y"] = 50,
		["grabbed"] = false,
		["name"] = "Chao",
		["age"] = "Egg",
		["mood"] = 0,
		["belly"] = 0,
		["swim"] = 0,
		["fly"] = 0,
		["run"] = 0,
		["power"] = 0,
		["stamina"] = 0,
		["rings"] = 0
}
cursor = {["img"] = images["cursor"],
		  ["x"] = 0,
		  ["y"] = 0,
		  ["held"] = nil,
}
drawObjects = {cursor, chao}
function newItem(stat)
	local item = {["img"] = images[stat],
			["x"] = 100,
			["y"] = 50,
			["grabbed"] = false,
			["stat"] = stat
	}
	table.insert(drawObjects, item)
end
function gui()
	image.blit(images["background"],0,0)
	for i = 1, 10 do
		screen.print(420, (i * 25) - 5, chao[chaoStats[i]])
	end
	if shopOn == true then
		draw.fillrect(0,0,30,272,beige)
		for i = 3, 8 do
			image.blit(images[itemStats[i]], 10, ((i-2)*25)-5)
		end
	end
end
function cursorGrab()
	for i = 2, #drawObjects do
		if (math.abs(cursor["x"] - drawObjects[i]["x"]) < 11 and math.abs(cursor["y"] - drawObjects[i]["y"]) < 11) then
			cursor["img"] = images["grab"]
			cursor["held"] = drawObjects[i]
			drawObjects[i]["grabbed"] = true
		end
	end
end
function buttons()
	controls.read()
	if (controls.up() and cursor["y"] > 0) then
		cursor["y"] = cursor["y"] - 2
	elseif (controls.down() and cursor["y"] < 250) then
		cursor["y"] = cursor["y"] + 2
	end
	if (controls.left() and cursor["x"] > 0) then
		cursor["x"] = cursor["x"] - 2
	elseif (controls.right() and cursor["x"] < 464) then
		cursor["x"] = cursor["x"] + 2
	end
	if (controls.cross() and (os.clock() - buttonTimer) > 0.25) then
		buttonTimer = os.clock()
		if (cursor["held"] == nil and shopOn == false) then
			cursorGrab()
		elseif (cursor["held"] == nil and shopOn == true) then
			for i = 1, 6 do
				if (math.abs(cursor["x"] - 20) < 11 and math.abs(cursor["y"] - ((i*25)-5)) < 11 and #drawObjects < 15) then
					newItem(itemStats[i+2])
				end
			end
			if cursor["x"] > 31 then
				shopOn = false
			end
		elseif (cursor["held"] ~= nil and cursor["x"] > 29 and cursor["x"] < 398) then
			cursor["held"]["grabbed"] = false
			cursor["held"] = nil
			cursor["img"] = images["cursor"]
		end
	end
	if (controls.l() and (os.clock() - buttonTimer) > 0.25) then
		buttonTimer = os.clock()
		if shopOn == true then
			shopOn = false
		else
			shopOn = true
		end
	end
end
function game()
	image.blit(images["title"],0,0)
	screen.flip()
	controls.waitforkey()
	screen.clear()
	while true do
		screen.clear()
		gui()
		buttons()
		if cursor["held"] ~= nil then
			cursor["held"]["x"] = cursor["x"] + 2
			cursor["held"]["y"] = cursor["y"] + 13
		end
		for i = #drawObjects, 1, -1 do
			image.blit(drawObjects[i]["img"],drawObjects[i]["x"],drawObjects[i]["y"])
		end
		screen.flip()
	end
end
game()


