-- UILibrary Part 1: Core Framework
-- A mobile-compatible, elegant UI library for Roblox
-- Author: Expert UI Developer
-- Version: 1.0.0 (Part 1)

local UILibrary = {}
local Windows = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Constants
local THEME = {
    -- Dark luxurious color palette
    Background = Color3.fromRGB(15, 15, 20),
    SecondaryBackground = Color3.fromRGB(20, 20, 28),
    TertiaryBackground = Color3.fromRGB(25, 25, 35),
    
    Accent = Color3.fromRGB(88, 101, 242),
    AccentDark = Color3.fromRGB(71, 82, 196),
    
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(160, 160, 170),
    
    Border = Color3.fromRGB(35, 35, 45),
    Shadow = Color3.fromRGB(0, 0, 0),
    
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 179, 127),
    Error = Color3.fromRGB(240, 71, 71),
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, direction),
        properties
    )
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    local touch = nil
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Placeholder for Lucide icons
local function lucideIcon(iconName)
    -- This will be replaced with actual Lucide icon implementation
    return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

-- Main Window Creation
function UILibrary:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowIcon = config.Icon or "lucide:layout-dashboard"
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary_" .. windowName:gsub("%s+", "")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- Main Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 800, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = THEME.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Add corner rounding
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = THEME.Shadow
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = THEME.SecondaryBackground
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    -- Make window draggable via top bar
    MakeDraggable(mainFrame, topBar)
    
    -- Brand Section (Top Left)
    local brandFrame = Instance.new("Frame")
    brandFrame.Name = "BrandFrame"
    brandFrame.Size = UDim2.new(0, 200, 1, 0)
    brandFrame.BackgroundTransparency = 1
    brandFrame.Parent = topBar
    
    local brandIcon = Instance.new("ImageLabel")
    brandIcon.Name = "BrandIcon"
    brandIcon.Size = UDim2.new(0, 24, 0, 24)
    brandIcon.Position = UDim2.new(0, 12, 0.5, -12)
    brandIcon.BackgroundTransparency = 1
    brandIcon.Image = lucideIcon(windowIcon)
    brandIcon.ImageColor3 = THEME.Accent
    brandIcon.Parent = brandFrame
    
    local brandText = Instance.new("TextLabel")
    brandText.Name = "BrandText"
    brandText.Size = UDim2.new(1, -50, 1, 0)
    brandText.Position = UDim2.new(0, 45, 0, 0)
    brandText.BackgroundTransparency = 1
    brandText.Text = windowName
    brandText.TextColor3 = THEME.Text
    brandText.TextScaled = false
    brandText.TextSize = 16
    brandText.Font = Enum.Font.Gotham
    brandText.TextXAlignment = Enum.TextXAlignment.Left
    brandText.Parent = brandFrame
    
    -- Window Controls (Top Right)
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Size = UDim2.new(0, 120, 1, 0)
    controlsFrame.Position = UDim2.new(1, -120, 0, 0)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = topBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Padding = UDim.new(0, 8)
    controlsLayout.Parent = controlsFrame
    
    -- Control buttons
    local function createControlButton(name, icon, callback)
        local button = Instance.new("TextButton")
        button.Name = name .. "Button"
        button.Size = UDim2.new(0, 28, 0, 28)
        button.BackgroundColor3 = THEME.TertiaryBackground
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = controlsFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        local buttonIcon = Instance.new("ImageLabel")
        buttonIcon.Size = UDim2.new(0, 16, 0, 16)
        buttonIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
        buttonIcon.BackgroundTransparency = 1
        buttonIcon.Image = lucideIcon(icon)
        buttonIcon.ImageColor3 = THEME.SubText
        buttonIcon.Parent = button
        
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = THEME.Border}, 0.2)
            CreateTween(buttonIcon, {ImageColor3 = THEME.Text}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = THEME.TertiaryBackground}, 0.2)
            CreateTween(buttonIcon, {ImageColor3 = THEME.SubText}, 0.2)
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    local minimizeBtn = createControlButton("Minimize", "lucide:minus", function()
        -- Will implement minimize logic
    end)
    minimizeBtn.LayoutOrder = 1
    
    local fullscreenBtn = createControlButton("Fullscreen", "lucide:maximize", function()
        -- Will implement fullscreen logic
    end)
    fullscreenBtn.LayoutOrder = 2
    
    local closeBtn = createControlButton("Close", "lucide:x", function()
        screenGui:Destroy()
    end)
    closeBtn.LayoutOrder = 3
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -40)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- Left Sidebar for Tabs
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = THEME.SecondaryBackground
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 4
    sidebar.ScrollBarImageColor3 = THEME.Border
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.Parent = contentArea
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 12)
    sidebarPadding.PaddingBottom = UDim.new(0, 12)
    sidebarPadding.PaddingLeft = UDim.new(0, 12)
    sidebarPadding.PaddingRight = UDim.new(0, 12)
    sidebarPadding.Parent = sidebar
    
    -- Tab Content Area
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -200, 1, 0)
    tabContent.Position = UDim2.new(0, 200, 0, 0)
    tabContent.BackgroundColor3 = THEME.Background
    tabContent.BorderSizePixel = 0
    tabContent.Parent = contentArea
    
    -- Floating Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
    toggleButton.BackgroundColor3 = THEME.Accent
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleIcon = Instance.new("ImageLabel")
    toggleIcon.Size = UDim2.new(0, 24, 0, 24)
    toggleIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = lucideIcon("lucide:panel-left")
    toggleIcon.ImageColor3 = THEME.Text
    toggleIcon.Parent = toggleButton
    
    -- Make toggle button draggable
    MakeDraggable(toggleButton)
    
    -- Toggle functionality
    local isVisible = true
    toggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        mainFrame.Visible = isVisible
        toggleIcon.Image = lucideIcon(isVisible and "lucide:panel-left" or "lucide:panel-right")
    end)
    
    -- Window object
    local Window = {
        _frame = mainFrame,
        _sidebar = sidebar,
        _tabContent = tabContent,
        _tabs = {},
        _activeTab = nil
    }
    
    -- Tab creation method (placeholder for Part 1)
    function Window:CreateTab(name, icon)
        icon = icon or "lucide:file"
        
        local Tab = {
            Name = name,
            Icon = icon,
            _elements = {}
        }
        
        -- Tab button in sidebar
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BackgroundColor3 = THEME.TertiaryBackground
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""
        tabButton.Parent = self._sidebar
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Tab will be fully implemented in Part 2
        
        table.insert(self._tabs, Tab)
        return Tab
    end
    
    -- Placeholder methods for Part 2
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    table.insert(Windows, Window)
    return Window
end

return UILibrary
