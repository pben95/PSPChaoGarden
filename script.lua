--480x272  240x136
--os.autofps(60)
chaoStats = {"name", "age", "mood", "belly", "swim", "fly", "run", "power", "stamina", "rings"}
items = {"swim", "fly", "run", "power", "stamina", "all", "none", "trumpet"}
itemCosts = {["swim"] = 30, ["fly"] = 30, ["run"] = 30, ["power"]= 30, ["stamina"] = 40, ["all"] = 100, ["none"] = 100, ["trumpet"] = 500}
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
		  ["none"] = image.load("images/none.png"),
		  ["trumpet"] = image.load("images/trumpet.png"),
		  ["background"] = image.load("images/background.png")
}
chao = {["img"] = images["egg"],
		["x"] = 100,
		["y"] = 50,
		["grabbed"] = false,
		["name"] = "Chao",
		["age"] = "Egg",
		["mood"] = 10,
		["belly"] = 10,
		["swim"] = 0,
		["fly"] = 0,
		["run"] = 0,
		["power"] = 0,
		["stamina"] = 0,
		["rings"] = 1000,
		["hunger"] = 0,
		["move"] = 0,
		["wx"] = 200,
		["wy"] = 100
}
cursor = {["img"] = images["cursor"],
		  ["x"] = 0,
		  ["y"] = 0,
		  ["held"] = nil,
		  ["timer"] = 0
}
drawObjects = {cursor, chao}
function useItem(item)
	if item["stat"] ~= "none" and item["stat"] ~= "trumpet" then
		if chao["belly"] < 10 then
			chao["belly"] = chao["belly"] + 1
			chao["mood"] = chao["mood"] + 1
			if item["stat"] == "all" then
				for i = 5, 9 do
					chao[chaoStats[i]] = chao[chaoStats[i]] + 2
				end
			else
				chao[item["stat"]] = chao[item["stat"]] + 2
			end
		else
			chao["mood"] = chao["mood"] - 1
		end
		cursor["held"] = nil
		cursor["img"] = images["cursor"]
		for i = 2, #drawObjects do
			if drawObjects[i] == item then
				table.remove(drawObjects, i)
			end
		end
	end
end
function buyItem(stat)
	if (chao["rings"] >= itemCosts[stat] and cursor["held"] == nil) then
		chao["rings"] = chao["rings"] - itemCosts[stat]
		local item = {["img"] = images[stat],
				["x"] = cursor["x"] + 2,
				["y"] = cursor["y"] + 13,
				["grabbed"] = true,
				["stat"] = stat
		}
		cursor["held"] = item
		cursor["img"] = images["grab"]
		table.insert(drawObjects, item)
	end
end
function cursorUse()
	if cursor["held"] == nil then
		if cursor["x"] < 30 then
			for i = 1, 8 do
				if (collide(11, cursor["x"], cursor["y"], 15, ((i*25)-5)) and #drawObjects < 15) then
					buyItem(items[i])		
				end
			end
		else
			for i = 2, #drawObjects do
				if collide(11, cursor["x"], cursor["y"], drawObjects[i]["x"], drawObjects[i]["y"]) then
					cursor["img"] = images["grab"]
					cursor["held"] = drawObjects[i]
					drawObjects[i]["grabbed"] = true
				end
			end
		end
	elseif (cursor["held"] ~= nil and cursor["x"] > 29 and cursor["x"] < 398) then
		cursor["held"]["grabbed"] = false
		cursor["held"] = nil
		cursor["img"] = images["cursor"]
	end
end
function chaoWander()
	if (chao["grabbed"] == false and (os.clock() - chao["move"]) > 0.18) then
		chao["move"] = os.clock()
		if chao["x"] ~= chao["wx"] then
			if chao["x"] < chao["wx"] then
				chao["x"] = chao["x"] + 1
			elseif chao["x"] > chao["wx"] then
				chao["x"] = chao["x"] - 1
			end
		end
		if chao["y"] ~= chao["wy"] then
			if chao["y"] < chao["wy"] then
				chao["y"] = chao["y"] + 1
			elseif chao["y"] > chao["wy"] then
				chao["y"] = chao["y"] - 1
			end
		end
		for i = 3, #drawObjects do
			if (collide(5, chao["x"], chao["y"], drawObjects[i]["x"], drawObjects[i]["y"]) and chao["belly"] < 9) then
				useItem(drawObjects[i])
			elseif (collide(50, chao["x"], chao["y"], drawObjects[i]["x"], drawObjects[i]["y"]) and chao["belly"] < 9) then
				chao["wx"] = drawObjects[i]["x"]
				chao["wy"] = drawObjects[i]["y"]
			end
		end
		if (chao["x"] == chao["wx"] and chao["y"] == chao["wy"]) then
			chao["wx"] = math.random(35, 390)
			chao["wy"] = math.random(10, 260)
		end
	end
end
function collide(num, x1, y1, x2, y2)
	if (math.abs(x1 - x2) < num and math.abs(y1 - y2) < num) then
		return true
	else
		return false
	end
end
function render()
	screen.clear()
	image.blit(images["background"],0,0)
	for i = 1, 10 do
		screen.print(420, (i * 25) - 5, chao[chaoStats[i]])
	end
	draw.fillrect(0,0,30,272,color.new(255,218,185))
	for i = 1, 8 do
		image.blit(images[items[i]], 10, (i*25)-5)
	end
	if cursor["held"] ~= nil then
		cursor["held"]["x"] = cursor["x"] + 2
		cursor["held"]["y"] = cursor["y"] + 13
	end
	for i = #drawObjects, 1, -1 do
		image.blit(drawObjects[i]["img"],drawObjects[i]["x"],drawObjects[i]["y"])
	end
	screen.print(0,1,#drawObjects)
	screen.flip()
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
	if (controls.cross() and (os.clock() - cursor["timer"]) > 0.25) then
		cursor["timer"] = os.clock()
		cursorUse()
	elseif (controls.square() and cursor["held"] ~= nil and chao["grabbed"] == false and collide(15, chao["x"], chao["y"], cursor["held"]["x"], cursor["held"]["y"]) and (os.clock() - cursor["timer"]) > 0.25) then
		cursor["timer"] = os.clock()
		useItem(cursor["held"])
	end
end
function game()
	image.blit(images["title"],0,0)
	screen.flip()
	controls.waitforkey()
	screen.clear()
	while true do
		buttons()
		render()
		if (os.clock() - chao["hunger"]) > 10 then
			chao["hunger"] = os.clock()
			chao["belly"] = chao["belly"] - 1
		end
		chaoWander()
	end
end
game()