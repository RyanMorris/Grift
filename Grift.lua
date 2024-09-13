
Grift = {};

Grift.Settings = {
	["Difficulty"] = 1,
	["Style"] = 1,
};

GRIFT_DESCRIPTION = {
	"3 difficulties:",
	"1 is easiest, 3 is hardest.",
	"Harder difficulties give more rewards.",
	"(soon)",
	"",
	"7 styles",
	"1 is least risky, 7 is most risky.",
	"Risky meaning enemies deal more",
	"damage, but have less health.",
};

GriftSavedVars = {
	["Settings"] = {
	},
}

function Grift:OnLoad()
	SLASH_GRIFTCMD1 = "/grift";
	SLASH_GRIFTCMD2 = "/gr";
	SlashCmdList["GRIFTCMD"] = function(msg)
		if string.lower(msg) == "test" then
			DEFAULT_CHAT_FRAME:AddMessage("grift command received, good test");
			
		--elseif string.sub(msg, 1, 1) == "s" then
		--	local _, d, s = string.find(msg, "%w+ (%d+) (%d+)");
		--	DEFAULT_CHAT_FRAME:AddMessage(string.format(".gr s %d %d", d, s));	
		--elseif string.sub(msg, 1, 1) == "c" then
		--	DEFAULT_CHAT_FRAME:AddMessage(".gr c");
		
		else
			-- DBMMinimapButton:GetScript("OnClick")();
			Grift:MinimapButtonOnClick();
		end
	end
	
	OnLoadFrame:RegisterEvent("VARIABLES_LOADED");
	OnLoadFrame:RegisterEvent("PLAYER_LEAVING_WORLD");
	
	GPrint("Loaded - type /gr for settings", 1.0, 1.0, 0.5);
end

function Grift.OnEvent(event, ...)
	--GPrint("Grift:OnEvent()", 1.0, 1.0, 0.5);
	if (event == "VARIABLES_LOADED") then
		--GPrint("Grift:OnEvent() VARIABLES_LOADED", 1.0, 1.0, 0.5);
		Grift:LoadVars();
	elseif (event == "PLAYER_LEAVING_WORLD") then -- PLAYER_LOGOUT seems to be fired after saving of variables in same cases (?)
		--GPrint("Grift:OnEvent() PLAYER_LEAVING_WORLD", 1.0, 1.0, 0.5);
		GriftSavedVars.Settings = Grift.Settings;
	end
end

function Grift:MainFrameOnLoad()
	--GPrint("Grift:MainFrameOnLoad() BEGIN", 1.0, 1.0, 0.5);
	
	tinsert(UISpecialFrames, "GriftMainFrame");
	
	for i, value in pairs(GRIFT_DESCRIPTION) do
		GriftSettingsFrameDescription:SetText( 
			GriftSettingsFrameDescription:GetText().."\n"..value
		);
	end
	
	Grift:MainFrameUpdate();
	--GPrint("Grift:MainFrameOnLoad() END", 1.0, 1.0, 0.5);
end

function Grift:MainFrameOnShow()
	--GPrint("Grift:MainFrameOnShow()", 1.0, 1.0, 0.5);
	Grift:MainFrameUpdate();
	UpdateMicroButtons();
	PlaySound("igMainMenuOpen");
end

function Grift:MainFrameOnHide()
	--GPrint("Grift:MainFrameOnHide()", 1.0, 1.0, 0.5);
	UpdateMicroButtons();
	PlaySound("igMainMenuClose");
	getglobal("GriftSettingsFrame"):Hide();
end

function Grift:MainFrameUpdate()
	Grift:SetTitleText();
	
	getglobal("GriftSettingsFrame"):Show()
	GriftSettingsFrameDescription:Show()
	
	-- for i, value in pairs(GRIFT_DESCRIPTION) do
		-- GriftSettingsFrameDescription:SetText( 
			-- GriftSettingsFrameDescription:GetText().."\n"..value
		-- );
	-- end
	
	GriftSettingsFrameButton1:SetText("Set");
	GriftSettingsFrameButton1:SetScript("OnClick", function() Grift:SendSet(); end);
	GriftSettingsFrameButton1:Enable();
	
	-- GriftSettingsFrameButton2:SetText("Check");
	-- GriftSettingsFrameButton2:SetScript("OnClick", function() Grift:SendCheck(); end);
	-- GriftSettingsFrameButton2:Enable();
	
	GriftSettingsFrameButton3:SetText("Check");
	GriftSettingsFrameButton3:SetScript("OnClick", function() Grift:SendCheck(); end);
	GriftSettingsFrameButton3:Enable();
	
	-- GriftSettingsFrameButton4:SetText("Check");
	-- GriftSettingsFrameButton4:SetScript("OnClick", function() Grift:SendCheck(); end);
	-- GriftSettingsFrameButton4:Enable();
end

function Grift:LoadVars()
	--GPrint(string.format("Grift:LoadVars() PRE Grift.Settings.Difficulty %d", Grift.Settings.Difficulty), 1.0, 1.0, 0.5);
	--GPrint(string.format("Grift:LoadVars() PRE Grift.Settings.Style %d", Grift.Settings.Style), 1.0, 1.0, 0.5);
	for k, value in pairs(Grift.Settings) do
		--GPrint(string.format("Grift:LoadVars() key %s value %d", k, value), 1.0, 1.0, 0.5);
		if GriftSavedVars.Settings[k] == nil then
			GriftSavedVars.Settings[k] = value;
			--GPrint(string.format("Grift:LoadVars() nil, new val %d", GriftSavedVars.Settings[k]), 1.0, 1.0, 0.5);
			--GPrint(string.format("Grift:LoadVars() nil, new val %d", value), 1.0, 1.0, 0.5);
		else
			Grift.Settings[k] = GriftSavedVars.Settings[k];
			--GPrint(string.format("Grift:LoadVars() loaded, new val %s", Grift.Settings[k]), 1.0, 1.0, 0.5);
			--GPrint(string.format("Grift:LoadVars() loaded, new val %d", value), 1.0, 1.0, 0.5);
		end
	end
	--GPrint(string.format("Grift:LoadVars() POST Grift.Settings.Difficulty %d", Grift.Settings.Difficulty), 1.0, 1.0, 0.5);
	--GPrint(string.format("Grift:LoadVars() POST Grift.Settings.Style %d", Grift.Settings.Style), 1.0, 1.0, 0.5);
end

function Grift:SendSet()
	local difficulty = Grift.Settings.Difficulty;
	local style = Grift.Settings.Style;
	GPrint("Sending new settings...", 1.0, 1.0, 0.5);
	SendChatMessage(string.format(".gr s %d %d", difficulty, style), "SAY");
end

function Grift:SendCheck()
	GPrint("Checking current settings...", 1.0, 1.0, 0.5);
	SendChatMessage(".gr c", "SAY");
end

function Grift:MinimapButtonOnClick()
	if GriftMainFrame:IsShown() then
		HideUIPanel(GriftMainFrame);
	else
		ShowUIPanel(GriftMainFrame);
	end
end

function Grift:SetTitleText()
	GriftMainFrameTitleText:SetText("Grift");
end

function Grift:Print(msg, r, g, b)
	GPrint(msg, r, g, b);
end

function GPrint(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(
		string.format("|cff%2x%2x%2xGrift: |r%s", 161, 94, 219, msg),
		r, g, b);
end

