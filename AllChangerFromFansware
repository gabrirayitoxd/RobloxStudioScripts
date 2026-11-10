--[[
        CON MUCHO ESFUERZO -Fansware (credit me if you want to use it.)
]]
local localPlayer = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
getgenv().Rivals_getOthLibrary = function()
if typeof(oth) == "table" then return oth end
if typeof(getgenv().oth) == "table" then return getgenv().oth end
return nil
end
getgenv().Rivals_withOthHook = function(target, hookBody)
if type(target) ~= "function" or type(hookBody) ~= "function" then return nil, false end
local othLib = getgenv().Rivals_getOthLibrary()
if othLib and type(othLib.hook) == "function" then
local original
local ok = pcall(function()
original = othLib.hook(target, function(...)
local root = original
if type(othLib.get_root_callback) == "function" then
local fromThread = othLib.get_root_callback()
if type(fromThread) == "function" then root = fromThread end
end
if type(root) ~= "function" then error("oth root missing") end
return hookBody(function(...) return root(...) end, ...)
end)
end)
if ok then
if type(original) == "function" then return original, true end
if type(othLib.get_root_callback) == "function" then return target, true end
end
end
local orig = target
return function(...)
return hookBody(function(...) return orig(...) end, ...)
end, false
end
getgenv().Rivals_othUnhook = function(target)
if type(target) ~= "function" then return false end
local othLib = getgenv().Rivals_getOthLibrary()
if othLib and type(othLib.unhook) == "function" then
return pcall(othLib.unhook, target)
end
return false
end
pcall(function()
getgenv()._rivalsFighterController = require(localPlayer.PlayerScripts.Controllers.FighterController)
end)
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG or { Enabled = true, Skins = {}, Wraps = {} }
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Skins = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Skins or {}
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Wraps = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Wraps or {}
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Charms = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Charms or {}
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Finishers = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Finishers or {}
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Enabled = true
getgenv().Rivals_weaponAppearanceState = getgenv().Rivals_weaponAppearanceState or { lastWeapon = nil, updatingUI = false, lastTick = 0, uiListsCache = {}, lastDropdownWeapon = nil, localFighterId = nil, globalListsLoaded = false, lastSkinListWeapon = nil }
getgenv().Rivals_weaponCosmeticCache = getgenv().Rivals_weaponCosmeticCache or { ready = false, building = false, skinsByWeapon = {}, wraps = { "None" }, charms = { "None" }, finishers = { "None" } }
getgenv().Rivals_guiImageCache = getgenv().Rivals_guiImageCache or {}
getgenv().Rivals_getWeaponIconCacheKey = getgenv().Rivals_getWeaponIconCacheKey or function(wn, highRes, baseOnly)
if not wn then return "" end
if baseOnly then return "wpn:" .. wn .. (highRes and ":hr" or ":lr") .. ":base" end
local sn = getgenv().Rivals_getSkinOverrideName and getgenv().Rivals_getSkinOverrideName(wn) or ""
return "wpn:" .. wn .. (highRes and ":hr" or ":lr") .. ":" .. (sn or "")
end
getgenv().Rivals_applyImageToLabel = getgenv().Rivals_applyImageToLabel or function(pic, key, resolver)
if not pic or not key or type(resolver) ~= "function" then return end
local cache = getgenv().Rivals_guiImageCache
local cached = cache[key]
if cached and cached ~= "" then
pic.Image = cached
return
end
local ok, img = pcall(resolver)
img = ok and img or ""
if img ~= "" then
cache[key] = img
pic.Image = img
return
end
task.defer(function()
if not pic.Parent then return end
local ok2, img2 = pcall(resolver)
img2 = ok2 and img2 or ""
if img2 ~= "" then
cache[key] = img2
pic.Image = img2
end
end)
end
do
local cache = getgenv().Rivals_weaponCosmeticCache
if not cache.ready then
cache.building = false
cache.wraps = { "None" }
cache.charms = { "None" }
cache.finishers = { "None" }
cache.skinsByWeapon = cache.skinsByWeapon or {}
end
end
getgenv().Rivals_PLAIN_VIEWMODEL_WEAPONS = getgenv().Rivals_PLAIN_VIEWMODEL_WEAPONS or { ["Scythe"]=true,["Trowel"]=true,["Warper"]=true,["Jump Pad"]=true,["Smoke Grenade"]=true,["Flashbang"]=true }
getgenv().Rivals_getLocalFighter = function()
local fc = getgenv()._rivalsFighterController
if not fc then
pcall(function()
fc = require(localPlayer.PlayerScripts.Controllers.FighterController)
getgenv()._rivalsFighterController = fc
end)
end
if fc and fc.LocalFighter then return fc.LocalFighter end
pcall(function()
fc = require(localPlayer.PlayerScripts.Controllers.FighterController)
getgenv()._rivalsFighterController = fc
end)
return fc and fc.LocalFighter or nil
end
getgenv().Rivals_appearanceQueueDelay = 0.5
getgenv().Rivals_enqueueAppearanceWork = function(key, fn)
if type(fn) ~= "function" then return end
local state = getgenv().Rivals_weaponAppearanceState
state._appearanceQueue = state._appearanceQueue or {}
state._appearanceQueuePending = state._appearanceQueuePending or {}
if key and state._appearanceQueuePending[key] then return end
if key then state._appearanceQueuePending[key] = true end
state._appearanceQueue[#state._appearanceQueue + 1] = { key = key, fn = fn }
getgenv().Rivals_pumpAppearanceQueue()
end
getgenv().Rivals_pumpAppearanceQueue = function()
local state = getgenv().Rivals_weaponAppearanceState
if state._appearanceQueuePumpRunning then return end
state._appearanceQueuePumpRunning = true
task.spawn(function()
while state._appearanceQueue and #state._appearanceQueue > 0 do
local job = table.remove(state._appearanceQueue, 1)
if job.key and state._appearanceQueuePending then
state._appearanceQueuePending[job.key] = nil
end
pcall(job.fn)
task.wait(getgenv().Rivals_appearanceQueueDelay or 0.5)
end
state._appearanceQueuePumpRunning = false
end)
end
getgenv().Rivals_getLocalEquippedWeaponName = function()
local ok, name = pcall(function()
local lf = getgenv().Rivals_getLocalFighter()
local item = lf and lf.EquippedItem
return item and (item.Name or (item.Info and item.Info.Name))
end)
return ok and name or nil
end
getgenv().Rivals_getLocalEquippedViewModel = function()
local ok, vm = pcall(function()
local lf = getgenv().Rivals_getLocalFighter()
local item = lf and lf.EquippedItem
return item and item.ViewModel
end)
return ok and vm or nil
end
getgenv().Rivals_applyViewModelOffset = function() end
getgenv().Rivals_sortCosmeticList = function(list)
table.sort(list, function(a, b)
if a == "None" then return true end
if b == "None" then return false end
return a < b
end)
end
getgenv().Rivals_buildViewModelModuleCache = function()
if getgenv().Rivals_viewModelModuleCache and getgenv().Rivals_viewModelModuleCache._v2 then
return getgenv().Rivals_viewModelModuleCache
end
local cache = {}
pcall(function()
local vmFolder = localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
if not vmFolder then return end
local function scan(folder)
for _, child in ipairs(folder:GetChildren()) do
if child:IsA("ModuleScript") then
cache[child.Name] = child
scan(child)
elseif child:IsA("Folder") then scan(child) end
end
end
scan(vmFolder)
cache._v2 = true
end)
getgenv().Rivals_viewModelModuleCache = cache
return cache
end
getgenv().Rivals_ensureWeaponCosmeticCache = function()
local cache = getgenv().Rivals_weaponCosmeticCache
if cache.ready or cache.building then return end
cache.building = true
task.spawn(function()
local built = false
local ok = pcall(function()
local CL = require(RS.Modules.CosmeticLibrary)
local IL = require(RS.Modules.ItemLibrary)
local charmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("Charms")
local finisherMods = RS.Modules:FindFirstChild("Finishers")
local charmIndex, finisherIndex = {}, {}
if charmAssets then
for _, desc in ipairs(charmAssets:GetDescendants()) do
charmIndex[desc.Name] = true
end
end
if finisherMods then
for _, child in ipairs(finisherMods:GetChildren()) do
finisherIndex[child.Name] = true
end
end
cache.wraps = { "None" }
cache.charms = { "None" }
cache.finishers = { "None" }
cache.skinsByWeapon = {}
local step = 0
for name, info in pairs(CL.Cosmetics or {}) do
if info.Type == "Wrap" then
cache.wraps[#cache.wraps + 1] = name
elseif info.Type == "Charm" and charmIndex[name] then
cache.charms[#cache.charms + 1] = name
elseif info.Type == "Finisher" then
if not finisherMods or finisherMods:FindFirstChild(name) then
cache.finishers[#cache.finishers + 1] = name
end
elseif info.Type == "Skin" and info.ItemName then
local b = cache.skinsByWeapon[info.ItemName]
if not b then b = { "None" }; cache.skinsByWeapon[info.ItemName] = b end
b[#b + 1] = name
end
step = step + 1
if step % 120 == 0 then task.wait() end
end
getgenv().Rivals_sortCosmeticList(cache.wraps)
getgenv().Rivals_sortCosmeticList(cache.charms)
getgenv().Rivals_sortCosmeticList(cache.finishers)
for wn in pairs(IL.Items or {}) do
if not cache.skinsByWeapon[wn] then cache.skinsByWeapon[wn] = { "None" } end
end
local vmRoot = localPlayer.PlayerScripts.Assets.ViewModels
local weaponsFolder = vmRoot:FindFirstChild("Weapons") or vmRoot
for i, wf in ipairs(weaponsFolder:GetChildren()) do
local wn = wf.Name
if IL.Items[wn] then
local b = cache.skinsByWeapon[wn]
local seen = { None = true }
for _, sn in ipairs(b) do seen[sn] = true end
for _, child in ipairs(wf:GetChildren()) do
if child.Name and child.Name ~= "" and not seen[child.Name] and IL.ViewModels[child.Name] then
seen[child.Name] = true
b[#b + 1] = child.Name
end
end
end
if i % 25 == 0 then task.wait() end
end
for _, b in pairs(cache.skinsByWeapon) do getgenv().Rivals_sortCosmeticList(b) end
getgenv().Rivals_buildViewModelModuleCache()
built = true
end)
cache.building = false
cache.ready = built and ok
if cache.ready then
local state = getgenv().Rivals_weaponAppearanceState
state.globalListsLoaded = false
state.uiListsCache = {}
state.lastSkinListWeapon = nil
task.spawn(function()
getgenv().Rivals_ensureCosmeticImagesTable()
local t = getgenv().Rivals_cosmeticImageTable or {}
local batch = {}
for _, url in pairs(t) do
if type(url) == "string" and url ~= "" then batch[#batch + 1] = url end
end
if #batch > 0 then
pcall(function() game:GetService("ContentProvider"):PreloadAsync(batch) end)
end
end)
getgenv().Rivals_enqueueAppearanceWork("cache:gui_refresh", function()
local wn = getgenv().Rivals_getLocalEquippedWeaponName() or state._uiSelectedWeapon
if wn and getgenv().Rivals_updateAppearanceDropdowns then
getgenv().Rivals_updateAppearanceDropdowns(wn)
end
if getgenv().Rivals_guiRefreshWeaponGrid then getgenv().Rivals_guiRefreshWeaponGrid() end
if getgenv().Rivals_guiRefreshCosmeticGrid then getgenv().Rivals_guiRefreshCosmeticGrid() end
end)
end
end)
end
getgenv().Rivals_getSkinsForWeapon = function(wn)
if not wn or wn=="" then return {"None"} end
local cache = getgenv().Rivals_weaponCosmeticCache
return cache.ready and (cache.skinsByWeapon[wn] or {"None"}) or {"None"}
end
getgenv().Rivals_getWrapsForWeapon = function()
local cache = getgenv().Rivals_weaponCosmeticCache
return (cache.ready and cache.wraps) or {"None"}
end
getgenv().Rivals_getCharmsForWeapon = function()
local cache = getgenv().Rivals_weaponCosmeticCache
return (cache.ready and cache.charms) or {"None"}
end
getgenv().Rivals_getFinishersForWeapon = function()
local cache = getgenv().Rivals_weaponCosmeticCache
return (cache.ready and cache.finishers) or {"None"}
end
getgenv().Rivals_getAllWeaponNames = function()
local IL = require(RS.Modules.ItemLibrary)
local list = {}
for name in pairs(IL.Items or {}) do
if type(name) == "string" and name ~= "" and not string.find(string.upper(name), "MISSING", 1, true) then
list[#list + 1] = name
end
end
table.sort(list, function(a, b) return a < b end)
return list
end
getgenv().Rivals_getWeaponIconCacheKey = function(wn, highRes, baseOnly)
if not wn then return "" end
if baseOnly then return "wpn:" .. wn .. (highRes and ":hr" or ":lr") .. ":base" end
local sn = getgenv().Rivals_getSkinOverrideName(wn) or ""
return "wpn:" .. wn .. (highRes and ":hr" or ":lr") .. ":" .. sn
end
getgenv().Rivals_getCosmeticListForKind = function(kind, wn)
local base
if kind == "skin" then base = getgenv().Rivals_getSkinsForWeapon(wn)
elseif kind == "wrap" then base = getgenv().Rivals_getWrapsForWeapon()
elseif kind == "charm" then base = getgenv().Rivals_getCharmsForWeapon()
else base = getgenv().Rivals_getFinishersForWeapon()
end
local out, seen = { "Random", "None" }, { Random = true, None = true }
for _, name in ipairs(base or {}) do
if name and name ~= "None" and not seen[name] then
seen[name] = true
out[#out + 1] = name
end
end
return out
end
getgenv().Rivals_ensureCosmeticImagesTable = function()
if getgenv().Rivals_cosmeticImageTable ~= nil then return getgenv().Rivals_cosmeticImageTable end
local t = {}
pcall(function()
local CONSTANTS = require(RS.Modules.CONSTANTS)
t = CONSTANTS.COSMETIC_IMAGES or {}
end)
getgenv().Rivals_cosmeticImageTable = t
return t
end
getgenv().Rivals_getCosmeticImageFromConstants = function(name)
if not name then return "" end
local img = getgenv().Rivals_ensureCosmeticImagesTable()[name]
return (type(img) == "string" and img ~= "") and img or ""
end
getgenv().Rivals_pickRandomFromCosmeticList = function(list)
local pool = {}
for _, name in ipairs(list or {}) do
if name and name ~= "None" and name ~= "Random" then
pool[#pool + 1] = name
end
end
if #pool == 0 then return nil end
return pool[math.random(1, #pool)]
end
getgenv().Rivals_resolveStoredCosmeticPick = function(pick, list)
if not pick or pick == "None" then return nil end
if pick == "Random" then return getgenv().Rivals_pickRandomFromCosmeticList(list) end
return pick
end
getgenv().Rivals_getRandomRollBucket = function(wn)
local state = getgenv().Rivals_weaponAppearanceState
state.resolvedRandom = state.resolvedRandom or {}
if wn then
state.resolvedRandom[wn] = state.resolvedRandom[wn] or {}
return state.resolvedRandom[wn]
end
return state.resolvedRandom
end
getgenv().Rivals_getCosmeticListForKindInternal = function(kind, wn)
if kind == "skin" then return getgenv().Rivals_getSkinsForWeapon(wn)
elseif kind == "wrap" then return getgenv().Rivals_getWrapsForWeapon()
elseif kind == "charm" then return getgenv().Rivals_getCharmsForWeapon()
else return getgenv().Rivals_getFinishersForWeapon()
end
end
getgenv().Rivals_rollRandomCosmeticForWeapon = function(wn, kind, forceRoll)
if not wn or not kind then return nil end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local stored
if kind == "skin" then stored = cfg.Skins[wn]
elseif kind == "wrap" then stored = cfg.Wraps[wn]
elseif kind == "charm" then stored = cfg.Charms[wn]
else stored = cfg.Finishers[wn]
end
if stored ~= "Random" then
local bucket = getgenv().Rivals_getRandomRollBucket(wn)
if bucket then bucket[kind] = nil end
return nil
end
local bucket = getgenv().Rivals_getRandomRollBucket(wn)
if not forceRoll and bucket[kind] then return bucket[kind] end
local rolled = getgenv().Rivals_pickRandomFromCosmeticList(getgenv().Rivals_getCosmeticListForKindInternal(kind, wn))
bucket[kind] = rolled
return rolled
end
getgenv().Rivals_rerollRandomCosmeticsForWeapon = function(wn)
if not wn then return end
for _, kind in ipairs({ "skin", "wrap", "charm", "finisher" }) do
getgenv().Rivals_rollRandomCosmeticForWeapon(wn, kind, true)
end
end
getgenv().Rivals_getEffectiveCosmeticPick = function(wn, kind)
if not wn or not kind then return nil end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local stored
if kind == "skin" then stored = cfg.Skins[wn]
elseif kind == "wrap" then stored = cfg.Wraps[wn]
elseif kind == "charm" then stored = cfg.Charms[wn]
else stored = cfg.Finishers[wn]
end
if not stored or stored == "None" then return nil end
if stored == "Random" then return getgenv().Rivals_rollRandomCosmeticForWeapon(wn, kind, false) end
return stored
end
getgenv().Rivals_getCosmeticThumbnail = function(kind, name, wn)
if not name then return "" end
local cache = getgenv().Rivals_guiImageCache
local key = tostring(kind) .. "\31" .. name .. "\31" .. tostring(wn or "")
if cache[key] then return cache[key] end
if name == "None" then
local noneImg = getgenv().Rivals_getCosmeticImageFromConstants("NONE_COSMETIC")
cache[key] = noneImg
return noneImg
end
if name == "Random" then
local randImg = getgenv().Rivals_getCosmeticImageFromConstants("RANDOM_COSMETIC")
cache[key] = randImg
return randImg
end
local ok, img = pcall(function()
local fromConst = getgenv().Rivals_getCosmeticImageFromConstants(name)
if fromConst ~= "" then return fromConst end
local CL = require(RS.Modules.CosmeticLibrary)
local info = CL.Cosmetics and CL.Cosmetics[name]
if info then
if type(info.Image) == "string" and info.Image ~= "" then return info.Image end
if type(info.Icon) == "string" and info.Icon ~= "" then return info.Icon end
end
if kind == "skin" and wn then
return getgenv().Rivals_resolveWeaponIconImage(wn, { Name = wn, Skin = { Name = name }, _rivalsLocalPatched = true }, false)
end
if kind == "finisher" then
local CLf = require(RS.Modules.CosmeticLibrary)
local finfo = CLf.Cosmetics and CLf.Cosmetics[name]
if finfo and type(finfo.Image) == "string" and finfo.Image ~= "" then return finfo.Image end
local IL = require(RS.Modules.ItemLibrary)
local vm = IL.ViewModels[name]
if vm then return vm.Image or vm.ImageHighResolution or "" end
end
return ""
end)
img = ok and img or ""
if img ~= "" then cache[key] = img end
return img
end
getgenv().Rivals_setGuiImageAsync = function(pic, key, resolver)
if not pic or not key or type(resolver) ~= "function" then return end
getgenv().Rivals_applyImageToLabel(pic, key, resolver)
end
getgenv().Rivals_applyImageToLabel = function(pic, key, resolver)
if not pic or not key or type(resolver) ~= "function" then return end
local cache = getgenv().Rivals_guiImageCache
local cached = cache[key]
if cached and cached ~= "" then
pic.Image = cached
return
end
local ok, img = pcall(resolver)
img = ok and img or ""
if img ~= "" then
cache[key] = img
pic.Image = img
return
end
task.defer(function()
if not pic.Parent then return end
local ok2, img2 = pcall(resolver)
img2 = ok2 and img2 or ""
if img2 ~= "" then
cache[key] = img2
pic.Image = img2
end
end)
end
getgenv().Rivals_TILE_PREVIEW_PX = 66
getgenv().Rivals_createTilePreviewHost = function(tile)
local host = Instance.new("Frame")
host.Name = "Preview"
host.BackgroundTransparency = 1
host.AnchorPoint = Vector2.new(0.5, 0)
host.Position = UDim2.new(0.5, 0, 0, 8)
host.Size = UDim2.new(0, getgenv().Rivals_TILE_PREVIEW_PX, 0, getgenv().Rivals_TILE_PREVIEW_PX)
host.Parent = tile
return host
end
getgenv().Rivals_styleTilePreviewImage = function(pic, scale)
pic.BackgroundTransparency = 1
pic.AnchorPoint = Vector2.new(0.5, 0.5)
pic.Position = UDim2.new(0.5, 0, 0.5, 0)
local s = scale or 1
if s >= 1 then
pic.Size = UDim2.new(1, 0, 1, 0)
else
pic.Size = UDim2.new(s, 0, s, 0)
end
pic.ScaleType = Enum.ScaleType.Fit
end
getgenv().Rivals_styleTilePreviewViewport = function(vp)
vp.AnchorPoint = Vector2.new(0.5, 0.5)
vp.Position = UDim2.new(0.5, 0, 0.5, 0)
vp.Size = UDim2.new(1, 0, 1, 0)
vp.BackgroundTransparency = 1
end
getgenv().Rivals_applyCosmeticTileFallback = function(pic, name)
if not pic or not name or name == "None" or name == "Random" then return end
pcall(function()
local CL = require(RS.Modules.CosmeticLibrary)
local info = CL.Cosmetics and CL.Cosmetics[name]
local rarity = info and info.Rarity and CL.Rarities and CL.Rarities[info.Rarity]
if rarity and rarity.Color then
pic.BackgroundColor3 = rarity.Color
pic.BackgroundTransparency = 0.2
end
end)
end
getgenv().Rivals_tryAttachCosmeticPreview = function(tile, pic, kind, name, wn)
if not tile or not pic or not name or name == "None" or name == "Random" then return false end
if kind ~= "wrap" and kind ~= "charm" and kind ~= "finisher" then return false end
local attached = false
pcall(function()
local CS = require(localPlayer.PlayerScripts.Modules.CosmeticSlot)
local slot = CS.new(name, false, true)
if not slot or not slot.Frame then return end
pcall(function() slot:SetInteractable(false) end)
if kind == "wrap" and wn then
pcall(function() slot:SetWeapon(wn) end)
else
pcall(function() slot:SetWeapon(nil) end)
end
if slot._cosmetic_viewport_frame then
pcall(function() slot._cosmetic_viewport_frame:ZoomOut() end)
elseif slot._emote_viewport_frame then
pcall(function() slot._emote_viewport_frame:ZoomOut() end)
end
local btn = slot.Frame:FindFirstChild("Button", true)
local vp = btn and btn:FindFirstChild("CosmeticViewportFrame")
if not vp or not vp:IsA("ViewportFrame") then
pcall(function() slot:Destroy() end)
return
end
getgenv().Rivals_styleTilePreviewViewport(vp)
vp.ZIndex = 2
local host = pic.Parent
vp.Parent = (host and host.Name == "Preview") and host or tile
pcall(function() slot.Frame:Destroy() end)
pcall(function() pic.Visible = false end)
attached = true
end)
return attached
end
getgenv().Rivals_setCosmeticPickForWeapon = function(wn, kind, pick)
if not wn or wn == "" then return end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if kind == "skin" then cfg.Skins[wn] = pick
elseif kind == "wrap" then cfg.Wraps[wn] = pick
elseif kind == "charm" then cfg.Charms[wn] = pick
else cfg.Finishers[wn] = pick end
if pick == "Random" then
getgenv().Rivals_rollRandomCosmeticForWeapon(wn, kind, true)
else
getgenv().Rivals_rollRandomCosmeticForWeapon(wn, kind, false)
end
getgenv().Rivals_refreshWeaponAppearanceForName(wn, kind == "finisher" and "finisher" or kind)
if kind == "skin" then
local cache = getgenv().Rivals_guiImageCache
local prefix = "wpn:" .. wn
for k in pairs(cache) do
if type(k) == "string" and string.sub(k, 1, #prefix) == prefix then cache[k] = nil end
end
end
if getgenv().Rivals_guiRefreshCosmeticGrid then getgenv().Rivals_guiRefreshCosmeticGrid() end
if getgenv().Rivals_guiRefreshWeaponGrid then getgenv().Rivals_guiRefreshWeaponGrid() end
local lf = getgenv().Rivals_getLocalFighter()
if lf then getgenv().Rivals_refreshHotbarIcons(lf) end
end
getgenv().Rivals_getViewModelModuleAlias = function(wn)
return ({["Smoke Grenade"]="Grenade",["Flashbang"]="Grenade"})[wn]
end
getgenv().Rivals_weaponUsesPlainViewModel = function(wn)
return wn and getgenv().Rivals_PLAIN_VIEWMODEL_WEAPONS[wn]==true
end
getgenv().Rivals_weaponNeedsTransparencyFix = function(wn)
if not wn then return false end
if getgenv().Rivals_weaponUsesPlainViewModel(wn) then return true end
local CL = require(RS.Modules.CosmeticLibrary)
if CL.IGNORE_TRANSPARENCY_WHITELIST and CL.IGNORE_TRANSPARENCY_WHITELIST[wn] then return true end
local IL = require(RS.Modules.ItemLibrary)
local info = IL.Items[wn]
if not info then return false end
return info.Type == "Custom" or info.Type == "Melee" or info.Class == "Utility" or info.Class == "Melee"
end
getgenv().Rivals_templateUsesArmSubmodelsOnly = function(template)
if not template then return false end
local hasArm, hasOther = false, false
for _, ch in ipairs(template:GetChildren()) do
if ch.Name == "_left_arm" or ch.Name == "_right_arm" then
hasArm = true
elseif ch.Name ~= "_fake" then
hasOther = true
end
end
return hasArm and not hasOther
end
getgenv().Rivals_weaponUsesArmSubmodelVisuals = function(wn, template)
if wn == "Fists" then return true end
return getgenv().Rivals_templateUsesArmSubmodelsOnly(template)
end
getgenv().Rivals_clearViewModelArmSubmodels = function(vm)
if not vm then return end
pcall(function()
if type(vm._arm_submodels) == "table" then
for child in pairs(vm._arm_submodels) do
pcall(function() if child and child.Parent then child:Destroy() end end)
end
end
vm._arm_submodels = {}
if vm.Model then
for _, armName in ipairs({ "LeftArm", "RightArm" }) do
local arm = vm.Model:FindFirstChild(armName)
if arm then
for _, ch in ipairs(arm:GetChildren()) do
if ch:IsA("Model") and (ch.Name == "_left_arm" or ch.Name == "_right_arm") then
pcall(function() ch:Destroy() end)
end
end
end
end
end
end)
end
getgenv().Rivals_setupArmSubmodelItemVisual = function(vm, wn)
if not vm or not vm.Model or not vm.ItemModel then return false end
local model = vm.Model
local iv = vm.ItemModel
getgenv().Rivals_clearViewModelArmSubmodels(vm)
getgenv().Rivals_clearItemVisualMotors(vm)
vm._arm_submodels = {}
vm._local_transparency_modifiers = vm._local_transparency_modifiers or {}
vm._local_transparency_modifier_update = vm._local_transparency_modifier_update or {}
local ok = pcall(function()
iv.Name = "ItemVisual"
if iv.Parent ~= model then iv.Parent = model end
for _, child in ipairs(iv:GetChildren()) do
if child.Name == "_fake" then
vm._can_wrap_left_arm = child:FindFirstChild("LeftArmWrapped") ~= nil
vm._can_wrap_right_arm = child:FindFirstChild("RightArmWrapped") ~= nil
task.defer(child.Destroy, child)
elseif child.Name == "_left_arm" or child.Name == "_right_arm" then
local armName = child.Name == "_left_arm" and "LeftArm" or "RightArm"
local armPart = model:FindFirstChild(armName)
if not armPart then error("missing " .. armName) end
if child.Primary and child.Primary:IsA("BasePart") then
child.PrimaryPart = child.Primary
elseif child:FindFirstChild("Primary") and child.Primary and child.Primary:IsA("BasePart") then
child.PrimaryPart = child.Primary
end
if not child.PrimaryPart then
child.PrimaryPart = getgenv().Rivals_getItemVisualPrimaryPart(child)
end
if not child.PrimaryPart then error("missing primary for " .. child.Name) end
vm._arm_submodels[child] = {
OriginalScale = child:GetScale(),
HideInThirdPerson = child:GetAttribute("HideInThirdPerson"),
}
child.Parent = armPart
child:PivotTo(armPart.CFrame)
local weld = Instance.new("WeldConstraint")
weld.Part0 = armPart
weld.Part1 = child.PrimaryPart
weld.Parent = child.PrimaryPart
for _, desc in ipairs(child:GetDescendants()) do
if desc:IsA("BasePart") then
desc.CastShadow = false
desc.CanCollide = false
desc.CanTouch = false
desc.CanQuery = false
desc.Massless = true
desc.LocalTransparencyModifier = 0
if desc:GetAttribute("IgnoreTransparency") == nil then
desc:SetAttribute("IgnoreTransparency", true)
end
if desc ~= child.PrimaryPart then
local w = Instance.new("WeldConstraint")
w.Part0 = child.PrimaryPart
w.Part1 = desc
w.Parent = child.PrimaryPart
desc.Anchored = false
end
end
end
child.PrimaryPart.Anchored = false
end
end
pcall(function()
if type(vm._UpdateHiddenArmSubmodels) == "function" then
vm:_UpdateHiddenArmSubmodels(true)
end
end)
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
getgenv().Rivals_ensureViewModelCharmRigFromTemplate(vm)
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
end)
return ok
end
getgenv().Rivals_weaponNeedsFullViewModelReplace = function(wn, sn, vmFolder)
if not wn or not sn then return false end
vmFolder = vmFolder or localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
return vmFolder and getgenv().Rivals_skinHasViewModelModule(vmFolder, wn, sn) or false
end
getgenv().Rivals_setSkinModuleRedirect = function(wn, sn, vmFolder)
getgenv().Rivals_skinModuleRedirect = (sn and vmFolder) and { weapon=wn, skin=sn, alias=getgenv().Rivals_getViewModelModuleAlias(wn), folder=vmFolder } or nil
end
getgenv().Rivals_installSkinModuleRedirectHook = function()
if getgenv().Rivals_skinRedirectHooked then return end
pcall(function()
local function skinRedirectMatch(self, name)
local r = getgenv().Rivals_skinModuleRedirect
return r and r.folder and self == r.folder and type(name) == "string"
and (name == r.weapon or (r.alias and name == r.alias))
end
local function trySkinFindFirstChild(orig, self, name, ...)
if skinRedirectMatch(self, name) then
local r = getgenv().Rivals_skinModuleRedirect
local alt = orig(self, r.skin, ...)
if alt then return alt end
if r.alias then
alt = orig(self, r.alias, ...)
if alt then return alt end
end
end
return orig(self, name, ...)
end
local function trySkinWaitForChild(orig, self, name, ...)
if skinRedirectMatch(self, name) then
local r = getgenv().Rivals_skinModuleRedirect
local alt = orig(self, r.skin, ...)
if alt then return alt end
end
return orig(self, name, ...)
end
local instAny = Instance :: any
local _, ffcOth = getgenv().Rivals_withOthHook(instAny.FindFirstChild, trySkinFindFirstChild)
local _, wfcOth = getgenv().Rivals_withOthHook(instAny.WaitForChild, trySkinWaitForChild)
if not (ffcOth and wfcOth) then
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
local m = getnamecallmethod()
if m == "FindFirstChild" then
local name = ...
if skinRedirectMatch(self, name) then
return trySkinFindFirstChild(function(s, n, ...) return old(s, n, ...) end, self, name, select(2, ...))
end
elseif m == "WaitForChild" then
local name = ...
if skinRedirectMatch(self, name) then
return trySkinWaitForChild(function(s, n, ...) return old(s, n, ...) end, self, name, select(2, ...))
end
end
return old(self, ...)
end)
setreadonly(mt, true)
end
getgenv().Rivals_skinRedirectHooked = true
end)
end
getgenv().Rivals_enumKeyName = function(key)
if key=="Name" or key=="ViewModel" then return key end
if type(key)~="string" then return nil end
local ok, name = pcall(function() return require(RS.Modules.EnumLibrary):FromEnum(key) end)
return ok and name or nil
end
getgenv().Rivals_getWeaponNameFromItemSerial = function(serial)
if not serial or type(serial)~="table" then return nil end
local IL = require(RS.Modules.ItemLibrary)
local function scan(t, depth)
if type(t)~="table" or depth>6 then return nil end
for k,v in pairs(t) do
if getgenv().Rivals_enumKeyName(k)=="Name" and type(v)=="string" and IL.Items[v] then return v end
end
if type(t.Name)=="string" and IL.Items[t.Name] then return t.Name end
if t.Data then local r=scan(t.Data, depth+1); if r then return r end end
for _, v in pairs(t) do
if type(v) == "table" and v ~= t.Data then
local r = scan(v, depth + 1)
if r then return r end
end
end
return nil
end
return scan(serial, 0)
end
getgenv().Rivals_setSerialName = function(t, newName, backups)
if type(t)~="table" then return false end
for k,v in pairs(t) do
if getgenv().Rivals_enumKeyName(k)=="Name" and type(v)=="string" then
table.insert(backups,{t,k,v}); t[k]=newName; return true
end
end
if type(t.Name)=="string" then table.insert(backups,{t,"Name",t.Name}); t.Name=newName; return true end
return false
end
getgenv().Rivals_patchItemSerialForSkin = function(serial, wn, sn)
if not serial or not wn or not sn or sn=="" then return nil end
local IL = require(RS.Modules.ItemLibrary)
if not IL.ViewModels[sn] then return nil end
local backups = {}
local function patchVM(t, depth)
if type(t)~="table" or depth>8 then return end
for k,v in pairs(t) do
if getgenv().Rivals_enumKeyName(k)=="ViewModel" and type(v)=="table" then
getgenv().Rivals_setSerialName(v, sn, backups)
if type(v.Data)=="table" then getgenv().Rivals_setSerialName(v.Data, sn, backups) end
patchVM(v, depth+1)
elseif type(v)=="table" then patchVM(v, depth+1) end
end
end
patchVM(serial, 0); if serial.Data then patchVM(serial.Data, 0) end
local function patchFallback(t, depth, pIsData)
if type(t)~="table" or depth>8 then return end
if depth>=2 and not pIsData then
local cn
for k,v in pairs(t) do if getgenv().Rivals_enumKeyName(k)=="Name" and type(v)=="string" then cn=v; break end end
if cn==wn and IL.ViewModels[sn] then getgenv().Rivals_setSerialName(t, sn, backups) end
end
for k,v in pairs(t) do if type(v)=="table" then patchFallback(v, depth+1, pIsData and getgenv().Rivals_enumKeyName(k)=="Data") end end
end
if #backups==0 then patchFallback(serial, 0, false) end
if #backups==0 then return nil end
return function() for _,e in ipairs(backups) do e[1][e[2]]=e[3] end end
end
getgenv().Rivals_patchViewModelSerialName = function(serial, sn)
if not serial or not sn or sn=="" then return nil end
local backups = {}
local function pt(t)
if type(t)~="table" then return end
for k,v in pairs(t) do if getgenv().Rivals_enumKeyName(k)=="Name" and type(v)=="string" then table.insert(backups,{t,k,v}); t[k]=sn end end
if type(t.Name)=="string" then table.insert(backups,{t,"Name",t.Name}); t.Name=sn end
end
pt(serial); if serial.Data then pt(serial.Data) end
if #backups==0 then return nil end
return function() for _,e in ipairs(backups) do e[1][e[2]]=e[3] end end
end
getgenv().Rivals_getSkinOverrideName = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled or not wn then return nil end
local pick = getgenv().Rivals_getEffectiveCosmeticPick(wn, "skin")
if not pick then return nil end
local IL = require(RS.Modules.ItemLibrary)
return IL.ViewModels[pick] and pick or nil
end
getgenv().Rivals_getConfiguredSkinPick = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
return (cfg and wn) and (cfg.Skins[wn] or "None") or "None"
end
getgenv().Rivals_getWrapOverrideName = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled or not wn then return nil end
local pick = getgenv().Rivals_getEffectiveCosmeticPick(wn, "wrap")
if not pick then return nil end
local CL = require(RS.Modules.CosmeticLibrary)
return (CL.Cosmetics[pick] and CL.Cosmetics[pick].Type=="Wrap") and pick or nil
end
getgenv().Rivals_getConfiguredCharmPick = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not (cfg and wn) then return "None" end
local pick = cfg.Charms[wn]
if pick == nil or pick == "" then return "None" end
return pick
end
getgenv().Rivals_getCharmOverrideName = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled or not wn then return nil end
local pick = getgenv().Rivals_getEffectiveCosmeticPick(wn, "charm")
if not pick then return nil end
local CL = require(RS.Modules.CosmeticLibrary)
if not (CL.Cosmetics[pick] and CL.Cosmetics[pick].Type == "Charm") then return nil end
local charmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("Charms")
if charmAssets then
if charmAssets:FindFirstChild(pick, true) then return pick end
for _, desc in ipairs(charmAssets:GetDescendants()) do
if desc.Name == pick then return pick end
end
end
return pick
end
getgenv().Rivals_getAppearanceCharmTable = function(wn)
local cn = getgenv().Rivals_getCharmOverrideName(wn)
return cn and { Name = cn } or nil
end
getgenv().Rivals_getConfiguredFinisherPick = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not (cfg and wn) then return "None" end
local pick = cfg.Finishers[wn]
if pick == nil or pick == "" then return "None" end
return pick
end
getgenv().Rivals_getFinisherOverrideName = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled or not wn then return nil end
local pick = getgenv().Rivals_getEffectiveCosmeticPick(wn, "finisher")
if not pick then return nil end
local CL = require(RS.Modules.CosmeticLibrary)
local finisherMods = RS.Modules:FindFirstChild("Finishers")
if CL.Cosmetics[pick] and CL.Cosmetics[pick].Type == "Finisher" and finisherMods and finisherMods:FindFirstChild(pick) then
return pick
end
return nil
end
getgenv().Rivals_getAppearanceFinisherTable = function(wn)
local fn = getgenv().Rivals_getFinisherOverrideName(wn)
return fn and { Name = fn } or nil
end
getgenv().Rivals_resolveAppearanceWeaponName = function(owner)
if type(owner) == "string" and owner ~= "" then return owner end
if type(owner) == "table" then
if type(owner.Name) == "string" and owner.Name ~= "" and not owner.Model then
if owner.Info and owner.Info.Name then return owner.Info.Name end
return owner.Name
end
if owner.ClientItem and type(owner.ClientItem.Name) == "string" then
return owner.ClientItem.Name
end
if type(owner._rivalsWeaponName) == "string" and owner._rivalsWeaponName ~= "" then
return owner._rivalsWeaponName
end
end
return nil
end
getgenv().Rivals_isLocalEliminator = function(eliminator)
if eliminator == nil then return false end
if eliminator == localPlayer then return true end
if typeof(eliminator) == "Instance" then
if eliminator:IsA("Player") then return eliminator == localPlayer end
if eliminator:IsA("Model") then return eliminator == localPlayer.Character end
if eliminator:IsA("Humanoid") then
return localPlayer.Character ~= nil and eliminator.Parent == localPlayer.Character
end
end
if type(eliminator) == "number" then return eliminator == localPlayer.UserId end
if type(eliminator) == "string" then
return eliminator == localPlayer.Name or tonumber(eliminator) == localPlayer.UserId
end
if type(eliminator) == "table" then
if eliminator.Player == localPlayer then return true end
if eliminator.UserId == localPlayer.UserId then return true end
if eliminator.Name == localPlayer.Name then return true end
if eliminator.Character and localPlayer.Character and eliminator.Character == localPlayer.Character then return true end
end
local lf = getgenv().Rivals_getLocalFighter()
if lf then
if eliminator == lf then return true end
if lf.Player == eliminator then return true end
if lf.Entity and eliminator == lf.Entity then return true end
if lf.Player and type(eliminator) == "table" and eliminator.Player == lf.Player then return true end
end
return false
end
getgenv().Rivals_getFinisherWeaponName = function()
local state = getgenv().Rivals_weaponAppearanceState
local lf = getgenv().Rivals_getLocalFighter()
local eq = lf and lf.EquippedItem
local wn = eq and (eq.Name or (eq.Info and eq.Info.Name))
if type(wn) == "string" and wn ~= "" then
state.lastFinisherWeapon = wn
return wn
end
return state.lastFinisherWeapon
end
getgenv().Rivals_resolveFinisherForEffect = function(eliminator, defaultName)
if not getgenv().Rivals_isLocalEliminator(eliminator) then return defaultName end
local wn = getgenv().Rivals_getFinisherWeaponName()
if not wn then return defaultName end
return getgenv().Rivals_getFinisherOverrideName(wn) or defaultName
end
getgenv().Rivals_prepareLocalFinisherPlay = function(finisherName, eliminator, serial)
if not getgenv().Rivals_isLocalEliminator(eliminator) then
return finisherName, eliminator, serial, false
end
local wn = getgenv().Rivals_getFinisherWeaponName()
if not wn then return finisherName, eliminator, serial, false end
local override = getgenv().Rivals_getFinisherOverrideName(wn)
if not override then return finisherName, eliminator, serial, false end
local elimOut = localPlayer
if typeof(eliminator) == "Instance" and eliminator:IsA("Player") then
elimOut = eliminator
end
local serialOut
if type(serial) == "table" then
serialOut = getgenv().Rivals_cloneSerial(serial)
if serialOut.Seed == nil then serialOut.Seed = math.random(1, 1000000) end
serialOut.Name = override
else
serialOut = { Seed = math.random(1, 1000000), Name = override }
end
return override, elimOut, serialOut, true
end
getgenv().Rivals_playFinisherFully = function(finisher)
if not finisher then return end
if type(finisher.Simulate) == "function" then
local ok = pcall(function() finisher:Simulate() end)
if ok then return end
end
local doneServer, doneClient = false, false
task.spawn(function()
pcall(function()
if type(finisher.PlayServer) == "function" then finisher:PlayServer(true) end
end)
doneServer = true
end)
task.spawn(function()
pcall(function()
if type(finisher.PlayClient) == "function" then finisher:PlayClient(true) end
end)
doneClient = true
end)
local t0 = os.clock()
while (not doneServer or not doneClient) and (os.clock() - t0) < 15 do
task.wait()
end
end
getgenv().Rivals_getAppearanceSkinTable = function(wn)
local sn = getgenv().Rivals_getSkinOverrideName(wn)
return sn and {Name=sn} or nil
end
getgenv().Rivals_getWeaponIconImage = function(wn, highRes, baseOnly)
if not wn then return "" end
local cache = getgenv().Rivals_guiImageCache
local key = getgenv().Rivals_getWeaponIconCacheKey(wn, highRes, baseOnly)
if cache[key] then return cache[key] end
local sn = ""
if not baseOnly then sn = getgenv().Rivals_getSkinOverrideName(wn) or "" end
local wd = { Name = wn, _rivalsLocalPatched = true }
if sn ~= "" then wd.Skin = { Name = sn } end
local img = getgenv().Rivals_resolveWeaponIconImage(wn, wd, highRes) or ""
if img == "" then
pcall(function()
local IL = require(RS.Modules.ItemLibrary)
local fn = IL._rivalsOrigGetViewModelImage or IL.GetViewModelImage
img = fn(IL, wn, wd.Skin, highRes) or ""
if img == "" and IL.ViewModels[wn] then
img = (highRes and IL.ViewModels[wn].ImageHighResolution) or IL.ViewModels[wn].Image or ""
end
end)
end
if img ~= "" then cache[key] = img end
return img
end
getgenv().Rivals_getHotbarIconForItem = function(clientItem)
if not clientItem or not clientItem.Name then return "" end
local wn = clientItem.Name
local wd = { Name = wn, _rivalsLocalPatched = true }
local sn = getgenv().Rivals_getSkinOverrideName(wn)
if sn then wd.Skin = { Name = sn } end
return getgenv().Rivals_resolveWeaponIconImage(wn, wd, false) or ""
end
getgenv().Rivals_getItemViewModelName = function(item)
if not item then return nil end
local vm = item.ViewModel
if vm then
if vm.Name then return vm.Name end
local n; pcall(function() if type(vm.Get)=="function" then n=vm:Get("Name") end end)
if type(n)=="string" then return n end
end
return item.Name
end
getgenv().Rivals_getItemViewModelSerial = function(item)
if not item then return nil end
local vm = item.ViewModel
if vm and vm._serial then return vm._serial end
local r; pcall(function() if type(item.Get)=="function" then r=item:Get("ViewModel") end end)
return type(r)=="table" and r or nil
end
getgenv().Rivals_getItemVisualModelName = function(item)
return getgenv().Rivals_getItemViewModelName(item)
end
getgenv().Rivals_getClientViewModelModuleScript = function(ps)
ps = ps or localPlayer:FindFirstChild("PlayerScripts")
if not ps then return nil end
local ci = ps.Modules.ClientReplicatedClasses.ClientFighter:FindFirstChild("ClientItem")
return ci and ci:FindFirstChild("ClientViewModel") or nil
end
getgenv().Rivals_cloneSerial = function(serial)
if type(serial) ~= "table" then return serial end
local seen = {}
local function copy(t)
if type(t) ~= "table" then return t end
if seen[t] then return seen[t] end
local c = {}
seen[t] = c
for k, v in pairs(t) do c[k] = copy(v) end
return c
end
return copy(serial)
end
getgenv().Rivals_skinHasViewModelModule = function(vmFolder, wn, sn)
if not sn or not vmFolder or not wn then return false end
local skinMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, sn)
local baseMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, nil)
return skinMod ~= nil and baseMod ~= nil and skinMod ~= baseMod
end
getgenv().Rivals_resolveViewModelModule = function(vmFolder, wn, sn)
local baseMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, nil)
if not sn then return baseMod, false end
local skinMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, sn)
if skinMod and baseMod and skinMod ~= baseMod then return skinMod, false end
return baseMod, true
end
getgenv().Rivals_findItemSlot = function(lf, item)
if not lf or not lf.Items or not item then return nil end
for k, v in pairs(lf.Items) do
if v == item then return k end
end
return nil
end
getgenv().Rivals_findOtherItemSlot = function(lf, item)
if not lf or not lf.Items then return nil end
for k, v in pairs(lf.Items) do
if v ~= item and v and v.Name then return k end
end
return nil
end
getgenv().Rivals_encodeReplicationTable = function(item, data)
if type(data) ~= "table" then return data end
local encoded = {}
for k, v in pairs(data) do
local ek = k
if item and type(item.ToEnum) == "function" then
pcall(function() ek = item:ToEnum(k) or k end)
end
encoded[ek] = v
end
return encoded
end
getgenv().Rivals_buildClientItemSerial = function(item, wn, sn)
if not item or not wn then return nil end
local EL = require(RS.Modules.EnumLibrary)
pcall(function() EL:WaitForEnumBuilder() end)
local function enum(name)
local ok, key = pcall(function() return EL:ToEnum(name) end)
return ok and key or name
end
local serial = {}
serial[enum("Name")] = wn
if item.Data then
serial[enum("Data")] = getgenv().Rivals_encodeReplicationTable(item, getgenv().Rivals_cloneSerial(item.Data))
end
local vmSerial = {}
vmSerial[enum("Name")] = sn or wn
serial[enum("ViewModel")] = vmSerial
return serial
end
getgenv().Rivals_getClientItemCreationSerial = function(item, wn, sn)
if not item or not wn then return nil end
local EL = require(RS.Modules.EnumLibrary)
pcall(function() EL:WaitForEnumBuilder() end)
local function enum(name)
local ok, key = pcall(function() return EL:ToEnum(name) end)
return ok and key or name
end
local serial
local ok = pcall(function() serial = item:Serialize() end)
if ok and type(serial) == "table" then
serial = getgenv().Rivals_cloneSerial(serial)
if not serial[enum("ViewModel")] then
serial = getgenv().Rivals_buildClientItemSerial(item, wn, sn)
end
else
serial = getgenv().Rivals_buildClientItemSerial(item, wn, sn)
end
if not serial then return nil end
if sn then getgenv().Rivals_patchItemSerialForSkin(serial, wn, sn) end
return serial
end
getgenv().Rivals_repickLoadoutForAppearance = function(preferredWeapon, preferredSlot)
local lf = getgenv().Rivals_getLocalFighter()
if not lf then return false end
local weapons
pcall(function() weapons = lf:Get("LastPickedWeapons") end)
if (type(weapons) ~= "table" or #weapons == 0) and lf.Data then weapons = lf.Data.LastPickedWeapons end
if type(weapons) ~= "table" or #weapons == 0 then return false end
pcall(function() RS.Remotes.Replication.Fighter.PickWeapons:FireServer(weapons) end)
task.defer(function()
for _ = 1, 40 do
task.wait(0.05)
local ready = true
for i, name in ipairs(weapons) do
local item = lf.Items[i]
if not item or item.Name ~= name or not item.ViewModel then ready = false; break end
end
if ready then break end
end
local slot = preferredSlot
if not slot and preferredWeapon then
for k, v in pairs(lf.Items) do
if v and v.Name == preferredWeapon then slot = k; break end
end
end
if slot then pcall(function() lf:EquipItem(slot) end) end
for _, item in pairs(lf.Items) do
if item and item.Name and item.ViewModel then
getgenv().Rivals_hookViewModelAppearance(item.ViewModel, item.Name)
getgenv().Rivals_safeViewModelUpdateWrap(item.ViewModel)
getgenv().Rivals_safeViewModelUpdateCharm(item.ViewModel)
item._rivalsAppliedSkinPick = getgenv().Rivals_getConfiguredSkinPick(item.Name)
end
end
getgenv().Rivals_refreshHotbarIcons(lf)
end)
return true
end
getgenv().Rivals_refreshViewModelAnimatorInfo = function(vm)
if not vm or not vm.Animator or not vm.Info then return end
pcall(function()
vm.Animator._viewmodel_animations = vm.Info.Animations
vm.Animator._play_animations_instantly = vm.Info.PlayAnimationsInstantly
end)
end
getgenv().Rivals_reloadViewModelAnimator = function(vm)
if not vm or not vm.Animator or not vm.Info then return false end
local anim = vm.Animator
local ok = pcall(function()
if type(anim.StopAllAnimations) == "function" then anim:StopAllAnimations() end
if type(anim._animation_cleanup) == "table" then
for _, obj in ipairs(anim._animation_cleanup) do pcall(function() obj:Destroy() end) end
end
anim._animation_cleanup = {}
anim._animation_tracks = {}
anim._animation_hashes = {}
anim._animation_keys_lookup = {}
if type(anim._animation_threads) == "table" then
for _, thread in pairs(anim._animation_threads) do pcall(function() task.cancel(thread) end) end
end
anim._animation_threads = {}
anim._animations_loaded = false
anim._equip_animation = nil
anim._idle_animation = nil
anim._inspect_animation = nil
anim._rare_inspect_animation = nil
anim._sprint_animation = nil
getgenv().Rivals_refreshViewModelAnimatorInfo(vm)
if type(anim.LoadAnimations) == "function" then anim:LoadAnimations() end
end)
return ok
end
getgenv().Rivals_refreshViewModelAmmoVisuals = function(vm)
if not vm or not vm.ItemModel then return end
pcall(function()
if type(vm._RegisterDefaultAmmoVisuals) == "function" then
vm:_RegisterDefaultAmmoVisuals()
return
end
if type(vm._RegisterAmmoVisual) ~= "function" then return end
for _, folderName in ipairs({ "ReloadBullets", "Bullets" }) do
local folder = vm.ItemModel:FindFirstChild(folderName, true)
if folder then
for i = 1, 6 do
local part = folder:FindFirstChild(tostring(i)) or folder:FindFirstChild(i)
if part then vm:_RegisterAmmoVisual(folderName, part) end
end
end
end
end)
end
getgenv().Rivals_isArmColorBlack = function(c)
return typeof(c) == "Color3" and c.R < 0.02 and c.G < 0.02 and c.B < 0.02
end
getgenv().Rivals_getCharacterArmsAppearance = function()
local shirtId, leftColor, rightColor
pcall(function()
local char = localPlayer.Character
if not char then return end
local shirt = char:FindFirstChildOfClass("Shirt")
if shirt then shirtId = shirt.ShirtTemplate end
local bc = char:FindFirstChild("Body Colors") or char:FindFirstChildOfClass("BodyColors")
if bc then
leftColor = bc.LeftArmColor3
rightColor = bc.RightArmColor3
end
end)
return shirtId, leftColor, rightColor
end
getgenv().Rivals_refreshPersistentArmsSnap = function()
local snap = getgenv()._rivalsPersistentArmsSnap or {}
local charShirt, charL, charR = getgenv().Rivals_getCharacterArmsAppearance()
local isBlack = getgenv().Rivals_isArmColorBlack
if charShirt and charShirt ~= "" then snap.shirtId = charShirt end
if charL and not isBlack(charL) then snap.leftColor = charL end
if charR and not isBlack(charR) then snap.rightColor = charR end
getgenv()._rivalsPersistentArmsSnap = snap
return snap
end
getgenv().Rivals_captureViewModelArms = function(vm)
local persist = getgenv().Rivals_refreshPersistentArmsSnap()
local isBlack = getgenv().Rivals_isArmColorBlack
local snap = {
shirtId = persist.shirtId,
leftColor = persist.leftColor,
rightColor = persist.rightColor,
}
if not vm then return snap end
pcall(function()
local shirt = vm._shirt_id
if shirt and shirt ~= "" then snap.shirtId = shirt end
if vm._left_arm_color and not isBlack(vm._left_arm_color) then snap.leftColor = vm._left_arm_color end
if vm._right_arm_color and not isBlack(vm._right_arm_color) then snap.rightColor = vm._right_arm_color end
if vm._left_arm and not isBlack(vm._left_arm.Color) then
snap.leftPartColor = vm._left_arm.Color
snap.leftColor = snap.leftColor or vm._left_arm.Color
end
if vm._right_arm and not isBlack(vm._right_arm.Color) then
snap.rightPartColor = vm._right_arm.Color
snap.rightColor = snap.rightColor or vm._right_arm.Color
end
if vm._left_arm_shirt_texture and vm._left_arm_shirt_texture.Texture ~= "" then
snap.leftShirt = vm._left_arm_shirt_texture.Texture
if not snap.shirtId or snap.shirtId == "" then snap.shirtId = snap.leftShirt end
end
if vm._right_arm_shirt_texture and vm._right_arm_shirt_texture.Texture ~= "" then
snap.rightShirt = vm._right_arm_shirt_texture.Texture
if not snap.shirtId or snap.shirtId == "" then snap.shirtId = snap.rightShirt end
end
end)
if snap.leftColor and not isBlack(snap.leftColor) then persist.leftColor = snap.leftColor end
if snap.rightColor and not isBlack(snap.rightColor) then persist.rightColor = snap.rightColor end
if snap.shirtId and snap.shirtId ~= "" then persist.shirtId = snap.shirtId end
return snap
end
getgenv().Rivals_restoreViewModelArms = function(vm, snap)
if not vm then return end
local persist = getgenv().Rivals_refreshPersistentArmsSnap()
local isBlack = getgenv().Rivals_isArmColorBlack
snap = snap or persist or {}
pcall(function()
getgenv().Rivals_ensureViewModelArmParts(vm)
if vm.Model then
for _, armName in ipairs({ "LeftArm", "RightArm" }) do
local arm = vm.Model:FindFirstChild(armName)
if arm and arm:IsA("BasePart") then
pcall(function()
if type(vm._LocalTransparencyModifier) == "function" then
vm:_LocalTransparencyModifier(arm, "ArmSubmodelSkin", 0)
end
end)
end
end
end
local shirt = snap.shirtId
if shirt == nil or shirt == "" then shirt = snap.leftShirt or snap.rightShirt end
if shirt == nil or shirt == "" then shirt = persist.shirtId end
local leftColor = snap.leftColor or snap.leftPartColor or persist.leftColor
local rightColor = snap.rightColor or snap.rightPartColor or persist.rightColor
if isBlack(leftColor) then leftColor = persist.leftColor end
if isBlack(rightColor) then rightColor = persist.rightColor end
if type(vm.SetArmsData) == "function" and leftColor and rightColor then
vm:SetArmsData(shirt or "", leftColor, rightColor)
else
if shirt ~= nil and shirt ~= "" then
vm._shirt_id = shirt
if vm._left_arm_shirt_texture then vm._left_arm_shirt_texture.Texture = shirt end
if vm._right_arm_shirt_texture then vm._right_arm_shirt_texture.Texture = shirt end
end
if leftColor and vm._left_arm then
vm._left_arm_color = leftColor
vm._left_arm.Color = leftColor
end
if rightColor and vm._right_arm then
vm._right_arm_color = rightColor
vm._right_arm.Color = rightColor
end
if leftColor and vm._left_arm_wrapped_part then vm._left_arm_wrapped_part.Color = leftColor end
if rightColor and vm._right_arm_wrapped_part then vm._right_arm_wrapped_part.Color = rightColor end
pcall(function() if type(vm._UpdateArms) == "function" then vm:_UpdateArms() end end)
end
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
end)
end
getgenv().Rivals_snapViewModelEquipSpring = function(vm)
if not vm then return end
pcall(function()
local s = vm._equip_spring
if not s then return end
s.Target = 0
s.Value = 0
if s.Velocity ~= nil then s.Velocity = 0 end
end)
end
getgenv().Rivals_cloneSkinItemVisualChildren = function(iv, template)
if not iv or not template then return end
for _, ch in ipairs(template:GetChildren()) do
if ch.Name ~= "_left_arm" and ch.Name ~= "_right_arm" then
ch:Clone().Parent = iv
end
end
end
getgenv().Rivals_finalizeViewModelSkinSwap = function(item, vm, wn, wasEquipped, keepEquipped, armsSnap)
if not item or not vm then return end
armsSnap = armsSnap or getgenv().Rivals_refreshPersistentArmsSnap()
if vm.Name == "Lasso" or getgenv().Rivals_findLassoRopeConstraint(vm.ItemModel) then
getgenv().Rivals_ensureLassoViewModelState(vm)
end
if vm.Name == "Lasso" then
getgenv().Rivals_ensureLassoViewModelState(vm)
getgenv().Rivals_connectLassoAnimationHooks(vm)
end
getgenv().Rivals_ensureViewModelArmParts(vm)
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
getgenv().Rivals_refreshViewModelAmmoVisuals(vm)
getgenv().Rivals_hookViewModelAppearance(vm, wn or item.Name)
local wrapWn = wn or item.Name
local function finishSwap()
getgenv().Rivals_reloadViewModelAnimator(vm)
if vm.Name == "Lasso" then
getgenv().Rivals_ensureLassoViewModelState(vm)
getgenv().Rivals_connectLassoAnimationHooks(vm)
end
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
pcall(function() vm:_UpdateSubModelVisibility() end)
getgenv().Rivals_ensureViewModelCharmRigFromTemplate(vm)
getgenv().Rivals_rebindViewModelCharmRig(vm)
getgenv().Rivals_applyViewModelWrap(vm, wrapWn, true)
getgenv().Rivals_applyViewModelCharm(vm, wrapWn, true)
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
getgenv().Rivals_snapViewModelEquipSpring(vm)
getgenv().Rivals_rebindViewModelCharmRig(vm)
pcall(function()
if vm.Animator and type(vm.Animator.PlayIdleAnimation) == "function" then
vm.Animator:PlayIdleAnimation()
end
end)
getgenv().Rivals_applyViewModelOffset()
getgenv().Rivals_snapViewModelEquipSpring(vm)
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
end
if keepEquipped then
task.defer(finishSwap)
getgenv().Rivals_snapViewModelEquipSpring(vm)
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
return
end
if wasEquipped then
getgenv().Rivals_reEquipClientItem(item, true, finishSwap)
else
task.defer(finishSwap)
end
end
getgenv().Rivals_cleanupViewModelItemVisuals = function(vm)
if not vm or not vm.Model then return end
pcall(function()
for _, ch in ipairs(vm.Model:GetChildren()) do
if ch:IsA("Model") then ch:Destroy() end
end
local prim = vm.Model.PrimaryPart
if prim then
for _, ch in ipairs(prim:GetChildren()) do
if ch:IsA("Motor6D") and ch.Name:find("ItemVisual", 1, true) then ch:Destroy() end
end
end
if vm.ItemModel then pcall(function() vm.ItemModel:Destroy() end); vm.ItemModel = nil end
end)
end
getgenv().Rivals_resetViewModelSetupState = function(vm)
if not vm then return end
getgenv().Rivals_cleanupViewModelItemVisuals(vm)
pcall(function()
vm._muzzle_attachments={}; vm._animation_context_submodels={}; vm._hidden_submodels={}
vm._arm_submodels={}; vm._submodel_boundingbox_attachments={}; vm._submodels_behind_head_values={}
vm._wrapped_only_objects={}; vm._can_wrap_left_arm=false; vm._can_wrap_right_arm=false
vm._left_arm=nil; vm._right_arm=nil; vm._original_wrap_properties=nil; vm._charm_sub_model=nil
vm._body_model=nil; vm._aim_position_attachment=nil; vm._aim_lookat_attachment=nil
vm._center_attachment=nil; vm._charm_attachment_model=nil; vm._charm_pivot_attachment=nil
vm._scope_glare_attachment=nil; vm._local_transparency_modifiers={}; vm._local_transparency_modifier_update={}
if vm._scope_glare_gui1 then pcall(function() vm._scope_glare_gui1:Destroy() end); vm._scope_glare_gui1=nil end
if vm._scope_glare_gui2 then pcall(function() vm._scope_glare_gui2:Destroy() end); vm._scope_glare_gui2=nil end
end)
end
getgenv().Rivals_BOX_CORNER_OFFSETS = getgenv().Rivals_BOX_CORNER_OFFSETS or {
Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, 0.5),
Vector3.new(-0.5, 0.5, -0.5), Vector3.new(0.5, 0.5, -0.5),
Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5),
Vector3.new(-0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, -0.5),
}
getgenv().Rivals_clearItemVisualSubmodelState = function(vm)
if not vm then return end
vm._animation_context_submodels = {}
vm._submodel_boundingbox_attachments = {}
end
getgenv().Rivals_getStaticViewModelModule = function()
if getgenv()._rivalsStaticViewModelMod ~= nil then return getgenv()._rivalsStaticViewModelMod or nil end
local ok, mod = pcall(function()
return require(localPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
end)
getgenv()._rivalsStaticViewModelMod = ok and mod or false
return ok and mod or nil
end
getgenv().Rivals_rebindViewModelCharmRig = function(vm, relOverride)
if not vm or not vm.ItemModel then return false end
local liveBody = vm.ItemModel:FindFirstChild("Body")
if not liveBody then return false end
local charmModel = liveBody:FindFirstChild("_charm_attachment_model")
if not charmModel then return false end
local livePrimary = liveBody:FindFirstChild(liveBody.Name .. "Primary")
or liveBody.PrimaryPart
or liveBody:FindFirstChild("Primary")
local charmPrimary = charmModel:FindFirstChild("Primary", true)
if not livePrimary or not charmPrimary or not charmPrimary:IsA("BasePart") then return false end
for _, d in ipairs(charmPrimary:GetChildren()) do
if d:IsA("WeldConstraint") and d.Name == "_rivals_charm_rig_weld" then
d:Destroy()
end
end
local rel = relOverride or vm._rivals_charm_rig_rel
if not rel then
rel = livePrimary.CFrame:ToObjectSpace(charmPrimary.CFrame)
end
vm._rivals_charm_rig_rel = rel
charmPrimary.CFrame = livePrimary.CFrame * rel
charmPrimary.Anchored = false
charmPrimary.CanCollide = false
charmPrimary.CanTouch = false
charmPrimary.CanQuery = false
charmPrimary.Massless = true
local weld = Instance.new("WeldConstraint")
weld.Name = "_rivals_charm_rig_weld"
weld.Part0 = livePrimary
weld.Part1 = charmPrimary
weld.Parent = charmPrimary
for _, desc in ipairs(charmModel:GetDescendants()) do
if desc:IsA("BasePart") and desc ~= charmPrimary then
desc.Anchored = false
desc.Massless = true
desc.CanCollide = false
desc.CanTouch = false
desc.CanQuery = false
if desc.Parent and desc.Parent:IsA("BasePart") and desc.Parent ~= charmPrimary then
local hasWeld = false
for _, ch in ipairs(desc.Parent:GetChildren()) do
if ch:IsA("WeldConstraint") and (ch.Part0 == desc.Parent or ch.Part1 == desc) then
hasWeld = true
break
end
end
if not hasWeld then
local w = Instance.new("WeldConstraint")
w.Part0 = charmPrimary
w.Part1 = desc
w.Parent = charmPrimary
end
end
end
end
vm._charm_attachment_model = charmModel
return true
end
getgenv().Rivals_rebindViewModelCharmRigIfNeeded = function(vm)
if not vm or not vm.ItemModel then return false end
local liveBody = vm.ItemModel:FindFirstChild("Body")
local charmModel = liveBody and liveBody:FindFirstChild("_charm_attachment_model")
if not charmModel then return false end
local charmPrimary = charmModel:FindFirstChild("Primary", true)
local livePrimary = liveBody and (liveBody:FindFirstChild(liveBody.Name .. "Primary") or liveBody.PrimaryPart or liveBody:FindFirstChild("Primary"))
if not charmPrimary or not livePrimary then return false end
local hasWeld = false
for _, d in ipairs(charmPrimary:GetChildren()) do
if d:IsA("WeldConstraint") and d.Name == "_rivals_charm_rig_weld" then
hasWeld = true
break
end
end
if not hasWeld then return getgenv().Rivals_rebindViewModelCharmRig(vm) end
local rel = vm._rivals_charm_rig_rel
if rel then
local expected = livePrimary.CFrame * rel
if (charmPrimary.CFrame.Position - expected.Position).Magnitude > 0.08 then
return getgenv().Rivals_rebindViewModelCharmRig(vm)
end
end
return true
end
getgenv().Rivals_ensureViewModelCharmRigFromTemplate = function(vm)
if not vm or not vm.ItemModel then return false end
if vm.Model and vm.Model:FindFirstChild("_charm_pivot_attachment", true) then
getgenv().Rivals_rebindViewModelCharmRig(vm)
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
return true
end
local vmName = vm.Name
if not vmName or vmName == "" then return false end
local Utility = require(RS.Modules.Utility)
local vmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("ViewModels")
if not vmAssets then return false end
local template = Utility:LookThrough(vmAssets, vmName)
if not template then return false end
local liveBody = vm.ItemModel:FindFirstChild("Body")
local templateBody = template:FindFirstChild("Body")
local templateCharm = (templateBody and templateBody:FindFirstChild("_charm_attachment_model"))
or template:FindFirstChild("_charm_attachment_model", true)
if not templateCharm or not liveBody then
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
return vm._charm_pivot_attachment ~= nil
end
if liveBody:FindFirstChild("_charm_attachment_model") then
getgenv().Rivals_rebindViewModelCharmRig(vm)
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
return vm._charm_pivot_attachment ~= nil
end
local templatePrimary = templateBody and (templateBody.PrimaryPart or templateBody:FindFirstChild("Primary"))
local templateCharmPrimary = templateCharm:FindFirstChild("Primary", true)
local relFromTemplate = nil
if templatePrimary and templateCharmPrimary and templatePrimary:IsA("BasePart") and templateCharmPrimary:IsA("BasePart") then
relFromTemplate = templatePrimary.CFrame:ToObjectSpace(templateCharmPrimary.CFrame)
end
local rigOk = pcall(function()
local clone = templateCharm:Clone()
clone.Name = "_charm_attachment_model"
clone.Parent = liveBody
vm._charm_attachment_model = clone
end)
if rigOk then
getgenv().Rivals_rebindViewModelCharmRig(vm, relFromTemplate)
end
if rigOk then
local SVM = getgenv().Rivals_getStaticViewModelModule()
if SVM and type(SVM.ForceCharmAttachmentModelVisible) == "function" then
pcall(function() SVM.ForceCharmAttachmentModelVisible(vm) end)
end
if SVM and type(SVM._UpdateCharmAttachmentModelVisibility) == "function" then
pcall(function() SVM._UpdateCharmAttachmentModelVisibility(vm) end)
end
end
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
return vm._charm_pivot_attachment ~= nil
end
getgenv().Rivals_syncCharmAttachmentRefs = function(vm)
if not vm then return end
local SVM = getgenv().Rivals_getStaticViewModelModule()
if SVM then
pcall(function()
if type(SVM.ForceCharmAttachmentModelVisible) == "function" then SVM.ForceCharmAttachmentModelVisible(vm) end
if type(SVM._UpdateCharmAttachmentModelVisibility) == "function" then SVM._UpdateCharmAttachmentModelVisibility(vm) end
if type(SVM.GetCharmPivotAttachment) == "function" then
local pivot = SVM.GetCharmPivotAttachment(vm)
if pivot then vm._charm_pivot_attachment = pivot end
end
end)
end
if vm._charm_pivot_attachment and vm.ItemModel then
vm._charm_sub_model = nil
for _, child in ipairs(vm.ItemModel:GetChildren()) do
if child:IsA("Model") and vm._charm_pivot_attachment:IsDescendantOf(child) then
vm._charm_sub_model = child
break
end
end
end
end
getgenv().Rivals_refreshViewModelAttachmentRefs = function(vm)
if not vm or not vm.Model then return end
local model = vm.Model
pcall(function()
local iv = vm.ItemModel
vm._body_model = (iv and iv:FindFirstChild("Body")) or model:FindFirstChild("Body", true) or model:FindFirstChild("Body")
vm._aim_position_attachment = model:FindFirstChild("_aim_position", true)
vm._aim_lookat_attachment = model:FindFirstChild("_aim_lookat", true)
vm._center_attachment = model:FindFirstChild("_center", true)
vm._charm_attachment_model = model:FindFirstChild("_charm_attachment_model", true)
vm._charm_pivot_attachment = vm._charm_attachment_model and vm._charm_attachment_model:FindFirstChild("_charm_pivot_attachment", true) or model:FindFirstChild("_charm_pivot_attachment", true)
vm._scope_glare_attachment = model:FindFirstChild("_scope_glare", true)
end)
if not vm._charm_pivot_attachment then
getgenv().Rivals_syncCharmAttachmentRefs(vm)
elseif vm._charm_pivot_attachment and vm.ItemModel then
vm._charm_sub_model = nil
for _, child in ipairs(vm.ItemModel:GetChildren()) do
if child:IsA("Model") and vm._charm_pivot_attachment:IsDescendantOf(child) then
vm._charm_sub_model = child
break
end
end
end
end
getgenv().Rivals_rebuildViewModelMuzzleAttachments = function(vm)
if not vm or not vm.Model then return end
vm._muzzle_attachments = {}
local muzzleFlashes = localPlayer.PlayerScripts.Assets.Misc.MuzzleFlashes
for _, desc in ipairs(vm.Model:GetDescendants()) do
if desc.Name == "_muzzle" then
for _, ch in ipairs(desc:GetChildren()) do
if ch:IsA("ParticleEmitter") or ch:IsA("PointLight") or ch:IsA("SpotLight") then ch:Destroy() end
end
table.insert(vm._muzzle_attachments, desc)
local flashName = desc:GetAttribute("MuzzleFlashParticlesName")
local flash = (flashName and muzzleFlashes:FindFirstChild(flashName))
or muzzleFlashes:FindFirstChild(vm.Name)
or (vm.ClientItem and muzzleFlashes:FindFirstChild(vm.ClientItem.Name))
or muzzleFlashes.Default
local flashAtt = flash and flash:FindFirstChild("Attachment")
if flashAtt then
for _, ch in ipairs(flashAtt:GetChildren()) do ch:Clone().Parent = desc end
end
end
end
end
getgenv().Rivals_parseAnimationContexts = function(value)
if type(value) ~= "string" or value == "" then return nil end
local contexts = {}
if string.split then
for _, part in ipairs(string.split(value, ", ")) do
if part ~= "" then contexts[#contexts+1] = part end
end
else
contexts[1] = value
end
return #contexts > 0 and contexts or nil
end
getgenv().Rivals_resetViewModelMotionState = function(vm)
if not vm then return end
pcall(function()
vm.CurrentBobbingValue = Vector2.zero
vm.CurrentRecoilValue = Vector3.zero
vm.CurrentSwayValue = Vector2.zero
vm.CurrentJumpValue = 0
vm.CurrentInspectValue = 0
vm.CurrentLandingValue = 0
end)
end
getgenv().Rivals_getItemVisualPrimaryPart = function(child)
if not child then return nil end
if child.Primary and child.Primary:IsA("BasePart") then return child.Primary end
local primary = child:FindFirstChild("Primary")
if primary and primary:IsA("BasePart") then return primary end
if child.PrimaryPart and child.PrimaryPart:IsA("BasePart") then return child.PrimaryPart end
for _, desc in ipairs(child:GetDescendants()) do
if desc:IsA("BasePart") and desc.Name ~= "Primary" then return desc end
end
return child:FindFirstChildWhichIsA("BasePart", true)
end
getgenv().Rivals_getViewModelTemplateRefCFrame = function(template)
if not template then return nil end
for _, ch in ipairs(template:GetChildren()) do
if ch.Name ~= "_fake" and ch.Name ~= "_right_arm" and ch.Name ~= "_left_arm" then
local prim = getgenv().Rivals_getItemVisualPrimaryPart(ch)
if prim then return prim.CFrame end
end
end
return nil
end
getgenv().Rivals_computeItemVisualMotorOffset = function(child, template, layoutRefCFrame)
local c0 = child:GetAttribute("C0")
local c1 = child:GetAttribute("C1")
if c0 then return c0, c1 or CFrame.identity end
layoutRefCFrame = layoutRefCFrame or (template and getgenv().Rivals_getViewModelTemplateRefCFrame(template))
local prim = getgenv().Rivals_getItemVisualPrimaryPart(child)
if prim and layoutRefCFrame then
return prim.CFrame:ToObjectSpace(layoutRefCFrame):Inverse(), CFrame.identity
end
return CFrame.identity, CFrame.identity
end
getgenv().Rivals_ensureViewModelArmParts = function(vm)
if not vm or not vm.Model then return end
pcall(function()
local model = vm.Model
local left = model:FindFirstChild("LeftArm")
local right = model:FindFirstChild("RightArm")
vm._left_arm = left
vm._right_arm = right
if left then
vm._left_arm_shirt_texture = left:FindFirstChild("ShirtTexture") or vm._left_arm_shirt_texture
local wrapped = left:FindFirstChild("LeftArmWrapped")
or model:FindFirstChild("LeftArmWrapped", true)
if wrapped then
wrapped.Parent = left
vm._left_arm_wrapped_part = wrapped
end
end
if right then
vm._right_arm_shirt_texture = right:FindFirstChild("ShirtTexture") or vm._right_arm_shirt_texture
local wrapped = right:FindFirstChild("RightArmWrapped")
or model:FindFirstChild("RightArmWrapped", true)
if wrapped then
wrapped.Parent = right
vm._right_arm_wrapped_part = wrapped
end
end
end)
end
getgenv().Rivals_clearItemVisualMotors = function(vm)
if not vm or not vm.Model or not vm.Model.PrimaryPart then return end
local primaryPart = vm.Model.PrimaryPart
for _, ch in ipairs(primaryPart:GetChildren()) do
if ch:IsA("Motor6D") and ch.Name:find("ItemVisual", 1, true) then
ch:Destroy()
end
end
end
getgenv().Rivals_isUnderItemVisualNamed = function(inst, root, modelName)
if not inst or not root or not modelName then return false end
local p = inst
while p and p ~= root do
if p.Name == modelName then return true end
p = p.Parent
end
return false
end
getgenv().Rivals_setupItemVisualOnly = function(vm, skipTransformReset, skinTemplate)
if not vm or not vm.Model or not vm.ItemModel then return false end
local model = vm.Model
local iv = vm.ItemModel
local primaryPart = model.PrimaryPart
if not primaryPart then return false end
getgenv().Rivals_ensureViewModelArmParts(vm)
vm._local_transparency_modifiers = {}
vm._local_transparency_modifier_update = {}
getgenv().Rivals_clearItemVisualSubmodelState(vm)
getgenv().Rivals_clearItemVisualMotors(vm)
for _, child in ipairs(iv:GetChildren()) do
if child.Name == "_left_arm" or child.Name == "_right_arm" then
child:Destroy()
elseif child.Name == "_fake" then
vm._can_wrap_left_arm = child:FindFirstChild("LeftArmWrapped") ~= nil
vm._can_wrap_right_arm = child:FindFirstChild("RightArmWrapped") ~= nil
task.defer(child.Destroy, child)
end
end
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
local childOk = true
local ok = pcall(function()
iv.Name = "ItemVisual"
if iv.Parent ~= model then iv.Parent = model end
local layoutRefCFrame = nil
for _, child in ipairs(iv:GetChildren()) do
local childSetupOk = pcall(function()
if child.Name == "_fake" or child.Name == "_left_arm" or child.Name == "_right_arm" then
return
end
if child.Primary and child.Primary:IsA("BasePart") then
child.PrimaryPart = child.Primary
elseif child:FindFirstChild("Primary") and child.Primary:IsA("BasePart") then
child.PrimaryPart = child.Primary
end
local partPrimary = child.PrimaryPart or getgenv().Rivals_getItemVisualPrimaryPart(child)
if not partPrimary then error("missing primary for " .. child.Name) end
child.PrimaryPart = partPrimary
layoutRefCFrame = layoutRefCFrame or partPrimary.CFrame
partPrimary.Anchored = true
for _, desc in ipairs(child:GetDescendants()) do
if desc:IsA("BasePart") then
if not getgenv().Rivals_isUnderItemVisualNamed(desc, child, "_charm_attachment_model") then
desc.Anchored = true
end
end
end
local motor = Instance.new("Motor6D")
motor.Part0 = primaryPart
motor.Part1 = child.PrimaryPart
motor.Name = 'ItemVisual["' .. child.Name .. '"]'
local attrC0 = child:GetAttribute("C0")
local attrC1 = child:GetAttribute("C1")
if attrC0 then
motor.C0 = attrC0
else
motor.C0 = partPrimary.CFrame:ToObjectSpace(layoutRefCFrame):Inverse()
end
motor.C1 = attrC1 or CFrame.identity
motor.Parent = primaryPart
for _, desc in ipairs(child:GetDescendants()) do
if desc:IsA("BasePart") then
desc.CastShadow = false
desc.CanCollide = false
desc.CanTouch = false
desc.CanQuery = false
desc.Massless = true
if desc ~= child.PrimaryPart then
if not getgenv().Rivals_isUnderItemVisualNamed(desc, child, "_charm_attachment_model") then
local weld = Instance.new("WeldConstraint")
weld.Part0 = child.PrimaryPart
weld.Part1 = desc
weld.Parent = child.PrimaryPart
end
end
end
end
child.PrimaryPart.Name = child.Name .. "Primary"
child:PivotTo(primaryPart.CFrame)
child.PrimaryPart.Anchored = false
for _, desc in ipairs(child:GetDescendants()) do
if desc:IsA("BasePart") and desc ~= child.PrimaryPart then
if not getgenv().Rivals_isUnderItemVisualNamed(desc, child, "_charm_attachment_model") then
desc.Anchored = false
end
end
end
local charmAttachModel = child:FindFirstChild("_charm_attachment_model")
if charmAttachModel then
vm._charm_attachment_model = charmAttachModel
getgenv().Rivals_rebindViewModelCharmRig(vm)
end
local animContexts = getgenv().Rivals_parseAnimationContexts(child:GetAttribute("AnimationContexts"))
if animContexts then vm._animation_context_submodels[child] = animContexts end
if vm._charm_pivot_attachment and vm._charm_pivot_attachment:IsDescendantOf(child) then
vm._charm_sub_model = child
end
vm._submodel_boundingbox_attachments[child] = {}
local bboxCF, bboxSize = child:GetBoundingBox()
for i, corner in ipairs(getgenv().Rivals_BOX_CORNER_OFFSETS) do
local att = Instance.new("Attachment")
att.Name = "_boundingbox" .. i
att.Parent = child.PrimaryPart
att.WorldCFrame = bboxCF * CFrame.new(bboxSize * corner)
table.insert(vm._submodel_boundingbox_attachments[child], att)
end
end)
if not childSetupOk then childOk = false end
end
if not childOk then error("child setup failed") end
getgenv().Rivals_ensureViewModelCharmRigFromTemplate(vm)
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
getgenv().Rivals_rebuildViewModelMuzzleAttachments(vm)
if not skipTransformReset and not vm._is_equipped then
pcall(function() vm:SetCFrame(CFrame.identity) end)
end
getgenv().Rivals_resetViewModelMotionState(vm)
pcall(function() vm:_UpdateSubModelVisibility() end)
end)
return ok and childOk
end
getgenv().Rivals_rebindItemVisualMotors = getgenv().Rivals_setupItemVisualOnly
getgenv().Rivals_refreshViewModelModelName = function(vm, item)
if not vm or not vm.Model or not item then return end
pcall(function()
local fighter = item.ClientFighter
local playerName = fighter and fighter.Player and fighter.Player.Name or "???"
vm.Model.Name = playerName .. " - " .. item.Name .. " - " .. vm.Name
end)
end
getgenv().Rivals_viewModelSafeForUpdate = function(vm)
if not vm then return false end
local model = vm.Model
if typeof(model)~="Instance" or not model.Parent then return false end
local im = vm.ItemModel
if im then
if typeof(im)~="Instance" then return false end
if not im.Parent then pcall(function() im.Parent=model end) end
if not im.Parent then return false end
end
return true
end
getgenv().Rivals_pruneViewModelWrapObjects = function(vm)
if not vm then return end
if type(vm._wrapped_only_objects)=="table" then
for k in pairs(vm._wrapped_only_objects) do if typeof(k)~="Instance" or not k.Parent then vm._wrapped_only_objects[k]=nil end end
end
if type(vm._original_wrap_properties)=="table" then
for inst in pairs(vm._original_wrap_properties) do if typeof(inst)~="Instance" or not inst.Parent then vm._original_wrap_properties[inst]=nil end end
end
end
getgenv().Rivals_getConfiguredWrapPick = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
return (cfg and wn and cfg.Wraps[wn]) or "None"
end
getgenv().Rivals_getWrapController = function()
local ok, wc = pcall(function() return require(localPlayer.PlayerScripts.Controllers.WrapController) end)
return ok and wc or nil
end
getgenv().Rivals_clearViewModelWrapVisuals = function(vm)
if not vm then return end
local WC = getgenv().Rivals_getWrapController()
if vm._original_wrap_properties and WC then
pcall(function() WC:ResetWrap(vm._original_wrap_properties) end)
end
vm._original_wrap_properties = nil
end
getgenv().Rivals_applyViewModelWrap = function(vm, wn, force)
if not vm or not wn then return false end
local pick = getgenv().Rivals_getConfiguredWrapPick(wn)
if not force and vm._rivalsAppliedWrapPick == pick then return true end
getgenv().Rivals_clearViewModelWrapVisuals(vm)
vm._rivalsAppliedWrapPick = pick
if pick == "None" then
getgenv().Rivals_unhookViewModelWrap(vm)
if type(vm._UpdateWrap) == "function" then pcall(function() vm:_UpdateWrap() end) end
return true
end
getgenv().Rivals_hookViewModelAppearance(vm, wn)
if not getgenv().Rivals_viewModelSafeForUpdate(vm) then return false end
local ok = pcall(function() vm:_UpdateWrap() end)
if not ok then vm._original_wrap_properties = nil end
return ok
end
getgenv().Rivals_resetViewModelWrapState = function(vm)
getgenv().Rivals_clearViewModelWrapVisuals(vm)
if vm then vm._rivalsAppliedWrapPick = nil end
end
getgenv().Rivals_safeViewModelUpdateWrap = function(vm, forceRefresh)
if not vm then return false end
local wn = vm._rivalsWeaponName or (vm.ClientItem and vm.ClientItem.Name)
if not wn then return false end
return getgenv().Rivals_applyViewModelWrap(vm, wn, forceRefresh == true)
end
getgenv().Rivals_unhookViewModelWrap = function(vm)
if vm and vm._rivalsOrigGetWrap then vm.GetWrap=vm._rivalsOrigGetWrap; vm._rivalsOrigGetWrap=nil end
end
getgenv().Rivals_unhookViewModelCharm = function(vm)
if vm and vm._rivalsOrigGet then vm.Get=vm._rivalsOrigGet; vm._rivalsOrigGet=nil end
end
getgenv().Rivals_destroyViewModelCharm = function(vm)
if not vm then return end
if vm.Charm then pcall(function() vm.Charm:Destroy() end); vm.Charm = nil end
vm._rivalsCharmPivotRef = nil
end
getgenv().Rivals_resetViewModelCharmState = function(vm)
getgenv().Rivals_destroyViewModelCharm(vm)
if vm then vm._rivalsAppliedCharmPick = nil end
end
getgenv().Rivals_tryNativeViewModelCharmUpdate = function(vm)
if not vm then return false end
local ok, has = pcall(function()
if type(vm._UpdateCharm) == "function" then
vm:_UpdateCharm()
return vm.Charm ~= nil
end
if type(vm._SetupCharm) == "function" then
vm:_SetupCharm()
return vm.Charm ~= nil
end
return false
end)
return ok and has == true
end
getgenv().Rivals_buildCharmDataTable = function(charmName)
local charmData = { Name = charmName }
pcall(function()
local CL = require(RS.Modules.CosmeticLibrary)
local info = CL.Cosmetics and CL.Cosmetics[charmName]
if type(info) == "table" then
for _, key in ipairs({ "Rarity", "Model", "Image", "Type", "ItemName" }) do
if info[key] ~= nil then charmData[key] = info[key] end
end
end
end)
return charmData
end
getgenv().Rivals_applyViewModelCharm = function(vm, wn, force)
if not vm then return false end
wn = wn or vm._rivalsWeaponName or (vm.ClientItem and vm.ClientItem.Name)
if not wn then return false end
getgenv().Rivals_hookViewModelAppearance(vm, wn)
local pick = getgenv().Rivals_getConfiguredCharmPick(wn)
if pick == "None" then
if force or vm._rivalsAppliedCharmPick ~= "None" or vm.Charm then
vm._rivalsAppliedCharmPick = "None"
getgenv().Rivals_destroyViewModelCharm(vm)
end
return true
end
if not force and vm._rivalsAppliedCharmPick == pick and vm.Charm and vm._charm_pivot_attachment then
return true
end
vm._rivalsAppliedCharmPick = pick
getgenv().Rivals_destroyViewModelCharm(vm)
getgenv().Rivals_ensureViewModelCharmRigFromTemplate(vm)
getgenv().Rivals_rebindViewModelCharmRig(vm)
getgenv().Rivals_refreshViewModelAttachmentRefs(vm)
local charmName = getgenv().Rivals_getCharmOverrideName(wn)
if not charmName or not vm._charm_pivot_attachment then return true end
local pivot = vm._charm_pivot_attachment
local ok = pcall(function()
local charmsMods = localPlayer.PlayerScripts.Modules:FindFirstChild("Charms")
local charmMod = require(localPlayer.PlayerScripts.Modules.Charm)
local charmScript = charmsMods and charmsMods:FindFirstChild(charmName, true)
local charmData = { Name = charmName }
vm.Charm = (charmScript and require(charmScript) or charmMod).new(vm, charmData, pivot)
vm.Charm:SetParent(vm.Model)
vm._rivalsCharmPivotRef = pivot
if type(vm.Charm.Update) == "function" then
vm.Charm:Update(nil, true)
end
end)
if not ok then getgenv().Rivals_destroyViewModelCharm(vm) end
return ok
end
getgenv().Rivals_safeViewModelUpdateCharm = function(vm, forceRefresh)
if not vm then return false end
local wn = vm._rivalsWeaponName or (vm.ClientItem and vm.ClientItem.Name)
if not wn then return false end
return getgenv().Rivals_applyViewModelCharm(vm, wn, forceRefresh == true)
end
getgenv().Rivals_unhookClientItemAppearance = function(item)
if item and item._rivalsOrigItemGet then item.Get = item._rivalsOrigItemGet; item._rivalsOrigItemGet = nil end
end
getgenv().Rivals_hookClientItemAppearance = function(item, wn)
if not item or not wn then return end
item._rivalsWeaponName = wn
if type(item.Get) ~= "function" or item._rivalsOrigItemGet then return end
item._rivalsOrigItemGet = item.Get
local origGet = item._rivalsOrigItemGet
item.Get = function(self, key, ...)
local keyName = getgenv().Rivals_enumKeyName(key) or key
if keyName == "Finisher" then
local fin = getgenv().Rivals_getAppearanceFinisherTable(self._rivalsWeaponName or self.Name)
if fin then return fin end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if cfg and cfg.Enabled and getgenv().Rivals_getConfiguredFinisherPick(self._rivalsWeaponName or self.Name) == "None" then
return nil
end
end
return origGet(self, key, ...)
end
end
getgenv().Rivals_installFinisherEffectHook = function()
pcall(function()
local ClientEntity = require(localPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity)
if type(ClientEntity._PlayFinisher) ~= "function" then return end
if ClientEntity._rivalsFinisherHookInstalled then return end
if not ClientEntity._rivalsOrigPlayFinisher then
ClientEntity._rivalsOrigPlayFinisher = ClientEntity._PlayFinisher
end
local Finishers = RS.Modules.Finishers
local playTarget = ClientEntity._rivalsOrigPlayFinisher
local playHook, usedOth = getgenv().Rivals_withOthHook(playTarget, function(origPlay, self, finisherName, isFinal, eliminator, serial)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local overridden = false
if cfg and cfg.Enabled then
finisherName, eliminator, serial, overridden = getgenv().Rivals_prepareLocalFinisherPlay(finisherName, eliminator, serial)
end
if not overridden then
return origPlay(self, finisherName, isFinal, eliminator, serial)
end
local subject = self.Humanoid or self.RootPart
if not (subject and subject:IsDescendantOf(workspace)) then return nil end
local mod = Finishers:FindFirstChild(finisherName)
if not mod then
return origPlay(self, finisherName, isFinal, eliminator, serial)
end
if self._current_finisher then
pcall(function() self._current_finisher:Destroy() end)
self._current_finisher = nil
end
local ok, fin = pcall(function()
return require(mod).new(subject, isFinal, eliminator)
end)
if not ok or not fin then
return origPlay(self, finisherName, isFinal, eliminator, serial)
end
self._current_finisher = fin
pcall(function() fin:SetSerial(serial) end)
task.spawn(function()
if self._current_finisher == fin then
getgenv().Rivals_playFinisherFully(fin)
end
return nil
end)
return nil
end)
if not usedOth then ClientEntity._PlayFinisher = playHook end
ClientEntity._rivalsFinisherHookInstalled = true
getgenv().Rivals_finisherHookInstalled = true
end)
end
getgenv().Rivals_hookViewModelAppearance = function(vm, wn)
if not vm then return end
vm._rivalsWeaponName = wn
if type(vm.GetWrap) == "function" then
if not vm._rivalsOrigGetWrap then vm._rivalsOrigGetWrap = vm.GetWrap end
local origWrap = vm._rivalsOrigGetWrap
vm.GetWrap = function(self)
local wrapName = getgenv().Rivals_getWrapOverrideName(self._rivalsWeaponName or (self.ClientItem and self.ClientItem.Name))
return wrapName and {Name=wrapName} or origWrap(self)
end
end
if type(vm.Get) == "function" then
if not vm._rivalsOrigGet then vm._rivalsOrigGet = vm.Get end
local origGet = vm._rivalsOrigGet
vm.Get = function(self, key, ...)
local keyName = getgenv().Rivals_enumKeyName(key) or key
if keyName == "Charm" then
local charm = getgenv().Rivals_getAppearanceCharmTable(self._rivalsWeaponName or (self.ClientItem and self.ClientItem.Name))
if charm then return charm end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if cfg and cfg.Enabled and getgenv().Rivals_getConfiguredCharmPick(self._rivalsWeaponName or (self.ClientItem and self.ClientItem.Name)) == "None" then
return nil
end
end
return origGet(self, key, ...)
end
end
end
getgenv().Rivals_applyCosmeticTransparencyWhitelist = function(vm, wn)
if not vm or not vm.ItemModel or not wn then return end
pcall(function()
local CL = require(RS.Modules.CosmeticLibrary)
if CL.IGNORE_TRANSPARENCY_WHITELIST and CL.IGNORE_TRANSPARENCY_WHITELIST[wn] then
for _, d in ipairs(vm.ItemModel:GetDescendants()) do
if d:IsA("BasePart") then d:SetAttribute("IgnoreTransparency", true) end
end
end
end)
end
getgenv().Rivals_setupUtilityViewModelVisual = function(vm, wn, template)
if not vm or not vm.Model or not vm.ItemModel then return false end
local primaryPart = vm.Model.PrimaryPart
if not primaryPart then return false end
for _, ch in ipairs(primaryPart:GetChildren()) do
if ch:IsA("Motor6D") and ch.Name:find("ItemVisual", 1, true) then ch:Destroy() end
end
vm._animation_context_submodels = {}
vm._submodel_boundingbox_attachments = {}
getgenv().Rivals_resetViewModelHiddenSubmodels(vm)
getgenv().Rivals_applyCosmeticTransparencyWhitelist(vm, wn)
vm._wrapped_only_objects = vm._wrapped_only_objects or {}
if vm.Model:FindFirstChild("RightArmWrapped") and type(vm._Setup) == "function" then
local ok = pcall(function() vm:_Setup() end)
if ok then
getgenv().Rivals_applyUtilityViewModelFixes(vm, wn)
pcall(function() vm:_UpdateSubModelVisibility() end)
return true
end
end
return getgenv().Rivals_setupItemVisualOnly(vm, true, template)
end
getgenv().Rivals_applyUtilityViewModelFixes = function(vm, wn)
if not vm or not wn then return end
pcall(function()
local needs = getgenv().Rivals_weaponNeedsTransparencyFix(wn)
if needs and vm.ItemModel then
for _, d in ipairs(vm.ItemModel:GetDescendants()) do
if d:IsA("BasePart") then
d:SetAttribute("IgnoreTransparency", true)
d.LocalTransparencyModifier = 0
end
end
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
end
end)
end
getgenv().Rivals_resetViewModelHiddenSubmodels = function(vm)
if not vm or not vm.ItemModel then return end
vm._hidden_submodels = {}
for _, child in ipairs(vm.ItemModel:GetChildren()) do
if child:IsA("Model") then vm._hidden_submodels[child.Name] = false end
end
end
getgenv().Rivals_findLassoRopeConstraint = function(itemModel)
if not itemModel then return nil end
local rope2 = itemModel:FindFirstChild("Rope 2", true)
if not rope2 then return nil end
local part3 = rope2:FindFirstChild("Part3", true)
local att = part3 and part3:FindFirstChild("Attachment", true)
return att and att:FindFirstChild("RopeConstraint")
end
getgenv().Rivals_disconnectLassoAnimationHooks = function(vm)
if not vm or not vm._rivalsLassoAnimConnections then return end
for _, conn in ipairs(vm._rivalsLassoAnimConnections) do
pcall(function() conn:Disconnect() end)
end
vm._rivalsLassoAnimConnections = nil
vm._rivalsLassoInitDone = nil
end
getgenv().Rivals_ensureLassoViewModelState = function(vm)
if not vm then return false end
vm._hook_submodel_hidden_until = vm._hook_submodel_hidden_until or 0
if not vm._rope_constraint then
vm._rope_constraint = getgenv().Rivals_findLassoRopeConstraint(vm.ItemModel)
end
if type(vm._UpdateRopeEnabled) ~= "function" then return vm._rope_constraint ~= nil end
if not vm._rivalsSafeUpdateRopeEnabled then
local orig = vm._UpdateRopeEnabled
vm._rivalsOrigUpdateRopeEnabled = orig
vm._UpdateRopeEnabled = function(self)
self._hook_submodel_hidden_until = self._hook_submodel_hidden_until or 0
if not self._rope_constraint then
self._rope_constraint = getgenv().Rivals_findLassoRopeConstraint(self.ItemModel)
end
if not self._rope_constraint or not self.Animator then return end
return orig(self)
end
vm._rivalsSafeUpdateRopeEnabled = true
end
return vm._rope_constraint ~= nil
end
getgenv().Rivals_connectLassoAnimationHooks = function(vm)
if not vm or vm._rivalsLassoInitDone then return end
getgenv().Rivals_ensureLassoViewModelState(vm)
if not vm.AnimationPlayed or not vm.AnimationStopped then return end
getgenv().Rivals_disconnectLassoAnimationHooks(vm)
vm._rivalsLassoAnimConnections = {
vm.AnimationPlayed:Connect(function()
getgenv().Rivals_ensureLassoViewModelState(vm)
pcall(function() vm:_UpdateRopeEnabled() end)
end),
vm.AnimationStopped:Connect(function()
getgenv().Rivals_ensureLassoViewModelState(vm)
pcall(function() vm:_UpdateRopeEnabled() end)
end),
}
vm._rivalsLassoInitDone = true
pcall(function() vm:_UpdateRopeEnabled() end)
end
getgenv().Rivals_restoreViewModelBaseClass = function(vm, wn)
if not vm or not wn then return false end
getgenv().Rivals_disconnectLassoAnimationHooks(vm)
if vm._rivalsOrigUpdateRopeEnabled then
vm._UpdateRopeEnabled = vm._rivalsOrigUpdateRopeEnabled
vm._rivalsOrigUpdateRopeEnabled = nil
vm._rivalsSafeUpdateRopeEnabled = nil
end
local vmFolder = localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
local baseMod = vmFolder and getgenv().Rivals_findViewModelModule(vmFolder, wn, nil)
if not baseMod then return false end
local ok = pcall(function()
local BaseClass = require(baseMod)
setmetatable(vm, BaseClass)
vm._rope_constraint = nil
vm._hook_submodel_hidden_until = nil
getgenv().Rivals_resetViewModelHiddenSubmodels(vm)
pcall(function() vm:_UpdateSubModelVisibility() end)
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
end)
return ok
end
getgenv().Rivals_applySkinViewModelModulePatch = function(vm, wn, sn, vmFolder)
if not vm or not wn or not sn then return false end
vmFolder = vmFolder or localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
if not vmFolder or not getgenv().Rivals_skinHasViewModelModule(vmFolder, wn, sn) then return false end
local skinMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, sn)
if not skinMod then return false end
local ok = pcall(function()
if sn == "Lasso" then
vm._hook_submodel_hidden_until = vm._hook_submodel_hidden_until or 0
end
local SkinClass = require(skinMod)
setmetatable(vm, SkinClass)
if sn == "Lasso" then
getgenv().Rivals_ensureLassoViewModelState(vm)
getgenv().Rivals_connectLassoAnimationHooks(vm)
elseif type(vm._arm_submodels) == "table" and next(vm._arm_submodels) ~= nil then
pcall(function() if type(vm._Setup) == "function" then vm:_Setup() end end)
end
getgenv().Rivals_resetViewModelHiddenSubmodels(vm)
pcall(function() vm:_UpdateSubModelVisibility() end)
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
end)
return ok
end
getgenv().Rivals_ensureRevolverBulletParts = function(im, wn)
if not im or not wn then return end
local rev = im:FindFirstChild("Revolver", true)
if not rev or rev:FindFirstChild("Bullets1") then return end
local vmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("ViewModels")
if not vmAssets then return end
local Utility = require(RS.Modules.Utility)
local def = Utility:LookThrough(vmAssets, wn)
if not def then return end
local defRev = def:FindFirstChild("Revolver", true)
local b1 = defRev and defRev:FindFirstChild("Bullets1")
if b1 then b1:Clone().Parent=rev end
end
getgenv().Rivals_findViewModelModule = function(vmFolder, wn, sn)
if not vmFolder then return nil end
local cache = getgenv().Rivals_buildViewModelModuleCache()
local alias = getgenv().Rivals_getViewModelModuleAlias(wn)
local names = {}
if sn then table.insert(names, sn) end
if alias then table.insert(names, alias) end
table.insert(names, wn)
for _, n in ipairs(names) do if cache[n] then return cache[n] end end
for _, n in ipairs(names) do
local wf = vmFolder:FindFirstChild(n)
if wf and sn then
local sm = wf:FindFirstChild(sn)
if sm and sm:IsA("ModuleScript") then return sm end
end
end
for _, child in ipairs(vmFolder:GetChildren()) do
if child:IsA("Folder") then
if sn then local sm=child:FindFirstChild(sn); if sm and sm:IsA("ModuleScript") then return sm end end
for _, n in ipairs(names) do local wm=child:FindFirstChild(n); if wm and wm:IsA("ModuleScript") then return wm end end
end
end
for _, n in ipairs(names) do local m=vmFolder:FindFirstChild(n,true); if m and m:IsA("ModuleScript") then return m end end
return nil
end
getgenv().Rivals_refreshHotbarIcons = function(lf, onlyItem)
lf = lf or getgenv().Rivals_getLocalFighter()
if not lf or not lf.FighterInterface then return end
local hotbar = lf.FighterInterface.Hotbar
if not hotbar or not hotbar._hotbar_slots then return end
for clientItem, slot in pairs(hotbar._hotbar_slots) do
if clientItem and slot and slot.Icon and (not onlyItem or clientItem==onlyItem) then
pcall(function()
local img = getgenv().Rivals_getHotbarIconForItem(clientItem)
if img and img ~= "" then slot.Icon.Image = img
else
local fb = getgenv().Rivals_getWeaponIconImage(clientItem.Name, false)
if fb and fb ~= "" then slot.Icon.Image = fb
elseif clientItem.ViewModel and type(clientItem.ViewModel.GetImage) == "function" then slot.Icon.Image = clientItem.ViewModel:GetImage() end
end
end)
end
end
end
getgenv().Rivals_refreshWeaponAppearanceIcons = function(lf, onlyItem)
getgenv().Rivals_refreshHotbarIcons(lf, onlyItem)
task.defer(function()
local gui = localPlayer:FindFirstChild("PlayerGui")
local main = gui and gui:FindFirstChild("MainGui")
if not main then return end
local pick = main:FindFirstChild("PickWeapons", true) or main:FindFirstChild("PickWeaponsList", true)
if pick and pick.Visible then
getgenv().Rivals_refreshPickWeaponsIcons()
end
end)
end
getgenv().Rivals_reEquipClientItem = function(item, shouldEquip, onComplete)
if not item then return end
if shouldEquip == false then return end
local equipAfter = shouldEquip == true or item.IsEquipped == true
task.defer(function()
pcall(function()
local vm = item.ViewModel
if item.IsEquipped and type(item.Unequip) == "function" then
item:Unequip()
task.wait()
elseif shouldEquip == true then
task.wait()
end
if not equipAfter then return end
if type(item.Equip) == "function" then item:Equip() end
if vm and type(vm.Equip) == "function" then vm:Equip() end
getgenv().Rivals_snapViewModelEquipSpring(vm)
getgenv().Rivals_restoreViewModelArms(vm or item.ViewModel)
if vm and type(vm._UpdateSubModelVisibility) == "function" then vm:_UpdateSubModelVisibility() end
if onComplete then onComplete() end
getgenv().Rivals_snapViewModelEquipSpring(item.ViewModel or vm)
getgenv().Rivals_restoreViewModelArms(item.ViewModel or vm)
end)
end)
end
getgenv().Rivals_forceRefreshEquippedItem = function(item, wn)
if not item then return end
getgenv().Rivals_reEquipClientItem(item)
task.defer(function()
task.wait(0.05)
local vm = item.ViewModel
if vm then
getgenv().Rivals_hookViewModelAppearance(vm, wn or item.Name)
getgenv().Rivals_safeViewModelUpdateWrap(vm)
getgenv().Rivals_safeViewModelUpdateCharm(vm)
end
getgenv().Rivals_reEquipClientItem(item)
end)
end
getgenv().Rivals_destroyItemViewModel = function(item, oldVm)
oldVm = oldVm or (item and item.ViewModel)
if not oldVm then return end
pcall(function() if type(oldVm.Unequip) == "function" then oldVm:Unequip() end end)
pcall(function() if type(oldVm.Destroy) == "function" then oldVm:Destroy() end end)
if item and item.ViewModel == oldVm then item.ViewModel = nil end
end
getgenv().Rivals_replaceItemViewModel = function(item, wn, sn, wasEquipped)
if not item or not wn then return false end
local ps = localPlayer.PlayerScripts
local vmFolder = ps.Modules:FindFirstChild("ViewModels")
if not vmFolder then return false end
local lf = getgenv().Rivals_getLocalFighter()
wasEquipped = wasEquipped == true or item.IsEquipped == true or (lf and lf.EquippedItem == item)
local oldVm = item.ViewModel
local armsSnap = getgenv().Rivals_captureViewModelArms(oldVm)
local serial = getgenv().Rivals_cloneSerial((oldVm and oldVm._serial) or getgenv().Rivals_getItemViewModelSerial(item))
if not serial then return false end
local modScript, assetOnly = getgenv().Rivals_resolveViewModelModule(vmFolder, wn, sn)
if not modScript then modScript = getgenv().Rivals_getClientViewModelModuleScript(ps) end
if not modScript then return false end
if wasEquipped then pcall(function() if type(item.Unequip) == "function" then item:Unequip() end end) end
if oldVm then pcall(function() if type(oldVm.Unequip) == "function" then oldVm:Unequip() end end) end
item.ViewModel = nil
local newVm = getgenv().Rivals_createSkinnedViewModel(modScript, serial, item, wn, sn, vmFolder, false, oldVm, assetOnly)
if not newVm then
item.ViewModel = oldVm
if wasEquipped then getgenv().Rivals_reEquipClientItem(item) end
return false
end
pcall(function() if oldVm and oldVm ~= newVm and type(oldVm.Destroy) == "function" then oldVm:Destroy() end end)
item.ViewModel = newVm
newVm.ClientItem = item
getgenv().Rivals_restoreViewModelArms(newVm, armsSnap)
item._rivalsAppliedSkinPick = (sn and sn ~= wn) and getgenv().Rivals_getConfiguredSkinPick(wn) or "None"
getgenv().Rivals_refreshWeaponAppearanceIcons(lf, item)
getgenv().Rivals_finalizeViewModelSkinSwap(item, newVm, wn, wasEquipped, false, armsSnap)
return true
end
getgenv().Rivals_swapViewModelItemOnly = function(item, wn, sn, forceReEquip)
local vm = item and item.ViewModel
if not vm or not sn then return false end
local wasEquipped = forceReEquip == true or item.IsEquipped == true
local playEquipAnim = item._rivalsPlayEquipAnim == true
local keepEquipped = not playEquipAnim and wasEquipped and item.IsEquipped == true and vm._is_equipped == true
local armsSnap = getgenv().Rivals_captureViewModelArms(vm)
if not keepEquipped and wasEquipped and type(item.Unequip) == "function" then
pcall(function() item:Unequip() end)
end
local IL = require(RS.Modules.ItemLibrary)
local Utility = require(RS.Modules.Utility)
local vmName = sn
local info = IL.ViewModels[vmName]
if not info then return false end
local vmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("ViewModels")
if not vmAssets then return false end
local template = Utility:LookThrough(vmAssets, vmName)
if not template then return false end
local ok = pcall(function()
getgenv().Rivals_ensureViewModelArmParts(vm)
getgenv().Rivals_clearViewModelArmSubmodels(vm)
getgenv().Rivals_clearItemVisualMotors(vm)
local oldIv = (vm.Model and vm.Model:FindFirstChild("ItemVisual")) or vm.ItemModel
local newIv = template:Clone()
newIv.Name = "ItemVisual"
local usesArmSubs = getgenv().Rivals_weaponUsesArmSubmodelVisuals(wn, template)
if not usesArmSubs then
for _, ch in ipairs(newIv:GetChildren()) do
if ch.Name == "_left_arm" or ch.Name == "_right_arm" then
ch:Destroy()
end
end
end
for _, d in ipairs(newIv:GetDescendants()) do
if d:IsA("BasePart") then
d.Anchored = true
d.CanCollide = false
d.Massless = true
end
end
if oldIv and oldIv ~= newIv then
pcall(function() oldIv:Destroy() end)
end
newIv.Parent = vm.Model
vm.Name = vmName
vm.Info = info
vm.ItemModel = newIv
if usesArmSubs then
if not getgenv().Rivals_setupArmSubmodelItemVisual(vm, wn) then error("arm submodel setup failed") end
elseif getgenv().Rivals_weaponNeedsTransparencyFix(wn) then
if not getgenv().Rivals_setupUtilityViewModelVisual(vm, wn, template) then error("utility setup failed") end
elseif not getgenv().Rivals_setupItemVisualOnly(vm, true, template) then
error("setup failed")
end
getgenv().Rivals_refreshViewModelModelName(vm, item)
getgenv().Rivals_ensureRevolverBulletParts(newIv, wn)
pcall(function() vm._original_scale = newIv:GetScale() end)
if info.RootPartOffset then
pcall(function()
vm._root_part_offset_inverse = info.RootPartOffset:Inverse()
end)
end
if vm._serial then
getgenv().Rivals_patchViewModelSerialName(vm._serial, vmName)
pcall(function() if type(vm.Set) == "function" then vm:Set("Name", vmName) end end)
end
getgenv().Rivals_applyUtilityViewModelFixes(vm, wn)
local vmFolder = localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
if sn and sn ~= wn and vmFolder and getgenv().Rivals_skinHasViewModelModule(vmFolder, wn, sn) then
getgenv().Rivals_applySkinViewModelModulePatch(vm, wn, sn, vmFolder)
else
getgenv().Rivals_restoreViewModelBaseClass(vm, wn)
end
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
getgenv().Rivals_snapViewModelEquipSpring(vm)
end)
if ok then
item._rivalsAppliedSkinPick = (sn and sn ~= wn) and getgenv().Rivals_getConfiguredSkinPick(wn) or "None"
getgenv().Rivals_refreshWeaponAppearanceIcons(nil, item)
getgenv().Rivals_finalizeViewModelSkinSwap(item, vm, wn, wasEquipped, keepEquipped, armsSnap)
if keepEquipped then
getgenv().Rivals_snapViewModelEquipSpring(vm)
getgenv().Rivals_restoreViewModelArms(vm, armsSnap)
getgenv().Rivals_applyViewModelOffset()
end
end
return ok
end
getgenv().Rivals_swapViewModelVisual = function(item, wn, sn, forceReEquip)
local vm = item and item.ViewModel
if not vm then return false end
local wasEquipped = forceReEquip == true or item.IsEquipped == true
if wasEquipped and type(item.Unequip) == "function" then pcall(function() item:Unequip() end) end
local IL = require(RS.Modules.ItemLibrary)
local Utility = require(RS.Modules.Utility)
local vmName = sn or wn
local info = IL.ViewModels[vmName]
if not info then return false end
local vmAssets = localPlayer.PlayerScripts.Assets:FindFirstChild("ViewModels")
if not vmAssets then return false end
local template = Utility:LookThrough(vmAssets, vmName)
if not template then return false end
local newIM = template:Clone()
local ok = pcall(function()
getgenv().Rivals_resetViewModelSetupState(vm)
vm._wrapped_only_objects = {}
vm.Name = vmName
vm.Info = info
vm.ItemModel = newIM
if vm.Model then newIM.Parent = vm.Model end
getgenv().Rivals_ensureRevolverBulletParts(newIM, wn)
pcall(function() vm._original_scale = vm.ItemModel:GetScale() end)
if info.RootPartOffset then
pcall(function()
vm._root_part_offset_inverse = info.RootPartOffset:Inverse()
vm._root_part_offset_override = nil
vm._root_part_offset_override_inverse = nil
end)
end
if vm._serial then
getgenv().Rivals_patchViewModelSerialName(vm._serial, vmName)
pcall(function() if type(vm.Set) == "function" then vm:Set("Name", vmName) end end)
end
getgenv().Rivals_refreshViewModelAnimatorInfo(vm)
local rev = newIM:FindFirstChild("Revolver", true)
if rev and not rev:FindFirstChild("Bullets1") then error("missing Bullets1") end
local setupOk = pcall(function() vm:_Setup() end)
if not setupOk then error("setup failed") end
getgenv().Rivals_applyUtilityViewModelFixes(vm, wn)
getgenv().Rivals_hookViewModelAppearance(vm, wn)
getgenv().Rivals_safeViewModelUpdateWrap(vm)
getgenv().Rivals_safeViewModelUpdateCharm(vm)
pcall(function() vm:_UpdateLocalTransparencyModifiers() end)
if vm.ItemModel and not vm.ItemModel.Parent and vm.Model then vm.ItemModel.Parent = vm.Model end
end)
if ok then
item._rivalsAppliedSkinPick = (sn and sn ~= wn) and getgenv().Rivals_getConfiguredSkinPick(wn) or "None"
getgenv().Rivals_refreshWeaponAppearanceIcons(nil, item)
if wasEquipped then getgenv().Rivals_reEquipClientItem(item) end
end
return ok
end
getgenv().Rivals_createSkinnedViewModel = function(modScript, serial, item, wn, sn, vmFolder, wasEquipped, oldVm, assetOnly)
if not modScript or not serial or not item then return nil end
serial = getgenv().Rivals_cloneSerial(serial) or serial
local vmName = sn or wn
getgenv().Rivals_patchViewModelSerialName(serial, vmName)
local itemSerial = getgenv().Rivals_getItemViewModelSerial(item)
if sn and itemSerial then getgenv().Rivals_patchItemSerialForSkin(itemSerial, wn, sn) end
local useRedirect = false
if sn and vmFolder then
local baseMod = getgenv().Rivals_findViewModelModule(vmFolder, wn, nil)
useRedirect = modScript == baseMod and getgenv().Rivals_skinHasViewModelModule(vmFolder, wn, sn)
end
if useRedirect then getgenv().Rivals_setSkinModuleRedirect(wn, sn, vmFolder) end
local origRCNew = getgenv().Rivals_origReplicatedClassNew
local rcHooked = false
local rcHookTarget = nil
if vmName and origRCNew then
rcHooked = true
local RC = require(RS.Modules.ReplicatedClass)
rcHookTarget = RC.new
local rcHook, usedOthRC = getgenv().Rivals_withOthHook(rcHookTarget, function(origRCNewFn, s, ...)
if type(s) == "table" then getgenv().Rivals_patchViewModelSerialName(s, vmName) end
local inst = origRCNewFn(s, ...)
pcall(function() inst:Set("Name", vmName) end)
return inst
end)
if not usedOthRC then RC.new = rcHook end
end
local newVm
local okBuild = pcall(function()
if wasEquipped and oldVm and type(oldVm.Unequip)=="function" then oldVm:Unequip() end
local VMClass = require(modScript)
newVm = VMClass.new(serial, item)
end)
if not okBuild then newVm = nil end
if rcHooked and rcHookTarget then
getgenv().Rivals_othUnhook(rcHookTarget)
local RC = require(RS.Modules.ReplicatedClass)
if RC.new ~= origRCNew then RC.new = origRCNew end
end
if useRedirect then getgenv().Rivals_skinModuleRedirect = nil end
if okBuild and newVm and vmName then
pcall(function() if type(newVm.Set)=="function" then newVm:Set("Name",vmName) end end)
getgenv().Rivals_applyUtilityViewModelFixes(newVm, wn)
end
return okBuild and newVm or nil
end
getgenv().Rivals_rebuildEquippedViewModelSkin = function(item, wn)
if not item or not wn or not item.ViewModel then return false, item end
local lf = getgenv().Rivals_getLocalFighter()
local wasEquipped = item.IsEquipped == true or (lf and lf.EquippedItem == item)
local sn = getgenv().Rivals_getSkinOverrideName(wn)
local ok
if sn then
ok = getgenv().Rivals_swapViewModelItemOnly(item, wn, sn, wasEquipped)
if not ok then
ok = getgenv().Rivals_replaceItemViewModel(item, wn, sn, wasEquipped)
end
else
ok = getgenv().Rivals_swapViewModelItemOnly(item, wn, wn, wasEquipped)
if not ok then ok = getgenv().Rivals_replaceItemViewModel(item, wn, nil, wasEquipped) end
end
return ok, item
end
getgenv().Rivals_restoreItemDefaultSkin = function(item, wn)
if not item or not wn then return false end
local had = item._rivalsAppliedSkinPick and item._rivalsAppliedSkinPick~="None"
if not had and getgenv().Rivals_getItemViewModelName(item)==wn then item._rivalsAppliedSkinPick="None"; return false end
local lf = getgenv().Rivals_getLocalFighter()
local wasEquipped = item.IsEquipped == true or (lf and lf.EquippedItem == item)
local ok = getgenv().Rivals_swapViewModelItemOnly(item, wn, wn, wasEquipped)
if not ok then ok = getgenv().Rivals_replaceItemViewModel(item, wn, nil, wasEquipped) end
if ok then item._rivalsAppliedSkinPick = "None" end
return ok
end
getgenv().Rivals_itemNeedsSkinVisualApply = function(item, wn)
if not item or not wn then return false end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return false end
local cfgPick = getgenv().Rivals_getConfiguredSkinPick(wn)
if cfgPick == "Random" then
local sn = getgenv().Rivals_getSkinOverrideName(wn)
return getgenv().Rivals_getItemVisualModelName(item) ~= (sn or wn)
end
if item._rivalsAppliedSkinPick ~= cfgPick then return true end
local sn = getgenv().Rivals_getSkinOverrideName(wn)
return getgenv().Rivals_getItemVisualModelName(item) ~= (sn or wn)
end
getgenv().Rivals_applySkinToItemIfNeeded = function(item, wn, force)
if not item or not wn then return false end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then
if force or (item._rivalsAppliedSkinPick and item._rivalsAppliedSkinPick~="None") then return getgenv().Rivals_restoreItemDefaultSkin(item, wn) end
return false
end
local pick = getgenv().Rivals_getConfiguredSkinPick(wn)
if pick=="None" then
if force or (item._rivalsAppliedSkinPick and item._rivalsAppliedSkinPick~="None") then return getgenv().Rivals_restoreItemDefaultSkin(item, wn) end
return false
end
if not force and not getgenv().Rivals_itemNeedsSkinVisualApply(item, wn) then return false end
if force then item._rivalsPlayEquipAnim = true end
local applied, newItem = getgenv().Rivals_rebuildEquippedViewModelSkin(item, wn)
if newItem then newItem._rivalsPlayEquipAnim = nil end
if item then item._rivalsPlayEquipAnim = nil end
if applied and newItem then
if pick == "Random" then
local sn = getgenv().Rivals_getSkinOverrideName(wn)
newItem._rivalsAppliedSkinPick = sn or "Random"
else
newItem._rivalsAppliedSkinPick = pick
end
end
return applied
end
getgenv().Rivals_restoreLoadoutDefaultAppearance = function(onlyItem)
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
for _, item in pairs(lf.Items) do
if item and item.Name and (not onlyItem or item==onlyItem) then
getgenv().Rivals_restoreItemDefaultSkin(item, item.Name)
if item.ViewModel then
getgenv().Rivals_unhookViewModelWrap(item.ViewModel)
getgenv().Rivals_unhookViewModelCharm(item.ViewModel)
getgenv().Rivals_unhookClientItemAppearance(item)
getgenv().Rivals_safeViewModelUpdateWrap(item.ViewModel)
getgenv().Rivals_resetViewModelCharmState(item.ViewModel)
end
end
end
getgenv().Rivals_refreshHotbarIcons(lf, onlyItem)
end
getgenv().Rivals_applyEquippedSkinAppearance = function(force)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local lf = getgenv().Rivals_getLocalFighter()
if not lf then return end
local eq = lf.EquippedItem
if not eq or not eq.Name then return end
if not cfg.Enabled then getgenv().Rivals_restoreLoadoutDefaultAppearance(eq); return end
local pick = getgenv().Rivals_getConfiguredSkinPick(eq.Name)
if pick=="None" then getgenv().Rivals_restoreItemDefaultSkin(eq, eq.Name); getgenv().Rivals_refreshHotbarIcons(lf, eq); return end
eq._rivalsAppliedSkinPick = nil
getgenv().Rivals_applySkinToItemIfNeeded(eq, eq.Name, force)
local vm = eq.ViewModel
if vm then getgenv().Rivals_hookClientItemAppearance(eq, eq.Name); getgenv().Rivals_hookViewModelAppearance(vm, eq.Name); getgenv().Rivals_safeViewModelUpdateWrap(vm); getgenv().Rivals_safeViewModelUpdateCharm(vm) end
getgenv().Rivals_refreshHotbarIcons(lf, eq)
end
getgenv().Rivals_hasConfiguredAppearance = function()
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or cfg.Enabled ~= true then return false end
local function hasPick(map)
if type(map) ~= "table" then return false end
for _, v in pairs(map) do
if type(v) == "string" and v ~= "" and v ~= "None" then return true end
end
return false
end
return hasPick(cfg.Skins) or hasPick(cfg.Wraps) or hasPick(cfg.Charms) or hasPick(cfg.Finishers)
end
getgenv().Rivals_applyLoadoutItemAppearance = function(item, force)
if not item or not item.Name then return end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return end
local wn = item.Name
local pick = cfg.Skins[wn] or "None"
local wrapPick = cfg.Wraps[wn] or "None"
local charmPick = cfg.Charms[wn] or "None"
getgenv().Rivals_hookClientItemAppearance(item, wn)
if pick == "None" then
if force or (item._rivalsAppliedSkinPick and item._rivalsAppliedSkinPick ~= "None") then
getgenv().Rivals_restoreItemDefaultSkin(item, wn)
end
else
if force then item._rivalsAppliedSkinPick = nil end
getgenv().Rivals_applySkinToItemIfNeeded(item, wn, force == true)
end
local vm = item.ViewModel
if vm then
getgenv().Rivals_hookViewModelAppearance(vm, wn)
if wrapPick ~= "None" or vm._rivalsAppliedWrapPick then
getgenv().Rivals_applyViewModelWrap(vm, wn, force == true)
end
if charmPick ~= "None" or vm._rivalsAppliedCharmPick then
getgenv().Rivals_applyViewModelCharm(vm, wn, force == true)
end
getgenv().Rivals_restoreViewModelArms(vm)
end
local lf = getgenv().Rivals_getLocalFighter()
if lf then getgenv().Rivals_refreshHotbarIcons(lf, item) end
end
getgenv().Rivals_applyFullLoadoutAppearance = function(force)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
if not cfg or not cfg.Enabled then
getgenv().Rivals_restoreLoadoutDefaultAppearance()
return
end
if force ~= true and not getgenv().Rivals_hasConfiguredAppearance() then return end
for _, item in pairs(lf.Items) do
if item and item.Name then
local wn = item.Name
local pick = cfg.Skins[wn] or "None"
local wrapPick = cfg.Wraps[wn] or "None"
local charmPick = cfg.Charms[wn] or "None"
local needsWork = pick ~= "None"
or wrapPick ~= "None"
or charmPick ~= "None"
or (cfg.Finishers[wn] and cfg.Finishers[wn] ~= "None")
or item._rivalsAppliedSkinPick
or (item.ViewModel and item.ViewModel._rivalsAppliedWrapPick)
or (item.ViewModel and item.ViewModel._rivalsAppliedCharmPick)
if needsWork or force == true then
local captured = item
getgenv().Rivals_enqueueAppearanceWork("loadout:" .. wn, function()
getgenv().Rivals_applyLoadoutItemAppearance(captured, force == true)
end)
end
end
end
end
getgenv().Rivals_getConfiguredPicksForWeapon = function(wn)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not wn or not cfg then
return { skin = "None", wrap = "None", charm = "None", finisher = "None" }
end
return {
skin = cfg.Skins[wn] or "None",
wrap = cfg.Wraps[wn] or "None",
charm = cfg.Charms[wn] or "None",
finisher = cfg.Finishers[wn] or "None",
}
end
getgenv().Rivals_pushDropdownPicksToUI = function(wn)
if not wn then return end
local state = getgenv().Rivals_weaponAppearanceState
state._uiSelectedWeapon = wn
state._dropdownWeapon = wn
if getgenv().Rivals_guiSetSelectedWeapon then getgenv().Rivals_guiSetSelectedWeapon(wn, true) end
if getgenv().Rivals_guiRefreshCosmeticGrid then getgenv().Rivals_guiRefreshCosmeticGrid() end
end
getgenv().Rivals_applySkinToLocalLoadout = function(wn, force)
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
for _, item in pairs(lf.Items) do
if item and item.Name==wn then getgenv().Rivals_applySkinToItemIfNeeded(item, wn, force) end
end
end
getgenv().Rivals_refreshWeaponAppearanceForNameNow = function(wn, kind)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg.Enabled then getgenv().Rivals_restoreLoadoutDefaultAppearance(); return end
if not wn then return end
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
local touched
for _, item in pairs(lf.Items) do
if item and item.Name == wn then
touched = item
if kind == "skin" or kind == "both" then
local pick = cfg.Skins[wn] or "None"
if pick == "None" then getgenv().Rivals_restoreItemDefaultSkin(item, wn)
else
if kind == "both" then item._rivalsAppliedSkinPick = nil end
getgenv().Rivals_applySkinToItemIfNeeded(item, wn, kind == "skin" or kind == "both")
end
end
local vm = item.ViewModel
if vm then
local wp = cfg.Wraps[wn] or "None"
if kind == "wrap" or kind == "both" or ((kind == "skin" or kind == "both") and wp ~= "None") then
getgenv().Rivals_applyViewModelWrap(vm, wn, true)
end
local cp = cfg.Charms[wn] or "None"
if kind == "charm" or kind == "both" or ((kind == "skin" or kind == "both") and cp ~= "None") then
getgenv().Rivals_applyViewModelCharm(vm, wn, true)
end
if kind == "skin" or kind == "both" then
getgenv().Rivals_hookViewModelAppearance(vm, wn)
end
getgenv().Rivals_restoreViewModelArms(vm)
end
getgenv().Rivals_hookClientItemAppearance(item, wn)
end
end
if touched then getgenv().Rivals_refreshWeaponAppearanceIcons(lf, touched) end
end
getgenv().Rivals_refreshWeaponAppearanceForName = function(wn, kind)
if not wn then return end
getgenv().Rivals_enqueueAppearanceWork("refresh:" .. wn .. ":" .. tostring(kind), function()
getgenv().Rivals_refreshWeaponAppearanceForNameNow(wn, kind)
end)
end
getgenv().Rivals_refreshEquippedWeaponAppearance = function(kind)
local wn = getgenv().Rivals_getLocalEquippedWeaponName()
if wn then getgenv().Rivals_refreshWeaponAppearanceForName(wn, kind) end
end
getgenv().Rivals_maintainEquippedItemAppearance = function(wn)
if not wn then return end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return end
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
local item = lf.EquippedItem
if not item or item.Name ~= wn then
for _, it in pairs(lf.Items) do
if it and it.Name == wn then
item = it
break
end
end
end
if not item or item.Name ~= wn or not item.ViewModel then return end
local vm = item.ViewModel
local function run()
if lf.EquippedItem ~= item then return end
getgenv().Rivals_restoreViewModelArms(vm)
local needsSkin = getgenv().Rivals_itemNeedsSkinVisualApply(item, wn)
if needsSkin then
getgenv().Rivals_hookClientItemAppearance(item, wn)
getgenv().Rivals_hookViewModelAppearance(vm, wn)
getgenv().Rivals_applySkinToItemIfNeeded(item, wn, false)
getgenv().Rivals_applyViewModelWrap(vm, wn, false)
getgenv().Rivals_applyViewModelCharm(vm, wn, false)
getgenv().Rivals_restoreViewModelArms(vm)
getgenv().Rivals_refreshHotbarIcons(lf, item)
else
if item._rivalsWeaponName ~= wn then getgenv().Rivals_hookClientItemAppearance(item, wn) end
if vm._rivalsWeaponName ~= wn then getgenv().Rivals_hookViewModelAppearance(vm, wn) end
local cp = cfg.Charms[wn] or "None"
if cp ~= "None" and (not vm.Charm or vm._rivalsAppliedCharmPick ~= cp) then
getgenv().Rivals_applyViewModelCharm(vm, wn, false)
end
local wp = cfg.Wraps[wn] or "None"
if wp ~= "None" and vm._rivalsAppliedWrapPick ~= wp then
getgenv().Rivals_applyViewModelWrap(vm, wn, false)
end
end
end
if vm._is_equipped then run() else task.defer(run) end
end
getgenv().Rivals_patchAmmoVisualModules = function()
pcall(function()
local vmRoot = localPlayer.PlayerScripts.Modules:FindFirstChild("ViewModels")
if not vmRoot then return end
local function safeRegister(mod)
if not mod or mod._rivalsSafeAmmoHook or type(mod._RegisterDefaultAmmoVisuals)~="function" then return end
mod._rivalsSafeAmmoHook = true
mod._RegisterDefaultAmmoVisuals = function(vm)
if not vm or not vm.ItemModel then return end
for _, fn in ipairs({"ReloadBullets","Bullets"}) do
local folder = vm.ItemModel:FindFirstChild(fn)
if folder then for i=1,6 do local p=folder:FindFirstChild(tostring(i)) or folder:FindFirstChild(i); if p then vm:_RegisterAmmoVisual(fn,p) end end end
end
end
end
for _, cn in ipairs({"BaseRevolver","BaseSlingshot","BaseFlareGun"}) do
local ms = vmRoot:FindFirstChild(cn)
if ms then safeRegister(require(ms)) end
end
end)
end
getgenv().Rivals_hookExistingLoadoutAppearance = function()
local lf = getgenv().Rivals_getLocalFighter()
if not lf or not lf.Items then return end
for _, item in pairs(lf.Items) do
if item and item.Name then
getgenv().Rivals_hookClientItemAppearance(item, item.Name)
if item.ViewModel then
getgenv().Rivals_hookViewModelAppearance(item.ViewModel, item.Name)
end
end
end
end
getgenv().Rivals_resolveWeaponNameFromViewModelName = function(vmName)
if type(vmName) ~= "string" or vmName == "" then return nil end
local wn = nil
pcall(function()
local CL = require(RS.Modules.CosmeticLibrary)
local IL = require(RS.Modules.ItemLibrary)
if CL.Cosmetics[vmName] and CL.Cosmetics[vmName].ItemName then
wn = CL.Cosmetics[vmName].ItemName
elseif IL.Items[vmName] then
wn = vmName
end
end)
return wn or vmName
end
getgenv().Rivals_patchViewModelDetailsForLocal = function(details, weaponNameHint)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return details end
local copy = {}
if type(details) == "table" then
for k, v in pairs(details) do copy[k] = v end
end
local wn = weaponNameHint
or (copy.WeaponName)
or getgenv().Rivals_resolveWeaponNameFromViewModelName(copy.ViewModelName)
or getgenv().Rivals_weaponAppearanceState.lastFinisherWeapon
or getgenv().Rivals_weaponAppearanceState.lastWeapon
if not wn then
if not copy.ViewModelName then copy.ViewModelName = "Assault Rifle" end
return copy
end
local sn = getgenv().Rivals_getSkinOverrideName(wn)
if sn then
copy.ViewModelName = sn
elseif not copy.ViewModelName then
copy.ViewModelName = wn
end
local wrap = getgenv().Rivals_getWrapOverrideName(wn)
if wrap then copy.Wrap = { Name = wrap } end
local charm = getgenv().Rivals_getCharmOverrideName(wn)
if charm then copy.Charm = { Name = charm } end
copy.WeaponName = wn
return copy
end
getgenv().Rivals_installFinalResultsSkinHook = function()
pcall(function()
local ClientDueler = require(localPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDueler)
if type(ClientDueler.GetRandomPlayedViewModelDetails) ~= "function" then return end
if ClientDueler._rivalsRandomDetailsHookInstalled then return end
if not ClientDueler._rivalsOrigGetRandomPlayedViewModelDetails then
ClientDueler._rivalsOrigGetRandomPlayedViewModelDetails = ClientDueler.GetRandomPlayedViewModelDetails
end
local target = ClientDueler._rivalsOrigGetRandomPlayedViewModelDetails
local hookFn, usedOth = getgenv().Rivals_withOthHook(target, function(orig, self, rng)
local details = orig(self, rng)
local isLocal = self and (self.IsLocalPlayer or self.Player == localPlayer)
if not isLocal then return details end
local hint = nil
pcall(function()
local item = self.ClientFighter and self.ClientFighter.EquippedItem
hint = item and (item.Name or (item.Info and item.Info.Name))
end)
hint = hint
or getgenv().Rivals_weaponAppearanceState.lastFinisherWeapon
or getgenv().Rivals_weaponAppearanceState.lastWeapon
if not details then
details = { ViewModelName = hint or "Assault Rifle" }
end
return getgenv().Rivals_patchViewModelDetailsForLocal(details, hint)
end)
if not usedOth then ClientDueler.GetRandomPlayedViewModelDetails = hookFn end
ClientDueler._rivalsRandomDetailsHookInstalled = true
end)
pcall(function()
local ClientDueler = require(localPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDueler)
if type(ClientDueler._RecordEquippedViewModelDetails) ~= "function" then return end
if ClientDueler._rivalsRecordDetailsHookInstalled then return end
if not ClientDueler._rivalsOrigRecordEquippedViewModelDetails then
ClientDueler._rivalsOrigRecordEquippedViewModelDetails = ClientDueler._RecordEquippedViewModelDetails
end
local target = ClientDueler._rivalsOrigRecordEquippedViewModelDetails
local hookFn, usedOth = getgenv().Rivals_withOthHook(target, function(orig, self)
local isLocal = self and (self.IsLocalPlayer or self.Player == localPlayer)
if not isLocal then return orig(self) end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return orig(self) end
local item = self.ClientFighter and self.ClientFighter.EquippedItem
if not item then return nil end
local oid = nil
pcall(function() oid = item:Get("ObjectID") end)
if oid and self._viewmodel_detail_check[oid] then return nil end
if oid then self._viewmodel_detail_check[oid] = true end
local details = nil
pcall(function() details = item:GetViewModelDetails() end)
if not details then return nil end
details = getgenv().Rivals_patchViewModelDetailsForLocal(details, item.Name)
local banned = false
pcall(function()
local IL = require(RS.Modules.ItemLibrary)
banned = IL.THIRD_PERSON_VIEWMODEL_BLACKLIST and IL.THIRD_PERSON_VIEWMODEL_BLACKLIST[details.ViewModelName] == true
end)
if banned then return nil end
table.insert(self._recorded_viewmodel_details, details)
return nil
end)
if not usedOth then ClientDueler._RecordEquippedViewModelDetails = hookFn end
ClientDueler._rivalsRecordDetailsHookInstalled = true
end)
end
getgenv().Rivals_setupWeaponAppearanceHooks = function()
getgenv().Rivals_installSkinModuleRedirectHook()
getgenv().Rivals_patchAmmoVisualModules()
getgenv().Rivals_installFinisherEffectHook()
getgenv().Rivals_installWeaponIconHooks()
getgenv().Rivals_installFinalResultsSkinHook()
pcall(function()
local ps = localPlayer:FindFirstChild("PlayerScripts")
if not ps then return end
local RC = require(RS.Modules.ReplicatedClass)
getgenv().Rivals_origReplicatedClassNew = RC.new
local cif = ps.Modules.ClientReplicatedClasses.ClientFighter
local cim = cif:FindFirstChild("ClientItem")
if cim then
local ClientItem = require(cim)
if ClientItem then
if not ClientItem._rivalsOrigNew then ClientItem._rivalsOrigNew = ClientItem.new end
if not ClientItem._rivalsAppearanceNewHook then
ClientItem._rivalsAppearanceNewHook = true
local newTarget = ClientItem._rivalsOrigNew
local newHook, usedOthNew = getgenv().Rivals_withOthHook(newTarget, function(origNew, serial, cf, ...)
local ea = {...}
local isLocal = cf and cf.IsLocalPlayer
local wn = isLocal and getgenv().Rivals_getWeaponNameFromItemSerial(serial) or nil
local sn = wn and getgenv().Rivals_getSkinOverrideName(wn) or nil
if sn and isLocal then getgenv().Rivals_patchItemSerialForSkin(serial, wn, sn) end
local vmMods = ps.Modules:FindFirstChild("ViewModels")
if sn and isLocal and vmMods then getgenv().Rivals_setSkinModuleRedirect(wn, sn, vmMods) end
local item
local okN, errN = pcall(function() item = origNew(serial, cf, table.unpack(ea)) end)
getgenv().Rivals_skinModuleRedirect = nil
if not okN then error(errN) end
if isLocal and item and item.ViewModel then
getgenv().Rivals_hookClientItemAppearance(item, wn or item.Name)
getgenv().Rivals_hookViewModelAppearance(item.ViewModel, wn or item.Name)
getgenv().Rivals_applyUtilityViewModelFixes(item.ViewModel, wn or item.Name)
if sn and vmMods and getgenv().Rivals_skinHasViewModelModule(vmMods, wn, sn) then
getgenv().Rivals_applySkinViewModelModulePatch(item.ViewModel, wn, sn, vmMods)
end
getgenv().Rivals_safeViewModelUpdateWrap(item.ViewModel)
getgenv().Rivals_safeViewModelUpdateCharm(item.ViewModel)
item._rivalsAppliedSkinPick = getgenv().Rivals_getConfiguredSkinPick(wn or item.Name)
end
return item
end)
if not usedOthNew then ClientItem.new = newHook end
end
end
local cvm = cim:FindFirstChild("ClientViewModel")
if cvm then
local ClientVM = require(cvm)
getgenv().Rivals_installClientViewModelUpdateHook = function(CVM)
if not CVM or CVM._rivalsSafeUpdateHook then return end
if type(CVM.Update)~="function" then return end
CVM._rivalsSafeUpdateHook = true
local updateTarget = CVM.Update
local updateHook, usedOthU = getgenv().Rivals_withOthHook(updateTarget, function(origU, self, ...)
if not getgenv().Rivals_viewModelSafeForUpdate(self) then return end
getgenv().Rivals_pruneViewModelWrapObjects(self)
local res = table.pack(pcall(origU, self, ...))
if not res[1] then self._wrapped_only_objects={}; self._original_wrap_properties=nil; return end
local wn = self._rivalsWeaponName or (self.ClientItem and self.ClientItem.Name)
if wn and getgenv().Rivals_getConfiguredCharmPick(wn) ~= "None" then
getgenv().Rivals_rebindViewModelCharmRigIfNeeded(self)
getgenv().Rivals_refreshViewModelAttachmentRefs(self)
end
if self.Charm and type(self.Charm.Update) == "function" and self._charm_pivot_attachment then
pcall(function() self.Charm:Update(nil, true) end)
end
return table.unpack(res, 2, res.n)
end)
if not usedOthU then CVM.Update = updateHook end
end
getgenv().Rivals_installClientViewModelUpdateHook(ClientVM)
end
end
end)
getgenv().Rivals_hookExistingLoadoutAppearance()
end
getgenv().Rivals_patchWeaponDataForAppearance = function(wd, forceLocal)
if not wd or not wd.Name then return wd end
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
if not cfg or not cfg.Enabled then return wd end
if not forceLocal and not wd._rivalsLocalPatched then return wd end
local sn = getgenv().Rivals_getSkinOverrideName(wd.Name)
local fn = getgenv().Rivals_getFinisherOverrideName(wd.Name)
local cn = getgenv().Rivals_getCharmOverrideName(wd.Name)
local wrap = getgenv().Rivals_getWrapOverrideName(wd.Name)
if not sn and not fn and not cn and not wrap then
if forceLocal then
local copy = {}
for k, v in pairs(wd) do copy[k] = v end
copy._rivalsLocalPatched = true
return copy
end
return wd
end
local copy = {}
for k, v in pairs(wd) do copy[k] = v end
if sn then copy.Skin = { Name = sn } end
if fn then copy.Finisher = { Name = fn } end
if cn then copy.Charm = { Name = cn } end
if wrap then copy.Wrap = { Name = wrap } end
copy._rivalsLocalPatched = true
return copy
end
getgenv().Rivals_resolveWeaponIconImage = function(weaponName, weaponData, highRes)
if type(weaponName) ~= "string" or weaponName == "" then
weaponName = weaponData and weaponData.Name
end
if not weaponName then return "" end
local IL = require(RS.Modules.ItemLibrary)
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
local allowLocal = (not weaponData) or weaponData._rivalsLocalPatched == true
if allowLocal and cfg and cfg.Enabled then
local sn = getgenv().Rivals_getSkinOverrideName(weaponName)
if sn then
local origGet = IL._rivalsOrigGetViewModelImage or IL.GetViewModelImage
local img = origGet(IL, weaponName, { Name = sn }, highRes)
if img and img ~= "" then return img end
img = IL.ViewModels[sn] and (highRes and IL.ViewModels[sn].ImageHighResolution or IL.ViewModels[sn].Image)
if img and img ~= "" then return img end
end
end
if weaponData then
local origFromWD = IL._rivalsOrigGetViewModelImageFromWeaponData or IL.GetViewModelImageFromWeaponData
local img = origFromWD(IL, weaponData, highRes)
if img and img ~= "" then return img end
end
local origGet = IL._rivalsOrigGetViewModelImage or IL.GetViewModelImage
return origGet(IL, weaponName, weaponData and weaponData.Skin, highRes) or ""
end
getgenv().Rivals_installWeaponIconHooks = function()
pcall(function()
local IL = require(RS.Modules.ItemLibrary)
if not IL._rivalsOrigGetViewModelImage then
IL._rivalsOrigGetViewModelImage = IL.GetViewModelImage
end
if not IL._rivalsOrigGetViewModelImageFromWeaponData then
IL._rivalsOrigGetViewModelImageFromWeaponData = IL.GetViewModelImageFromWeaponData
end
IL.GetViewModelImage = IL._rivalsOrigGetViewModelImage
if not IL._rivalsFromWeaponDataHookInstalled then
IL._rivalsFromWeaponDataHookInstalled = true
local fromWDTarget = IL._rivalsOrigGetViewModelImageFromWeaponData
local fromWDHook, usedOthWD = getgenv().Rivals_withOthHook(fromWDTarget, function(origFromWD, self, weaponData, highRes)
if type(weaponData) == "table" and weaponData._rivalsLocalPatched then
local img = origFromWD(self, weaponData, highRes)
if (not img or img == "") and weaponData.Name then
img = getgenv().Rivals_resolveWeaponIconImage(weaponData.Name, weaponData, highRes)
end
return img
end
return origFromWD(self, weaponData, highRes)
end)
if not usedOthWD then IL.GetViewModelImageFromWeaponData = fromWDHook end
end
end)
pcall(function()
local PDC = require(localPlayer.PlayerScripts.Controllers.PlayerDataController)
if not PDC._rivalsGetWeaponDataHookInstalled then
if not PDC._rivalsOrigGetWeaponData then
PDC._rivalsOrigGetWeaponData = PDC.GetWeaponData
end
PDC._rivalsGetWeaponDataHookInstalled = true
local wdTarget = PDC._rivalsOrigGetWeaponData
local wdHook, usedOthWD = getgenv().Rivals_withOthHook(wdTarget, function(orig, self, weaponName, ...)
local wd = orig(self, weaponName, ...)
if type(wd) == "table" then
return getgenv().Rivals_patchWeaponDataForAppearance(wd, true)
end
if type(weaponName) == "string" and getgenv().Rivals_getSkinOverrideName(weaponName) then
return getgenv().Rivals_patchWeaponDataForAppearance({ Name = weaponName }, true)
end
return wd
end)
if not usedOthWD then PDC.GetWeaponData = wdHook end
end
end)
pcall(function()
local function hookPickPage(mod)
if not mod or type(mod.PickWeapon) ~= "function" then return end
if mod._rivalsPickWeaponHookInstalled then return end
if not mod._rivalsOrigPickWeapon then
mod._rivalsOrigPickWeapon = mod.PickWeapon
end
mod._rivalsPickWeaponHookInstalled = true
local pickTarget = mod._rivalsOrigPickWeapon
local pickHook, usedOthPick = getgenv().Rivals_withOthHook(pickTarget, function(origPick, self, slotIndex, weaponName, ...)
local ret = origPick(self, slotIndex, weaponName, ...)
pcall(function()
local slot = self._chosen_weapon_slots and self._chosen_weapon_slots[slotIndex]
local pic = slot and slot.Button and (slot.Button:FindFirstChild("Picture") or slot.Button:FindFirstChild("Picture", true))
if pic then
local img = getgenv().Rivals_resolveWeaponIconImage(weaponName, { Name = weaponName, _rivalsLocalPatched = true }, false)
if img and img ~= "" then pic.Image = img end
end
end)
return ret
end)
if not usedOthPick then mod.PickWeapon = pickHook end
end
hookPickPage(require(localPlayer.PlayerScripts.Modules.Pages.PickWeapons))
pcall(function() hookPickPage(require(localPlayer.PlayerScripts.Modules.Pages.PickWeaponsList)) end)
end)
pcall(function()
local WeaponSlot = require(localPlayer.PlayerScripts.Modules.WeaponSlot)
if type(WeaponSlot._Setup) ~= "function" then return end
if WeaponSlot._rivalsSetupHookInstalled then return end
if not WeaponSlot._rivalsOrigSetup then
WeaponSlot._rivalsOrigSetup = WeaponSlot._Setup
end
WeaponSlot._rivalsSetupHookInstalled = true
local setupTarget = WeaponSlot._rivalsOrigSetup
local setupHook, usedOthSetup = getgenv().Rivals_withOthHook(setupTarget, function(origSetup, self, ...)
local ret = origSetup(self, ...)
pcall(function()
if not (self.WeaponData and self.WeaponData._rivalsLocalPatched) then return end
local pic = self.Frame and self.Frame.Button and self.Frame.Button.Icon and self.Frame.Button.Icon.Picture
if pic and self.Name then
local img = getgenv().Rivals_resolveWeaponIconImage(self.Name, self.WeaponData, false)
if img and img ~= "" then pic.Image = img end
end
end)
return ret
end)
if not usedOthSetup then WeaponSlot._Setup = setupHook end
end)
end
getgenv().Rivals_refreshPickWeaponsIcons = function()
pcall(function()
local function refreshPage(page)
if not page then return end
local localMark = { _rivalsLocalPatched = true }
if page._chosen_weapons and page._chosen_weapon_slots then
for i, wn in pairs(page._chosen_weapons) do
local slot = page._chosen_weapon_slots[i]
local pic = slot and slot.Button and (slot.Button:FindFirstChild("Picture") or slot.Button:FindFirstChild("Picture", true))
if pic and type(wn) == "string" then
localMark.Name = wn
local img = getgenv().Rivals_resolveWeaponIconImage(wn, localMark, false)
if img and img ~= "" then pic.Image = img end
end
end
end
if page._weapon_slot_cleanup then
for _, slot in pairs(page._weapon_slot_cleanup) do
local frame = typeof(slot) == "Instance" and slot or (slot and slot.Frame)
if not frame and type(slot) == "table" and slot.Button then frame = slot end
local btn = frame and (frame.Button or frame:FindFirstChild("Button"))
local title = btn and btn:FindFirstChild("Title", true)
local pic = btn and btn:FindFirstChild("Picture", true)
local wn = title and title.Text
if pic and wn and wn ~= "" then
localMark.Name = wn
local img = getgenv().Rivals_resolveWeaponIconImage(wn, localMark, false)
if img and img ~= "" then pic.Image = img end
end
end
end
if page._pick_weapon_slots then
for _, slot in pairs(page._pick_weapon_slots) do
local btn = typeof(slot) == "Instance" and slot:FindFirstChild("Button") or (slot.Button or slot)
if typeof(btn) == "Instance" then
local title = btn:FindFirstChild("Title", true)
local pic = btn:FindFirstChild("Picture", true)
local wn = title and title.Text
if pic and wn and wn ~= "" then
localMark.Name = wn
local img = getgenv().Rivals_resolveWeaponIconImage(wn, localMark, false)
if img and img ~= "" then pic.Image = img end
end
end
end
end
end
refreshPage(require(localPlayer.PlayerScripts.Modules.Pages.PickWeapons))
pcall(function() refreshPage(require(localPlayer.PlayerScripts.Modules.Pages.PickWeaponsList)) end)
end)
pcall(function()
local gui = localPlayer.PlayerGui:FindFirstChild("MainGui")
if not gui then return end
local localMark = { _rivalsLocalPatched = true }
for _, pageName in ipairs({"PickWeapons", "PickWeaponsList"}) do
local page = gui:FindFirstChild(pageName, true)
if page then
for _, slot in ipairs(page:GetDescendants()) do
if slot.Name == "WeaponSlot" or slot.Name == "PickWeaponChosenSlot" then
local title = slot:FindFirstChild("Title", true)
local pic = slot:FindFirstChild("Picture", true)
local wn = title and title.Text
if pic and wn and wn ~= "" then
localMark.Name = wn
local img = getgenv().Rivals_resolveWeaponIconImage(wn, localMark, false)
if img and img ~= "" then pic.Image = img end
end
end
end
end
end
end)
end
getgenv().Rivals_tickWeaponAppearance = function()
local state = getgenv().Rivals_weaponAppearanceState
local lf = getgenv().Rivals_getLocalFighter()
local item = lf and lf.EquippedItem
local wn = item and (item.Name or (item.Info and item.Info.Name))
if wn ~= state.lastWeapon then
state.lastWeapon = wn
if wn and getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Enabled then
getgenv().Rivals_enqueueAppearanceWork("equip:" .. wn, function()
if state.lastWeapon ~= wn then return end
getgenv().Rivals_maintainEquippedItemAppearance(wn)
end)
end
return
end
local now = tick()
if now - (state.lastTick or 0) >= 12 then
state.lastTick = now
if state._appearanceQueuePumpRunning then return end
if state._appearanceQueue and #state._appearanceQueue > 0 then return end
if getgenv().Rivals_hasConfiguredAppearance() then
getgenv().Rivals_applyFullLoadoutAppearance(false)
end
end
end
getgenv().Rivals_buildCoreGui = function()
if getgenv().Rivals_GuiScreen then
pcall(function() getgenv().Rivals_GuiScreen:Destroy() end)
getgenv().Rivals_GuiScreen = nil
end
getgenv().Rivals_installWeaponIconHooks()
local UIS = game:GetService("UserInputService")
local uiState = getgenv().Rivals_weaponAppearanceState
uiState._uiCosmeticKind = uiState._uiCosmeticKind or "skin"
uiState._uiSelectedWeapon = uiState._uiSelectedWeapon or getgenv().Rivals_getLocalEquippedWeaponName() or "Assault Rifle"
local UI_FONT = Enum.Font.Code
local GRID_CELL = Vector2.new(78, 96)
local GRID_VIEW_H = 200
local COL = {
bg = Color3.fromRGB(16, 16, 18),
panel = Color3.fromRGB(22, 22, 24),
tile = Color3.fromRGB(18, 18, 20),
tileSel = Color3.fromRGB(28, 52, 32),
text = Color3.fromRGB(220, 220, 220),
muted = Color3.fromRGB(135, 135, 140),
line = Color3.fromRGB(88, 88, 94),
selLine = Color3.fromRGB(55, 120, 65),
}
local function stroke(inst, t)
local s = Instance.new("UIStroke")
s.Color = COL.line
s.Thickness = t or 1
s.Parent = inst
end
local gui = Instance.new("ScreenGui")
gui.Name = "RivalsCosmetics"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 900
gui.Parent = localPlayer:WaitForChild("PlayerGui")
getgenv().Rivals_GuiScreen = gui
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 524, 0, 688)
main.Position = UDim2.new(0.5, -262, 0.5, -344)
main.BackgroundColor3 = COL.line
main.BorderSizePixel = 0
main.Parent = gui
local mainInner = Instance.new("Frame")
mainInner.Size = UDim2.new(1, -2, 1, -2)
mainInner.Position = UDim2.new(0, 1, 0, 1)
mainInner.BackgroundColor3 = COL.bg
mainInner.BorderSizePixel = 0
mainInner.Parent = main
local mainHost = mainInner
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.Parent = mainHost
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 1, 0)
title.Font = UI_FONT
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextColor3 = COL.text
title.Text = "Cosmetic Changer"
title.Parent = titleBar
local footer = Instance.new("Frame")
footer.BackgroundTransparency = 1
footer.Size = UDim2.new(1, -24, 0, 132)
footer.Position = UDim2.new(0, 12, 1, -138)
footer.Parent = mainHost
local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 12, 0, 36)
content.Size = UDim2.new(1, -24, 1, -174)
content.Parent = mainHost
local dropLayer = Instance.new("Frame")
dropLayer.Name = "RivalsDropLayer"
dropLayer.Size = UDim2.new(1, 0, 1, 0)
dropLayer.BackgroundTransparency = 1
dropLayer.Visible = false
dropLayer.ZIndex = 500
dropLayer.Parent = gui
local openMenu = nil
local openMenuBlocker = nil
local function closeOpenMenu()
if openMenu then pcall(function() openMenu:Destroy() end); openMenu = nil end
if openMenuBlocker then pcall(function() openMenuBlocker:Destroy() end); openMenuBlocker = nil end
dropLayer.Visible = false
end
local function sectionLabel(text, y)
local l = Instance.new("TextLabel")
l.BackgroundTransparency = 1
l.Size = UDim2.new(1, 0, 0, 16)
l.Position = UDim2.new(0, 0, 0, y)
l.Font = UI_FONT
l.TextSize = 12
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextColor3 = COL.muted
l.Text = text
l.Parent = content
return y + 20
end
local function styleScrollPanel(scroll)
scroll.BackgroundColor3 = COL.panel
scroll.BackgroundTransparency = 0.35
scroll.BorderSizePixel = 0
stroke(scroll)
end
local function makeSearchBox(y, placeholder)
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, 0, 0, 26)
box.Position = UDim2.new(0, 0, 0, y)
box.BackgroundColor3 = COL.panel
box.TextColor3 = COL.text
box.PlaceholderText = placeholder
box.PlaceholderColor3 = COL.muted
box.Font = UI_FONT
box.TextSize = 12
box.Text = ""
box.TextXAlignment = Enum.TextXAlignment.Left
box.ClearTextOnFocus = false
box.Parent = content
stroke(box)
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 8)
pad.Parent = box
return box, y + 32
end
local function makeActionButton(parent, text, size, pos, onClick)
local b = Instance.new("TextButton")
b.AutoButtonColor = false
b.BackgroundColor3 = COL.panel
b.TextColor3 = COL.text
b.Font = UI_FONT
b.TextSize = 12
b.Text = text
b.Size = size
b.Position = pos
b.Parent = parent
stroke(b)
b.MouseButton1Click:Connect(onClick)
return b
end
local y = 0
y = sectionLabel("weapon filter", y)
local weaponSearch, y2 = makeSearchBox(y, "assault rifle...")
y = y2
local function getWeaponNameList()
return getgenv().Rivals_getAllWeaponNames()
end
local weaponScroll = Instance.new("ScrollingFrame")
weaponScroll.Position = UDim2.new(0, 0, 0, y)
weaponScroll.Size = UDim2.new(1, 0, 0, GRID_VIEW_H)
styleScrollPanel(weaponScroll)
weaponScroll.ScrollBarThickness = 3
weaponScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
weaponScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
weaponScroll.Parent = content
local weaponGrid = Instance.new("UIGridLayout")
weaponGrid.CellSize = UDim2.new(0, GRID_CELL.X, 0, GRID_CELL.Y)
weaponGrid.CellPadding = UDim2.new(0, 4, 0, 4)
weaponGrid.SortOrder = Enum.SortOrder.LayoutOrder
weaponGrid.Parent = weaponScroll
local function filterWeaponNames(query)
query = string.lower(query or "")
local out = {}
for _, name in ipairs(getWeaponNameList()) do
if query == "" or string.find(string.lower(name), query, 1, true) then out[#out + 1] = name end
end
return out
end
local function rebuildWeaponGrid()
for _, ch in ipairs(weaponScroll:GetChildren()) do
if ch:IsA("GuiObject") and ch ~= weaponGrid then ch:Destroy() end
end
local selected = uiState._uiSelectedWeapon
for _, wn in ipairs(filterWeaponNames(weaponSearch.Text)) do
local tile = Instance.new("TextButton")
tile.AutoButtonColor = false
tile.BackgroundColor3 = (wn == selected) and COL.tileSel or COL.tile
tile.Text = ""
tile.Parent = weaponScroll
stroke(tile)
if wn == selected then
local sel = Instance.new("UIStroke")
sel.Color = COL.selLine
sel.Thickness = 1
sel.Parent = tile
end
local previewHost = getgenv().Rivals_createTilePreviewHost(tile)
local pic = Instance.new("ImageLabel")
pic.ZIndex = 2
getgenv().Rivals_styleTilePreviewImage(pic, 1)
pic.Parent = previewHost
local imgKey = getgenv().Rivals_getWeaponIconCacheKey(wn, false, true)
local function gridIcon()
return getgenv().Rivals_getWeaponIconImage(wn, false, true)
end
local imgNow = gridIcon()
if imgNow ~= "" then pic.Image = imgNow end
getgenv().Rivals_applyImageToLabel(pic, imgKey, gridIcon)
local cap = Instance.new("TextLabel")
cap.BackgroundTransparency = 1
cap.Size = UDim2.new(1, -4, 0, 24)
cap.Position = UDim2.new(0, 2, 1, -26)
cap.Font = UI_FONT
cap.TextSize = 10
cap.TextWrapped = true
cap.TextXAlignment = Enum.TextXAlignment.Center
cap.TextColor3 = COL.text
cap.Text = wn
cap.Parent = tile
tile.MouseButton1Click:Connect(function()
closeOpenMenu()
uiState._uiSelectedWeapon = wn
rebuildWeaponGrid()
if getgenv().Rivals_guiRefreshCosmeticGrid then getgenv().Rivals_guiRefreshCosmeticGrid() end
end)
end
end
getgenv().Rivals_guiRefreshWeaponGrid = rebuildWeaponGrid
weaponSearch:GetPropertyChangedSignal("Text"):Connect(rebuildWeaponGrid)
y = y + GRID_VIEW_H + 8
local kindLabels = { skin = "skin", wrap = "wrap", charm = "charm", finisher = "finisher" }
local kindOrder = { "skin", "wrap", "charm", "finisher" }
local kindDisplay = {}
for _, k in ipairs(kindOrder) do kindDisplay[#kindDisplay + 1] = kindLabels[k] end
y = sectionLabel("cosmetic filter", y)
local cosSearch, y3 = makeSearchBox(y, "red...")
y = y3
local cosScroll = Instance.new("ScrollingFrame")
cosScroll.Position = UDim2.new(0, 0, 0, y)
styleScrollPanel(cosScroll)
cosScroll.Size = UDim2.new(1, 0, 0, GRID_VIEW_H)
cosScroll.ScrollBarThickness = 5
cosScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cosScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cosScroll.Parent = content
local cosGrid = Instance.new("UIGridLayout")
cosGrid.CellSize = UDim2.new(0, GRID_CELL.X, 0, GRID_CELL.Y)
cosGrid.CellPadding = UDim2.new(0, 4, 0, 4)
cosGrid.SortOrder = Enum.SortOrder.LayoutOrder
cosGrid.Parent = cosScroll
local function getSelectedPick()
local wn = uiState._uiSelectedWeapon
if not wn then return "None" end
local picks = getgenv().Rivals_getConfiguredPicksForWeapon(wn)
local k = uiState._uiCosmeticKind or "skin"
return picks[k] or "None"
end
local function filterList(list, query)
query = string.lower(query or "")
if query == "" then return list end
local out = {}
for _, name in ipairs(list) do
if string.find(string.lower(name), query, 1, true) then out[#out + 1] = name end
end
return out
end
local cosGridRebuildToken = 0
local rebuildCosmeticGrid
local function rebuildCosmeticGridImpl()
for _, ch in ipairs(cosScroll:GetChildren()) do
if ch:IsA("GuiObject") and ch ~= cosGrid then ch:Destroy() end
end
local cosCache = getgenv().Rivals_weaponCosmeticCache
if not cosCache.ready then return end
local wn = uiState._uiSelectedWeapon
local kind = uiState._uiCosmeticKind or "skin"
if not wn then return end
local list = filterList(getgenv().Rivals_getCosmeticListForKind(kind, wn), cosSearch.Text)
local selected = getSelectedPick()
for _, name in ipairs(list) do
local tile = Instance.new("TextButton")
tile.AutoButtonColor = false
tile.BackgroundColor3 = (name == selected) and COL.tileSel or COL.tile
tile.Text = ""
tile.Parent = cosScroll
stroke(tile)
if name == selected then
local sel = Instance.new("UIStroke")
sel.Color = COL.selLine
sel.Thickness = 1
sel.Parent = tile
end
local previewHost = getgenv().Rivals_createTilePreviewHost(tile)
local pic = Instance.new("ImageLabel")
pic.ZIndex = 2
local iconScale = (name == "None" or name == "Random") and 0.5 or 1
getgenv().Rivals_styleTilePreviewImage(pic, iconScale)
pic.Parent = previewHost
local imgKey = tostring(kind) .. "\31" .. name .. "\31" .. tostring(wn or "")
local tileRef, picRef, kindRef, nameRef, wnRef = tile, pic, kind, name, wn
local useViewport = kind == "wrap" or kind == "charm"
if not useViewport then
getgenv().Rivals_applyImageToLabel(pic, imgKey, function()
return getgenv().Rivals_getCosmeticThumbnail(kind, name, wn)
end)
else
task.defer(function()
if tileRef.Parent ~= cosScroll then return end
if getgenv().Rivals_tryAttachCosmeticPreview(tileRef, picRef, kindRef, nameRef, wnRef) then return end
getgenv().Rivals_applyCosmeticTileFallback(picRef, nameRef)
getgenv().Rivals_applyImageToLabel(picRef, imgKey, function()
return getgenv().Rivals_getCosmeticThumbnail(kindRef, nameRef, wnRef)
end)
end)
end
if name == "Random" and pic.Image == "" then
local q = Instance.new("TextLabel")
q.BackgroundTransparency = 1
q.Size = UDim2.new(1, 0, 1, 0)
q.Font = UI_FONT
q.TextSize = 28
q.TextColor3 = COL.text
q.Text = "?"
q.Parent = pic
end
local cap = Instance.new("TextLabel")
cap.BackgroundTransparency = 1
cap.Size = UDim2.new(1, -4, 0, 24)
cap.Position = UDim2.new(0, 2, 1, -26)
cap.Font = UI_FONT
cap.TextSize = 10
cap.TextWrapped = true
cap.TextXAlignment = Enum.TextXAlignment.Center
cap.TextColor3 = COL.text
cap.Text = name
cap.Parent = tile
tile.MouseButton1Click:Connect(function()
closeOpenMenu()
if getgenv().Rivals_weaponAppearanceState.updatingUI then return end
getgenv().Rivals_setCosmeticPickForWeapon(wn, kind, name)
rebuildCosmeticGrid()
end)
end
end
rebuildCosmeticGrid = function()
cosGridRebuildToken = cosGridRebuildToken + 1
local token = cosGridRebuildToken
task.defer(function()
if token ~= cosGridRebuildToken then return end
rebuildCosmeticGridImpl()
end)
end
getgenv().Rivals_guiRefreshCosmeticGrid = rebuildCosmeticGrid
getgenv().Rivals_guiSetSelectedWeapon = function(wn, silent)
uiState._uiSelectedWeapon = wn
if getgenv().Rivals_guiRefreshWeaponGrid then getgenv().Rivals_guiRefreshWeaponGrid() end
if silent ~= true and getgenv().Rivals_guiRefreshCosmeticGrid then getgenv().Rivals_guiRefreshCosmeticGrid() end
end
cosSearch:GetPropertyChangedSignal("Text"):Connect(rebuildCosmeticGrid)
getgenv().Rivals_weaponSkinDropdown = { Value = "None", SetValue = function() end, SetValues = function() end, _rivalsLastPick = nil }
getgenv().Rivals_weaponWrapDropdown = getgenv().Rivals_weaponSkinDropdown
getgenv().Rivals_weaponCharmDropdown = getgenv().Rivals_weaponSkinDropdown
getgenv().Rivals_weaponFinisherDropdown = getgenv().Rivals_weaponSkinDropdown
local kindBtnFrame = Instance.new("TextButton")
kindBtnFrame.Size = UDim2.new(1, 0, 0, 28)
kindBtnFrame.Position = UDim2.new(0, 0, 0, 0)
kindBtnFrame.BackgroundColor3 = COL.panel
kindBtnFrame.AutoButtonColor = false
kindBtnFrame.Text = ""
kindBtnFrame.Parent = footer
stroke(kindBtnFrame)
local kindTxt = Instance.new("TextLabel")
kindTxt.BackgroundTransparency = 1
kindTxt.Size = UDim2.new(1, -24, 1, 0)
kindTxt.Position = UDim2.new(0, 8, 0, 0)
kindTxt.Font = UI_FONT
kindTxt.TextSize = 12
kindTxt.TextXAlignment = Enum.TextXAlignment.Left
kindTxt.TextColor3 = COL.text
kindTxt.Text = kindLabels[uiState._uiCosmeticKind or "skin"]
kindTxt.Active = false
kindTxt.Parent = kindBtnFrame
local kindArrow = Instance.new("TextLabel")
kindArrow.BackgroundTransparency = 1
kindArrow.Size = UDim2.new(0, 20, 1, 0)
kindArrow.Position = UDim2.new(1, -22, 0, 0)
kindArrow.Font = UI_FONT
kindArrow.TextSize = 12
kindArrow.TextColor3 = COL.muted
kindArrow.Text = ">"
kindArrow.Active = false
kindArrow.Parent = kindBtnFrame
local applyAllBtn
local function syncApplyAllVisibility()
if applyAllBtn then
local k = uiState._uiCosmeticKind or "skin"
applyAllBtn.Visible = k ~= "skin"
end
end
local kindPickerApi = { Value = kindLabels[uiState._uiCosmeticKind or "skin"] }
function kindPickerApi:SetValue(v, silent)
self.Value = v
kindTxt.Text = tostring(v)
if not silent then
for k, label in pairs(kindLabels) do
if label == v then
uiState._uiCosmeticKind = k
break
end
end
syncApplyAllVisibility()
task.defer(rebuildCosmeticGrid)
end
end
local function resetMenuCosmeticKindToSkin()
uiState._uiCosmeticKind = "skin"
kindPickerApi:SetValue("skin", true)
syncApplyAllVisibility()
end
local function openKindMenu()
closeOpenMenu()
dropLayer.Visible = true
openMenuBlocker = Instance.new("TextButton")
openMenuBlocker.Size = UDim2.new(1, 0, 1, 0)
openMenuBlocker.BackgroundTransparency = 1
openMenuBlocker.Text = ""
openMenuBlocker.ZIndex = 301
openMenuBlocker.Parent = dropLayer
openMenuBlocker.MouseButton1Click:Connect(closeOpenMenu)
local menu = Instance.new("Frame")
menu.BackgroundColor3 = COL.panel
menu.BorderSizePixel = 0
menu.ZIndex = 302
menu.Parent = dropLayer
stroke(menu)
openMenu = menu
local lay = Instance.new("UIListLayout")
lay.Padding = UDim.new(0, 1)
lay.Parent = menu
for _, val in ipairs(kindDisplay) do
local opt = Instance.new("TextButton")
opt.Size = UDim2.new(1, 0, 0, 26)
opt.BackgroundColor3 = COL.tile
opt.Text = val
opt.TextColor3 = COL.text
opt.Font = UI_FONT
opt.TextSize = 12
opt.TextXAlignment = Enum.TextXAlignment.Left
opt.AutoButtonColor = false
opt.ZIndex = 303
opt.Parent = menu
stroke(opt)
opt.MouseButton1Click:Connect(function()
kindPickerApi:SetValue(val)
closeOpenMenu()
end)
end
task.defer(function()
local btnPos = kindBtnFrame.AbsolutePosition
local btnSize = kindBtnFrame.AbsoluteSize
local layerPos = dropLayer.AbsolutePosition
menu.Size = UDim2.fromOffset(btnSize.X, 112)
menu.Position = UDim2.fromOffset(btnPos.X - layerPos.X, btnPos.Y - layerPos.Y - 114)
for _, ch in ipairs(menu:GetChildren()) do
if ch:IsA("GuiObject") and ch ~= lay then
ch.Size = UDim2.new(1, 0, 0, 26)
end
end
end)
end
kindBtnFrame.MouseButton1Click:Connect(function()
if openMenu then closeOpenMenu() else openKindMenu() end
end)
applyAllBtn = makeActionButton(footer, "apply selected to all", UDim2.new(1, 0, 0, 28), UDim2.new(0, 0, 0, 34), function()
local kind = uiState._uiCosmeticKind or "skin"
if kind == "skin" then return end
local pick = getSelectedPick()
for _, wnAll in ipairs(getgenv().Rivals_getAllWeaponNames()) do
getgenv().Rivals_setCosmeticPickForWeapon(wnAll, kind, pick)
end
rebuildCosmeticGrid()
end)
syncApplyAllVisibility()
makeActionButton(footer, "reset to defaults", UDim2.new(0.5, -2, 0, 28), UDim2.new(0, 0, 0, 68), function()
local cfg = getgenv().Rivals_WEAPON_APPEARANCE_CONFIG
cfg.Skins = {}
cfg.Wraps = {}
cfg.Charms = {}
cfg.Finishers = {}
uiState.resolvedRandom = {}
getgenv().Rivals_restoreLoadoutDefaultAppearance()
rebuildWeaponGrid()
rebuildCosmeticGrid()
getgenv().Rivals_applyFullLoadoutAppearance(true)
end)
makeActionButton(footer, "close", UDim2.new(0.5, -2, 0, 28), UDim2.new(0.5, 2, 0, 68), function()
closeOpenMenu()
resetMenuCosmeticKindToSkin()
main.Visible = false
end)
local hint = Instance.new("TextLabel")
hint.BackgroundTransparency = 1
hint.Size = UDim2.new(1, 0, 0, 14)
hint.Position = UDim2.new(0, 0, 0, 102)
hint.Font = UI_FONT
hint.TextSize = 10
hint.TextXAlignment = Enum.TextXAlignment.Center
hint.TextColor3 = COL.muted
hint.Text = "right click a weapon to toggle the skin changer for it."
hint.Parent = footer
getgenv().Rivals_toggleCosmeticsGui = function()
local opening = not main.Visible
main.Visible = opening
if opening then
rebuildCosmeticGrid()
else
closeOpenMenu()
resetMenuCosmeticKindToSkin()
end
end
rebuildWeaponGrid()
rebuildCosmeticGrid()
local dragConn, dragEnd
titleBar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
local start = input.Position
local orig = main.Position
dragEnd = UIS.InputEnded:Connect(function(ended)
if ended.UserInputType == Enum.UserInputType.MouseButton1 then
if dragConn then dragConn:Disconnect() end
if dragEnd then dragEnd:Disconnect() end
end
end)
dragConn = UIS.InputChanged:Connect(function(ch)
if ch.UserInputType == Enum.UserInputType.MouseMovement then
local delta = ch.Position - start
main.Position = UDim2.new(orig.X.Scale, orig.X.Offset + delta.X, orig.Y.Scale, orig.Y.Offset + delta.Y)
end
end)
end
end)
UIS.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.RightShift then getgenv().Rivals_toggleCosmeticsGui() end
end)
end
getgenv().Rivals_setDropdownValuesSafe = function(dropdown, values, pick, forceValues)
if not dropdown then return false end
local changed = false
if forceValues ~= false and values ~= nil then
pcall(function()
if dropdown.SetValues then dropdown:SetValues(values); changed = true end
end)
dropdown._rivalsLastPick = nil
end
if pick ~= nil then
local prev = dropdown._rivalsLastPick
if prev ~= pick or dropdown.Value ~= pick then
pcall(function() if dropdown.SetValue then dropdown:SetValue(pick, true) end end)
dropdown._rivalsLastPick = pick
changed = true
end
end
return changed
end
getgenv().Rivals_updateAppearanceDropdowns = function(wn, opts)
opts = opts or {}
local state = getgenv().Rivals_weaponAppearanceState
if not wn then return end
if not state._uiSelectedWeapon then
state._uiSelectedWeapon = wn
end
if opts.labelOnly then
state._uiDropdownPending = wn
return
end
getgenv().Rivals_ensureWeaponCosmeticCache()
getgenv().Rivals_pushDropdownPicksToUI(state._uiSelectedWeapon or wn)
state._uiDropdownPending = nil
end
getgenv().Rivals_ensureWeaponCosmeticCache()
getgenv().Rivals_setupWeaponAppearanceHooks()
getgenv().Rivals_buildCoreGui()
if getgenv()._rivalsAppearanceHeartbeat then
pcall(function() getgenv()._rivalsAppearanceHeartbeat:Disconnect() end)
getgenv()._rivalsAppearanceHeartbeat = nil
end
getgenv()._rivalsAppearanceHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
getgenv().Rivals_WEAPON_APPEARANCE_CONFIG.Enabled = true
getgenv().Rivals_tickWeaponAppearance()
local state = getgenv().Rivals_weaponAppearanceState
local wn = getgenv().Rivals_getLocalEquippedWeaponName() or state.lastWeapon
if wn then state.lastFinisherWeapon = wn end
if wn ~= state._uiWeapon then
state._uiWeapon = wn
state._uiWeaponChangedAt = tick()
getgenv().Rivals_updateAppearanceDropdowns(wn, { labelOnly = true })
elseif state._uiDropdownPending and wn and (tick() - (state._uiWeaponChangedAt or 0)) >= 0.35 then
local pending = state._uiDropdownPending
state._uiDropdownPending = nil
getgenv().Rivals_updateAppearanceDropdowns(pending)
end
end)
task.defer(function()
task.wait()
if getgenv().Rivals_hasConfiguredAppearance() then
getgenv().Rivals_applyFullLoadoutAppearance(true)
end
end)
