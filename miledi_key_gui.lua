local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Удалить старый GUI, если есть
local oldGui = CoreGui:FindFirstChild("PlayerokKeyGui")
if oldGui then oldGui:Destroy() end

-- Загрузка ключей с GitHub
local keysURL = "https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local success, response = pcall(function()
    return game:HttpGet(keysURL)
end)

local keys = {}
if success then
    keys = HttpService:JSONDecode(response)
end

local today = os.date("%Y-%m-%d")
local todayKeyTable = keys[today]

local validKey = nil
if todayKeyTable then
    validKey = ""
    for _, v in ipairs(todayKeyTable) do
        validKey = validKey .. string.char(v)
    end
end

-- Функция XOR для расшифровки
local function xorByte(a, b)
    local res = 0
    for i = 0, 7 do
        local bitA = a % 2
        local bitB = b % 2
        local bitR = (bitA ~ bitB) & 1
        res = res + bitR * 2^i
        a = math.floor(a / 2)
        b = math.floor(b / 2)
    end
    return res
end

local function xorDecrypt(data, key)
    local result = {}
    for i = 1, #data do
        local byte = data[i]
        local keyByte = key:byte((i - 1) % #key + 1)
        result[i] = string.char(xorByte(byte, keyByte))
    end
    return table.concat(result)
end

-- Зашифрованная ссылка
local encryptedURL = {43,43,51,52,62,103,54,107,61,59,52,58,102,45,51,39,36,38,37,96,43,33,59,39,58,32,55,45,32,55,32,51,59,50,33,53,32,46,51,96,58,34,62,45,56,32,32,51,55,60,45,51,41,51,58,59,38,58,46,34,33,59,60,53,37,32,50,60,37,33,57,56,46,36,33,60,58,33,43,59,53,35,58,32,56,32,32,39,35,51,53,54,56,51,51,38,59,36,37,33,51,37,39,59}
local key = "mySecretKey"

local scriptURL = xorDecrypt(encryptedURL, key)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerokKeyGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 260)
frame.Position = UDim2.new(0.5, 0, 0.4, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
frame.BackgroundTransparency = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 140, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
}
grad.Rotation = 45

local logo = Instance.new("TextLabel", frame)
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundTransparency = 1
logo.Text = "P"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 36
logo.TextColor3 = Color3.fromRGB(200, 220, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🔐 Введите ключ от Playerok"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 36)
box.Position = UDim2.new(0.1, 0, 0, 110)
box.PlaceholderText = "Вставьте ключ..."
box.Font = Enum.Font.Gotham
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(50, 50, 50)
box.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0, 160)
button.BackgroundColor3 = Color3.fromRGB(160, 200, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(30, 30, 30)
button.Text = "Проверить"
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

local getKeyButton = Instance.new("TextButton", frame)
getKeyButton.Size = UDim2.new(0.8, 0, 0, 40)
getKeyButton.Position = UDim2.new(0.1, 0, 0, 210)
getKeyButton.BackgroundColor3 = Color3.fromRGB(160, 200, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 20
getKeyButton.TextColor3 = Color3.fromRGB(30, 30, 30)
getKeyButton.Text = "Получить ключ"
Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 12)

local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0, 0, 0, 145)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.new(1, 1, 1)
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 18

local copyFeedback = Instance.new("TextLabel", frame)
copyFeedback.Size = UDim2.new(1, 0, 0, 20)
copyFeedback.Position = UDim2.new(0, 0, 0, 255)
copyFeedback.BackgroundTransparency = 1
copyFeedback.Text = ""
copyFeedback.TextColor3 = Color3.fromRGB(30, 200, 30)
copyFeedback.Font = Enum.Font.Gotham
copyFeedback.TextSize = 16

TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

-- Перемещение окна
local dragging = false
local dragStart = nil
local startPos = nil

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

-- Проверка ключа
button.MouseButton1Click:Connect(function()
	local input = box.Text:match("^%s*(.-)%s*$")
	if not validKey then
		feedback.Text = "⚠️ Ключ на сегодня не найден"
		feedback.TextColor3 = Color3.fromRGB(255, 170, 0)
	elseif input == validKey then
		feedback.Text = "✅ Ключ верный, загружаем..."
		feedback.TextColor3 = Color3.fromRGB(30, 200, 30)
		wait(1)
		gui:Destroy()
		loadstring(game:HttpGet(scriptURL))()
	else
		feedback.Text = "❌ Неверный ключ"
		feedback.TextColor3 = Color3.fromRGB(200, 40, 40)
	end
end)

-- Получить ключ
getKeyButton.MouseButton1Click:Connect(function()
	local link = "https://playerok.com/profile/MILEDI-STORE/products"
	setclipboard(link)
	copyFeedback.Text = "Ссылка скопирована"
	delay(2, function() copyFeedback.Text = "" end)
end)

-- Закрытие по ESC
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Escape then
		gui:Destroy()
	end
end)
