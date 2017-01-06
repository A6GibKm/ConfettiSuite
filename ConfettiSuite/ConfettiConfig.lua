-- Confetti.IsConfigLoaded = false
--
-- --slash commands
-- SLASH_CONF1 = "/confetti"
-- SLASH_CONF2 = "/cft"
-- SlashCmdList["CONF"] = function() Confetti_ConfigFrame:Show() end
--
-- function Confetti.VaiablesLoaded()
--   if ( not Confetti_SavedVariables ) then
--   	 	Confetti_SavedVariables = {};
--   end
--   if ( not Confetti_SavedVariables[test] ) then
--   	 	Confetti_SavedVariables[test] = true;
--   end
--   if ( not Confetti_SavedVariables[on] ) then
--   	 	Confetti_SavedVariables[on] = true;
--   end
--   Confetti.IsConfigLoaded = true
--   Confetti.ConfigChange()
-- end
--
-- function Confetti.ConfigChange()
--   if not Confetti.IsConfigLoaded then
--     Confetti_ConfigFrame:Hide();
--     return;
--   end
--   if Confetti_SavedVariables.on then
--     Confetti_ConfigFrame:Show();
--   else
--     Confetti_ConfigFrame:Hide();
--   end
-- end
--
-- function Confetti.VaiablesSetToDefault()
-- 	if ( not Confetti.IsConfigLoaded  ) then
-- 		return;
-- 	end
-- 	Confetti_SavedVariables.on = true;
-- 	Confetti_SavedVariables.test = true;
--   print("Set to default");
-- 	Confetti.ConfigChange();
-- end
--
-- function ConfettiConfig_OnClick()
--   -- make sure our profile has been loaded
--   	if ( not not Confetti.IsConfigLoaded ) then -- config not loaded
--   		this:GetParent():Hide(); -- hide our config pane (this is now a checkbox)
--   		return;
--   	end
--   	-- read setting out of checkbox (or slider) and put into profile
--          -- use this:GetName() to know which checkbox was hit.
--   	if ( this:GetName() == (this:GetParent():GetName().."CheckButtonOn" ) ) then
--   		myClockConfig[myClockRealm][myClockChar].on = this:GetChecked(); -- set profile
--   	elseif ( this:GetName() == (this:GetParent():GetName().."CheckButtonTime24" ) ) then
--   		myClockConfig[myClockRealm][myClockChar].time24 = this:GetChecked();
--   	elseif ( this:GetName() == (this:GetParent():GetName().."SliderOffset" ) ) then
--   		myClockConfig[myClockRealm].offset = this:GetValue();
--   	end
--   	-- configuration was changed, make sure our addon changes too!
--   	-- notice our addon is changed right away, not when we hit 'done'.
--   	myClock_ConfigChange();
-- end
--
-- function ConfettiConfig_OnLoad()
--   Confetti_ConfigFrame:RegisterEvent("VARIABLES_LOADED");
-- end
--
-- function ConfettiConfig_OnShow()
--   -- make sure our profile has been loaded
-- 	if ( not Confetti.IsConfigLoaded ) then -- config not loaded
-- 		this:Hide(); -- hide our config pane
-- 		return;
-- 	end
-- 	-- read settings from profile, and change our checkbuttons and slider to represent them
-- 	getglobal(this:GetName().."CheckButtonOn"):SetChecked( Confetti_SavedVariables[on] );
-- 	getglobal(this:GetName().."CheckButtonTime24"):SetChecked( Confetti_SavedVariables[test] );
-- end
