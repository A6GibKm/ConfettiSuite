Confetti = {}

local _, _, classIndex = UnitClass("player")

if not ( classIndex == 1 ) then
  return;
end

function Confetti.Test()
  ConfettiVariables.Threshold = 10^5;
  print ("threshold set to 100.000");
end

if not ConfettiFrame then
  ConfettiFrame = CreateFrame("Frame", "ConfettiFrame", UIParent);
end

function Confetti.FormatNumber(amount,bolean)
  if bolean then
    local amountBeforeComma = math.floor(amount/ 10^6);
    local amountAfterComma = math.floor( (amount % 10^6)/10^4);
    return amountBeforeComma.."."..amountAfterComma;
  end

  local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
  return formatted
end

Confetti.OnShow = function()
  PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\airhorn.mp3");
end

Confetti.OnEvent = function(self, event, ...)

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

    if type == "SPELL_MISSED" and destGUID == UnitGUID("player") then
      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, misstype = ...

      if misstype == "REFLECT" then
        Confetti.spellId = spellId
        Confetti.sourceGUID = sourceGUID
      end

    elseif type == "SPELL_DAMAGE" then

      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount = ...

      --Show confetti
      if (sourceName == UnitName("player") and spellName=="Shield Slam") and amount >=  ConfettiVariables.Threshold then

        ConfettiArt:Hide();
        amount = Confetti.FormatNumber(amount,true);
        ConfettiText:SetText("Shield Slam Hit for "..amount.." m !");
        ConfettiArt:Show();
        C_Timer.After(2.5, function() ConfettiArt:Hide() end);

      end

      if Confetti.spellId then
        if (sourceGUID == Confetti.sourceGUID and destGUID == Confetti.sourceGUID) and spellId == Confetti.spellId then

          ConfettiSR:Hide();
          _, _, icon ,_  = GetSpellInfo(spellId);

          ConfettiSRIcon:SetTexture(icon);
          ConfettiSRText:SetText("Reflect: "..spellName.." for "..Confetti.FormatNumber(amount)..".");
          ConfettiSR:Show();

          C_Timer.After(2.5, function() ConfettiSR:Hide() end);

          Confetti.TotalDmg = Confetti.TotalDmg + amount
          Confetti.spellId = nil
          Confetti.sourceGUID = nil

        end
      end

    elseif type == "SWING_DAMAGE" and destGUID == UnitGUID("player") then

      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, _, school, _, blocked = ...

      if Confetti.TotalHits then
        Confetti.TotalHits = Confetti.TotalHits + 1

        if blocked then
          Confetti.Blocked = Confetti.Blocked + 1
        end

      end

    end

  elseif event == "PLAYER_REGEN_DISABLED" then
    Confetti.TotalDmg = 0
    Confetti.Blocked = 0
    Confetti.TotalHits = 0

  elseif event == "PLAYER_REGEN_ENABLED" then
    if Confetti.TotalDmg then
      if Confetti.TotalDmg ~= 0 then
        print("|cff33ff99Confetti Suite: |rReflected "..Confetti.FormatNumber(Confetti.TotalDmg).." Damage.")
      end
    end

    if (Confetti.Blocked and Confetti.TotalHits) then
      if Confetti.TotalHits > 1 then
        local eblock = math.floor(100* Confetti.Blocked / Confetti.TotalHits)
        print("|cff33ff99Confetti Suite: |rBlocked "..eblock.."% of melee hits.")
      end
    end

  elseif ( event == "VARIABLES_LOADED" ) then
    ConfettiCfg.VariablesLoaded();
  end

end

ConfettiFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
ConfettiFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
ConfettiFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
ConfettiFrame:RegisterEvent("VARIABLES_LOADED");

ConfettiFrame:SetScript("OnEvent", Confetti.OnEvent);
