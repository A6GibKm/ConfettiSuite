ConfettiCfg = {}

ConfettiCfg.IsConfigLoaded = false

if not ConfettiConfig then
  ConfettiConfig = CreateFrame("Frame","ConfettiConfig",UIParent);
end

SLASH_CONF1 = "/confetti"
SLASH_CONF2 = "/cft"
SlashCmdList["CONF"] = function()
  print("|cff33ff99Confetti Suite: |rConfig Loaded")
  ConfettiConfigWindow:Show();
end

ConfettiCfg.VariablesLoaded = function()
  if ( not ConfettiVariables ) then
  	 	ConfettiVariables = {
        ["on"] = true,
        ["test"] = true,
        ["Threshold"] = 9*10^5,
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

  ConfettiConfigWindowThreshold:SetNumber(ConfettiVariables.Threshold)

end

ConfettiCfg.VaiablesSetToDefault = function()
	if ( not ConfettiCfg.IsConfigLoaded  ) then
		return;
	end
	ConfettiVariables.on = true;
	ConfettiVariables.test = true;
  print("|cff33ff99Confetti Suite: |rSet to default");
	ConfettiCfg.ConfigChange();
end

ConfettiCfg.ConfigThreshold = function(text)
  ConfettiVariables.Threshold = text:GetNumber();
  print("|cff33ff99Confetti Suite: |rConfetti will be shown for SS hits over "..Confetti.FormatNumber(text:GetNumber()))
  ConfettiCfg.ConfigChange();
end


ConfettiCfg.ConfigOnClick = function(button)

  if ( not ConfettiCfg.IsConfigLoaded ) then
		return;
	end

  if ( button:GetName() == (button:GetParent():GetName().."EnabledButton" ) ) then
    ConfettiVariables.on = button:GetChecked();

    if button:GetChecked() then
      print("|cff33ff99Confetti Suite: |rThe Confetti is Enabled.")
    else
      print("|cff33ff99Confetti Suite: |rThe Confetti is Disabled. Sad.")
    end

  elseif ( button:GetName() == (button:GetParent():GetName().."SREnabledButton" ) ) then
    ConfettiVariables.SREnabled = button:GetChecked();

    if button:GetChecked() then
      print("|cff33ff99Confetti Suite: |rThe Spell Reflect Module is Enabled.")
    else
      print("|cff33ff99Confetti Suite: |rThe Spell Reflect Module is Disabled. Sad.")
    end

  elseif ( button:GetName() == (button:GetParent():GetName().."SBEnabledButton" ) ) then
    ConfettiVariables.SBEnabled = button:GetChecked();

    if button:GetChecked() then
      print("|cff33ff99Confetti Suite: |rThe Shield Block Module is Enabled.")
    else
      print("|cff33ff99Confetti Suite: |rThe Shield Block Module is Disabled. Sad.")
    end

  end
  ConfettiCfg.ConfigChange();
end

ConfettiCfg.ConfigOnShow = function()
	if ( not ConfettiCfg.IsConfigLoaded ) then
		return;
	end
  ConfettiConfigWindowEnabledButton:SetChecked(ConfettiVariables.on);
  ConfettiConfigWindowSREnabledButton:SetChecked(ConfettiVariables.SREnabled);
  ConfettiConfigWindowSBEnabledButton:SetChecked(ConfettiVariables.SBEnabled);
  ConfettiConfigWindowThreshold:SetNumber(ConfettiVariables.Threshold);
end
