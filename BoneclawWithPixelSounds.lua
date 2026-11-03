-- Rivals | Default Assault Rifle -> Boneclaw Rifle (full model clone + sound + icon)
-- Language: Luau | Target: RIVALS (Roblox)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Config = {
	WeaponFolder = "Assault Rifle",
	TargetCase = "Spooky Skin Case",
	TargetName = "Boneclaw Rifle",
	IconId = "rbxassetid://100015754284323",
	Scale = 1,
	-- add every numeric id you see on the default AR from Dex
	SoundMap = {
		[13087362838] = 17650837861, -- common AR shoot -> boneclaw
		-- [otherDefaultId] = boneclawId,
	},
}

local function getViewModels()
	local ps = LP:FindFirstChild("PlayerScripts")
	if not ps then return nil end
	local assets = ps:FindFirstChild("Assets")
	if not assets then return nil end
	return assets:FindFirstChild("ViewModels")
end

local function findModel(root, caseName, skinName)
	if not root then return nil end
	if caseName then
		local caseFolder = root:FindFirstChild(caseName)
		if caseFolder then
			local m = caseFolder:FindFirstChild(skinName)
			if m then return m end
		end
	end
	for _, v in ipairs(root:GetDescendants()) do
		if v.Name == skinName and (v:IsA("Model") or v:IsA("Folder")) then
			return v
		end
	end
	return nil
end

local function isArName(name)
	return name == "Assault Rifle" or string.find(string.lower(name), "assault") ~= nil
end

local function patchSounds(root)
	if not root then return end
	for _, s in ipairs(root:GetDescendants()) do
		if s:IsA("Sound") then
			local raw = s.SoundId or ""
			local id = tonumber(raw:match("%d+"))
			if id and Config.SoundMap[id] then
				local newId = "rbxassetid://" .. Config.SoundMap[id]
				if s.SoundId ~= newId then
					s.SoundId = newId
				end
			end
		end
	end
end

local function patchAllSounds()
	local vm = getViewModels()
	if vm then patchSounds(vm) end
	if LP.Character then patchSounds(LP.Character) end
	local bp = LP:FindFirstChild("Backpack")
	if bp then patchSounds(bp) end
end

local function patchIcon()
	local function hitTools(container)
		if not container then return end
		for _, t in ipairs(container:GetChildren()) do
			if t:IsA("Tool") and isArName(t.Name) then
				if t.TextureId ~= Config.IconId then
					t.TextureId = Config.IconId
				end
			end
		end
	end
	hitTools(LP.Character)
	hitTools(LP:FindFirstChild("Backpack"))

	-- some HUD slots use ImageLabel / ImageButton instead of Tool.TextureId
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		for _, gui in ipairs(pg:GetDescendants()) do
			if (gui:IsA("ImageLabel") or gui:IsA("ImageButton")) and isArName(gui.Name) then
				if gui.Image ~= Config.IconId then
					gui.Image = Config.IconId
				end
			end
		end
	end
end

local function cloneBoneclawOnto(target, boneclaw)
	if not target or not boneclaw then return false end
	if target == boneclaw then return false end
	local parent = target.Parent
	local slotName = target.Name
	target:Destroy()
	local clone = boneclaw:Clone()
	clone.Name = slotName
	clone.Parent = parent
	if Config.Scale ~= 1 then
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Size = d.Size * Config.Scale
			elseif d:IsA("SpecialMesh") then
				d.Scale = d.Scale * Config.Scale
			end
		end
	end
	patchSounds(clone)
	return true
end

local function apply()
	local viewModels = getViewModels()
	if not viewModels then
		warn("[skinchanger] ViewModels missing")
		return
	end

	local boneclaw = findModel(viewModels, Config.TargetCase, Config.TargetName)
		or findModel(viewModels, Config.TargetCase, "Boneclaw")
		or findModel(viewModels, nil, "Boneclaw Rifle")
	if not boneclaw then
		warn("[skinchanger] Boneclaw not found — check Spooky Skin Case name in Dex")
		return
	end

	local weapons = viewModels:FindFirstChild("Weapons")
	local ar = weapons and weapons:FindFirstChild(Config.WeaponFolder)
	if not ar then
		ar = findModel(viewModels, "Weapons", Config.WeaponFolder)
			or findModel(viewModels, nil, "Assault Rifle")
	end
	if not ar then
		warn("[skinchanger] default Assault Rifle slot not found")
		return
	end

	-- only swap if it still looks like the default (no BaseParts under a pure folder, or still named AR)
	local alreadyBone = ar:FindFirstChild("Boneclaw") or (ar.Name == Config.TargetName)
	if not alreadyBone then
		if cloneBoneclawOnto(ar, boneclaw) then
			print("[skinchanger] Assault Rifle <- Boneclaw clone")
		end
	else
		patchSounds(ar)
	end

	patchAllSounds()
	patchIcon()
end

-- initial wait for ViewModels
task.spawn(function()
	local t0 = os.clock()
	while not getViewModels() and os.clock() - t0 < 20 do
		task.wait(0.3)
	end
	apply()
end)

-- character / equip
LP.CharacterAdded:Connect(function(char)
	task.wait(1.4)
	apply()
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and isArName(child.Name) then
			task.wait(0.4)
			apply()
		elseif child:IsA("Sound") then
			local id = tonumber((child.SoundId or ""):match("%d+"))
			if id and Config.SoundMap[id] then
				child.SoundId = "rbxassetid://" .. Config.SoundMap[id]
			end
		end
	end)
end)

-- catch late Sounds anywhere under the player
local function hookDescendant(container)
	if not container then return end
	container.DescendantAdded:Connect(function(desc)
		if desc:IsA("Sound") then
			local id = tonumber((desc.SoundId or ""):match("%d+"))
			if id and Config.SoundMap[id] then
				desc.SoundId = "rbxassetid://" .. Config.SoundMap[id]
			end
		elseif desc:IsA("Tool") and isArName(desc.Name) then
			task.defer(function()
				desc.TextureId = Config.IconId
				patchSounds(desc)
			end)
		end
	end)
end
hookDescendant(LP)
if LP.Character then hookDescendant(LP.Character) end
LP.CharacterAdded:Connect(hookDescendant)

-- keep model + sound + icon alive against game wipes
task.spawn(function()
	while task.wait(2) do
		local vm = getViewModels()
		if not vm then continue end
		local weapons = vm:FindFirstChild("Weapons")
		local ar = weapons and weapons:FindFirstChild(Config.WeaponFolder)
		if ar and not ar:FindFirstChildWhichIsA("BasePart", true) then
			apply()
		else
			patchAllSounds()
			patchIcon()
		end
	end
end)

print("[skinchanger] Assault Rifle -> Boneclaw (model + sound + icon, persistent)")
