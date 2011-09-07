local T, C, L = unpack(ElvUI)

-- Config/Class Settings
local Options = {
	iconSpacing = 3, -- Spacing between icons
	iconSize = 36,   -- Size of the buff icons
}

local font  = C["media"].font

-- Handy macro's for getting SpellID's
-- Buffs
--/run for i = 1, 40 do local n,_,_,_,_,_,_,_,_,_,id = UnitAura("player", i) if n then print(n.." = "..id) end end
-- Debuffs
--/run for i = 1, 40 do local n,_,_,_,_,_,_,_,_,_,id = UnitDebuff("target", i) if n then print(n.." = "..id) end end

local GetSpell = function(SpellID)
	local name = select(1, GetSpellInfo(SpellID))
	return name
end

local Config = { -- Note to self: remove keys, they're not needed anymore.
	ROGUE = {
		[1] = {"target", GetSpell(2818), nil, "HARMFUL"},         -- Deadly Poison
		[2] = {"target", GetSpell(3409), nil, "HARMFUL"},         -- Cripping Poison
		[3] = {"target", GetSpell(1943), nil, "HARMFUL"},         -- Rupture
		[4] = {"player", GetSpell(73651), nil, "HELPFUL"},        -- Recuperate
		[5] = {"player", GetSpell(5171), nil, "HELPFUL"},         -- Slice and Dice
		[6] = {"player", GetSpell(5277), nil, "HELPFUL"},         -- Evasion
		[7] = {"player", GetSpell(31224), nil, "HELPFUL"},        -- Cloak of Shadows
		[8] = {"player", GetSpell(2983), nil, "HELPFUL"},         -- Sprint
		[9] = {"player", GetSpell(703), nil, "HELPFUL"},          -- Garrote
	},
	PRIEST = {
		[1] = {"player", GetSpell(17), nil, "HELPFUL"},           -- Power Word: Shield
		[2] = {"player", GetSpell(6788), nil, "HARMFUL"},         -- Weakened Soul
		[3] = {"target", GetSpell(589), nil, "HARMFUL"},          -- Shadow Word: Pain
		[4] = {"target", GetSpell(2944), nil, "HARMFUL"},         -- Devouring Plague
		[5] = {"target", "Vampiric Touch", nil, "HARMFUL"},       -- Vampiric Touch
		[6] = {"player", GetSpell(74241), nil, "HELPFUL"},        -- Power Torrent
		[7] = {"target", GetSpell(15357), nil, "HELPFUL"},        -- Inspiration
		[8] = {"player", GetSpell(47753), nil, "HELPFUL"},        -- Divine Aegis
		[9] = {"player", GetSpell(41635), nil, "HELPFUL"},   	  -- Prayer of Mending
	},
	DRUID = {
		[1] = {"target", "Rip", nil, "HARMFUL"},                  -- Rip
		[2] = {"target", "Rake", nil, "HARMFUL"},                 -- Rake
		[3] = {"target", "Mangle", nil, "HARMFUL"},               -- Mangle
		[4] = {"player", "Savage Roar", nil, "HELPFUL"},          -- Savage Roar
	},
	WARRIOR = {
		[1] = {"target", "Rend", nil, "HARMFUL"},                 -- Rend
		[2] = {"player", "Flurry", nil, "HELPFUL"},               -- Flurry
		[3] = {"player", "Bloodthirst", nil, "HELPFUL"},          -- Bloodthirst
	},
	WARLOCK = {
		[1] = {"target", "Bane of Agony", nil, "HARMFUL"},        -- Bane of Agony
		[2] = {"target", "Corruption", nil, "HARMFUL"},           -- Corruption
		[3] = {"target", "Immolate", nil, "HARMFUL"},             -- Immolate
	},
	HUNTER = {
		[1] = {"target", "Serpent Sting", nil, "HARMFUL"},        -- Serpent Sting
		[2] = {"target", "Explosive Shot", nil, "HARMFUL"},       -- Explosive Shot
		[3] = {"target", "Hunter's Mark", nil, "HARMFUL"},        -- Hunter's Mark
		[4] = {"player", "Black Arrow", nil, "HELPFUL"},          -- Black Arrow
	},
	SHAMAN = {
		[1] = {"player", "Unleash Life", nil, "HELPFUL"},         -- Earthliving
		[2] = {"player", GetSpell(73683), nil, "HELPFUL"},        -- Flametongue
		[3] = {"player", "Tidal Waves", nil, "HELPFUL"},          -- Tidal Waves
		[4] = {"player", "Riptide", nil, "HELPFUL"},              -- Riptide
		[5] = {"target", "Flame Shock", nil, "HARMFUL"},          -- Flame Shock
		[6] = {"target", "Earth Shock", nil, "HARMFUL"},          -- Earth Shock
		[7] = {"target", "Frost Shock", nil, "HARMFUL"},          -- Frost Shock
		[8] = {"player", "Elemental Mastery", nil, "HELPFUL"},    -- Elemental Mastery
		[9] = {"player", GetSpell(96230), nil, "HELPFUL"},        -- Synapse Springs
		[10] = {"player", GetSpell(99712), nil, "HELPFUL"},       -- Trin: B Dominance
		[11] = {"player", GetSpell(91024), nil, "HELPFUL"},       -- Trin: Theralion(Normal)
		[12] = {"player", GetSpell(91007), nil, "HELPFUL"},       -- Trin: Bell(normal)
		[13] = {"player", "Power Torrent", nil, "HELPFUL"},       -- Ench: Power Torrent
	},
	DEATHKNIGHT = {
		[1] = {"target", "Blood Plague", nil, "HARMFUL"},         -- Blood Plague
		[2] = {"target", "Frost Fever", nil, "HARMFUL"},          -- Frost Fever
		[3] = {"target", "Unholy Blight", nil, "HARMFUL"},        -- Unholy Blight
		[4] = {"player", "Blood Shield", nil, "HELPFUL"},         -- Blood Shield
	},
	PALADIN = {
		[1] = {"target", "Beacon of Light", nil, "HELPFUL"},      -- Beacon of Light
		[2] = {"target", "Judgement of Light", nil, "HARMFUL"},   -- Judgement of Light
		[3] = {"player", "Divine Plea", nil, "HELPFUL"},          -- Divine Plea
		[4] = {"player", "Divine Illumination", nil, "HELPFUL"},  -- Divine Illumination
	},
	MAGE = {
		[1] = {"target", "Scorch", nil, "HARMFUL"},               -- Scorch
		[2] = {"target", "Arcane Blast", nil, "HARMFUL"},         -- Arcane Blast
		[3] = {"player", "Missile Barrage", nil, "HELPFUL"},      -- Missile Barrage
		[4] = {"player", "Fireball!", nil, "HELPFUL"},            -- Fireball!
	},
}

-- Core
local cache = {}
local offset = 0
local tslu = 1

local CreateBars = function(self, ela)
	tslu = tslu - ela
	
	if tslu < 0 then
		if cache[1] then
			for i = 1, getn(cache) do
				cache[i]:Kill()
			end
			wipe(cache) 
		end

		for i, v in ipairs(Config[T.myclass]) do
			local name, _, icon, count, _, duration, expires, unit, _, _, _ = UnitAura(unpack(v))

			if count and unit == "player" then
				local min, max = (-1 * (GetTime() - expires)), duration
				local r, g, b = ElvUF.ColorGradient(min/max, 1,0,0,1,1,0,0,1,0)

			-- Create timers
			local frame = CreateFrame("Frame", "tIconBG"..i, UIParent)
			frame:CreatePanel(nil, Options.iconSize, Options.iconSize, "CENTER", UIParent, "CENTER", 0, 0)

			frame.Icon = frame:CreateTexture(nil, "ARTWORK")
			frame.Icon:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
			frame.Icon:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
			frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			frame.Icon:SetTexture(icon)
			
			frame.Time = frame:FontString("Time", font, 14, "THINOUTLINE")
			frame.Time:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
			frame.Time:SetTextColor(r, g, b)
			if floor(min) > 59 then
					frame.Time:SetText(ceil((min)/60).."m")
				else
					frame.Time:SetText(floor(min).."s")
				end
			
			if (frame.count) then
					frame.count = _G[bar.count:GetName()]
				else
					frame.count = frame:CreateFontString("Count", "ARTWORK")
					frame.count:SetFont(C["media"].uffont, 14, "OUTLINE")
					frame.count:Point("TOPRIGHT", -2, -2)
					frame.count:SetJustifyH("CENTER")
				end

			if count > 0 then
				frame.Time = frame:FontString("Time", font, 12, "THINOUTLINE")
				frame.count:Point("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
				frame.count:SetText(count)
			end
				
				tinsert(cache, frame)
			end
		end
		
		for key, frame in ipairs(cache) do
			offset = getn(cache) * 18 - (Options.iconSize / 2)
			frame:ClearAllPoints()
			if key == 1 then
				frame:Point("CENTER", T.UIParent, "CENTER", -offset, 200)
			else
				frame:Point("LEFT", cache[key-1], "RIGHT", Options.iconSpacing, 0)
			end
		end
		tslu = 1
	end
end

local StartTimers = function(self, event) -- Need a nice method to stop OnUpdate after timers finish
	self:UnregisterEvent("UNIT_AURA")
	self:SetScript("OnUpdate", CreateBars)
end

local CheckAuras = CreateFrame("Frame")
CheckAuras:RegisterEvent("UNIT_AURA")
CheckAuras:SetScript("OnEvent", StartTimers)
--[[
local finished = false

while not finished do
	if not count then
		finished = true
	end
end]]