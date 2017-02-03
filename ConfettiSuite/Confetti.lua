local _, _, classIndex = UnitClass("player")

if not ( classIndex == 1 ) then
  return;
end

Confetti = {}

Confetti.AddonString = "|cff33ff99Confetti Suite: |r"


if not ConfettiFrame then
  ConfettiFrame = CreateFrame("Frame", "ConfettiFrame", UIParent);
end

if not ConfettiSRFrame then
  ConfettiSRFrame = CreateFrame("Frame", "ConfettiSRFrame", UIParent);
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

ConfettiOnShow = function(self)

  self.TimeSinceLastUpdate = 0

  if self:GetName() == "ConfettiArt" then
    PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\Media\\Airhorn.mp3");
  end

end

function ConfettiOnUpdate(self, elapsed)

  self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

  if (self.TimeSinceLastUpdate > 2.5) then
    self:Hide();
    self.TimeSinceLastUpdate = 0;
  end
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

      end

      if Confetti.spellId then
        if (sourceGUID == Confetti.sourceGUID and destGUID == Confetti.sourceGUID) and spellId == Confetti.spellId then

          ConfettiSR:Hide();
          _, _, icon ,_  = GetSpellInfo(spellId);
          ConfettiSRIcon:SetTexture(icon);
          ConfettiSRText:SetText("Reflect: "..spellName.." for "..Confetti.FormatNumber(amount)..".");
          ConfettiSR:Show();

          Confetti.TotalDmg = Confetti.TotalDmg + amount
          Confetti.spellId = nil
          Confetti.sourceGUID = nil

        end
      end

    elseif type == "SWING_MISSED" then
      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, missType, isOffHand, amountMissed = ...

      if missType == "ABSORB" then
        Confetti.TotalHits = Confetti.TotalHits + 1
        if UnitBuff("player", "Shield Block") or UnitBuff("player", "Neltharion's Fury") then
          Confetti.Blocked = Confetti.Blocked + 1
        end
      end

    elseif type == "SWING_DAMAGE" and destName == UnitName("player") then

      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, amount, _, school, _, blocked, absorbed, critical, glancing, crushing, isOffHand = ...

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
        print(Confetti.AddonString.."Reflected "..Confetti.FormatNumber(Confetti.TotalDmg).." Damage.")
      end
    end

    if (Confetti.Blocked and Confetti.TotalHits) then
      if Confetti.TotalHits > 1 and ConfettiVariables.SBEnabled then
        local eblock = math.floor(1000 * Confetti.Blocked/ Confetti.TotalHits)/10
        print(Confetti.AddonString.."Blocked "..eblock.."% of melee hits.")
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
