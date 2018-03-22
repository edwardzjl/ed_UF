
local addonName, addon = ...
local cfg = addon.cfg
----------------------------------------------------------------------------------------------------
--[显示目标、焦点战斗状态]
local function AddCombatIconTextureTo(frame)
	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\CHARACTERFRAME\\UI-StateIcon.blp")
	texture:SetTexCoord(.49, 0.99, 0, .49) -- sprite leak. booo
	texture:SetWidth(30)
	texture:SetHeight(30)
	texture:SetPoint("CENTER")
	return texture
end

local function CreateCombatIconOn(parentFrame)
	local frame = CreateFrame("Frame", nil, parentFrame)
	frame:SetWidth(30)
	frame:SetHeight(30)
	frame:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -36, 21)
	frame:Hide()
	AddCombatIconTextureTo(frame)
	RaiseFrameLevel(frame)
	return frame
end

local function ToggleCombatIcon(unit)
	local frame = _G[unit.."CombatIconFrame"]
	if UnitAffectingCombat(unit) then
		frame:Show()
	else
		frame:Hide()
	end
end
----------------------------------------------------------------------------------------------------
--[设置头像]
local function setUnitFrames()
	if not InCombatLockdown() then
		--[移动头像位置]
		-- TargetFrame:ClearAllPoints()
		-- TargetFrame:SetPoint("CENTER", UIParent, "CENTER", cfg.TargetFrameX, cfg.TargetFrameY)
		-- FocusFrame:ClearAllPoints()
		-- FocusFrame:SetPoint("CENTER", UIParent, "CENTER", cfg.FocusFrameX, cfg.FocusFrameY)
		--[隐藏玩家头像伤害治疗量]
		PlayerHitIndicator:SetText(nil)
		PlayerHitIndicator.SetText = function() end
		PetHitIndicator:SetText(nil)
		PetHitIndicator.SetText = function() end
		--[敌对，焦点，目标阵营战斗PVP图标清除]
		-- PlayerPVPIcon:SetAlpha(0)
		-- TargetFrameTextureFramePVPIcon:SetAlpha(0)
		-- FocusFrameTextureFramePVPIcon:SetAlpha(0)

		TotemFrame:ClearAllPoints()
		TotemFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -190)
		TotemFrame:SetScale(1.0)
		TotemFrame:SetAlpha(1.0)
	end
end
----------------------------------------------------------------------------------------------------
--[血条、鼠标提示信息显示职业颜色]
-- local function colour(statusbar, unit)
--     if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
--         local _, class = UnitClass(unit)
--         local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
--         statusbar:SetStatusBarColor(c.r, c.g, c.b)
--     end
-- end

-- hooksecurefunc("UnitFrameHealthBar_Update", colour)
-- hooksecurefunc("HealthBar_OnValueChanged", function(self)
-- 	colour(self, self.unit)
-- end)
----------------------------------------------------------------------------------------------------

local UnitFrame = CreateFrame("Frame")
UnitFrame:RegisterEvent("PLAYER_LOGIN")
UnitFrame:SetScript("OnEvent", function(self, event, ...)
	setUnitFrames()
	_G["targetCombatIconFrame"] = CreateCombatIconOn(TargetFrame)
	_G["focusCombatIconFrame"] = CreateCombatIconOn(FocusFrame)
end)
UnitFrame:SetScript("OnUpdate", function(self)
	ToggleCombatIcon("target")
	ToggleCombatIcon("focus")
end)
