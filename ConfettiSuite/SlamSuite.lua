Confetti = {}

threshold = 10^6

if not MyCombatFrame then
  CreateFrame("Frame", "MyCombatFrame", UIParent)
end

MyCombatFrame:RegisterEvent("COMBAT_LOG_EVENT")

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function Confetti_OnLoad(self)
  self:Hide()
  ConfettiArt_Text:SetFont("Fonts\\FRIZQT__.ttf", 35)
  print("Confetti loaded.")
end

function Confetti_Show(amount)
  ConfettiArt:Show()
  --ConfettiArt:SetScript("OnUpdate", onUpdate)
  ConfettiArt_Text:SetText("Shield Slam Hit for "..amount.." m.")
  PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\airhorn.mp3")
  C_Timer.After(2.5, function() ConfettiArt:Hide() end)
end

function MyCombatFrame_OnEvent(self, event, ...)
  local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
  if event == "COMBAT_LOG_EVENT" then
    if type == "SPELL_DAMAGE" then
      local spellId, spellName, spellSchool = select(12, ...)
      local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
      if (spellName=="Shield Slam") and (amount >  threshold ) then
        amount = comma_value(round(amount / 1000000 , 2))
        --DEFAULT_CHAT_FRAME:AddMessage("Shield Slam Just Hitted for "..amount.." m.")
      Confetti_Show(amount)
      end
    end
  end
end

MyCombatFrame:SetScript("OnEvent", MyCombatFrame_OnEvent)
