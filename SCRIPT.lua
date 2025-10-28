
print("Hello, World!")
-- JP HUB V1 - Loadstring Ready
-- https://github.com/seuusuario/jphubv1.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CONFIGURAÇÃO ESP
local espOn = false
local namesOn = false
local nameOffset = 2.5
local highlights = {}
local nameGuis = {}

local function createHighlight(player)
	if not player.Character then return end
	if highlights[player] then highlights[player]:Destroy() end
	local hl = Instance.new("Highlight")
	hl.Adornee = player.Character
	hl.FillColor = Color3.fromRGB(255,0,0)
	hl.OutlineColor = Color3.fromRGB(40,0,0)
	hl.FillTransparency = 0.25
	hl.OutlineTransparency = 0.2
	hl.Parent = player.Character
	highlights[player] = hl
end

local function removeHighlight(player)
	if highlights[player] then highlights[player]:Destroy() end
	highlights[player] = nil
end

local function createNameGui(player)
	if not player.Character then return end
	local head = player.Character:FindFirstChild("Head")
	if not head then return end
	if nameGuis[player] then nameGuis[player]:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = head
	billboard.Size = UDim2.new(0,80,0,15)
	billboard.StudsOffset = Vector3.new(0,nameOffset,0)
	billboard.AlwaysOnTop = true
	billboard.Parent = player.Character

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = player.Name
	label.TextColor3 = Color3.new(1,1,1)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.Parent = billboard

	nameGuis[player] = billboard
end

local function removeNameGui(player)
	if nameGuis[player] then nameGuis[player]:Destroy() end
	nameGuis[player] = nil
end

local function updateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LocalPlayer then
			if espOn then createHighlight(p) else removeHighlight(p) end
			if namesOn then createNameGui(p) else removeNameGui(p) end
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(0.3)
		updateESP()
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	removeHighlight(p)
	removeNameGui(p)
end)

for _,p in ipairs(Players:GetPlayers()) do
	p.CharacterAdded:Connect(function()
		task.wait(0.3)
		updateESP()
	end)
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JP_HUB_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0.05,0,0.8,0)
openBtn.BackgroundColor3 = Color3.fromRGB(138,43,226)
openBtn.Text = ""
openBtn.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = openBtn

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,300,0,250)
menu.Position = UDim2.new(0.05,-310,0.56,0)
menu.BackgroundColor3 = Color3.fromRGB(28,28,28)
menu.Parent = screenGui
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0,8)
menuCorner.Parent = menu

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(138,43,226)
titleBar.Parent = menu
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "JP HUB V1"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = titleBar

-- Função arrastar
local function makeDraggable(gui)
	local dragging = false
	local dragInput, mousePos, startPos
	gui.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then
			dragging=true
			mousePos=input.Position
			startPos=gui.Position
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then dragging=false end
			end)
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseMovement then
			dragInput=input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input==dragInput and dragging then
			local delta=input.Position - mousePos
			gui.Position=UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(menu)
makeDraggable(openBtn)

-- Abas
local geralTab = Instance.new("TextButton")
geralTab.Size = UDim2.new(0.5,0,0,30)
geralTab.Position = UDim2.new(0,0,0,30)
geralTab.Text = "Geral"
geralTab.BackgroundColor3 = Color3.fromRGB(60,60,60)
geralTab.TextColor3 = Color3.new(1,1,1)
geralTab.Font = Enum.Font.SourceSansBold
geralTab.Parent = menu

local visuaisTab = Instance.new("TextButton")
visuaisTab.Size = UDim2.new(0.5,0,0,30)
visuaisTab.Position = UDim2.new(0.5,0,0,30)
visuaisTab.Text = "Visuais"
visuaisTab.BackgroundColor3 = Color3.fromRGB(60,60,60)
visuaisTab.TextColor3 = Color3.new(1,1,1)
visuaisTab.Font = Enum.Font.SourceSansBold
visuaisTab.Parent = menu

local geralPage = Instance.new("Frame")
geralPage.Size = UDim2.new(1,0,1,-60)
geralPage.Position = UDim2.new(0,0,0,60)
geralPage.BackgroundTransparency = 1
geralPage.Parent = menu

local visuaisPage = Instance.new("Frame")
visuaisPage.Size = UDim2.new(1,0,1,-60)
visuaisPage.Position = UDim2.new(0,0,0,60)
visuaisPage.BackgroundTransparency = 1
visuaisPage.Visible = false
visuaisPage.Parent = menu

geralTab.Activated:Connect(function()
	geralPage.Visible = true
	visuaisPage.Visible = false
end)
visuaisTab.Activated:Connect(function()
	geralPage.Visible = false
	visuaisPage.Visible = true
end)

-- Geral: Teleguiado
local teleguiadoBtn = Instance.new("TextButton")
teleguiadoBtn.Size = UDim2.new(1,-20,0,40)
teleguiadoBtn.Position = UDim2.new(0,10,0,10)
teleguiadoBtn.BackgroundColor3 = Color3.fromRGB(70,0,130)
teleguiadoBtn.TextColor3 = Color3.new(1,1,1)
teleguiadoBtn.Font = Enum.Font.SourceSansBold
teleguiadoBtn.Text = "🚀 Teleguiado (Visual)"
teleguiadoBtn.Parent = geralPage

-- Visuais: ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1,-20,0,36)
espBtn.Position = UDim2.new(0,10,0,10)
espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSans
espBtn.Text = "ESP: OFF"
espBtn.Parent = visuaisPage
espBtn.Activated:Connect(function()
	espOn = not espOn
	espBtn.Text = "ESP: "..(espOn and "ON" or "OFF")
	updateESP()
end)

-- Visuais: Nomes
local nameBtn = Instance.new("TextButton")
nameBtn.Size = UDim2.new(1,-20,0,36)
nameBtn.Position = UDim2.new(0,10,0,56)
nameBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
nameBtn.TextColor3 = Color3.new(1,1,1)
nameBtn.Font = Enum.Font.SourceSans
nameBtn.Text = "Nomes: OFF"
nameBtn.Parent = visuaisPage
nameBtn.Activated:Connect(function()
	namesOn = not namesOn
	nameBtn.Text = "Nomes: "..(namesOn and "ON" or "OFF")
	updateESP()
end)

-- Slider offset nomes
local sliderFrame = Instance.new("Frame")
sliderFrame.Parent = visuaisPage
sliderFrame.Position = UDim2.new(0,10,0,100)
sliderFrame.Size = UDim2.new(1,-20,0,30)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0,5)
sliderCorner.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Parent = sliderFrame
sliderBar.Size = UDim2.new((nameOffset-0.5)/4.5,0,1,0)
sliderBar.BackgroundColor3 = Color3.fromRGB(180,0,255)
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,5)
barCorner.Parent = sliderBar

local knob = Instance.new("Frame")
knob.Parent = sliderFrame
knob.Size = UDim2.new(0,20,0,20)
knob.Position = UDim2.new((nameOffset-0.5)/4.5,0,0.5,-10)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = knob

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Parent = sliderFrame
sliderLabel.Size = UDim2.new(1,0,1,0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Offset Nomes: "..string.format("%.1f", nameOffset)
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 14

-- Slider drag
local dragging = false
local function updateSlider(inputX)
	local relativePos = math.cl