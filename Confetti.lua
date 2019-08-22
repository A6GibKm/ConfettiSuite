-- Check if the player is a Warrior
local _, _, classIndex = UnitClass("player")

if not (classIndex == 1) then
  return;
end

if not Confetti then
  Confetti = {}
end

Confetti.AddonString = "|cff33ff99Confetti Suite: |r"

if not Confetti.Frame then
  Confetti.Frame = CreateFrame("Frame", "Confetti.Frame", UIParent);
end

function Confetti.FormatNumber(amount,bolean)

  if bolean then
    local amountBeforeComma = math.floor(amount/ 10^6);
    local amountAfterComma = math.floor((amount % 10^6)/10^4);
    return amountBeforeComma.."."..amountAfterComma;
  end

  local formatted = amount

    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');
      if (k==0) then
        break
      end
    end
  return formatted

end

function Confetti.OnShow(self)

  self.TimeSinceLastUpdate = 0

  if self:GetName() == "ConfettiArt" then
    PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\Media\\Airhorn.mp3");
  end

end

function Confetti.OnUpdate(self, elapsed)

  self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

  if (self.TimeSinceLastUpdate > 2.5) then
    self:Hide();
    self.TimeSinceLastUpdate = 0;
  end

end

function Confetti.OnEvent(self, event, ...)

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

    if type == "SPELL_DAMAGE" then

      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount = ...

      --Show confetti
      if (sourceName == UnitName("player") and spellName=="Shield Slam") and amount >=  ConfettiVariables.Threshold then

        ConfettiArt:Hide();
        amount = Confetti.FormatNumber(amount,true);
        ConfettiText:SetText("Shield Slam Hit for "..amount.." m !");
        ConfettiArt:Show();

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

    if (Confetti.Blocked and Confetti.TotalHits) then
      if Confetti.TotalHits > 1 and ConfettiVariables.SBEnabled then
        local blockPercent = math.floor(1000 * Confetti.Blocked/ Confetti.TotalHits)/10;
        print(Confetti.AddonString.."Blocked "..blockPercent.."% of melee hits.");
      end
    end

  elseif ( event == "VARIABLES_LOADED" ) then
    ConfettiConfig.VariablesLoaded();
  end

end

Confetti.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
Confetti.Frame:RegisterEvent("PLAYER_REGEN_ENABLED");
Confetti.Frame:RegisterEvent("PLAYER_REGEN_DISABLED");
Confetti.Frame:RegisterEvent("VARIABLES_LOADED");

Confetti.Frame:SetScript("OnEvent", Confetti.OnEvent);
Confetti.Frame:SetScript("OnShow", Confetti.OnShow);
Confetti.Frame:SetScript("OnEvent", Confetti.OnUpdate);
