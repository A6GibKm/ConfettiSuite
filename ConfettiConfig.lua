local _, _, classIndex = UnitClass("player")

if not (classIndex == 1) then
  return;
end

if not ConfettiConfig then
  ConfettiConfig = {}
  ConfettiConfig.IsConfigLoaded = false
end

SLASH_CONF1 = "/confetti"
SLASH_CONF2 = "/cft"

SlashCmdList["CONF"] = function(threshold)
  if threshold > 0 then
    ConfettiVariables.threshold = threshold
  end
end

function ConfettiConfig.VariablesLoaded()
  if (not ConfettiVariables) then
    ConfettiVariables = {
      ["on"] = true,
      ["threshold"] = 10^6,
    };
  end
  ConfettiConfig.IsConfigLoaded = true
end
