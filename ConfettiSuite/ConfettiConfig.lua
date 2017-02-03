local _, _, classIndex = UnitClass("player")

if not ( classIndex == 1 ) then
  return;
end

ConfettiCfg = {}

ConfettiCfg.IsConfigLoaded = false

if not ConfettiConfig then
  ConfettiConfig = CreateFrame("Frame","ConfettiConfig",UIParent);
end

SLASH_CONF1 = "/confetti"
SLASH_CONF2 = "/cft"
SlashCmdList["CONF"] = function()
  ConfettiConfigWindow:Show();
end

ConfettiCfg.VariablesLoaded = function()
  if ( not ConfettiVariables ) then
  	 	ConfettiVariables = {
        ["on"] = true,
        ["test"] = true,
        ["Threshold"] = 10^6,
        ["SREnabled"] = true,
        ["SBEnabled"] = true
      };
  end
  ConfettiCfg.IsConfigLoaded = true
  ConfettiCfg.ConfigChange()
end

ConfettiCfg.ConfigChange = function()

  if not ConfettiCfg.IsConfigLoaded then
    return;
  end

  if ConfettiVariables.on == true then
    ConfettiFrame:Show();
  else
    ConfettiFrame:Hide();
  end

  if ConfettiVariables.SREnabled == true then
    ConfettiSRFrame:Show();
  else
    ConfettiSRFrame:Hide();
  end

end

ConfettiCfg.VaiablesSetToDefault = function()
	if ( not ConfettiCfg.IsConfigLoaded  ) then
		return;
	end
  ConfettiVariables = {
    ["on"] = true,
    ["test"] = true,
    ["Threshold"] = 10^6,
    ["SREnabled"] = true,
    ["SBEnabled"] = true
  };
  print(Confetti.AddonString.."Set to default");
	ConfettiCfg.ConfigChange();
end

ConfettiCfg.ConfigThreshold = function(self)
  ConfettiVariables.Threshold = self:GetNumber();
  print(Confetti.AddonString.."Confetti will be shown for SS hits over "..Confetti.FormatNumber(ConfettiVariables.Threshold))
  ConfettiCfg.ConfigChange();
end


ConfettiCfg.ConfigOnClick = function(button)

  if ( not ConfettiCfg.IsConfigLoaded ) then
		return;
	end

  if ( button:GetName() == (button:GetParent():GetName().."EnabledButton" ) ) then
    ConfettiVariables.on = button:GetChecked();

    if button:GetChecked() then
      print(Confetti.AddonString.."The Confetti is Enabled.")
    else
      print(Confetti.AddonString.."The Confetti is Disabled. Sad.")
    end

  elseif ( button:GetName() == (button:GetParent():GetName().."SREnabledButton" ) ) then
    ConfettiVariables.SREnabled = button:GetChecked();

    if button:GetChecked() then
      print(Confetti.AddonString.."The Spell Reflect Module is Enabled.")
    else
      print(Confetti.AddonString.."The Spell Reflect Module is Disabled.")
    end

  elseif ( button:GetName() == (button:GetParent():GetName().."SBEnabledButton" ) ) then
    ConfettiVariables.SBEnabled = button:GetChecked();

    if button:GetChecked() then
      print(Confetti.AddonString.."The Shield Block Module is Enabled.")
    else
      print(Confetti.AddonString.."The Shield Block Module is Disabled.")
    end

  end
  ConfettiCfg.ConfigChange();
end

ConfettiCfg.ConfigOnShow = function(self)
	if ( not ConfettiCfg.IsConfigLoaded ) then
		return;
	end
  print(Confetti.AddonString.."Config Loaded")
  getglobal(self:GetName().."EnabledButton"):SetChecked(ConfettiVariables.on);
  getglobal(self:GetName().."SREnabledButton"):SetChecked(ConfettiVariables.SREnabled);
  getglobal(self:GetName().."SBEnabledButton"):SetChecked(ConfettiVariables.SBEnabled);
  getglobal(self:GetName().."Threshold"):SetNumber(ConfettiVariables.Threshold);
end
