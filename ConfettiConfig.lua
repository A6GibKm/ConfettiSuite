local _, _, classIndex = UnitClass("player")

if not (classIndex == 1) then
  return;
end

if not Confetti then
  Confetti = {}
end

SLASH_CONF1 = "/confetti";
SLASH_CONF2 = "/cft";

SlashCmdList["CONF"] = function(threshold)
  ConfettiConfig.Initialize();
  if threshold > 0 then
    ConfettiVariables.threshold = threshold;
  end
end

function Confetti.configInitialize()
  if (not ConfettiVariables) then
    ConfettiVariables = {
      ["threshold"] = 10^6,
    };
  end
end
