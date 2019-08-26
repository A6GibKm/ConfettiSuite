-- Check if the player is a Warrior
local _, _, classIndex = UnitClass("player")

if not (classIndex == 1) then
  return;
end

if not ConfettiFrame then
  local ConfettiFrame = CreateFrame("Frame", "ConfettiFrame", UIParent);
end

local function FormatNumber(amount)

  local formatted = amount
  local k

    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');
      if (k == 0) then
        break
      end
    end
  return formatted

end

local function Unit(amount)
  -- TODO improve this
  return "k";
end

local function OnShow(self)
  self.TimeSinceLastUpdate = 0
  PlaySound(15881)
end

local function OnUpdate(self, elapsed)

  self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

  if (self.TimeSinceLastUpdate > 2.5) then
    self:Hide();
    self.TimeSinceLastUpdate = 0;
  end

end

local function OnEvent(self, event, ...)

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    local type = select(3, ...)

    if type == "SPELL_DAMAGE" then

      local timeStamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount = ...

      if (sourceName == UnitName("player") and spellName == "Shield Slam") and amount >=  ConfettiVariables.Threshold then

        ConfettiFrame:Hide();
        amount = FormatNumber(amount);
        ConfettiText:SetText("Shield Slam Hit for "..amount..""..Unit(amount).." !");
        ConfettiFrame:Show();

      end
    end
  end
end

ConfettiFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

ConfettiFrame:SetScript("OnEvent", OnEvent);
ConfettiFrame:SetScript("OnShow", OnShow);
ConfettiFrame:SetScript("OnEvent", OnUpdate);
