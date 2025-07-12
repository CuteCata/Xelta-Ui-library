--[[
    Modern Roblox UI Library - Part 1 (Core Foundation)
    สร้างโดยใช้ Metatable เพื่อให้สามารถ extend ได้ใน Part ต่อๆ ไป
    รองรับทั้ง PC และ Mobile พร้อมระบบ drag เฉพาะขอบสำหรับมือถือ
]]

local UILibrary = {}
UILibrary.__index = UILibrary

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local THEME = {
    Background = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Tertiary = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Accent = Color3.fromRGB(100, 100, 255),
    Success = Color3.fromRGB(50, 200, 50),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Utility Functions
local function CreateTween(instance, properties, duration)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Device Detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Get Safe Parent (รองรับ Executor ต่างๆ)
local function GetParent()
    local success, result = pcall(function()
        return CoreGui
    end)
    
    if success then
        return result
    else
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Lucide Icon Support
local LUCIDE_ICONS = {
    house = "rbxassetid://10734910430",
    zap = "rbxassetid://10734950309",
    close = "rbxassetid://10734896621",
    minimize = "rbxassetid://10734896621",
    maximize = "rbxassetid://10734895698",
    menu = "rbxassetid://10734898355"
}

-- Create UI Library
function UILibrary:Create(config)
    config = config or {}
    
    local Library = setmetatable({
        Name = config.Name or "UI Library",
        Windows = {},
        Theme = config.Theme or THEME,
        _connections = {},
        _metatables = {} -- สำหรับเก็บ metatable ที่จะ extend ใน Part อื่นๆ
    }, UILibrary)
    
    return Library
end

-- Window Class
local Window = {}
Window.__index = Window

function UILibrary:CreateWindow(config)
    config = config or {}
    
    local WindowObj = setmetatable({
        Name = config.Name or "Window",
        Size = config.Size or UDim2.new(0, 700, 0, 500),
        Library = self,
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        FullScreen = false,
        _gui = nil,
        _mainFrame = nil,
        _tabContainer = nil,
        _contentContainer = nil,
        _connections = {}
    }, Window)
    
    -- สร้าง GUI
    WindowObj:_CreateGUI()
    
    -- เพิ่ม Window เข้า Library
    table.insert(self.Windows, WindowObj)
    
    return WindowObj
end

function Window:_CreateGUI()
    -- Main ScreenGui
    self._gui = Instance.new("ScreenGui")
    self._gui.Name = "UILibrary_" .. self.Name:gsub(" ", "_")
    self._gui.ResetOnSpawn = false
    self._gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self._gui.Parent = GetParent()
    
    -- Main Frame
    self._mainFrame = Instance.new("Frame")
    self._mainFrame.Name = "MainFrame"
    self._mainFrame.Size = self.Size
    self._mainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self._mainFrame.BackgroundColor3 = self.Library.Theme.Background
    self._mainFrame.BorderSizePixel = 0
    self._mainFrame.Parent = self._gui
    
    -- Corner Radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = self._mainFrame
    
    -- Drop Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = self._mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = self.Library.Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self._mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = self.Name
    titleText.TextColor3 = self.Library.Theme.Text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.Gotham
    titleText.Parent = titleBar
    
    -- Control Buttons Container
    local controlContainer = Instance.new("Frame")
    controlContainer.Name = "Controls"
    controlContainer.Size = UDim2.new(0, 120, 1, 0)
    controlContainer.Position = UDim2.new(1, -120, 0, 0)
    controlContainer.BackgroundTransparency = 1
    controlContainer.Parent = titleBar
    
    -- Create Control Buttons
    self:_CreateControlButtons(controlContainer)
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -40)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = self._mainFrame
    
    -- Tab Container (Left Side)
    self._tabContainer = Instance.new("ScrollingFrame")
    self._tabContainer.Name = "TabContainer"
    self._tabContainer.Size = UDim2.new(0, 200, 1, 0)
    self._tabContainer.BackgroundColor3 = self.Library.Theme.Secondary
    self._tabContainer.BorderSizePixel = 0
    self._tabContainer.ScrollBarThickness = 2
    self._tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self._tabContainer.Parent = contentArea
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = self._tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = self._tabContainer
    
    -- Content Container (Right Side)
    self._contentContainer = Instance.new("Frame")
    self._contentContainer.Name = "ContentContainer"
    self._contentContainer.Size = UDim2.new(1, -200, 1, 0)
    self._contentContainer.Position = UDim2.new(0, 200, 0, 0)
    self._contentContainer.BackgroundColor3 = self.Library.Theme.Background
    self._contentContainer.BorderSizePixel = 0
    self._contentContainer.Parent = contentArea
    
    -- Mobile Toggle Button (ถ้าเป็นมือถือ)
    if IsMobile() then
        self:_CreateMobileToggle()
    end
    
    -- Setup Drag (เฉพาะขอบสำหรับมือถือ)
    self:_SetupDrag()
end

function Window:_CreateControlButtons(parent)
    local buttons = {
        {Name = "Minimize", Icon = "minimize", Function = function() self:Minimize() end},
        {Name = "FullScreen", Icon = "maximize", Function = function() self:ToggleFullScreen() end},
        {Name = "Close", Icon = "close", Function = function() self:Close() end}
    }
    
    for i, buttonData in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Name = buttonData.Name
        button.Size = UDim2.new(0, 30, 0, 30)
        button.Position = UDim2.new(0, (i-1) * 35, 0.5, -15)
        button.BackgroundColor3 = self.Library.Theme.Tertiary
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.5, -10, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = LUCIDE_ICONS[buttonData.Icon] or ""
        icon.ImageColor3 = self.Library.Theme.Text
        icon.Parent = button
        
        button.MouseButton1Click:Connect(buttonData.Function)
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = self.Library.Theme.Accent}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = self.Library.Theme.Tertiary}, 0.2)
        end)
    end
end

function Window:_CreateMobileToggle()
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "MobileToggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
    toggleButton.BackgroundColor3 = self.Library.Theme.Accent
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = self._gui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 25)
    toggleCorner.Parent = toggleButton
    
    local menuIcon = Instance.new("ImageLabel")
    menuIcon.Size = UDim2.new(0, 30, 0, 30)
    menuIcon.Position = UDim2.new(0.5, -15, 0.5, -15)
    menuIcon.BackgroundTransparency = 1
    menuIcon.Image = LUCIDE_ICONS.menu
    menuIcon.ImageColor3 = self.Library.Theme.Text
    menuIcon.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Window:_SetupDrag()
    local dragZones = {}
    
    -- สร้าง drag zones สำหรับแต่ละขอบ
    local zones = {
        {Name = "Top", Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 0)},
        {Name = "Bottom", Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -20)},
        {Name = "Left", Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(0, 0, 0, 0)},
        {Name = "Right", Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0)}
    }
    
    for _, zone in ipairs(zones) do
        local dragFrame = Instance.new("Frame")
        dragFrame.Name = "DragZone_" .. zone.Name
        dragFrame.Size = zone.Size
        dragFrame.Position = zone.Position
        dragFrame.BackgroundTransparency = 1 -- Invisible
        dragFrame.Parent = self._mainFrame
        
        table.insert(dragZones, dragFrame)
    end
    
    -- Drag Logic
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            self._mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    for _, dragZone in ipairs(dragZones) do
        dragZone.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self._mainFrame.Position
            end
        end)
    end
    
    UserInputService.InputChanged:Connect(updateDrag)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(config)
    config = config or {}
    
    local TabObj = setmetatable({
        Name = config.Name or "Tab",
        Icon = config.Icon,
        Window = self,
        Content = {},
        _button = nil,
        _container = nil,
        _connections = {}
    }, Tab)
    
    TabObj:_CreateGUI()
    
    table.insert(self.Tabs, TabObj)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        TabObj:Select()
    end
    
    return TabObj
end

function Tab:_CreateGUI()
    -- Tab Button
    self._button = Instance.new("TextButton")
    self._button.Name = self.Name .. "_Tab"
    self._button.Size = UDim2.new(1, -20, 0, 40)
    self._button.BackgroundColor3 = self.Window.Library.Theme.Tertiary
    self._button.BorderSizePixel = 0
    self._button.Text = ""
    self._button.Parent = self.Window._tabContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = self._button
    
    -- Tab Content Layout
    local tabLayout = Instance.new("Frame")
    tabLayout.Size = UDim2.new(1, 0, 1, 0)
    tabLayout.BackgroundTransparency = 1
    tabLayout.Parent = self._button
    
    -- Icon (if provided)
    local iconSize = 0
    if self.Icon and LUCIDE_ICONS[self.Icon] then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 10, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = LUCIDE_ICONS[self.Icon]
        icon.ImageColor3 = self.Window.Library.Theme.TextDark
        icon.Parent = tabLayout
        iconSize = 34
    end
    
    -- Tab Text
    local tabText = Instance.new("TextLabel")
    tabText.Size = UDim2.new(1, -iconSize - 20, 1, 0)
    tabText.Position = UDim2.new(0, iconSize + 10, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = self.Name
    tabText.TextColor3 = self.Window.Library.Theme.TextDark
    tabText.TextScaled = true
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Font = Enum.Font.Gotham
    tabText.Parent = tabLayout
    
    -- Tab Content Container
    self._container = Instance.new("ScrollingFrame")
    self._container.Name = self.Name .. "_Content"
    self._container.Size = UDim2.new(1, 0, 1, 0)
    self._container.BackgroundTransparency = 1
    self._container.BorderSizePixel = 0
    self._container.ScrollBarThickness = 4
    self._container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self._container.Visible = false
    self._container.Parent = self.Window._contentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = self._container
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 20)
    contentPadding.PaddingLeft = UDim.new(0, 20)
    contentPadding.PaddingRight = UDim.new(0, 20)
    contentPadding.PaddingBottom = UDim.new(0, 20)
    contentPadding.Parent = self._container
    
    -- Update canvas size automatically
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self._container.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    -- Tab Button Click
    self._button.MouseButton1Click:Connect(function()
        self:Select()
    end)
    
    -- Hover Effect
    self._button.MouseEnter:Connect(function()
        if self.Window.CurrentTab ~= self then
            CreateTween(self._button, {BackgroundColor3 = self.Window.Library.Theme.Secondary}, 0.2)
        end
    end)
    
    self._button.MouseLeave:Connect(function()
        if self.Window.CurrentTab ~= self then
            CreateTween(self._button, {BackgroundColor3 = self.Window.Library.Theme.Tertiary}, 0.2)
        end
    end)
end

function Tab:Select()
    -- Deselect current tab
    if self.Window.CurrentTab then
        self.Window.CurrentTab._container.Visible = false
        CreateTween(self.Window.CurrentTab._button, {BackgroundColor3 = self.Window.Library.Theme.Tertiary}, 0.2)
        
        local oldIcon = self.Window.CurrentTab._button:FindFirstChildWhichIsA("ImageLabel", true)
        if oldIcon then
            CreateTween(oldIcon, {ImageColor3 = self.Window.Library.Theme.TextDark}, 0.2)
        end
        
        local oldText = self.Window.CurrentTab._button:FindFirstChildWhichIsA("TextLabel", true)
        if oldText then
            CreateTween(oldText, {TextColor3 = self.Window.Library.Theme.TextDark}, 0.2)
        end
    end
    
    -- Select this tab
    self.Window.CurrentTab = self
    self._container.Visible = true
    CreateTween(self._button, {BackgroundColor3 = self.Window.Library.Theme.Accent}, 0.2)
    
    local icon = self._button:FindFirstChildWhichIsA("ImageLabel", true)
    if icon then
        CreateTween(icon, {ImageColor3 = self.Window.Library.Theme.Text}, 0.2)
    end
    
    local text = self._button:FindFirstChildWhichIsA("TextLabel", true)
    if text then
        CreateTween(text, {TextColor3 = self.Window.Library.Theme.Text}, 0.2)
    end
end

-- Window Control Methods
function Window:Minimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        CreateTween(self._mainFrame, {Size = UDim2.new(0, 400, 0, 40)}, 0.3)
        self._mainFrame:FindFirstChild("ContentArea").Visible = false
    else
        CreateTween(self._mainFrame, {Size = self.Size}, 0.3)
        wait(0.3)
        self._mainFrame:FindFirstChild("ContentArea").Visible = true
    end
end

function Window:ToggleFullScreen()
    self.FullScreen = not self.FullScreen
    
    if self.FullScreen then
        self._originalSize = self._mainFrame.Size
        self._originalPosition = self._mainFrame.Position
        CreateTween(self._mainFrame, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }, 0.3)
    else
        CreateTween(self._mainFrame, {
            Size = self._originalSize or self.Size,
            Position = self._originalPosition or UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
        }, 0.3)
    end
end

function Window:Close()
    -- Cleanup connections
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    
    -- Cleanup tabs
    for _, tab in ipairs(self.Tabs) do
        for _, connection in ipairs(tab._connections) do
            connection:Disconnect()
        end
    end
    
    -- Destroy GUI
    self._gui:Destroy()
    
    -- Remove from library
    local index = table.find(self.Library.Windows, self)
    if index then
        table.remove(self.Library.Windows, index)
    end
end

function Window:Toggle()
    self._mainFrame.Visible = not self._mainFrame.Visible
end

-- Metatable Extensions Support
function UILibrary:ExtendClass(className, methods)
    local class = className == "Window" and Window or 
                  className == "Tab" and Tab or 
                  className == "UILibrary" and UILibrary
    
    if class then
        for name, method in pairs(methods) do
            class[name] = method
        end
    end
end

-- Return the library
return UILibrary
