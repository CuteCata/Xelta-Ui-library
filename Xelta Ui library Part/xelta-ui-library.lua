-- Roblox UI Library v1.0
-- A modern, mobile-compatible UI library with clean architecture
-- Similar to Rayfield but with custom specifications

local UILibrary = {}
UILibrary.__index = UILibrary

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local COLORS = {
    Background = Color3.fromRGB(15, 15, 20),
    SecondaryBackground = Color3.fromRGB(20, 20, 28),
    TertiaryBackground = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(108, 121, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(35, 35, 45),
    Success = Color3.fromRGB(67, 181, 129),
    Error = Color3.fromRGB(240, 71, 71)
}

local TWEEN_INFO = {
    Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Utility Functions
local function CreateInstance(class, properties, children)
    local instance = Instance.new(class)
    
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    
    return instance
end

local function Tween(instance, properties, tweenInfo)
    local tween = TweenService:Create(instance, tweenInfo or TWEEN_INFO.Fast, properties)
    tween:Play()
    return tween
end

-- Placeholder for Lucide icons (will be replaced with actual icon system)
local function lucideIcon(iconName)
    return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

-- Mobile Detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Make UI Draggable (for desktop)
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
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

-- Window Class
local Window = {}
Window.__index = Window

function Window:CreateTab(name, icon)
    local Tab = {}
    Tab.__index = Tab
    
    -- Create tab button
    local tabButton = CreateInstance("TextButton", {
        Name = name .. "Tab",
        BackgroundColor3 = COLORS.TertiaryBackground,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 35),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        Text = "",
        Parent = self.TabList
    })
    
    -- Tab content container
    local tabFrame = CreateInstance("Frame", {
        Name = name .. "TabFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        Parent = self.TabContent
    })
    
    -- Tab icon
    local tabIcon = CreateInstance("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = lucideIcon(icon or "file"),
        ImageColor3 = COLORS.SubText,
        Parent = tabButton
    })
    
    -- Tab label
    local tabLabel = CreateInstance("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 35, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = COLORS.SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabButton
    })
    
    -- Selection indicator
    local selectionIndicator = CreateInstance("Frame", {
        Name = "SelectionIndicator",
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(0, 3, 1, -10),
        Visible = false,
        Parent = tabButton
    })
    
    -- Tab content scroll frame
    local scrollFrame = CreateInstance("ScrollingFrame", {
        Name = "ScrollFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Border,
        Parent = tabFrame
    })
    
    local contentLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollFrame
    })
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Tab selection logic
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    -- Tab methods
    Tab.Button = tabButton
    Tab.Frame = tabFrame
    Tab.Icon = tabIcon
    Tab.Label = tabLabel
    Tab.Indicator = selectionIndicator
    Tab.ScrollFrame = scrollFrame
    Tab.Window = self
    
    function Tab:CreateButton(options)
        options = options or {}
        
        local buttonFrame = CreateInstance("Frame", {
            Name = options.Name or "Button",
            BackgroundColor3 = COLORS.SecondaryBackground,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 38),
            Parent = self.ScrollFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = buttonFrame
        })
        
        local button = CreateInstance("TextButton", {
            Name = "Button",
            BackgroundColor3 = COLORS.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -90, 0.5, -14),
            Size = UDim2.new(0, 80, 0, 28),
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            Text = "Click",
            TextColor3 = COLORS.Text,
            TextSize = 13,
            Parent = buttonFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = button
        })
        
        local buttonLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -110, 1, 0),
            Font = Enum.Font.Gotham,
            Text = options.Name or "Button",
            TextColor3 = COLORS.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = buttonFrame
        })
        
        -- Button hover effect
        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundColor3 = COLORS.AccentHover})
        end)
        
        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundColor3 = COLORS.Accent})
        end)
        
        -- Click callback
        button.MouseButton1Click:Connect(function()
            if options.Callback then
                options.Callback()
            end
        end)
        
        return buttonFrame
    end
    
    function Tab:CreateToggle(options)
        options = options or {}
        local toggled = options.Default or false
        
        local toggleFrame = CreateInstance("Frame", {
            Name = options.Name or "Toggle",
            BackgroundColor3 = COLORS.SecondaryBackground,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 38),
            Parent = self.ScrollFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = toggleFrame
        })
        
        local toggleLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.Gotham,
            Text = options.Name or "Toggle",
            TextColor3 = COLORS.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleFrame
        })
        
        local toggleButton = CreateInstance("TextButton", {
            Name = "ToggleButton",
            BackgroundColor3 = toggled and COLORS.Accent or COLORS.Border,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -50, 0.5, -10),
            Size = UDim2.new(0, 40, 0, 20),
            AutoButtonColor = false,
            Text = "",
            Parent = toggleFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = toggleButton
        })
        
        local toggleIndicator = CreateInstance("Frame", {
            Name = "Indicator",
            BackgroundColor3 = COLORS.Text,
            BorderSizePixel = 0,
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Parent = toggleButton
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = toggleIndicator
        })
        
        -- Toggle logic
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            Tween(toggleButton, {
                BackgroundColor3 = toggled and COLORS.Accent or COLORS.Border
            })
            
            Tween(toggleIndicator, {
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            
            if options.Callback then
                options.Callback(toggled)
            end
        end)
        
        return toggleFrame
    end
    
    -- Add tab to window
    table.insert(self.Tabs, Tab)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function Window:SelectTab(tab)
    -- Deselect all tabs
    for _, t in pairs(self.Tabs) do
        t.Frame.Visible = false
        t.Indicator.Visible = false
        Tween(t.Icon, {ImageColor3 = COLORS.SubText})
        Tween(t.Label, {TextColor3 = COLORS.SubText})
    end
    
    -- Select the new tab
    tab.Frame.Visible = true
    tab.Indicator.Visible = true
    Tween(tab.Icon, {ImageColor3 = COLORS.Text})
    Tween(tab.Label, {TextColor3 = COLORS.Text})
    
    self.CurrentTab = tab
end

function Window:Minimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Tween(self.MainFrame, {Size = UDim2.new(0, 500, 0, 40)})
        self.TabContainer.Visible = false
        self.ContentContainer.Visible = false
    else
        Tween(self.MainFrame, {Size = UDim2.new(0, 500, 0, 350)})
        wait(0.2)
        self.TabContainer.Visible = true
        self.ContentContainer.Visible = true
    end
end

function Window:ToggleFullscreen()
    self.Fullscreen = not self.Fullscreen
    
    if self.Fullscreen then
        self.OriginalSize = self.MainFrame.Size
        self.OriginalPosition = self.MainFrame.Position
        
        Tween(self.MainFrame, {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10)
        })
    else
        Tween(self.MainFrame, {
            Size = self.OriginalSize,
            Position = self.OriginalPosition
        })
    end
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end

-- Main Library Function
function UILibrary:CreateWindow(options)
    options = options or {}
    
    local window = setmetatable({
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Fullscreen = false
    }, Window)
    
    -- Create ScreenGui
    window.ScreenGui = CreateInstance("ScreenGui", {
        Name = "UILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Main Frame
    window.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Size = UDim2.new(0, 500, 0, 350),
        Parent = window.ScreenGui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = window.MainFrame
    })
    
    -- Top Bar
    local topBar = CreateInstance("Frame", {
        Name = "TopBar",
        BackgroundColor3 = COLORS.SecondaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = window.MainFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = topBar
    })
    
    -- Fix top bar corners
    CreateInstance("Frame", {
        BackgroundColor3 = COLORS.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 8),
        Parent = topBar
    })
    
    -- Script Name (Brand)
    CreateInstance("TextLabel", {
        Name = "ScriptName",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = options.Name or "UI Library",
        TextColor3 = COLORS.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Window Controls Container
    local controlsContainer = CreateInstance("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0.5, -10),
        Size = UDim2.new(0, 80, 0, 20),
        Parent = topBar
    })
    
    -- Minimize Button
    local minimizeBtn = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        BackgroundColor3 = COLORS.TertiaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 20, 0, 20),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        Text = "−",
        TextColor3 = COLORS.Text,
        TextSize = 16,
        Parent = controlsContainer
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = minimizeBtn
    })
    
    -- Fullscreen Button
    local fullscreenBtn = CreateInstance("TextButton", {
        Name = "FullscreenButton",
        BackgroundColor3 = COLORS.TertiaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(0, 20, 0, 20),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        Text = "□",
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Parent = controlsContainer
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = fullscreenBtn
    })
    
    -- Close Button
    local closeBtn = CreateInstance("TextButton", {
        Name = "CloseButton",
        BackgroundColor3 = COLORS.Error,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 60, 0, 0),
        Size = UDim2.new(0, 20, 0, 20),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        Text = "×",
        TextColor3 = COLORS.Text,
        TextSize = 18,
        Parent = controlsContainer
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = closeBtn
    })
    
    -- Tab Container (Left Side)
    window.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = COLORS.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40),
        Parent = window.MainFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = window.TabContainer
    })
    
    -- Fix tab container corners
    CreateInstance("Frame", {
        BackgroundColor3 = COLORS.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, -8),
        Size = UDim2.new(1, 0, 0, 8),
        Parent = window.TabContainer
    })
    
    CreateInstance("Frame", {
        BackgroundColor3 = COLORS.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -8, 0, 0),
        Size = UDim2.new(0, 8, 1, 0),
        Parent = window.TabContainer
    })
    
    -- Tab List
    window.TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -5, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        Parent = window.TabContainer
    })
    
    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = window.TabList
    })
    
    -- Content Container
    window.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40),
        Parent = window.MainFrame
    })
    
    window.TabContent = CreateInstance("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = window.ContentContainer
    })
    
    -- Button Connections
    minimizeBtn.MouseButton1Click:Connect(function()
        window:Minimize()
    end)
    
    fullscreenBtn.MouseButton1Click:Connect(function()
        window:ToggleFullscreen()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    -- Make draggable (desktop only)
    if not IsMobile() then
        MakeDraggable(window.MainFrame, topBar)
    end
    
    return window
end

return UILibrary
