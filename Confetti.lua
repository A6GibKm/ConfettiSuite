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

function Confetti.FormatNumber(amount)

  local formatted, k = amount, 0

    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');
      if (k == 0) then
        break
      end
    end
  return formatted

end

function Confetti.Unit(ammount)
  return "k"
end

function Confetti.OnShow(self)
  self.TimeSinceLastUpdate = 0
  PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\Media\\Airhorn.mp3");
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

    local timeStamp, Type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

    if Type == "SPELL_DAMAGE" then

      local timeStamp, Type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount = ...

      if (sourceName == UnitName("player") and spellName == "Shield Slam") and amount >=  ConfettiVariables.Threshold then

        Confetti.Frame:Hide();
        amount = Confetti.FormatNumber(amount);
        ConfettiText:SetText("Shield Slam Hit for "..amount..""..Confetti.Unit.." !");
        Confetti.Frame:Show();

      end
    end

  elseif event == "VARIABLES_LOADED" then
      Confetti.configInitialize();
  end

end

Confetti.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
Confetti.Frame:RegisterEvent("VARIABLES_LOADED");

Confetti.Frame:SetScript("OnEvent", Confetti.OnEvent);
Confetti.Frame:SetScript("OnShow", Confetti.OnShow);
Confetti.Frame:SetScript("OnEvent", Confetti.OnUpdate);
