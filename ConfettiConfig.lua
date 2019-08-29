local _, _, classIndex = UnitClass("player")

if not (classIndex == 1) then
  return;
end

local AddonString = "|cff33ff99Confetti Suite: |r";

local DefaultThreshold = 10^6

if not ConfettiConfigFrame then
  local ConfettiConfigFrame = CreateFrame("Frame", "ConfettiConfigFrame", UIParent)
end

SLASH_CONF1 = "/confetti";
SLASH_CONF2 = "/cft";

local function ConfHandler(threshold, _)
  local t = tonumber(threshold)
  if t >= 0 then
    ConfettiVariables.threshold = t;
    print(AddonString, "Threshold set to", t)
  else
    print(AddonString, threshold, "is not a number")
  end
end

SlashCmdList["CONF"] = ConfHandler;

local function ConfigInit()
  if (not ConfettiVariables) then
    ConfettiVariables = {
      ["threshold"] = DefaultThreshold
    };
  end
end

local function OnEvent(self, event)
  if event == "VARIABLES_LOADED" then
      ConfigInit();
  end
end

ConfettiConfigFrame:RegisterEvent("VARIABLES_LOADED");
ConfettiConfigFrame:SetScript("OnEvent", OnEvent);
