if not Confetti then Confetti = {} end

Confetti.threshold = 10^6

local _,_,classIndex = UnitClass("player")

if not classIndex == 1 then
  Confetti_MainFrame:Hide();
end

function Confetti.Test()
  Confetti.threshold = 10^5;
  print ("threshold set to 100.000");
end

if not Confetti_MainFrame then
  CreateFrame("Frame", "Confetti_MainFrame", UIParent);
end

Confetti_MainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

-- functions

function Confetti.FormatNumber(amount)
  local amountBeforeComma = math.floor(amount/ 10^6);
  local amountAfterComma = math.floor( (amount % 10^6)/10^4  );
  return amountBeforeComma.."."..amountAfterComma;
end

function Confetti_Show(amount)
  amount = Confetti.FormatNumber(amount);
  Confetti_ArtFrame_Text:SetText("Shield Slam Hit for "..amount.." m !");
  Confetti_ArtFrame:Show();
  C_Timer.After(2.5, function() Confetti_ArtFrame:Hide() end);
end

function Confetti_ArtFrame_OnShow()
  PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\airhorn.mp3");
end

function Confetti_MainFrame_OnEvent(self, event, ...)
  local _, type, _ , _ ,sourceName , _ ,_ ,_ ,_ ,_ ,_ ,_ ,spellName ,_ ,amount  = ...
  if event == "COMBAT_LOG_EVENT_UNFILTERED"
  and type == "SPELL_DAMAGE"
  and sourceName == UnitName("player")
  and spellName=="Shield Slam"
  and amount >=  Confetti.threshold  then
      Confetti_Show(amount);
  end

  -- config part
  if ( event == "VARIABLES_LOADED" ) then
		Confetti.VariablesLoaded();
	end
end

Confetti_MainFrame:SetScript("OnEvent", Confetti_MainFrame_OnEvent);

-- CONFIG

Confetti_MainFrame:SetScript("OnLoad", ConfettiConfig_OnLoad);
Confetti_MainFrame:RegisterEvent("VARIABLES_LOADED");

Confetti.IsConfigLoaded = false

--slash commands
SLASH_CONF1 = "/confetti"
SLASH_CONF2 = "/cft"
SlashCmdList["CONF"] = function() Confetti_ConfigFrame:Show() end

function Confetti.VariablesLoaded()
  if ( not Confetti_SavedVariables ) then
  	 	Confetti_SavedVariables = { ["on"] = true , ["test"] = true };
  end
  -- if ( not Confetti_SavedVariables["test"] ) then
  -- 	 	Confetti_SavedVariables["test"] = true;
  -- end
  -- if ( not Confetti_SavedVariables["on"] ) then
  -- 	 	Confetti_SavedVariables["on"] = true;
  -- end
  Confetti.IsConfigLoaded = true
  Confetti.ConfigChange()
end

function Confetti.ConfigChange()
  if not Confetti.IsConfigLoaded then
    return;
  end
  if Confetti_SavedVariables.on == true then
    Confetti_MainFrame:Show();
  else
    Confetti_MainFrame:Hide();
  end
end

function Confetti.VaiablesSetToDefault()
	if ( not Confetti.IsConfigLoaded  ) then
		return;
	end
	Confetti_SavedVariables.on = true;
	Confetti_SavedVariables.test = true;
  print("Set to default");
	Confetti.ConfigChange();
end

function ConfettiConfig_OnClick()
  if ( not Confetti.IsConfigLoaded ) then
		return;
	end
  Confetti_SavedVariables.on = EnabledButton:GetChecked(); -- set profile
  if EnabledButton:GetChecked() then
    print("The Confetti is Enabled.")
  else
    print("The Confetti is Disabled. Sad.")
  end
  Confetti.ConfigChange();
end

function ConfettiConfig_OnLoad()
  Confetti_ConfigFrame:RegisterEvent("VARIABLES_LOADED");
end

function ConfettiConfig_OnShow()
	if ( not Confetti.IsConfigLoaded ) then
		return;
	end
  EnabledButton:SetChecked(Confetti_SavedVariables.on);
end
