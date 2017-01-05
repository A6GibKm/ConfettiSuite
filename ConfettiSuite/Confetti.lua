Confetti = {}

Confetti.threshold = 10^6

function Confetti.test()
  Confetti.threshold = 10^5
end

if not Confetti_MainFrame then
  CreateFrame("Frame", "Confetti_MainFrame", UIParent)
end

Confetti_MainFrame:RegisterEvent("COMBAT_LOG_EVENT")

function Confetti.FormatNumber(amount)
  local amountBeforeComma = math.floor(amount/ 10^6)
  local amountAfterComma = math.floor( (amount % 10^6)/10^4  )
  return amountBeforeComma.."."..amountAfterComma
end

function Confetti_OnLoad(self)
  self:Hide()
  ConfettiArt_Text:SetFont("Fonts\\FRIZQT__.ttf", 35)
  --print("Confetti loaded.")
end

function Confetti_Show(amount)
  ConfettiArt:Show()
  ConfettiArt_Text:SetText("Shield Slam Hit for "..amount.." m !")
  PlaySoundFile("Interface\\AddOns\\ConfettiSuite\\airhorn.mp3")
  C_Timer.After(2.5, function() ConfettiArt:Hide() end)
end

function Confetti_MainFrame_OnEvent(self, event, ...)
  local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
  if event == "COMBAT_LOG_EVENT" and type == "SPELL_DAMAGE" then
    local spellId, spellName, spellSchool = select(12, ...)
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(15, ...)
    if (spellName=="Shield Slam") and (amount >=  Confetti.threshold ) then
      amount = Confetti.FormatNumber(amount)
      Confetti_Show(amount)
    end
  end
end

Confetti_MainFrame:SetScript("OnEvent", Confetti_MainFrame_OnEvent)
