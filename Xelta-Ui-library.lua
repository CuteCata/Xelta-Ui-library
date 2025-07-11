-- ================================
-- ASTDX Custom UI Library - Part 1
-- Core Structure & Main Components
-- ================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main Library Table
local UILibrary = {}
UILibrary.__index = UILibrary

-- Color Scheme (Modern Dark Theme)
local Colors = {
    Primary = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(108, 121, 255),
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(237, 66, 69),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(185, 187, 190),
    TextMuted = Color3.fromRGB(114, 118, 125),
    Border = Color3.fromRGB(45, 45, 55),
    Background = Color3.fromRGB(15, 15, 20),
    Card = Color3.fromRGB(30, 30, 40),
    Hover = Color3.fromRGB(40, 40, 50)
}

-- Animation Settings
local AnimationSpeed = 0.25
local EasingStyle = Enum.EasingStyle.Quad
local EasingDirection = Enum.EasingDirection.Out

-- Utility Functions
local function CreateTween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or AnimationSpeed, style or EasingStyle, direction or EasingDirection),
        properties
    )
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- Main Window Creation
function UILibrary:CreateWindow(config)
    config = config or {}
    
    local WindowData = {
        Name = config.Name or "ASTDX Hub",
        Size = config.Size or UDim2.new(0, 580, 0, 420),
        Position = config.Position or UDim2.new(0.5, -290, 0.5, -210),
        Tabs = {},
        CurrentTab = nil,
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false,
        Theme = config.Theme or "Dark"
    }
    
    -- Create Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ASTDXHub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = WindowData.Size
    MainFrame.Position = WindowData.Position
    MainFrame.BackgroundColor3 = Colors.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true
    
    CreateCorner(MainFrame, 12)
    CreateStroke(MainFrame, Colors.Border, 1)
    
    -- Shadow Effect
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.8
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = MainFrame.ZIndex - 1
    Shadow.Parent = MainFrame
    
    CreateCorner(Shadow, 12)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Colors.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    CreateCorner(TitleBar, 12)
    
    -- Title Bar Gradient
    CreateGradient(TitleBar, {
        Colors.Secondary,
        Colors.Primary
    }, 90)
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -100, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = WindowData.Name
    TitleText.TextColor3 = Colors.Text
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 7.5)
    CloseButton.BackgroundColor3 = Colors.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    CreateCorner(CloseButton, 6)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -75, 0, 7.5)
    MinimizeButton.BackgroundColor3 = Colors.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    CreateCorner(MinimizeButton, 6)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -45)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundColor3 = Colors.Card
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    -- Tab List
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Colors.Accent
    TabList.BorderSizePixel = 0
    TabList.Parent = TabContainer
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -45)
    ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    ContentContainer.BackgroundColor3 = Colors.Background
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Store references
    WindowData.ScreenGui = ScreenGui
    WindowData.MainFrame = MainFrame
    WindowData.TabContainer = TabContainer
    WindowData.TabList = TabList
    WindowData.ContentContainer = ContentContainer
    WindowData.TitleText = TitleText
    
    return WindowData
end

-- ================================
-- ASTDX Custom UI Library - Part 2
-- Tab System & Navigation
-- ================================

-- Tab Creation Function
function UILibrary:CreateTab(window, config)
    config = config or {}
    
    local TabData = {
        Name = config.Name or "Tab",
        Icon = config.Icon or "🏠",
        Visible = config.Visible ~= false,
        Active = false,
        Elements = {},
        Window = window
    }
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton_" .. TabData.Name
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Colors.Card
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = window.TabList
    
    CreateCorner(TabButton, 6)
    
    -- Tab Icon
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Name = "Icon"
    TabIcon.Size = UDim2.new(0, 20, 0, 20)
    TabIcon.Position = UDim2.new(0, 10, 0, 10)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = TabData.Icon
    TabIcon.TextColor3 = Colors.TextSecondary
    TabIcon.TextSize = 16
    TabIcon.Font = Enum.Font.Gotham
    TabIcon.Parent = TabButton
    
    -- Tab Label
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Name = "Label"
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 35, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = TabData.Name
    TabLabel.TextColor3 = Colors.TextSecondary
    TabLabel.TextSize = 12
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.Parent = TabButton
    
    -- Tab Content Frame
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = "TabContent_" .. TabData.Name
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Colors.Accent
    TabContent.BorderSizePixel = 0
    TabContent.Visible = false
    TabContent.Parent = window.ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent
    
    -- Tab Selection Function
    local function SelectTab()
        -- Deselect all tabs
        for _, tab in pairs(window.Tabs) do
            tab.Active = false
            tab.Button.BackgroundColor3 = Colors.Card
            tab.Icon.TextColor3 = Colors.TextSecondary
            tab.Label.TextColor3 = Colors.TextSecondary
            tab.Content.Visible = false
        end
        
        -- Select this tab
        TabData.Active = true
        TabButton.BackgroundColor3 = Colors.Accent
        TabIcon.TextColor3 = Colors.Text
        TabLabel.TextColor3 = Colors.Text
        TabContent.Visible = true
        window.CurrentTab = TabData
        
        -- Animation
        local selectTween = CreateTween(TabButton, {
            BackgroundColor3 = Colors.Accent
        }, 0.2)
        selectTween:Play()
    end
    
    -- Tab Hover Effects
    TabButton.MouseEnter:Connect(function()
        if not TabData.Active then
            local hoverTween = CreateTween(TabButton, {
                BackgroundColor3 = Colors.Hover
            }, 0.15)
            hoverTween:Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabData.Active then
            local leaveTween = CreateTween(TabButton, {
                BackgroundColor3 = Colors.Card
            }, 0.15)
            leaveTween:Play()
        end
    end)
    
    -- Tab Click Handler
    TabButton.MouseButton1Click:Connect(SelectTab)
    
    -- Store references
    TabData.Button = TabButton
    TabData.Icon = TabIcon
    TabData.Label = TabLabel
    TabData.Content = TabContent
    TabData.Layout = ContentLayout
    TabData.SelectTab = SelectTab
    
    -- Add to window tabs
    table.insert(window.Tabs, TabData)
    
    -- Select first tab automatically
    if #window.Tabs == 1 then
        SelectTab()
    end
    
    -- Update tab list canvas size
    window.TabList.CanvasSize = UDim2.new(0, 0, 0, #window.Tabs * 45)
    
    return TabData
end

-- Section Creation Function
function UILibrary:CreateSection(tab, config)
    config = config or {}
    
    local SectionData = {
        Name = config.Name or "Section",
        Tab = tab,
        Elements = {}
    }
    
    -- Section Frame
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section_" .. SectionData.Name
    SectionFrame.Size = UDim2.new(1, 0, 0, 35)
    SectionFrame.BackgroundColor3 = Colors.Card
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Parent = tab.Content
    
    CreateCorner(SectionFrame, 8)
    CreateStroke(SectionFrame, Colors.Border, 1)
    
    -- Section Title
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = SectionData.Name
    SectionTitle.TextColor3 = Colors.Text
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Parent = SectionFrame
    
    -- Section Content Layout
    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 5)
    SectionLayout.Parent = SectionFrame
    
    -- Store references
    SectionData.Frame = SectionFrame
    SectionData.Title = SectionTitle
    SectionData.Layout = SectionLayout
    
    -- Add to tab elements
    table.insert(tab.Elements, SectionData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return SectionData
end

-- Divider Creation Function
function UILibrary:CreateDivider(tab, config)
    config = config or {}
    
    local DividerFrame = Instance.new("Frame")
    DividerFrame.Name = "Divider"
    DividerFrame.Size = UDim2.new(1, 0, 0, 20)
    DividerFrame.BackgroundTransparency = 1
    DividerFrame.Parent = tab.Content
    
    local DividerLine = Instance.new("Frame")
    DividerLine.Name = "Line"
    DividerLine.Size = UDim2.new(1, -40, 0, 1)
    DividerLine.Position = UDim2.new(0, 20, 0.5, 0)
    DividerLine.BackgroundColor3 = Colors.Border
    DividerLine.BorderSizePixel = 0
    DividerLine.Parent = DividerFrame
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return DividerFrame
end

-- Paragraph Creation Function
function UILibrary:CreateParagraph(tab, config)
    config = config or {}
    
    local ParagraphData = {
        Title = config.Title or "Paragraph",
        Content = config.Content or "Content goes here...",
        Tab = tab
    }
    
    -- Calculate content height
    local contentHeight = 25 + (string.len(ParagraphData.Content) / 60) * 15
    contentHeight = math.max(contentHeight, 60)
    
    -- Paragraph Frame
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = "Paragraph_" .. ParagraphData.Title
    ParagraphFrame.Size = UDim2.new(1, 0, 0, contentHeight)
    ParagraphFrame.BackgroundColor3 = Colors.Card
    ParagraphFrame.BorderSizePixel = 0
    ParagraphFrame.Parent = tab.Content
    
    CreateCorner(ParagraphFrame, 6)
    CreateStroke(ParagraphFrame, Colors.Border, 1)
    
    -- Paragraph Title
    local ParagraphTitle = Instance.new("TextLabel")
    ParagraphTitle.Name = "Title"
    ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
    ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
    ParagraphTitle.BackgroundTransparency = 1
    ParagraphTitle.Text = ParagraphData.Title
    ParagraphTitle.TextColor3 = Colors.Text
    ParagraphTitle.TextSize = 13
    ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphTitle.Font = Enum.Font.GothamBold
    ParagraphTitle.Parent = ParagraphFrame
    
    -- Paragraph Content
    local ParagraphContent = Instance.new("TextLabel")
    ParagraphContent.Name = "Content"
    ParagraphContent.Size = UDim2.new(1, -20, 1, -30)
    ParagraphContent.Position = UDim2.new(0, 10, 0, 25)
    ParagraphContent.BackgroundTransparency = 1
    ParagraphContent.Text = ParagraphData.Content
    ParagraphContent.TextColor3 = Colors.TextSecondary
    ParagraphContent.TextSize = 11
    ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
    ParagraphContent.TextWrapped = true
    ParagraphContent.Font = Enum.Font.Gotham
    ParagraphContent.Parent = ParagraphFrame
    
    -- Store references
    ParagraphData.Frame = ParagraphFrame
    ParagraphData.TitleLabel = ParagraphTitle
    ParagraphData.ContentLabel = ParagraphContent
    
    -- Add to tab elements
    table.insert(tab.Elements, ParagraphData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return ParagraphData
end

-- ================================
-- ASTDX Custom UI Library - Part 3
-- Button & Toggle Components (Complete)
-- ================================

-- Button Creation Function
function UILibrary:CreateButton(tab, config)
    config = config or {}
    
    local ButtonData = {
        Name = config.Name or "Button",
        Callback = config.Callback or function() end,
        Tab = tab,
        Enabled = config.Enabled ~= false
    }
    
    -- Button Frame
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "Button_" .. ButtonData.Name
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = tab.Content
    
    -- Button
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, -20, 1, -10)
    Button.Position = UDim2.new(0, 10, 0, 5)
    Button.BackgroundColor3 = Colors.Accent
    Button.BorderSizePixel = 0
    Button.Text = ButtonData.Name
    Button.TextColor3 = Colors.Text
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ButtonFrame
    
    CreateCorner(Button, 6)
    
    -- Button Gradient
    CreateGradient(Button, {
        Colors.Accent,
        Colors.AccentHover
    }, 45)
    
    -- Button Hover Effects
    Button.MouseEnter:Connect(function()
        if ButtonData.Enabled then
            local hoverTween = CreateTween(Button, {
                BackgroundColor3 = Colors.AccentHover,
                Size = UDim2.new(1, -15, 1, -5)
            }, 0.15)
            hoverTween:Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if ButtonData.Enabled then
            local leaveTween = CreateTween(Button, {
                BackgroundColor3 = Colors.Accent,
                Size = UDim2.new(1, -20, 1, -10)
            }, 0.15)
            leaveTween:Play()
        end
    end)
    
    -- Button Click Handler
    Button.MouseButton1Click:Connect(function()
        if ButtonData.Enabled then
            -- Click animation
            local clickTween = CreateTween(Button, {
                Size = UDim2.new(1, -25, 1, -15)
            }, 0.1)
            clickTween:Play()
            
            clickTween.Completed:Connect(function()
                local returnTween = CreateTween(Button, {
                    Size = UDim2.new(1, -20, 1, -10)
                }, 0.1)
                returnTween:Play()
            end)
            
            -- Execute callback
            ButtonData.Callback()
        end
    end)
    
    -- Store references
    ButtonData.Frame = ButtonFrame
    ButtonData.Button = Button
    
    -- Add to tab elements
    table.insert(tab.Elements, ButtonData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return ButtonData
end

-- Toggle Creation Function
function UILibrary:CreateToggle(tab, config)
    config = config or {}
    
    local ToggleData = {
        Name = config.Name or "Toggle",
        CurrentValue = config.CurrentValue or false,
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or ""
    }
    
    -- Toggle Frame
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. ToggleData.Name
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Colors.Card
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = tab.Content
    
    CreateCorner(ToggleFrame, 6)
    CreateStroke(ToggleFrame, Colors.Border, 1)
    
    -- Toggle Label
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = ToggleData.Name
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Parent = ToggleFrame
    
    -- Toggle Switch Background
    local ToggleBG = Instance.new("Frame")
    ToggleBG.Name = "ToggleBG"
    ToggleBG.Size = UDim2.new(0, 40, 0, 20)
    ToggleBG.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleBG.BackgroundColor3 = Colors.Border
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = ToggleFrame
    
    CreateCorner(ToggleBG, 10)
    
    -- Toggle Switch
    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Name = "Switch"
    ToggleSwitch.Size = UDim2.new(0, 16, 0, 16)
    ToggleSwitch.Position = UDim2.new(0, 2, 0, 2)
    ToggleSwitch.BackgroundColor3 = Colors.Text
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.Parent = ToggleBG
    
    CreateCorner(ToggleSwitch, 8)
    
    -- Toggle Button (Invisible click detector)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    -- Toggle Function
    local function Toggle()
        ToggleData.CurrentValue = not ToggleData.CurrentValue
        
        if ToggleData.CurrentValue then
            -- ON State
            local bgTween = CreateTween(ToggleBG, {
                BackgroundColor3 = Colors.Success
            }, 0.2)
           -- ================================
-- ASTDX Custom UI Library - Part 3 (ส่วนที่ขาด)
-- ================================

-- ต่อจาก ToggleSwitch ที่ขาดไป
            local switchTween = CreateTween(ToggleSwitch, {
                Position = UDim2.new(0, 22, 0, 2)
            }, 0.2)
            
            bgTween:Play()
            switchTween:Play()
        else
            -- OFF State
            local bgTween = CreateTween(ToggleBG, {
                BackgroundColor3 = Colors.Border
            }, 0.2)
            local switchTween = CreateTween(ToggleSwitch, {
                Position = UDim2.new(0, 2, 0, 2)
            }, 0.2)
            
            bgTween:Play()
            switchTween:Play()
        end
        
        -- Execute callback
        ToggleData.Callback(ToggleData.CurrentValue)
    end
    
    -- Set initial state
    if ToggleData.CurrentValue then
        ToggleBG.BackgroundColor3 = Colors.Success
        ToggleSwitch.Position = UDim2.new(0, 22, 0, 2)
    end
    
    -- Toggle Hover Effects
    ToggleButton.MouseEnter:Connect(function()
        local hoverTween = CreateTween(ToggleFrame, {
            BackgroundColor3 = Colors.Hover
        }, 0.15)
        hoverTween:Play()
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        local leaveTween = CreateTween(ToggleFrame, {
            BackgroundColor3 = Colors.Card
        }, 0.15)
        leaveTween:Play()
    end)
    
    -- Toggle Click Handler
    ToggleButton.MouseButton1Click:Connect(Toggle)
    
    -- Store references
    ToggleData.Frame = ToggleFrame
    ToggleData.Label = ToggleLabel
    ToggleData.Background = ToggleBG
    ToggleData.Switch = ToggleSwitch
    ToggleData.Button = ToggleButton
    ToggleData.Toggle = Toggle
    
    -- Add to tab elements
    table.insert(tab.Elements, ToggleData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return ToggleData
end

-- Return library for Part 3
return UILibrary

-- ================================
-- ASTDX Custom UI Library - Part 4
-- Slider & Dropdown Components
-- ================================

-- Slider Creation Function
function UILibrary:CreateSlider(tab, config)
    config = config or {}
    
    local SliderData = {
        Name = config.Name or "Slider",
        Range = config.Range or {0, 100},
        Increment = config.Increment or 1,
        Suffix = config.Suffix or "",
        CurrentValue = config.CurrentValue or config.Range[1],
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        Dragging = false
    }
    
    -- Slider Frame
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. SliderData.Name
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Colors.Card
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = tab.Content
    
    CreateCorner(SliderFrame, 6)
    CreateStroke(SliderFrame, Colors.Border, 1)
    
    -- Slider Label
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = SliderData.Name
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Parent = SliderFrame
    
    -- Slider Value Label
    local SliderValueLabel = Instance.new("TextLabel")
    SliderValueLabel.Name = "ValueLabel"
    SliderValueLabel.Size = UDim2.new(0, 60, 0, 20)
    SliderValueLabel.Position = UDim2.new(1, -70, 0, 5)
    SliderValueLabel.BackgroundTransparency = 1
    SliderValueLabel.Text = tostring(SliderData.CurrentValue) .. SliderData.Suffix
    SliderValueLabel.TextColor3 = Colors.Accent
    SliderValueLabel.TextSize = 11
    SliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    SliderValueLabel.Font = Enum.Font.GothamBold
    SliderValueLabel.Parent = SliderFrame
    
    -- Slider Track
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Size = UDim2.new(1, -30, 0, 6)
    SliderTrack.Position = UDim2.new(0, 15, 0, 32)
    SliderTrack.BackgroundColor3 = Colors.Secondary
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    CreateCorner(SliderTrack, 3)
    
    -- Slider Fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    CreateCorner(SliderFill, 3)
    
    -- Slider Handle
    local SliderHandle = Instance.new("Frame")
    SliderHandle.Name = "Handle"
    SliderHandle.Size = UDim2.new(0, 16, 0, 16)
    SliderHandle.Position = UDim2.new(0, -8, 0, -5)
    SliderHandle.BackgroundColor3 = Colors.Text
    SliderHandle.BorderSizePixel = 0
    SliderHandle.Parent = SliderFill
    
    CreateCorner(SliderHandle, 8)
    CreateStroke(SliderHandle, Colors.Accent, 2)
    
    -- Slider Button (Invisible click detector)
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderFrame
    
    -- Slider Functions
    local function UpdateSlider()
        local percentage = (SliderData.CurrentValue - SliderData.Range[1]) / (SliderData.Range[2] - SliderData.Range[1])
        local fillSize = UDim2.new(percentage, 0, 1, 0)
        
        local fillTween = CreateTween(SliderFill, {
            Size = fillSize
        }, 0.1)
        fillTween:Play()
        
        SliderValueLabel.Text = tostring(SliderData.CurrentValue) .. SliderData.Suffix
    end
    
    local function SetValue(value)
        value = math.clamp(value, SliderData.Range[1], SliderData.Range[2])
        value = math.floor(value / SliderData.Increment + 0.5) * SliderData.Increment
        SliderData.CurrentValue = value
        UpdateSlider()
        SliderData.Callback(value)
    end
    
    -- Slider Input Handling
    SliderButton.MouseButton1Down:Connect(function()
        SliderData.Dragging = true
        
        local function Update()
            local mouse = Players.LocalPlayer:GetMouse()
            local percentage = math.clamp((mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = SliderData.Range[1] + (SliderData.Range[2] - SliderData.Range[1]) * percentage
            SetValue(value)
        end
        
        local connection
        connection = mouse.Move:Connect(Update)
        
        local function Stop()
            SliderData.Dragging = false
            connection:Disconnect()
        end
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Stop()
            end
        end)
        
        Update()
    end)
    
    -- Initialize slider
    UpdateSlider()
    
    -- Store references
    SliderData.Frame = SliderFrame
    SliderData.Label = SliderLabel
    SliderData.ValueLabel = SliderValueLabel
    SliderData.Track = SliderTrack
    SliderData.Fill = SliderFill
    SliderData.Handle = SliderHandle
    SliderData.Button = SliderButton
    SliderData.SetValue = SetValue
    SliderData.UpdateSlider = UpdateSlider
    
    -- Add to tab elements
    table.insert(tab.Elements, SliderData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return SliderData
end

-- Dropdown Creation Function
function UILibrary:CreateDropdown(tab, config)
    config = config or {}
    
    local DropdownData = {
        Name = config.Name or "Dropdown",
        Options = config.Options or {"Option 1", "Option 2", "Option 3"},
        CurrentOption = config.CurrentOption or config.Options[1],
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        IsOpen = false
    }
    
    -- Dropdown Frame
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown_" .. DropdownData.Name
    DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    DropdownFrame.BackgroundColor3 = Colors.Card
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = tab.Content
    
    CreateCorner(DropdownFrame, 6)
    CreateStroke(DropdownFrame, Colors.Border, 1)
    
    -- Dropdown Label
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Size = UDim2.new(1, -20, 0, 20)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 2)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = DropdownData.Name
    DropdownLabel.TextColor3 = Colors.Text
    DropdownLabel.TextSize = 11
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Parent = DropdownFrame
    
    -- Dropdown Selected Frame
    local DropdownSelected = Instance.new("Frame")
    DropdownSelected.Name = "Selected"
    DropdownSelected.Size = UDim2.new(1, -20, 0, 20)
    DropdownSelected.Position = UDim2.new(0, 10, 0, 18)
    DropdownSelected.BackgroundColor3 = Colors.Secondary
    DropdownSelected.BorderSizePixel = 0
    DropdownSelected.Parent = DropdownFrame
    
    CreateCorner(DropdownSelected, 4)
    CreateStroke(DropdownSelected, Colors.Border, 1)
    
    -- Dropdown Selected Text
    local DropdownSelectedText = Instance.new("TextLabel")
    DropdownSelectedText.Name = "SelectedText"
    DropdownSelectedText.Size = UDim2.new(1, -30, 1, 0)
    DropdownSelectedText.Position = UDim2.new(0, 8, 0, 0)
    DropdownSelectedText.BackgroundTransparency = 1
    DropdownSelectedText.Text = DropdownData.CurrentOption
    DropdownSelectedText.TextColor3 = Colors.Text
    DropdownSelectedText.TextSize = 11
    DropdownSelectedText.TextXAlignment = Enum.TextXAlignment.Left
    DropdownSelectedText.Font = Enum.Font.Gotham
    DropdownSelectedText.Parent = DropdownSelected
    
    -- Dropdown Arrow
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Name = "Arrow"
    DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -20, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = Colors.TextSecondary
    DropdownArrow.TextSize = 10
    DropdownArrow.Font = Enum.Font.Gotham
    DropdownArrow.Parent = DropdownSelected
    
    -- Dropdown List Frame
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "List"
    DropdownList.Size = UDim2.new(1, -20, 0, 0)
    DropdownList.Position = UDim2.new(0, 10, 1, 5)
    DropdownList.BackgroundColor3 = Colors.Secondary
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = DropdownFrame
    
    CreateCorner(DropdownList, 4)
    CreateStroke(DropdownList, Colors.Border, 1)
    
    -- Dropdown List Layout
    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropdownListLayout.Parent = DropdownList
    
    -- Dropdown Button (Invisible click detector)
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    -- Dropdown Functions
    local function CreateOption(optionText)
        local OptionFrame = Instance.new("TextButton")
        OptionFrame.Name = "Option_" .. optionText
        OptionFrame.Size = UDim2.new(1, 0, 0, 25)
        OptionFrame.BackgroundColor3 = Colors.Secondary
        OptionFrame.BorderSizePixel = 0
        OptionFrame.Text = optionText
        OptionFrame.TextColor3 = Colors.Text
        OptionFrame.TextSize = 11
        OptionFrame.TextXAlignment = Enum.TextXAlignment.Left
        OptionFrame.Font = Enum.Font.Gotham
        OptionFrame.Parent = DropdownList
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 8)
        OptionPadding.Parent = OptionFrame
        
        -- Option hover effect
        OptionFrame.MouseEnter:Connect(function()
            local hoverTween = CreateTween(OptionFrame, {
                BackgroundColor3 = Colors.Hover
            }, 0.15)
            hoverTween:Play()
        end)
        
        OptionFrame.MouseLeave:Connect(function()
            local leaveTween = CreateTween(OptionFrame, {
                BackgroundColor3 = Colors.Secondary
            }, 0.15)
            leaveTween:Play()
        end)
        
        -- Option click handler
        OptionFrame.MouseButton1Click:Connect(function()
            DropdownData.CurrentOption = optionText
            DropdownSelectedText.Text = optionText
            ToggleDropdown()
            DropdownData.Callback(optionText)
        end)
        
        return OptionFrame
    end
    
    local function ToggleDropdown()
        DropdownData.IsOpen = not DropdownData.IsOpen
        
        if DropdownData.IsOpen then
            -- Open dropdown
            DropdownList.Visible = true
            local listHeight = #DropdownData.Options * 25
            
            local openTween = CreateTween(DropdownList, {
                Size = UDim2.new(1, -20, 0, listHeight)
            }, 0.2)
            openTween:Play()
            
            local arrowTween = CreateTween(DropdownArrow, {
                Rotation = 180
            }, 0.2)
            arrowTween:Play()
            
            -- Update main frame size
            local newFrameSize = UDim2.new(1, 0, 0, 40 + listHeight + 10)
            local frameTween = CreateTween(DropdownFrame, {
                Size = newFrameSize
            }, 0.2)
            frameTween:Play()
        else
            -- Close dropdown
            local closeTween = CreateTween(DropdownList, {
                Size = UDim2.new(1, -20, 0, 0)
            }, 0.2)
            closeTween:Play()
            
            local arrowTween = CreateTween(DropdownArrow, {
                Rotation = 0
            }, 0.2)
            arrowTween:Play()
            
            -- Update main frame size
            local frameTween = CreateTween(DropdownFrame, {
                Size = UDim2.new(1, 0, 0, 40)
            }, 0.2)
            frameTween:Play()
            
            closeTween.Completed:Connect(function()
                DropdownList.Visible = false
            end)
        end
        
        -- Update tab content canvas size
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    end
    
    -- Create options
    for _, option in ipairs(DropdownData.Options) do
        CreateOption(option)
    end
    
    -- Dropdown click handler
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    
    -- Store references
    DropdownData.Frame = DropdownFrame
    DropdownData.Label = DropdownLabel
    DropdownData.Selected = DropdownSelected
    DropdownData.SelectedText = DropdownSelectedText
    DropdownData.Arrow = DropdownArrow
    DropdownData.List = DropdownList
    DropdownData.Button = DropdownButton
    DropdownData.ToggleDropdown = ToggleDropdown
    
    -- Add to tab elements
    table.insert(tab.Elements, DropdownData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return DropdownData
end

-- ================================
-- ASTDX Custom UI Library - Part 5
-- Additional Components & Window Controls
-- ================================

-- TextBox Creation Function
function UILibrary:CreateTextBox(tab, config)
    config = config or {}
    
    local TextBoxData = {
        Name = config.Name or "TextBox",
        CurrentValue = config.CurrentValue or "",
        PlaceholderText = config.PlaceholderText or "Enter text...",
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        ClearTextOnFocus = config.ClearTextOnFocus or false,
        TextDisappear = config.TextDisappear or false
    }
    
    -- TextBox Frame
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = "TextBox_" .. TextBoxData.Name
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 50)
    TextBoxFrame.BackgroundColor3 = Colors.Card
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = tab.Content
    
    CreateCorner(TextBoxFrame, 6)
    CreateStroke(TextBoxFrame, Colors.Border, 1)
    
    -- TextBox Label
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Name = "Label"
    TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
    TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Text = TextBoxData.Name
    TextBoxLabel.TextColor3 = Colors.Text
    TextBoxLabel.TextSize = 12
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Parent = TextBoxFrame
    
    -- TextBox Input
    local TextBoxInput = Instance.new("TextBox")
    TextBoxInput.Name = "Input"
    TextBoxInput.Size = UDim2.new(1, -20, 0, 20)
    TextBoxInput.Position = UDim2.new(0, 10, 0, 25)
    TextBoxInput.BackgroundColor3 = Colors.Secondary
    TextBoxInput.BorderSizePixel = 0
    TextBoxInput.Text = TextBoxData.CurrentValue
    TextBoxInput.PlaceholderText = TextBoxData.PlaceholderText
    TextBoxInput.TextColor3 = Colors.Text
    TextBoxInput.PlaceholderColor3 = Colors.TextMuted
    TextBoxInput.TextSize = 11
    TextBoxInput.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxInput.Font = Enum.Font.Gotham
    TextBoxInput.ClearTextOnFocus = TextBoxData.ClearTextOnFocus
    TextBoxInput.Parent = TextBoxFrame
    
    CreateCorner(TextBoxInput, 4)
    CreateStroke(TextBoxInput, Colors.Border, 1)
    
    -- TextBox Padding
    local TextBoxPadding = Instance.new("UIPadding")
    TextBoxPadding.PaddingLeft = UDim.new(0, 8)
    TextBoxPadding.PaddingRight = UDim.new(0, 8)
    TextBoxPadding.Parent = TextBoxInput
    
    -- TextBox Focus Effects
    TextBoxInput.Focused:Connect(function()
        local focusTween = CreateTween(TextBoxInput, {
            BackgroundColor3 = Colors.Hover
        }, 0.15)
        focusTween:Play()
        
        local strokeTween = CreateTween(TextBoxInput.UIStroke, {
            Color = Colors.Accent
        }, 0.15)
        strokeTween:Play()
    end)
    
    TextBoxInput.FocusLost:Connect(function()
        local unfocusTween = CreateTween(TextBoxInput, {
            BackgroundColor3 = Colors.Secondary
        }, 0.15)
        unfocusTween:Play()
        
        local strokeTween = CreateTween(TextBoxInput.UIStroke, {
            Color = Colors.Border
        }, 0.15)
        strokeTween:Play()
        
        TextBoxData.CurrentValue = TextBoxInput.Text
        TextBoxData.Callback(TextBoxInput.Text)
        
        if TextBoxData.TextDisappear then
            wait(0.1)
            TextBoxInput.Text = ""
        end
    end)
    
    -- Store references
    TextBoxData.Frame = TextBoxFrame
    TextBoxData.Label = TextBoxLabel
    TextBoxData.Input = TextBoxInput
    
    -- Add to tab elements
    table.insert(tab.Elements, TextBoxData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return TextBoxData
end

-- Keybind Creation Function
function UILibrary:CreateKeybind(tab, config)
    config = config or {}
    
    local KeybindData = {
        Name = config.Name or "Keybind",
        CurrentKeybind = config.CurrentKeybind or "None",
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        HoldToInteract = config.HoldToInteract or false,
        IsBinding = false
    }
    
    -- Keybind Frame
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "Keybind_" .. KeybindData.Name
    KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
    KeybindFrame.BackgroundColor3 = Colors.Card
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.Parent = tab.Content
    
    CreateCorner(KeybindFrame, 6)
    CreateStroke(KeybindFrame, Colors.Border, 1)
    
    -- Keybind Label
    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Name = "Label"
    KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = KeybindData.Name
    KeybindLabel.TextColor3 = Colors.Text
    KeybindLabel.TextSize = 12
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.Parent = KeybindFrame
    
    -- Keybind Button
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Name = "Button"
    KeybindButton.Size = UDim2.new(0, 80, 0, 25)
    KeybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Colors.Secondary
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = KeybindData.CurrentKeybind
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.TextSize = 10
    KeybindButton.Font = Enum.Font.Gotham
    KeybindButton.Parent = KeybindFrame
    
    CreateCorner(KeybindButton, 4)
    CreateStroke(KeybindButton, Colors.Border, 1)
    
    -- Keybind Functions
    local function UpdateKeybindText()
        if KeybindData.IsBinding then
            KeybindButton.Text = "..."
            KeybindButton.TextColor3 = Colors.Warning
        else
            KeybindButton.Text = KeybindData.CurrentKeybind
            KeybindButton.TextColor3 = Colors.Text
        end
    end
    
    local function SetKeybind(key)
        KeybindData.CurrentKeybind = key
        KeybindData.IsBinding = false
        UpdateKeybindText()
    end
    
    -- Keybind Click Handler
    KeybindButton.MouseButton1Click:Connect(function()
        KeybindData.IsBinding = true
        UpdateKeybindText()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name
                SetKeybind(keyName)
                connection:Disconnect()
            end
        end)
        
        -- Timeout after 5 seconds
        wait(5)
        if KeybindData.IsBinding then
            KeybindData.IsBinding = false
            UpdateKeybindText()
            connection:Disconnect()
        end
    end)
    
    -- Keybind Activation
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode.Name == KeybindData.CurrentKeybind then
                if KeybindData.HoldToInteract then
                    KeybindData.Callback(true)
                else
                    KeybindData.Callback()
                end
            end
        end
    end)
    
    if KeybindData.HoldToInteract then
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode.Name == KeybindData.CurrentKeybind then
                    KeybindData.Callback(false)
                end
            end
        end)
    end
    
    -- Store references
    KeybindData.Frame = KeybindFrame
    KeybindData.Label = KeybindLabel
    KeybindData.Button = KeybindButton
    KeybindData.SetKeybind = SetKeybind
    
    -- Add to tab elements
    table.insert(tab.Elements, KeybindData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return KeybindData
end

-- ColorPicker Creation Function
function UILibrary:CreateColorPicker(tab, config)
    config = config or {}
    
    local ColorPickerData = {
        Name = config.Name or "Color Picker",
        CurrentColor = config.CurrentColor or Color3.fromRGB(255, 255, 255),
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        IsOpen = false
    }
    
    -- ColorPicker Frame
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = "ColorPicker_" .. ColorPickerData.Name
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 40)
    ColorPickerFrame.BackgroundColor3 = Colors.Card
    ColorPickerFrame.BorderSizePixel = 0
    ColorPickerFrame.Parent = tab.Content
    
    CreateCorner(ColorPickerFrame, 6)
    CreateStroke(ColorPickerFrame, Colors.Border, 1)
    
    -- ColorPicker Label
    local ColorPickerLabel = Instance.new("TextLabel")
    ColorPickerLabel.Name = "Label"
    ColorPickerLabel.Size = UDim2.new(1, -60, 1, 0)
    ColorPickerLabel.Position = UDim2.new(0, 15, 0, 0)
    ColorPickerLabel.BackgroundTransparency = 1
    ColorPickerLabel.Text = ColorPickerData.Name
    ColorPickerLabel.TextColor3 = Colors.Text
    ColorPickerLabel.TextSize = 12
    ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorPickerLabel.Font = Enum.Font.Gotham
    ColorPickerLabel.Parent = ColorPickerFrame
    
    -- ColorPicker Preview
    local ColorPickerPreview = Instance.new("Frame")
    ColorPickerPreview.Name = "Preview"
    ColorPickerPreview.Size = UDim2.new(0, 30, 0, 25)
    ColorPickerPreview.Position = UDim2.new(1, -40, 0.5, -12.5)
    ColorPickerPreview.BackgroundColor3 = ColorPickerData.CurrentColor
    ColorPickerPreview.BorderSizePixel = 0
    ColorPickerPreview.Parent = ColorPickerFrame
    
    CreateCorner(ColorPickerPreview, 4)
    CreateStroke(ColorPickerPreview, Colors.Border, 1)
    
    -- ColorPicker Button
    local ColorPickerButton = Instance.new("TextButton")
    ColorPickerButton.Name = "Button"
    ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
    ColorPickerButton.BackgroundTransparency = 1
    ColorPickerButton.Text = ""
    ColorPickerButton.Parent = ColorPickerFrame
    
    -- Simple Color Palette
    local ColorPalette = Instance.new("Frame")
    ColorPalette.Name = "Palette"
    ColorPalette.Size = UDim2.new(1, -20, 0, 0)
    ColorPalette.Position = UDim2.new(0, 10, 1, 5)
    ColorPalette.BackgroundColor3 = Colors.Secondary
    ColorPalette.BorderSizePixel = 0
    ColorPalette.Visible = false
    ColorPalette.ZIndex = 10
    ColorPalette.Parent = ColorPickerFrame
    
    CreateCorner(ColorPalette, 4)
    CreateStroke(ColorPalette, Colors.Border, 1)
    
    -- Color Palette Grid
    local PaletteGrid = Instance.new("UIGridLayout")
    PaletteGrid.CellSize = UDim2.new(0, 20, 0, 20)
    PaletteGrid.CellPadding = UDim2.new(0, 2, 0, 2)
    PaletteGrid.SortOrder = Enum.SortOrder.LayoutOrder
    PaletteGrid.Parent = ColorPalette
    
    -- Palette Padding
    local PalettePadding = Instance.new("UIPadding")
    PalettePadding.PaddingTop = UDim.new(0, 5)
    PalettePadding.PaddingBottom = UDim.new(0, 5)
    PalettePadding.PaddingLeft = UDim.new(0, 5)
    PalettePadding.PaddingRight = UDim.new(0, 5)
    PalettePadding.Parent = ColorPalette
    
    -- Common Colors
    local CommonColors = {
        Color3.fromRGB(255, 255, 255), -- White
        Color3.fromRGB(220, 220, 220), -- Light Gray
        Color3.fromRGB(128, 128, 128), -- Gray
        Color3.fromRGB(64, 64, 64),    -- Dark Gray
        Color3.fromRGB(0, 0, 0),       -- Black
        Color3.fromRGB(255, 0, 0),     -- Red
        Color3.fromRGB(255, 165, 0),   -- Orange
        Color3.fromRGB(255, 255, 0),   -- Yellow
        Color3.fromRGB(0, 255, 0),     -- Green
        Color3.fromRGB(0, 255, 255),   -- Cyan
        Color3.fromRGB(0, 0, 255),     -- Blue
        Color3.fromRGB(128, 0, 128),   -- Purple
        Color3.fromRGB(255, 192, 203), -- Pink
        Color3.fromRGB(165, 42, 42),   -- Brown
        Color3.fromRGB(255, 20, 147),  -- Deep Pink
        Color3.fromRGB(0, 250, 154),   -- Medium Spring Green
        Color3.fromRGB(30, 144, 255),  -- Dodger Blue
        Color3.fromRGB(255, 69, 0),    -- Red Orange
        Color3.fromRGB(50, 205, 50),   -- Lime Green
        Color3.fromRGB(138, 43, 226)   -- Blue Violet
    }
    
    -- Create color buttons
    for i, color in ipairs(CommonColors) do
        local ColorButton = Instance.new("TextButton")
        ColorButton.Name = "Color_" .. i
        ColorButton.Size = UDim2.new(0, 20, 0, 20)
        ColorButton.BackgroundColor3 = color
        ColorButton.BorderSizePixel = 0
        ColorButton.Text = ""
        ColorButton.Parent = ColorPalette
        
        CreateCorner(ColorButton, 2)
        CreateStroke(ColorButton, Colors.Border, 1)
        
        ColorButton.MouseButton1Click:Connect(function()
            ColorPickerData.CurrentColor = color
            ColorPickerPreview.BackgroundColor3 = color
            ColorPickerData.Callback(color)
            
            -- Close palette
            ColorPickerData.IsOpen = false
            local closeTween = CreateTween(ColorPalette, {
                Size = UDim2.new(1, -20, 0, 0)
            }, 0.2)
            closeTween:Play()
            
            local frameTween = CreateTween(ColorPickerFrame, {
                Size = UDim2.new(1, 0, 0, 40)
            }, 0.2)
            frameTween:Play()
            
            closeTween.Completed:Connect(function()
                ColorPalette.Visible = false
            end)
        end)
    end
    
    -- Toggle Color Palette
    local function ToggleColorPalette()
        ColorPickerData.IsOpen = not ColorPickerData.IsOpen
        
        if ColorPickerData.IsOpen then
            ColorPalette.Visible = true
            local paletteHeight = math.ceil(#CommonColors / 10) * 22 + 10
            
            local openTween = CreateTween(ColorPalette, {
                Size = UDim2.new(1, -20, 0, paletteHeight)
            }, 0.2)
            openTween:Play()
            
            local frameTween = CreateTween(ColorPickerFrame, {
                Size = UDim2.new(1, 0, 0, 40 + paletteHeight + 10)
            }, 0.2)
            frameTween:Play()
        else
            local closeTween = CreateTween(ColorPalette, {
                Size = UDim2.new(1, -20, 0, 0)
            }, 0.2)
            closeTween:Play()
            
            local frameTween = CreateTween(ColorPickerFrame, {
                Size = UDim2.new(1, 0, 0, 40)
            }, 0.2)
            frameTween:Play()
            
            closeTween.Completed:Connect(function()
                ColorPalette.Visible = false
            end)
        end
        
        -- Update tab content canvas size
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    end
    
    -- ColorPicker Click Handler
    ColorPickerButton.MouseButton1Click:Connect(ToggleColorPalette)
    
    -- Store references
    ColorPickerData.Frame = ColorPickerFrame
    ColorPickerData.Label = ColorPickerLabel
    ColorPickerData.Preview = ColorPickerPreview
    ColorPickerData.Button = ColorPickerButton
    ColorPickerData.Palette = ColorPalette
    ColorPickerData.ToggleColorPalette = ToggleColorPalette
    
    -- Add to tab elements
    table.insert(tab.Elements, ColorPickerData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return ColorPickerData
end

-- Window Controls Implementation
function UILibrary:AddWindowControls(window)
    -- Dragging functionality
    if window.Draggable then
        local dragStart = nil
        local startPos = nil
        
        local function Update(input)
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            window.MainFrame.Position = newPosition
        end
        
        window.MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                startPos = window.MainFrame.Position
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    end
                end)
                
                local moveConnection
                moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                    if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                        Update(moveInput)
                    end
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        moveConnection:Disconnect()
                    end
                end)
            end
        end)
    end
    
    -- Close button functionality
    local closeButton = window.MainFrame.TitleBar.CloseButton
    closeButton.MouseButton1Click:Connect(function()
        -- Close animation
        local closeTween = CreateTween(window.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3)
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            window.ScreenGui:Destroy()
        end)
    end)
    
    -- Minimize button functionality
    local minimizeButton = window.MainFrame.TitleBar.MinimizeButton
    local isMinimized = false
    local originalSize = window.MainFrame.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            local minimizeTween = CreateTween(window.MainFrame, {
                Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 45)
            }, 0.3)
            minimizeTween:Play()
            
            minimizeButton.Text = "+"
        else
            local restoreTween = CreateTween(window.MainFrame, {
                Size = originalSize
            }, 0.3)
            restoreTween:Play()
            
            minimizeButton.Text = "−"
        end
    end)
    
    -- Close button hover effects
    closeButton.MouseEnter:Connect(function()
        local hoverTween = CreateTween(closeButton, {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }, 0.15)
        hoverTween:Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        local leaveTween = CreateTween(closeButton, {
            BackgroundColor3 = Colors.Error
        }, 0.15)
        leaveTween:Play()
    end)
    
    -- Minimize button hover effects
    minimizeButton.MouseEnter:Connect(function()
        local hoverTween = CreateTween(minimizeButton, {
            BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        }, 0.15)
        hoverTween:Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        local leaveTween = CreateTween(minimizeButton, {
            BackgroundColor3 = Colors.Warning
        }, 0.15)
        leaveTween:Play()
    end)
end

-- Notification System
function UILibrary:CreateNotification(config)
    config = config or {}
    
    local NotificationData = {
        Title = config.Title or "Notification",
        Content = config.Content or "This is a notification",
        Duration = config.Duration or 5,
        Type = config.Type or "Info" -- Info, Success, Warning, Error
    }
    
    -- Get notification color based on type
    local notificationColor = Colors.Accent
    if NotificationData.Type == "Success" then
        notificationColor = Colors.Success
    elseif NotificationData.Type == "Warning" then
        notificationColor = Colors.Warning
    elseif NotificationData.Type == "Error" then
        notificationColor = Colors.Error
    end
    
    -- Create notification GUI
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "Notification"
    NotificationGui.Parent = CoreGui
    
    -- Notification Frame
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
    NotificationFrame.Position = UDim2.new(1, -320, 0, 20)
    NotificationFrame.BackgroundColor3 = Colors.Card
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = NotificationGui
    
    CreateCorner(NotificationFrame, 8)
    CreateStroke(NotificationFrame, notificationColor, 2)
    
    -- Notification Title
    local NotificationTitle = Instance.new("TextLabel")
    NotificationTitle.Name = "Title"
    NotificationTitle.Size = UDim2.new(1, -20, 0, 25)
    NotificationTitle.Position = UDim2.new(0, 10, 0, 5)
    NotificationTitle.BackgroundTransparency = 1
    NotificationTitle.Text = NotificationData.Title
    NotificationTitle.TextColor3 = Colors.Text
    NotificationTitle.TextSize = 13
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotificationTitle.Font = Enum.Font.GothamBold
    NotificationTitle.Parent = NotificationFrame
    
    -- Notification Content
    local NotificationContent = Instance.new("TextLabel")
    NotificationContent.Name = "Content"
    NotificationContent.Size = UDim2.new(1, -20, 0, 40)
    NotificationContent.Position = UDim2.new(0, 10, 0, 30)
    NotificationContent.BackgroundTransparency = 1
    NotificationContent.Text = NotificationData.Content
    NotificationContent.TextColor3 = Colors.TextSecondary
    NotificationContent.TextSize = 11
    NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
    NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
    NotificationContent.TextWrapped = true
    NotificationContent.Font = Enum.Font.Gotham
    NotificationContent.Parent = NotificationFrame
    
    -- Slide in animation
    local slideInTween = CreateTween(NotificationFrame, {
        Position = UDim2.new(1, -320, 0, 20)
    }, 0.5)
    slideInTween:Play()
    
    -- Auto dismiss after duration
    game:GetService("Debris"):AddItem(NotificationGui, NotificationData.Duration)
    
    -- Slide out animation before destruction
    wait(NotificationData.Duration - 0.5)
    local slideOutTween = CreateTween(NotificationFrame, {
        Position = UDim2.new(1, 0, 0, 20)
    }, 0.5)
    slideOutTween:Play()
    
    return NotificationData
end

-- ================================
-- ASTDX Custom UI Library - Part 6
-- Extended Components & Features
-- ================================

-- Multi-Select Dropdown Creation Function
function UILibrary:CreateMultiDropdown(tab, config)
   config = config or {}
   
   local MultiDropdownData = {
       Name = config.Name or "Multi Dropdown",
       Options = config.Options or {"Option 1", "Option 2", "Option 3"},
       Default = config.Default or {},
       Callback = config.Callback or function() end,
       Tab = tab,
       Flag = config.Flag or "",
       IsOpen = false,
       SelectedOptions = {}
   }
   
   -- Initialize selected options
   for _, option in ipairs(MultiDropdownData.Default) do
       MultiDropdownData.SelectedOptions[option] = true
   end
   
   -- Multi Dropdown Frame
   local MultiDropdownFrame = Instance.new("Frame")
   MultiDropdownFrame.Name = "MultiDropdown_" .. MultiDropdownData.Name
   MultiDropdownFrame.Size = UDim2.new(1, 0, 0, 40)
   MultiDropdownFrame.BackgroundColor3 = Colors.Card
   MultiDropdownFrame.BorderSizePixel = 0
   MultiDropdownFrame.Parent = tab.Content
   
   CreateCorner(MultiDropdownFrame, 6)
   CreateStroke(MultiDropdownFrame, Colors.Border, 1)
   
   -- Multi Dropdown Label
   local MultiDropdownLabel = Instance.new("TextLabel")
   MultiDropdownLabel.Name = "Label"
   MultiDropdownLabel.Size = UDim2.new(1, -20, 0, 20)
   MultiDropdownLabel.Position = UDim2.new(0, 10, 0, 2)
   MultiDropdownLabel.BackgroundTransparency = 1
   MultiDropdownLabel.Text = MultiDropdownData.Name
   MultiDropdownLabel.TextColor3 = Colors.Text
   MultiDropdownLabel.TextSize = 11
   MultiDropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
   MultiDropdownLabel.Font = Enum.Font.Gotham
   MultiDropdownLabel.Parent = MultiDropdownFrame
   
   -- Multi Dropdown Selected Frame
   local MultiDropdownSelected = Instance.new("Frame")
   MultiDropdownSelected.Name = "Selected"
   MultiDropdownSelected.Size = UDim2.new(1, -20, 0, 20)
   MultiDropdownSelected.Position = UDim2.new(0, 10, 0, 18)
   MultiDropdownSelected.BackgroundColor3 = Colors.Secondary
   MultiDropdownSelected.BorderSizePixel = 0
   MultiDropdownSelected.Parent = MultiDropdownFrame
   
   CreateCorner(MultiDropdownSelected, 4)
   CreateStroke(MultiDropdownSelected, Colors.Border, 1)
   
   -- Multi Dropdown Selected Text
   local MultiDropdownSelectedText = Instance.new("TextLabel")
   MultiDropdownSelectedText.Name = "SelectedText"
   MultiDropdownSelectedText.Size = UDim2.new(1, -30, 1, 0)
   MultiDropdownSelectedText.Position = UDim2.new(0, 8, 0, 0)
   MultiDropdownSelectedText.BackgroundTransparency = 1
   MultiDropdownSelectedText.Text = "None"
   MultiDropdownSelectedText.TextColor3 = Colors.Text
   MultiDropdownSelectedText.TextSize = 11
   MultiDropdownSelectedText.TextXAlignment = Enum.TextXAlignment.Left
   MultiDropdownSelectedText.TextTruncate = Enum.TextTruncate.AtEnd
   MultiDropdownSelectedText.Font = Enum.Font.Gotham
   MultiDropdownSelectedText.Parent = MultiDropdownSelected
   
   -- Multi Dropdown Arrow
   local MultiDropdownArrow = Instance.new("TextLabel")
   MultiDropdownArrow.Name = "Arrow"
   MultiDropdownArrow.Size = UDim2.new(0, 20, 1, 0)
   MultiDropdownArrow.Position = UDim2.new(1, -20, 0, 0)
   MultiDropdownArrow.BackgroundTransparency = 1
   MultiDropdownArrow.Text = "▼"
   MultiDropdownArrow.TextColor3 = Colors.TextSecondary
   MultiDropdownArrow.TextSize = 10
   MultiDropdownArrow.Font = Enum.Font.Gotham
   MultiDropdownArrow.Parent = MultiDropdownSelected
   
   -- Multi Dropdown List Frame
   local MultiDropdownList = Instance.new("Frame")
   MultiDropdownList.Name = "List"
   MultiDropdownList.Size = UDim2.new(1, -20, 0, 0)
   MultiDropdownList.Position = UDim2.new(0, 10, 1, 5)
   MultiDropdownList.BackgroundColor3 = Colors.Secondary
   MultiDropdownList.BorderSizePixel = 0
   MultiDropdownList.Visible = false
   MultiDropdownList.ZIndex = 10
   MultiDropdownList.Parent = MultiDropdownFrame
   
   CreateCorner(MultiDropdownList, 4)
   CreateStroke(MultiDropdownList, Colors.Border, 1)
   
   -- Multi Dropdown List Layout
   local MultiDropdownListLayout = Instance.new("UIListLayout")
   MultiDropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
   MultiDropdownListLayout.Parent = MultiDropdownList
   
   -- Multi Dropdown Button
   local MultiDropdownButton = Instance.new("TextButton")
   MultiDropdownButton.Name = "MultiDropdownButton"
   MultiDropdownButton.Size = UDim2.new(1, 0, 1, 0)
   MultiDropdownButton.BackgroundTransparency = 1
   MultiDropdownButton.Text = ""
   MultiDropdownButton.Parent = MultiDropdownFrame
   
   -- Update selected text function
   local function UpdateSelectedText()
       local selected = {}
       for option, isSelected in pairs(MultiDropdownData.SelectedOptions) do
           if isSelected then
               table.insert(selected, option)
           end
       end
       
       if #selected == 0 then
           MultiDropdownSelectedText.Text = "None"
       elseif #selected == 1 then
           MultiDropdownSelectedText.Text = selected[1]
       else
           MultiDropdownSelectedText.Text = table.concat(selected, ", ")
       end
   end
   
   -- Create option function
   local function CreateMultiOption(optionText)
       local OptionFrame = Instance.new("Frame")
       OptionFrame.Name = "Option_" .. optionText
       OptionFrame.Size = UDim2.new(1, 0, 0, 25)
       OptionFrame.BackgroundColor3 = Colors.Secondary
       OptionFrame.BorderSizePixel = 0
       OptionFrame.Parent = MultiDropdownList
       
       -- Checkbox for option
       local OptionCheckbox = Instance.new("Frame")
       OptionCheckbox.Name = "Checkbox"
       OptionCheckbox.Size = UDim2.new(0, 16, 0, 16)
       OptionCheckbox.Position = UDim2.new(0, 8, 0.5, -8)
       OptionCheckbox.BackgroundColor3 = Colors.Card
       OptionCheckbox.BorderSizePixel = 0
       OptionCheckbox.Parent = OptionFrame
       
       CreateCorner(OptionCheckbox, 3)
       CreateStroke(OptionCheckbox, Colors.Border, 1)
       
       -- Checkmark
       local Checkmark = Instance.new("TextLabel")
       Checkmark.Name = "Checkmark"
       Checkmark.Size = UDim2.new(1, 0, 1, 0)
       Checkmark.BackgroundTransparency = 1
       Checkmark.Text = "✓"
       Checkmark.TextColor3 = Colors.Success
       Checkmark.TextSize = 12
       Checkmark.Font = Enum.Font.GothamBold
       Checkmark.Visible = MultiDropdownData.SelectedOptions[optionText] or false
       Checkmark.Parent = OptionCheckbox
       
       -- Option text
       local OptionText = Instance.new("TextLabel")
       OptionText.Name = "Text"
       OptionText.Size = UDim2.new(1, -35, 1, 0)
       OptionText.Position = UDim2.new(0, 30, 0, 0)
       OptionText.BackgroundTransparency = 1
       OptionText.Text = optionText
       OptionText.TextColor3 = Colors.Text
       OptionText.TextSize = 11
       OptionText.TextXAlignment = Enum.TextXAlignment.Left
       OptionText.Font = Enum.Font.Gotham
       OptionText.Parent = OptionFrame
       
       -- Option button
       local OptionButton = Instance.new("TextButton")
       OptionButton.Name = "Button"
       OptionButton.Size = UDim2.new(1, 0, 1, 0)
       OptionButton.BackgroundTransparency = 1
       OptionButton.Text = ""
       OptionButton.Parent = OptionFrame
       
       -- Update checkbox state
       if MultiDropdownData.SelectedOptions[optionText] then
           OptionCheckbox.BackgroundColor3 = Colors.Success
           Checkmark.Visible = true
       end
       
       -- Option hover effect
       OptionButton.MouseEnter:Connect(function()
           local hoverTween = CreateTween(OptionFrame, {
               BackgroundColor3 = Colors.Hover
           }, 0.15)
           hoverTween:Play()
       end)
       
       OptionButton.MouseLeave:Connect(function()
           local leaveTween = CreateTween(OptionFrame, {
               BackgroundColor3 = Colors.Secondary
           }, 0.15)
           leaveTween:Play()
       end)
       
       -- Option click handler
       OptionButton.MouseButton1Click:Connect(function()
           MultiDropdownData.SelectedOptions[optionText] = not MultiDropdownData.SelectedOptions[optionText]
           
           if MultiDropdownData.SelectedOptions[optionText] then
               OptionCheckbox.BackgroundColor3 = Colors.Success
               Checkmark.Visible = true
           else
               OptionCheckbox.BackgroundColor3 = Colors.Card
               Checkmark.Visible = false
           end
           
           UpdateSelectedText()
           
           -- Get selected options
           local selected = {}
           for option, isSelected in pairs(MultiDropdownData.SelectedOptions) do
               if isSelected then
                   table.insert(selected, option)
               end
           end
           
           MultiDropdownData.Callback(selected)
       end)
       
       return OptionFrame
   end
   
   -- Toggle dropdown function
   local function ToggleMultiDropdown()
       MultiDropdownData.IsOpen = not MultiDropdownData.IsOpen
       
       if MultiDropdownData.IsOpen then
           MultiDropdownList.Visible = true
           local listHeight = #MultiDropdownData.Options * 25
           
           local openTween = CreateTween(MultiDropdownList, {
               Size = UDim2.new(1, -20, 0, listHeight)
           }, 0.2)
           openTween:Play()
           
           local arrowTween = CreateTween(MultiDropdownArrow, {
               Rotation = 180
           }, 0.2)
           arrowTween:Play()
           
           local frameTween = CreateTween(MultiDropdownFrame, {
               Size = UDim2.new(1, 0, 0, 40 + listHeight + 10)
           }, 0.2)
           frameTween:Play()
       else
           local closeTween = CreateTween(MultiDropdownList, {
               Size = UDim2.new(1, -20, 0, 0)
           }, 0.2)
           closeTween:Play()
           
           local arrowTween = CreateTween(MultiDropdownArrow, {
               Rotation = 0
           }, 0.2)
           arrowTween:Play()
           
           local frameTween = CreateTween(MultiDropdownFrame, {
               Size = UDim2.new(1, 0, 0, 40)
           }, 0.2)
           frameTween:Play()
           
           closeTween.Completed:Connect(function()
               MultiDropdownList.Visible = false
           end)
       end
       
       tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   end
   
   -- Create options
   for _, option in ipairs(MultiDropdownData.Options) do
       CreateMultiOption(option)
   end
   
   -- Initialize selected text
   UpdateSelectedText()
   
   -- Click handler
   MultiDropdownButton.MouseButton1Click:Connect(ToggleMultiDropdown)
   
   -- Store references
   MultiDropdownData.Frame = MultiDropdownFrame
   MultiDropdownData.UpdateSelectedText = UpdateSelectedText
   
   -- Add to tab elements
   table.insert(tab.Elements, MultiDropdownData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return MultiDropdownData
end

-- Progress Bar Creation Function
function UILibrary:CreateProgressBar(tab, config)
   config = config or {}
   
   local ProgressBarData = {
       Name = config.Name or "Progress Bar",
       Value = config.Value or 0,
       MaxValue = config.MaxValue or 100,
       Suffix = config.Suffix or "%",
       Tab = tab,
       ShowValue = config.ShowValue ~= false,
       Color = config.Color or Colors.Accent
   }
   
   -- Progress Bar Frame
   local ProgressBarFrame = Instance.new("Frame")
   ProgressBarFrame.Name = "ProgressBar_" .. ProgressBarData.Name
   ProgressBarFrame.Size = UDim2.new(1, 0, 0, 45)
   ProgressBarFrame.BackgroundColor3 = Colors.Card
   ProgressBarFrame.BorderSizePixel = 0
   ProgressBarFrame.Parent = tab.Content
   
   CreateCorner(ProgressBarFrame, 6)
   CreateStroke(ProgressBarFrame, Colors.Border, 1)
   
   -- Progress Bar Label
   local ProgressBarLabel = Instance.new("TextLabel")
   ProgressBarLabel.Name = "Label"
   ProgressBarLabel.Size = UDim2.new(1, -20, 0, 20)
   ProgressBarLabel.Position = UDim2.new(0, 10, 0, 5)
   ProgressBarLabel.BackgroundTransparency = 1
   ProgressBarLabel.Text = ProgressBarData.Name
   ProgressBarLabel.TextColor3 = Colors.Text
   ProgressBarLabel.TextSize = 12
   ProgressBarLabel.TextXAlignment = Enum.TextXAlignment.Left
   ProgressBarLabel.Font = Enum.Font.Gotham
   ProgressBarLabel.Parent = ProgressBarFrame
   
   -- Progress Bar Value Label
   local ProgressBarValueLabel = Instance.new("TextLabel")
   ProgressBarValueLabel.Name = "ValueLabel"
   ProgressBarValueLabel.Size = UDim2.new(0, 60, 0, 20)
   ProgressBarValueLabel.Position = UDim2.new(1, -70, 0, 5)
   ProgressBarValueLabel.BackgroundTransparency = 1
   ProgressBarValueLabel.Text = "0" .. ProgressBarData.Suffix
   ProgressBarValueLabel.TextColor3 = ProgressBarData.Color
   ProgressBarValueLabel.TextSize = 11
   ProgressBarValueLabel.TextXAlignment = Enum.TextXAlignment.Right
   ProgressBarValueLabel.Font = Enum.Font.GothamBold
   ProgressBarValueLabel.Visible = ProgressBarData.ShowValue
   ProgressBarValueLabel.Parent = ProgressBarFrame
   
   -- Progress Bar Track
   local ProgressBarTrack = Instance.new("Frame")
   ProgressBarTrack.Name = "Track"
   ProgressBarTrack.Size = UDim2.new(1, -20, 0, 8)
   ProgressBarTrack.Position = UDim2.new(0, 10, 0, 30)
   ProgressBarTrack.BackgroundColor3 = Colors.Secondary
   ProgressBarTrack.BorderSizePixel = 0
   ProgressBarTrack.Parent = ProgressBarFrame
   
   CreateCorner(ProgressBarTrack, 4)
   
   -- Progress Bar Fill
   local ProgressBarFill = Instance.new("Frame")
   ProgressBarFill.Name = "Fill"
   ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
   ProgressBarFill.BackgroundColor3 = ProgressBarData.Color
   ProgressBarFill.BorderSizePixel = 0
   ProgressBarFill.Parent = ProgressBarTrack
   
   CreateCorner(ProgressBarFill, 4)
   
   -- Progress Bar Gradient
   CreateGradient(ProgressBarFill, {
       ProgressBarData.Color,
       Color3.new(
           ProgressBarData.Color.R * 0.8,
           ProgressBarData.Color.G * 0.8,
           ProgressBarData.Color.B * 0.8
       )
   }, 0)
   
   -- Update progress function
   local function UpdateProgress(value)
       value = math.clamp(value, 0, ProgressBarData.MaxValue)
       ProgressBarData.Value = value
       
       local percentage = value / ProgressBarData.MaxValue
       local fillSize = UDim2.new(percentage, 0, 1, 0)
       
       local fillTween = CreateTween(ProgressBarFill, {
           Size = fillSize
       }, 0.3)
       fillTween:Play()
       
       if ProgressBarData.ShowValue then
           local displayValue = math.floor(percentage * 100)
           ProgressBarValueLabel.Text = tostring(displayValue) .. ProgressBarData.Suffix
       end
   end
   
   -- Initialize progress
   UpdateProgress(ProgressBarData.Value)
   
   -- Store references
   ProgressBarData.Frame = ProgressBarFrame
   ProgressBarData.UpdateProgress = UpdateProgress
   
   -- Add to tab elements
   table.insert(tab.Elements, ProgressBarData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return ProgressBarData
end

-- Image Display Creation Function
function UILibrary:CreateImage(tab, config)
   config = config or {}
   
   local ImageData = {
       Name = config.Name or "Image",
       ImageId = config.ImageId or "rbxasset://textures/ui/GuiImagePlaceholder.png",
       Size = config.Size or UDim2.new(0, 100, 0, 100),
       Tab = tab
   }
   
   -- Image Frame
   local ImageFrame = Instance.new("Frame")
   ImageFrame.Name = "Image_" .. ImageData.Name
   ImageFrame.Size = UDim2.new(1, 0, 0, ImageData.Size.Y.Offset + 30)
   ImageFrame.BackgroundColor3 = Colors.Card
   ImageFrame.BorderSizePixel = 0
   ImageFrame.Parent = tab.Content
   
   CreateCorner(ImageFrame, 6)
   CreateStroke(ImageFrame, Colors.Border, 1)
   
   -- Image Label
   local ImageLabel = Instance.new("TextLabel")
   ImageLabel.Name = "Label"
   ImageLabel.Size = UDim2.new(1, -20, 0, 20)
   ImageLabel.Position = UDim2.new(0, 10, 0, 5)
   ImageLabel.BackgroundTransparency = 1
   ImageLabel.Text = ImageData.Name
   ImageLabel.TextColor3 = Colors.Text
   ImageLabel.TextSize = 12
   ImageLabel.TextXAlignment = Enum.TextXAlignment.Left
   ImageLabel.Font = Enum.Font.Gotham
   ImageLabel.Parent = ImageFrame
   
   -- Image Display
   local ImageDisplay = Instance.new("ImageLabel")
   ImageDisplay.Name = "ImageDisplay"
   ImageDisplay.Size = ImageData.Size
   ImageDisplay.Position = UDim2.new(0.5, -ImageData.Size.X.Offset/2, 0, 25)
   ImageDisplay.BackgroundColor3 = Colors.Secondary
   ImageDisplay.BorderSizePixel = 0
   ImageDisplay.Image = ImageData.ImageId
   ImageDisplay.ScaleType = Enum.ScaleType.Fit
   ImageDisplay.Parent = ImageFrame
   
   CreateCorner(ImageDisplay, 4)
   CreateStroke(ImageDisplay, Colors.Border, 1)
   
   -- Update image function
   local function UpdateImage(imageId)
       ImageData.ImageId = imageId
       ImageDisplay.Image = imageId
   end
   
   -- Store references
   ImageData.Frame = ImageFrame
   ImageData.Display = ImageDisplay
   ImageData.UpdateImage = UpdateImage
   
   -- Add to tab elements
   table.insert(tab.Elements, ImageData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return ImageData
end

-- Modal/Dialog System
function UILibrary:CreateModal(config)
   config = config or {}
   
   local ModalData = {
       Title = config.Title or "Modal",
       Content = config.Content or "This is a modal dialog",
       Buttons = config.Buttons or {
           {Text = "OK", Callback = function() end},
           {Text = "Cancel", Callback = function() end}
       }
   }
   
   -- Modal ScreenGui
   local ModalGui = Instance.new("ScreenGui")
   ModalGui.Name = "Modal"
   ModalGui.Parent = CoreGui
   ModalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   
   -- Background Blur
   local ModalBackground = Instance.new("Frame")
   ModalBackground.Name = "Background"
   ModalBackground.Size = UDim2.new(1, 0, 1, 0)
   ModalBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   ModalBackground.BackgroundTransparency = 0.5
   ModalBackground.BorderSizePixel = 0
   ModalBackground.Parent = ModalGui
   
   -- Modal Frame
   local ModalFrame = Instance.new("Frame")
   ModalFrame.Name = "ModalFrame"
   ModalFrame.Size = UDim2.new(0, 350, 0, 200)
   ModalFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
   ModalFrame.BackgroundColor3 = Colors.Primary
   ModalFrame.BorderSizePixel = 0
   ModalFrame.Parent = ModalGui
   
   CreateCorner(ModalFrame, 8)
   CreateStroke(ModalFrame, Colors.Border, 2)
   
   -- Modal Title
   local ModalTitle = Instance.new("TextLabel")
   ModalTitle.Name = "Title"
   ModalTitle.Size = UDim2.new(1, -20, 0, 30)
   ModalTitle.Position = UDim2.new(0, 10, 0, 10)
   ModalTitle.BackgroundTransparency = 1
   ModalTitle.Text = ModalData.Title
   ModalTitle.TextColor3 = Colors.Text
   ModalTitle.TextSize = 16
   ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
   ModalTitle.Font = Enum.Font.GothamBold
   ModalTitle.Parent = ModalFrame
   
   -- Modal Content
   local ModalContent = Instance.new("TextLabel")
   ModalContent.Name = "Content"
   ModalContent.Size = UDim2.new(1, -20, 1, -100)
   ModalContent.Position = UDim2.new(0, 10, 0, 40)
   ModalContent.BackgroundTransparency = 1
   ModalContent.Text = ModalData.Content
   ModalContent.TextColor3 = Colors.TextSecondary
   ModalContent.TextSize = 12
   ModalContent.TextXAlignment = Enum.TextXAlignment.Left
   ModalContent.TextYAlignment = Enum.TextYAlignment.Top
   ModalContent.TextWrapped = true
   ModalContent.Font = Enum.Font.Gotham
   ModalContent.Parent = ModalFrame
   
   -- Button Container
   local ButtonContainer = Instance.new("Frame")
   ButtonContainer.Name = "ButtonContainer"
   ButtonContainer.Size = UDim2.new(1, -20, 0, 35)
   ButtonContainer.Position = UDim2.new(0, 10, 1, -45)
   ButtonContainer.BackgroundTransparency = 1
   ButtonContainer.Parent = ModalFrame
   
   local ButtonLayout = Instance.new("UIListLayout")
   ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
   ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
   ButtonLayout.Padding = UDim.new(0, 10)
   ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
   ButtonLayout.Parent = ButtonContainer
   
   -- Create buttons
   for i, buttonConfig in ipairs(ModalData.Buttons) do
       local Button = Instance.new("TextButton")
       Button.Name = "Button_" .. i
       Button.Size = UDim2.new(0, 80, 1, 0)
       Button.BackgroundColor3 = i == 1 and Colors.Accent or Colors.Secondary
       Button.BorderSizePixel = 0
       Button.Text = buttonConfig.Text
       Button.TextColor3 = Colors.Text
       Button.TextSize = 12
       Button.Font = Enum.Font.GothamBold
       Button.Parent = ButtonContainer
       
       CreateCorner(Button, 4)
       
       Button.MouseButton1Click:Connect(function()
           buttonConfig.Callback()
           ModalGui:Destroy()
       end)
       
       -- Button hover effects
       Button.MouseEnter:Connect(function()
           local hoverTween = CreateTween(Button, {
               BackgroundColor3 = i == 1 and Colors.AccentHover or Colors.Hover
           }, 0.15)
           hoverTween:Play()
       end)
       
       Button.MouseLeave:Connect(function()
           local leaveTween = CreateTween(Button, {
               BackgroundColor3 = i == 1 and Colors.Accent or Colors.Secondary
           }, 0.15)
           leaveTween:Play()
       end)
   end
   
   -- Close on background click
   ModalBackground.InputBegan:Connect(function(input)
       if input.UserInputType == Enum.UserInputType.MouseButton1 then
           ModalGui:Destroy()
       end
   end)
   
   -- Fade in animation
   ModalBackground.BackgroundTransparency = 1
   ModalFrame.Position = UDim2.new(0.5, -175, 0.5, -120)
   
   local bgTween = CreateTween(ModalBackground, {
       BackgroundTransparency = 0.5
   }, 0.3)
   
   local frameTween = CreateTween(ModalFrame, {
       Position = UDim2.new(0.5, -175, 0.5, -100)
   }, 0.3, Enum.EasingStyle.Back)
   
   bgTween:Play()
   frameTween:Play()
   
   return ModalData
end

-- Tooltip System
function UILibrary:AddTooltip(element, text)
   local TooltipGui = Instance.new("ScreenGui")
   TooltipGui.Name = "Tooltip"
   TooltipGui.Parent = CoreGui
   TooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   TooltipGui.Enabled = false
   
   local TooltipFrame = Instance.new("Frame")
   TooltipFrame.Name = "TooltipFrame"
   TooltipFrame.Size = UDim2.new(0, 200, 0, 30)
   TooltipFrame.BackgroundColor3 = Colors.Secondary
   TooltipFrame.BorderSizePixel = 0
   TooltipFrame.Parent = TooltipGui
   
   CreateCorner(TooltipFrame, 4)
   CreateStroke(TooltipFrame, Colors.Border, 1)
   
   -- Shadow
   local TooltipShadow = Instance.new("Frame")
   TooltipShadow.Name = "Shadow"
   TooltipShadow.Size = UDim2.new(1, 10, 1, 10)
   TooltipShadow.Position = UDim2.new(0, -5, 0, -5)
   TooltipShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   TooltipShadow.BackgroundTransparency = 0.9
   TooltipShadow.BorderSizePixel = 0
   TooltipShadow.ZIndex = TooltipFrame.ZIndex - 1
   TooltipShadow.Parent = TooltipFrame
   
   CreateCorner(TooltipShadow, 4)
   
   local TooltipText = Instance.new("TextLabel")
   TooltipText.Name = "Text"
   TooltipText.Size = UDim2.new(1, -10, 1, 0)
   TooltipText.Position = UDim2.new(0, 5, 0, 0)
   TooltipText.BackgroundTransparency = 1
   TooltipText.Text = text
   TooltipText.TextColor3 = Colors.Text
   TooltipText.TextSize = 11
   TooltipText.TextWrapped = true
   TooltipText.Font = Enum.Font.Gotham
   TooltipText.Parent = TooltipFrame
   
   -- Calculate text size
   local textBounds = TooltipText.TextBounds
   TooltipFrame.Size = UDim2.new(0, math.min(textBounds.X + 20, 250), 0, textBounds.Y + 10)
   
   -- Mouse tracking
   local mouse = Players.LocalPlayer:GetMouse()
   
   local function UpdatePosition()
       TooltipFrame.Position = UDim2.new(0, mouse.X + 10, 0, mouse.Y + 10)
   end
   
   element.MouseEnter:Connect(function()
       TooltipGui.Enabled = true
       UpdatePosition()
       
       local fadeIn = CreateTween(TooltipFrame, {
           BackgroundTransparency = 0
       }, 0.2)
       fadeIn:Play()
   end)
   
   element.MouseLeave:Connect(function()
       TooltipGui.Enabled = false
   end)
   
   element.MouseMoved:Connect(UpdatePosition)
   
   return TooltipGui
end

-- Search Box Creation Function (continued)
function :CreateSearchBox(tab, config)
   config = config or {}
   
   local SearchBoxData = {
       Name = config.Name or "Search",
       PlaceholderText = config.PlaceholderText or "Search...",
       Callback = config.Callback or function() end,
       Tab = tab,
       SearchableElements = config.SearchableElements or tab.Elements
   }
   
   -- Search Box Frame
   local SearchBoxFrame = Instance.new("Frame")
   SearchBoxFrame.Name = "SearchBox_" .. SearchBoxData.Name
   SearchBoxFrame.Size = UDim2.new(1, 0, 0, 35)
   SearchBoxFrame.BackgroundColor3 = Colors.Card
   SearchBoxFrame.BorderSizePixel = 0
   SearchBoxFrame.Parent = tab.Content
   
   CreateCorner(SearchBoxFrame, 6)
   CreateStroke(SearchBoxFrame, Colors.Border, 1)
   
   -- Search Icon
   local SearchIcon = Instance.new("TextLabel")
   SearchIcon.Name = "Icon"
   SearchIcon.Size = UDim2.new(0, 30, 1, 0)
   SearchIcon.Position = UDim2.new(0, 5, 0, 0)
   SearchIcon.BackgroundTransparency = 1
   SearchIcon.Text = "🔍"
   SearchIcon.TextColor3 = Colors.TextSecondary
   SearchIcon.TextSize = 14
   SearchIcon.Font = Enum.Font.Gotham
   SearchIcon.Parent = SearchBoxFrame
   
   -- Search Input
   local SearchInput = Instance.new("TextBox")
   SearchInput.Name = "Input"
   SearchInput.Size = UDim2.new(1, -40, 1, -10)
   SearchInput.Position = UDim2.new(0, 35, 0, 5)
   SearchInput.BackgroundTransparency = 1
   SearchInput.Text = ""
   SearchInput.PlaceholderText = SearchBoxData.PlaceholderText
   SearchInput.TextColor3 = Colors.Text
   SearchInput.PlaceholderColor3 = Colors.TextMuted
   SearchInput.TextSize = 12
   SearchInput.TextXAlignment = Enum.TextXAlignment.Left
   SearchInput.Font = Enum.Font.Gotham
   SearchInput.ClearTextOnFocus = false
   SearchInput.Parent = SearchBoxFrame
   
   -- Search function
   local function PerformSearch(query)
       query = query:lower()
       
       for _, element in ipairs(SearchBoxData.SearchableElements) do
           if element.Frame then
               local elementName = (element.Name or ""):lower()
               local isVisible = query == "" or elementName:find(query, 1, true) ~= nil
               
               element.Frame.Visible = isVisible
           end
       end
       
       -- Update canvas size
       tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
       
       SearchBoxData.Callback(query)
   end
   
   -- Search input changed
   SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
       PerformSearch(SearchInput.Text)
   end)
   
   -- Focus effects
   SearchInput.Focused:Connect(function()
       local iconTween = CreateTween(SearchIcon, {
           TextColor3 = Colors.Accent
       }, 0.15)
       iconTween:Play()
       
       local strokeTween = CreateTween(SearchBoxFrame.UIStroke, {
           Color = Colors.Accent
       }, 0.15)
       strokeTween:Play()
   end)
   
   SearchInput.FocusLost:Connect(function()
       local iconTween = CreateTween(SearchIcon, {
           TextColor3 = Colors.TextSecondary
       }, 0.15)
       iconTween:Play()
       
       local strokeTween = CreateTween(SearchBoxFrame.UIStroke, {
           Color = Colors.Border
       }, 0.15)
       strokeTween:Play()
   end)
   
   -- Store references
   SearchBoxData.Frame = SearchBoxFrame
   SearchBoxData.Input = SearchInput
   SearchBoxData.PerformSearch = PerformSearch
   
   -- Add to tab elements
   table.insert(tab.Elements, SearchBoxData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return SearchBoxData
end

-- List/Table Component
function UILibrary:CreateList(tab, config)
   config = config or {}
   
   local ListData = {
       Name = config.Name or "List",
       Items = config.Items or {},
       Callback = config.Callback or function() end,
       Tab = tab,
       Multiselect = config.Multiselect or false,
       SelectedItems = {}
   }
   
   -- Calculate list height
   local listHeight = math.min(#ListData.Items * 30 + 10, 200)
   
   -- List Frame
   local ListFrame = Instance.new("Frame")
   ListFrame.Name = "List_" .. ListData.Name
   ListFrame.Size = UDim2.new(1, 0, 0, listHeight + 30)
   ListFrame.BackgroundColor3 = Colors.Card
   ListFrame.BorderSizePixel = 0
   ListFrame.Parent = tab.Content
   
   CreateCorner(ListFrame, 6)
   CreateStroke(ListFrame, Colors.Border, 1)
   
   -- List Label
   local ListLabel = Instance.new("TextLabel")
   ListLabel.Name = "Label"
   ListLabel.Size = UDim2.new(1, -20, 0, 25)
   ListLabel.Position = UDim2.new(0, 10, 0, 5)
   ListLabel.BackgroundTransparency = 1
   ListLabel.Text = ListData.Name
   ListLabel.TextColor3 = Colors.Text
   ListLabel.TextSize = 12
   ListLabel.TextXAlignment = Enum.TextXAlignment.Left
   ListLabel.Font = Enum.Font.Gotham
   ListLabel.Parent = ListFrame
   
   -- List Container
   local ListContainer = Instance.new("ScrollingFrame")
   ListContainer.Name = "Container"
   ListContainer.Size = UDim2.new(1, -20, 0, listHeight)
   ListContainer.Position = UDim2.new(0, 10, 0, 30)
   ListContainer.BackgroundColor3 = Colors.Secondary
   ListContainer.BorderSizePixel = 0
   ListContainer.ScrollBarThickness = 3
   ListContainer.ScrollBarImageColor3 = Colors.Accent
   ListContainer.CanvasSize = UDim2.new(0, 0, 0, #ListData.Items * 30)
   ListContainer.Parent = ListFrame
   
   CreateCorner(ListContainer, 4)
   
   local ListLayout = Instance.new("UIListLayout")
   ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
   ListLayout.Parent = ListContainer
   
   -- Create list items
   for i, itemData in ipairs(ListData.Items) do
       local itemText = type(itemData) == "table" and itemData.Text or tostring(itemData)
       local itemValue = type(itemData) == "table" and itemData.Value or itemData
       
       local ItemFrame = Instance.new("TextButton")
       ItemFrame.Name = "Item_" .. i
       ItemFrame.Size = UDim2.new(1, 0, 0, 30)
       ItemFrame.BackgroundColor3 = Colors.Secondary
       ItemFrame.BorderSizePixel = 0
       ItemFrame.Text = ""
       ItemFrame.Parent = ListContainer
       
       local ItemText = Instance.new("TextLabel")
       ItemText.Name = "Text"
       ItemText.Size = UDim2.new(1, -10, 1, 0)
       ItemText.Position = UDim2.new(0, 10, 0, 0)
       ItemText.BackgroundTransparency = 1
       ItemText.Text = itemText
       ItemText.TextColor3 = Colors.Text
       ItemText.TextSize = 11
       ItemText.TextXAlignment = Enum.TextXAlignment.Left
       ItemText.Font = Enum.Font.Gotham
       ItemText.Parent = ItemFrame
       
       -- Item selection
       ItemFrame.MouseButton1Click:Connect(function()
           if ListData.Multiselect then
               if ListData.SelectedItems[itemValue] then
                   ListData.SelectedItems[itemValue] = nil
                   ItemFrame.BackgroundColor3 = Colors.Secondary
                   ItemText.TextColor3 = Colors.Text
               else
                   ListData.SelectedItems[itemValue] = true
                   ItemFrame.BackgroundColor3 = Colors.Accent
                   ItemText.TextColor3 = Colors.Text
               end
               
               local selected = {}
               for value, _ in pairs(ListData.SelectedItems) do
                   table.insert(selected, value)
               end
               ListData.Callback(selected)
           else
               -- Clear previous selection
               for _, child in ipairs(ListContainer:GetChildren()) do
                   if child:IsA("TextButton") then
                       child.BackgroundColor3 = Colors.Secondary
                       if child:FindFirstChild("Text") then
                           child.Text.TextColor3 = Colors.Text
                       end
                   end
               end
               
               -- Select current item
               ItemFrame.BackgroundColor3 = Colors.Accent
               ItemText.TextColor3 = Colors.Text
               ListData.Callback(itemValue)
           end
       end)
       
       -- Item hover effect
       ItemFrame.MouseEnter:Connect(function()
           if not (ListData.SelectedItems[itemValue] or ItemFrame.BackgroundColor3 == Colors.Accent) then
               local hoverTween = CreateTween(ItemFrame, {
                   BackgroundColor3 = Colors.Hover
               }, 0.15)
               hoverTween:Play()
           end
       end)
       
       ItemFrame.MouseLeave:Connect(function()
           if not (ListData.SelectedItems[itemValue] or ItemFrame.BackgroundColor3 == Colors.Accent) then
               local leaveTween = CreateTween(ItemFrame, {
                   BackgroundColor3 = Colors.Secondary
               }, 0.15)
               leaveTween:Play()
           end
       end)
   end
   
   -- Store references
   ListData.Frame = ListFrame
   ListData.Container = ListContainer
   
   -- Add to tab elements
   table.insert(tab.Elements, ListData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return ListData
end

-- Theme System
function UILibrary:CreateTheme(name, colors)
   local Theme = {
       Name = name,
       Colors = colors
   }
   
   return Theme
end

function UILibrary:ApplyTheme(window, theme)
   Colors = theme.Colors
   
   -- Update all UI elements with new colors
   local function UpdateColors(parent)
       for _, child in ipairs(parent:GetDescendants()) do
           if child:IsA("Frame") then
               if child.BackgroundColor3 == Colors.Primary then
                   child.BackgroundColor3 = theme.Colors.Primary
               elseif child.BackgroundColor3 == Colors.Secondary then
                   child.BackgroundColor3 = theme.Colors.Secondary
               elseif child.BackgroundColor3 == Colors.Card then
                   child.BackgroundColor3 = theme.Colors.Card
               elseif child.BackgroundColor3 == Colors.Accent then
                   child.BackgroundColor3 = theme.Colors.Accent
               end
           elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
               if child.TextColor3 == Colors.Text then
                   child.TextColor3 = theme.Colors.Text
               elseif child.TextColor3 == Colors.TextSecondary then
                   child.TextColor3 = theme.Colors.TextSecondary
               elseif child.TextColor3 == Colors.TextMuted then
                   child.TextColor3 = theme.Colors.TextMuted
               end
           elseif child:IsA("UIStroke") then
               if child.Color == Colors.Border then
                   child.Color = theme.Colors.Border
               end
           end
       end
   end
   
   UpdateColors(window.ScreenGui)
end

-- Predefined Themes
UILibrary.Themes = {
   Dark = {
       Primary = Color3.fromRGB(25, 25, 35),
       Secondary = Color3.fromRGB(35, 35, 45),
       Accent = Color3.fromRGB(88, 101, 242),
       AccentHover = Color3.fromRGB(108, 121, 255),
       Success = Color3.fromRGB(67, 181, 129),
       Warning = Color3.fromRGB(250, 166, 26),
       Error = Color3.fromRGB(237, 66, 69),
       Text = Color3.fromRGB(255, 255, 255),
       TextSecondary = Color3.fromRGB(185, 187, 190),
       TextMuted = Color3.fromRGB(114, 118, 125),
       Border = Color3.fromRGB(45, 45, 55),
       Background = Color3.fromRGB(15, 15, 20),
       Card = Color3.fromRGB(30, 30, 40),
       Hover = Color3.fromRGB(40, 40, 50)
   },
   Light = {
       Primary = Color3.fromRGB(255, 255, 255),
       Secondary = Color3.fromRGB(245, 245, 245),
       Accent = Color3.fromRGB(88, 101, 242),
       AccentHover = Color3.fromRGB(68, 81, 222),
       Success = Color3.fromRGB(67, 181, 129),
       Warning = Color3.fromRGB(250, 166, 26),
       Error = Color3.fromRGB(237, 66, 69),
       Text = Color3.fromRGB(0, 0, 0),
       TextSecondary = Color3.fromRGB(100, 100, 100),
       TextMuted = Color3.fromRGB(150, 150, 150),
       Border = Color3.fromRGB(220, 220, 220),
       Background = Color3.fromRGB(250, 250, 250),
       Card = Color3.fromRGB(255, 255, 255),
       Hover = Color3.fromRGB(240, 240, 240)
   },
   Ocean = {
       Primary = Color3.fromRGB(20, 30, 48),
       Secondary = Color3.fromRGB(30, 41, 59),
       Accent = Color3.fromRGB(59, 130, 246),
       AccentHover = Color3.fromRGB(79, 150, 255),
       Success = Color3.fromRGB(34, 197, 94),
       Warning = Color3.fromRGB(251, 146, 60),
       Error = Color3.fromRGB(239, 68, 68),
       Text = Color3.fromRGB(241, 245, 249),
       TextSecondary = Color3.fromRGB(148, 163, 184),
       TextMuted = Color3.fromRGB(100, 116, 139),
       Border = Color3.fromRGB(51, 65, 85),
       Background = Color3.fromRGB(15, 23, 42),
       Card = Color3.fromRGB(30, 41, 59),
       Hover = Color3.fromRGB(51, 65, 85)
   }
}

-- Save/Load Configuration
function UILibrary:SaveConfig(window, filename)
   local config = {}
   
   -- Save all element values
   for _, tab in ipairs(window.Tabs) do
       config[tab.Name] = {}
       
       for _, element in ipairs(tab.Elements) do
           if element.Flag and element.Flag ~= "" then
               if element.CurrentValue ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentValue
               elseif element.CurrentOption ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentOption
               elseif element.CurrentKeybind ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentKeybind
               elseif element.CurrentColor ~= nil then
                   config[tab.Name][element.Flag] = {
                       R = element.CurrentColor.R,
                       G = element.CurrentColor.G,
                       B = element.CurrentColor.B
                   }
               elseif element.SelectedOptions ~= nil then
                   local selected = {}
                   for option, isSelected in pairs(element.SelectedOptions) do
                       if isSelected then
                           table.insert(selected, option)
                       end
                   end
                   config[tab.Name][element.Flag] = selected
               end
           end
       end
   end
   
   -- Convert to JSON and save
   local success, result = pcall(function()
       return game:GetService("HttpService"):JSONEncode(config)
   end)
   
   if success then
       writefile(filename .. ".json", result)
       return true
   else
       warn("Failed to save config:", result)
       return false
   end
end

function UILibrary:LoadConfig(window, filename)
   if not isfile(filename .. ".json") then
       return false
   end
   
   local success, config = pcall(function()
       local content = readfile(filename .. ".json")
       return game:GetService("HttpService"):JSONDecode(content)
   end)
   
   if not success then
       warn("Failed to load config:", config)
       return false
   end
   
   -- Apply loaded values
   for _, tab in ipairs(window.Tabs) do
       if config[tab.Name] then
           for _, element in ipairs(tab.Elements) do
               if element.Flag and element.Flag ~= "" and config[tab.Name][element.Flag] ~= nil then
                   local value = config[tab.Name][element.Flag]
                   
                   if element.Toggle then
                       element.CurrentValue = value
                       element.Toggle()
                   elseif element.SetValue then
                       element.SetValue(value)
                   elseif element.SetKeybind then
                       element.SetKeybind(value)
                   elseif type(value) == "table" and value.R and value.G and value.B then
                       element.CurrentColor = Color3.new(value.R, value.G, value.B)
                       element.Preview.BackgroundColor3 = element.CurrentColor
                       element.Callback(element.CurrentColor)
                   elseif element.SelectedOptions then
                       -- Multi-select dropdown
                       element.SelectedOptions = {}
                       for _, option in ipairs(value) do
                           element.SelectedOptions[option] = true
                       end
                       element.UpdateSelectedText()
                       element.Callback(value)
                   end
               end
           end
       end
   end
   
   return true
end

-- Animation Presets
UILibrary.Animations = {
   Bounce = {
       Style = Enum.EasingStyle.Back,
       Direction = Enum.EasingDirection.Out,
       Time = 0.5
   },
   Elastic = {
       Style = Enum.EasingStyle.Elastic,
       Direction = Enum.EasingDirection.Out,
       Time = 0.8
   },
   Smooth = {
       Style = Enum.EasingStyle.Quad,
       Direction = Enum.EasingDirection.InOut,
       Time = 0.3
   },
   Sharp = {
       Style = Enum.EasingStyle.Quint,
       Direction = Enum.EasingDirection.Out,
       Time = 0.2
   }
}

-- ================================
-- ASTDX Custom UI Library - Part 7
-- Advanced Features & Optimizations
-- ================================

-- Notification Queue System
UILibrary.NotificationQueue = {
   Notifications = {},
   MaxNotifications = 5,
   NotificationSpacing = 10,
   BasePosition = UDim2.new(1, -320, 0, 20)
}

function UILibrary:QueueNotification(config)
   config = config or {}
   
   local NotificationData = {
       Title = config.Title or "Notification",
       Content = config.Content or "This is a notification",
       Duration = config.Duration or 5,
       Type = config.Type or "Info", -- Info, Success, Warning, Error
       Sound = config.Sound or nil
   }
   
   -- Get notification color based on type
   local notificationColor = Colors.Accent
   if NotificationData.Type == "Success" then
       notificationColor = Colors.Success
   elseif NotificationData.Type == "Warning" then
       notificationColor = Colors.Warning
   elseif NotificationData.Type == "Error" then
       notificationColor = Colors.Error
   end
   
   -- Create notification GUI
   local NotificationGui = Instance.new("ScreenGui")
   NotificationGui.Name = "QueuedNotification"
   NotificationGui.Parent = CoreGui
   NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   
   -- Notification Frame
   local NotificationFrame = Instance.new("Frame")
   NotificationFrame.Name = "NotificationFrame"
   NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
   NotificationFrame.Position = UDim2.new(1, 0, 0, 20) -- Start off-screen
   NotificationFrame.BackgroundColor3 = Colors.Card
   NotificationFrame.BorderSizePixel = 0
   NotificationFrame.Parent = NotificationGui
   
   CreateCorner(NotificationFrame, 8)
   CreateStroke(NotificationFrame, notificationColor, 2)
   
   -- Type Indicator
   local TypeIndicator = Instance.new("Frame")
   TypeIndicator.Name = "TypeIndicator"
   TypeIndicator.Size = UDim2.new(0, 4, 1, 0)
   TypeIndicator.Position = UDim2.new(0, 0, 0, 0)
   TypeIndicator.BackgroundColor3 = notificationColor
   TypeIndicator.BorderSizePixel = 0
   TypeIndicator.Parent = NotificationFrame
   
   local IndicatorCorner = Instance.new("UICorner")
   IndicatorCorner.CornerRadius = UDim.new(0, 8)
   IndicatorCorner.Parent = TypeIndicator
   
   -- Notification Icon
   local NotificationIcon = Instance.new("TextLabel")
   NotificationIcon.Name = "Icon"
   NotificationIcon.Size = UDim2.new(0, 30, 0, 30)
   NotificationIcon.Position = UDim2.new(0, 15, 0, 10)
   NotificationIcon.BackgroundTransparency = 1
   NotificationIcon.Text = NotificationData.Type == "Success" and "✓" or 
                         NotificationData.Type == "Warning" and "⚠" or 
                         NotificationData.Type == "Error" and "✕" or "ℹ"
   NotificationIcon.TextColor3 = notificationColor
   NotificationIcon.TextSize = 18
   NotificationIcon.Font = Enum.Font.GothamBold
   NotificationIcon.Parent = NotificationFrame
   
   -- Notification Title
   local NotificationTitle = Instance.new("TextLabel")
   NotificationTitle.Name = "Title"
   NotificationTitle.Size = UDim2.new(1, -70, 0, 25)
   NotificationTitle.Position = UDim2.new(0, 50, 0, 5)
   NotificationTitle.BackgroundTransparency = 1
   NotificationTitle.Text = NotificationData.Title
   NotificationTitle.TextColor3 = Colors.Text
   NotificationTitle.TextSize = 13
   NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
   NotificationTitle.Font = Enum.Font.GothamBold
   NotificationTitle.Parent = NotificationFrame
   
   -- Notification Content
   local NotificationContent = Instance.new("TextLabel")
   NotificationContent.Name = "Content"
   NotificationContent.Size = UDim2.new(1, -60, 0, 40)
   NotificationContent.Position = UDim2.new(0, 50, 0, 25)
   NotificationContent.BackgroundTransparency = 1
   NotificationContent.Text = NotificationData.Content
   NotificationContent.TextColor3 = Colors.TextSecondary
   NotificationContent.TextSize = 11
   NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
   NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
   NotificationContent.TextWrapped = true
   NotificationContent.Font = Enum.Font.Gotham
   NotificationContent.Parent = NotificationFrame
   
   -- Progress Bar
   local ProgressBar = Instance.new("Frame")
   ProgressBar.Name = "ProgressBar"
   ProgressBar.Size = UDim2.new(1, 0, 0, 2)
   ProgressBar.Position = UDim2.new(0, 0, 1, -2)
   ProgressBar.BackgroundColor3 = notificationColor
   ProgressBar.BorderSizePixel = 0
   ProgressBar.Parent = NotificationFrame
   
   -- Close Button
   local CloseButton = Instance.new("TextButton")
   CloseButton.Name = "CloseButton"
   CloseButton.Size = UDim2.new(0, 20, 0, 20)
   CloseButton.Position = UDim2.new(1, -25, 0, 5)
   CloseButton.BackgroundTransparency = 1
   CloseButton.Text = "✕"
   CloseButton.TextColor3 = Colors.TextMuted
   CloseButton.TextSize = 12
   CloseButton.Font = Enum.Font.GothamBold
   CloseButton.Parent = NotificationFrame
   
   -- Add to queue
   table.insert(UILibrary.NotificationQueue.Notifications, {
       Gui = NotificationGui,
       Frame = NotificationFrame,
       Data = NotificationData
   })
   
   -- Remove old notifications if exceeding max
   if #UILibrary.NotificationQueue.Notifications > UILibrary.NotificationQueue.MaxNotifications then
       local oldNotif = table.remove(UILibrary.NotificationQueue.Notifications, 1)
       oldNotif.Gui:Destroy()
       UILibrary:UpdateNotificationPositions()
   end
   
   -- Update all notification positions
   UILibrary:UpdateNotificationPositions()
   
   -- Play sound if specified
   if NotificationData.Sound then
       local sound = Instance.new("Sound")
       sound.SoundId = NotificationData.Sound
       sound.Volume = 0.5
       sound.Parent = workspace
       sound:Play()
       sound.Ended:Connect(function()
           sound:Destroy()
       end)
   end
   
   -- Progress animation
   local progressTween = CreateTween(ProgressBar, {
       Size = UDim2.new(0, 0, 0, 2)
   }, NotificationData.Duration, Enum.EasingStyle.Linear)
   progressTween:Play()
   
   -- Auto dismiss
   task.wait(NotificationData.Duration)
   
   -- Find and remove from queue
   for i, notif in ipairs(UILibrary.NotificationQueue.Notifications) do
       if notif.Gui == NotificationGui then
           table.remove(UILibrary.NotificationQueue.Notifications, i)
           break
       end
   end
   
   -- Slide out animation
   local slideOutTween = CreateTween(NotificationFrame, {
       Position = UDim2.new(1, 0, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
   }, 0.5)
   slideOutTween:Play()
   
   slideOutTween.Completed:Connect(function()
       NotificationGui:Destroy()
       UILibrary:UpdateNotificationPositions()
   end)
   
   -- Close button handler
   CloseButton.MouseButton1Click:Connect(function()
       for i, notif in ipairs(UILibrary.NotificationQueue.Notifications) do
           if notif.Gui == NotificationGui then
               table.remove(UILibrary.NotificationQueue.Notifications, i)
               break
           end
       end
       
       local closeTween = CreateTween(NotificationFrame, {
           Position = UDim2.new(1, 0, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset),
           BackgroundTransparency = 1
       }, 0.3)
       closeTween:Play()
       
       closeTween.Completed:Connect(function()
           NotificationGui:Destroy()
           UILibrary:UpdateNotificationPositions()
       end)
   end)
   
   -- Close button hover
   CloseButton.MouseEnter:Connect(function()
       CreateTween(CloseButton, {TextColor3 = Colors.Text}, 0.15):Play()
   end)
   
   CloseButton.MouseLeave:Connect(function()
       CreateTween(CloseButton, {TextColor3 = Colors.TextMuted}, 0.15):Play()
   end)
   
   return NotificationData
end

function UILibrary:UpdateNotificationPositions()
   for i, notif in ipairs(self.NotificationQueue.Notifications) do
       local targetY = self.NotificationQueue.BasePosition.Y.Offset + 
                      ((i - 1) * (80 + self.NotificationQueue.NotificationSpacing))
       
       local positionTween = CreateTween(notif.Frame, {
           Position = UDim2.new(
               self.NotificationQueue.BasePosition.X.Scale,
               self.NotificationQueue.BasePosition.X.Offset,
               0,
               targetY
           )
       }, 0.3)
       positionTween:Play()
   end
end

-- Tab Groups/Categories
function UILibrary:CreateTabGroup(window, config)
   config = config or {}
   
   local TabGroupData = {
       Name = config.Name or "Group",
       Icon = config.Icon or "📁",
       Expanded = config.Expanded ~= false,
       Tabs = {},
       Window = window
   }
   
   -- Tab Group Button
   local TabGroupButton = Instance.new("Frame")
   TabGroupButton.Name = "TabGroup_" .. TabGroupData.Name
   TabGroupButton.Size = UDim2.new(1, 0, 0, 35)
   TabGroupButton.BackgroundColor3 = Colors.Secondary
   TabGroupButton.BorderSizePixel = 0
   TabGroupButton.Parent = window.TabList
   
   CreateCorner(TabGroupButton, 6)
   
   -- Group Icon
   local GroupIcon = Instance.new("TextLabel")
   GroupIcon.Name = "Icon"
   GroupIcon.Size = UDim2.new(0, 20, 0, 20)
   GroupIcon.Position = UDim2.new(0, 8, 0.5, -10)
   GroupIcon.BackgroundTransparency = 1
   GroupIcon.Text = TabGroupData.Icon
   GroupIcon.TextColor3 = Colors.Text
   GroupIcon.TextSize = 14
   GroupIcon.Font = Enum.Font.Gotham
   GroupIcon.Parent = TabGroupButton
   
   -- Group Label
   local GroupLabel = Instance.new("TextLabel")
   GroupLabel.Name = "Label"
   GroupLabel.Size = UDim2.new(1, -60, 1, 0)
   GroupLabel.Position = UDim2.new(0, 30, 0, 0)
   GroupLabel.BackgroundTransparency = 1
   GroupLabel.Text = TabGroupData.Name
   GroupLabel.TextColor3 = Colors.Text
   GroupLabel.TextSize = 12
   GroupLabel.TextXAlignment = Enum.TextXAlignment.Left
   GroupLabel.Font = Enum.Font.GothamBold
   GroupLabel.Parent = TabGroupButton
   
   -- Expand/Collapse Arrow
   local GroupArrow = Instance.new("TextLabel")
   GroupArrow.Name = "Arrow"
   GroupArrow.Size = UDim2.new(0, 20, 1, 0)
   GroupArrow.Position = UDim2.new(1, -25, 0, 0)
   GroupArrow.BackgroundTransparency = 1
   GroupArrow.Text = TabGroupData.Expanded and "▼" or "▶"
   GroupArrow.TextColor3 = Colors.TextSecondary
   GroupArrow.TextSize = 10
   GroupArrow.Font = Enum.Font.Gotham
   GroupArrow.Parent = TabGroupButton
   
   -- Group Container
   local GroupContainer = Instance.new("Frame")
   GroupContainer.Name = "Container"
   GroupContainer.Size = UDim2.new(1, -10, 0, 0)
   GroupContainer.Position = UDim2.new(0, 10, 1, 5)
   GroupContainer.BackgroundTransparency = 1
   GroupContainer.Visible = TabGroupData.Expanded
   GroupContainer.Parent = TabGroupButton
   
   local GroupLayout = Instance.new("UIListLayout")
   GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
   GroupLayout.Padding = UDim.new(0, 5)
   GroupLayout.Parent = GroupContainer
   
   -- Toggle Button
   local ToggleButton = Instance.new("TextButton")
   ToggleButton.Name = "ToggleButton"
   ToggleButton.Size = UDim2.new(1, 0, 0, 35)
   ToggleButton.BackgroundTransparency = 1
   ToggleButton.Text = ""
   ToggleButton.Parent = TabGroupButton
   
   -- Toggle function
   local function ToggleGroup()
       TabGroupData.Expanded = not TabGroupData.Expanded
       
       if TabGroupData.Expanded then
           GroupContainer.Visible = true
           GroupArrow.Text = "▼"
           
           local expandTween = CreateTween(TabGroupButton, {
               Size = UDim2.new(1, 0, 0, 35 + (#TabGroupData.Tabs * 45))
           }, 0.3)
           expandTween:Play()
           
           -- Fade in tabs
           for _, tabButton in ipairs(GroupContainer:GetChildren()) do
               if tabButton:IsA("TextButton") then
                   tabButton.BackgroundTransparency = 1
                   CreateTween(tabButton, {BackgroundTransparency = 0}, 0.2):Play()
               end
           end
       else
           GroupArrow.Text = "▶"
           
           local collapseTween = CreateTween(TabGroupButton, {
               Size = UDim2.new(1, 0, 0, 35)
           }, 0.3)
           collapseTween:Play()
           
           collapseTween.Completed:Connect(function()
               GroupContainer.Visible = false
           end)
       end
       
       -- Update tab list canvas
       window.TabList.CanvasSize = UDim2.new(0, 0, 0, window.TabList.UIListLayout.AbsoluteContentSize.Y)
   end
   
   -- Click handler
   ToggleButton.MouseButton1Click:Connect(ToggleGroup)
   
   -- Hover effects
   ToggleButton.MouseEnter:Connect(function()
       CreateTween(TabGroupButton, {BackgroundColor3 = Colors.Hover}, 0.15):Play()
   end)
   
   ToggleButton.MouseLeave:Connect(function()
       CreateTween(TabGroupButton, {BackgroundColor3 = Colors.Secondary}, 0.15):Play()
   end)
   
   -- Add tab to group function
   function TabGroupData:AddTab(tabData)
       table.insert(self.Tabs, tabData)
       tabData.Button.Parent = GroupContainer
       
       -- Update group size if expanded
       if self.Expanded then
           TabGroupButton.Size = UDim2.new(1, 0, 0, 35 + (#self.Tabs * 45))
       end
       
       -- Update canvas size
       window.TabList.CanvasSize = UDim2.new(0, 0, 0, window.TabList.UIListLayout.AbsoluteContentSize.Y)
   end
   
   -- Store references
   TabGroupData.Button = TabGroupButton
   TabGroupData.Container = GroupContainer
   TabGroupData.ToggleGroup = ToggleGroup
   
   return TabGroupData
end

-- Element Animations
UILibrary.ElementAnimations = {
   FadeIn = function(element, duration)
       duration = duration or 0.3
       element.BackgroundTransparency = 1
       
       if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
           element.TextTransparency = 1
       end
       
       CreateTween(element, {BackgroundTransparency = 0}, duration):Play()
       
       if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
           CreateTween(element, {TextTransparency = 0}, duration):Play()
       end
   end,
   
   FadeOut = function(element, duration)
       duration = duration or 0.3
       
       CreateTween(element, {BackgroundTransparency = 1}, duration):Play()
       
       if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
           CreateTween(element, {TextTransparency = 1}, duration):Play()
       end
   end,
   
   SlideIn = function(element, direction, duration)
       duration = duration or 0.5
       direction = direction or "Left"
       
       local originalPosition = element.Position
       local startPosition
       
       if direction == "Left" then
           startPosition = UDim2.new(-1, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
       elseif direction == "Right" then
           startPosition = UDim2.new(2, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
       elseif direction == "Top" then
           startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, -1, 0)
       elseif direction == "Bottom" then
           startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 2, 0)
       end
       
       element.Position = startPosition
       
       CreateTween(element, {Position = originalPosition}, duration, Enum.EasingStyle.Quint):Play()
   end,
   
   SlideOut = function(element, direction, duration)
       duration = duration or 0.5
       direction = direction or "Left"
       
       local targetPosition
       
       if direction == "Left" then
           targetPosition = UDim2.new(-1, 0, element.Position.Y.Scale, element.Position.Y.Offset)
       elseif direction == "Right" then
           targetPosition = UDim2.new(2, 0, element.Position.Y.Scale, element.Position.Y.Offset)
       elseif direction == "Top" then
           targetPosition = UDim2.new(element.Position.X.Scale, element.Position.X.Offset, -1, 0)
       elseif direction == "Bottom" then
           targetPosition = UDim2.new(element.Position.X.Scale, element.Position.X.Offset, 2, 0)
       end
       
       CreateTween(element, {Position = targetPosition}, duration, Enum.EasingStyle.Quint):Play()
   end,
   
   Bounce = function(element, intensity, duration)
       intensity = intensity or 1.2
       duration = duration or 0.5
       
       local originalSize = element.Size
       local bounceSize = UDim2.new(
           originalSize.X.Scale * intensity,
           originalSize.X.Offset * intensity,
           originalSize.Y.Scale * intensity,
           originalSize.Y.Offset * intensity
       )
       
       local bounceTween = CreateTween(element, {Size = bounceSize}, duration/2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
       bounceTween:Play()
       
       bounceTween.Completed:Connect(function()
           CreateTween(element, {Size = originalSize}, duration/2, Enum.EasingStyle.Bounce):Play()
       end)
   end,
   
   Shake = function(element, intensity, duration)
       intensity = intensity or 5
       duration = duration or 0.5
       
       local originalPosition = element.Position
       local shakeCount = 10
       local shakeDelay = duration / shakeCount
       
       task.spawn(function()
           for i = 1, shakeCount do
               local offsetX = math.random(-intensity, intensity)
               local offsetY = math.random(-intensity, intensity)
               
               element.Position = UDim2.new(
                   originalPosition.X.Scale,
                   originalPosition.X.Offset + offsetX,
                   originalPosition.Y.Scale,
                   originalPosition.Y.Offset + offsetY
               )
               
               task.wait(shakeDelay)
           end
           
           element.Position = originalPosition
       end)
   end,
   
   Pulse = function(element, scale, duration, count)
       scale = scale or 1.1
       duration = duration or 0.5
       count = count or 1
       
       local originalSize = element.Size
       local pulseSize = UDim2.new(
           originalSize.X.Scale * scale,
           originalSize.X.Offset * scale,
           originalSize.Y.Scale * scale,
           originalSize.Y.Offset * scale
       )
       
       for i = 1, count do
           local expandTween = CreateTween(element, {Size = pulseSize}, duration/2)
           expandTween:Play()
           expandTween.Completed:Wait()
           
           local contractTween = CreateTween(element, {Size = originalSize}, duration/2)
           contractTween:Play()
           contractTween.Completed:Wait()
       end
   end
}

-- Responsive Design System
UILibrary.ResponsiveSystem = {
   Breakpoints = {
       Mobile = 600,
       Tablet = 900,
       Desktop = 1200
   },
   
   CurrentDevice = "Desktop",
   Elements = {}
}

function UILibrary:MakeResponsive(window)
   local viewport = workspace.CurrentCamera.ViewportSize
   
   -- Determine device type
   local function GetDeviceType()
       if viewport.X <= UILibrary.ResponsiveSystem.Breakpoints.Mobile then
           return "Mobile"
       elseif viewport.X <= UILibrary.ResponsiveSystem.Breakpoints.Tablet then
           return "Tablet"
       else
           return "Desktop"
       end
   end
   
   -- Update window size based on device
   local function UpdateWindowSize()
       local deviceType = GetDeviceType()
       UILibrary.ResponsiveSystem.CurrentDevice = deviceType
       
       local newSize
       local newPosition
       
       if deviceType == "Mobile" then
           newSize = UDim2.new(0.95, 0, 0.9, 0)
           newPosition = UDim2.new(0.025, 0, 0.05, 0)
           window.TabContainer.Size = UDim2.new(0, 0, 1, -45) -- Hide tab sidebar
           window.ContentContainer.Size = UDim2.new(1, 0, 1, -45)
           window.ContentContainer.Position = UDim2.new(0, 0, 0, 45)
       elseif deviceType == "Tablet" then
           newSize = UDim2.new(0.8, 0, 0.8, 0)
           newPosition = UDim2.new(0.1, 0, 0.1, 0)
           window.TabContainer.Size = UDim2.new(0, 120, 1, -45)
           window.ContentContainer.Size = UDim2.new(1, -120, 1, -45)
           window.ContentContainer.Position = UDim2.new(0, 120, 0, 45)
       else
           newSize = window.Size or UDim2.new(0, 580, 0, 420)
           newPosition = window.Position or UDim2.new(0.5, -290, 0.5, -210)
           window.TabContainer.Size = UDim2.new(0, 150, 1, -45)
           window.ContentContainer.Size = UDim2.new(1, -150, 1, -45)
           window.ContentContainer.Position = UDim2.new(0, 150, 0, 45)
       end
       
       CreateTween(window.MainFrame, {
           Size = newSize,
           Position = newPosition
       }, 0.5):Play()
       
       -- Update font sizes
       local function UpdateFontSizes(parent)
           for _, child in ipairs(parent:GetDescendants()) do
               if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                   local originalSize = child:GetAttribute("OriginalTextSize") or child.TextSize
                   child:SetAttribute("OriginalTextSize", originalSize)
                   
                   if deviceType == "Mobile" then
                       child.TextSize = math.max(originalSize - 2, 10)
                   elseif deviceType == "Tablet" then
                       child.TextSize = math.max(originalSize - 1, 11)
                   else
                       child.TextSize = originalSize
                   end
               end
           end
       end
       
       UpdateFontSizes(window.ScreenGui)
       
       -- Mobile-specific tab handling
       if deviceType == "Mobile" then
           -- Create mobile tab selector
           if not window.MobileTabSelector then
               local MobileTabSelector = Instance.new("Frame")
               MobileTabSelector.Name = "MobileTabSelector"
               MobileTabSelector.Size = UDim2.new(1, 0, 0, 40)
               MobileTabSelector.Position = UDim2.new(0, 0, 0, 45)
               MobileTabSelector.BackgroundColor3 = Colors.Secondary
               MobileTabSelector.BorderSizePixel = 0
               MobileTabSelector.Parent = window.MainFrame
               
               local SelectorButton = Instance.new("TextButton")
               SelectorButton.Size = UDim2.new(1, -20, 1, 0)
               SelectorButton.Position = UDim2.new(0, 10, 0, 0)
               SelectorButton.BackgroundTransparency = 1
               SelectorButton.Text = window.CurrentTab and window.CurrentTab.Name or "Select Tab"
               SelectorButton.TextColor3 = Colors.Text
               SelectorButton.TextSize = 12
               SelectorButton.Font = Enum.Font.Gotham
               SelectorButton.Parent = MobileTabSelector
               
               local SelectorArrow = Instance.new("TextLabel")
               SelectorArrow.Size = UDim2.new(0, 20, 1, 0)
               SelectorArrow.Position = UDim2.new(1, -25, 0, 0)
               SelectorArrow.BackgroundTransparency = 1
               SelectorArrow.Text = "▼"
               SelectorArrow.TextColor3 = Colors.TextSecondary
               SelectorArrow.TextSize = 10
               SelectorArrow.Font = Enum.Font.Gotham
               SelectorArrow.Parent = MobileTabSelector
               
               window.MobileTabSelector = MobileTabSelector
               window.ContentContainer.Position = UDim2.new(0, 0, 0, 85)
               window.ContentContainer.Size = UDim2.new(1, 0, 1, -85)
           end
           
           window.MobileTabSelector.Visible = true
       else
           if window.MobileTabSelector then
               window.MobileTabSelector.Visible = false
           end
       end
   end
   
   -- Initial update
   UpdateWindowSize()
   
   -- Listen for viewport changes
   workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
       viewport = workspace.CurrentCamera.ViewportSize
       UpdateWindowSize()
   end)
   
   -- Store reference
   UILibrary.ResponsiveSystem.Elements[window] = {
       Update = UpdateWindowSize,
       GetDevice = GetDeviceType
   }
   
   return {
       Update = UpdateWindowSize,
       GetDevice = GetDeviceType
   }
end

-- Helper function to apply animations to elements
function UILibrary:AnimateElement(element, animationType, ...)
   if UILibrary.ElementAnimations[animationType] then
       UILibrary.ElementAnimations[animationType](element, ...)
   end
end

-- Enhanced window creation with responsive support
local OriginalCreateWindow = UILibrary.CreateWindow
function UILibrary:CreateWindow(config)
   local window = OriginalCreateWindow(self, config)
   
   -- Add responsive support by default
   if config.Responsive ~= false then
       self:MakeResponsive(window)
   end
   
   -- Apply initial animations
   if config.AnimateOnOpen ~= false then
       self:AnimateElement(window.MainFrame, "FadeIn", 0.5)
       self:AnimateElement(window.MainFrame, "SlideIn", "Top", 0.5)
   end
   
   -- Add close all notifications function
   window.ClearNotifications = function()
       for _, notif in ipairs(UILibrary.NotificationQueue.Notifications) do
           notif.Gui:Destroy()
       end
       UILibrary.NotificationQueue.Notifications = {}
   end
   
   return window
end

-- ================================
-- ASTDX Custom UI Library - Part 8
-- Webhook Integration
-- ================================

-- Webhook System
UILibrary.WebhookSystem = {
   DefaultWebhook = nil,
   RateLimits = {},
   Queue = {}
}

-- Webhook Creation Function
function UILibrary:SetWebhook(webhookUrl)
   UILibrary.WebhookSystem.DefaultWebhook = webhookUrl
end

-- Send Webhook Function
function UILibrary:SendWebhook(config)
   config = config or {}
   
   local webhookUrl = config.Url or UILibrary.WebhookSystem.DefaultWebhook
   if not webhookUrl then
       warn("No webhook URL provided")
       return false
   end
   
   -- Rate limiting check
   local currentTime = tick()
   if UILibrary.WebhookSystem.RateLimits[webhookUrl] then
       local lastSent = UILibrary.WebhookSystem.RateLimits[webhookUrl]
       if currentTime - lastSent < 2 then -- 2 second rate limit
           table.insert(UILibrary.WebhookSystem.Queue, {
               Config = config,
               Time = currentTime + 2
           })
           return false
       end
   end
   
   UILibrary.WebhookSystem.RateLimits[webhookUrl] = currentTime
   
   -- Build embed
   local embed = {
       title = config.Title or "ASTDX UI Notification",
       description = config.Description or "",
       color = config.Color or 5814783, -- Default purple color
       fields = config.Fields or {},
       footer = {
           text = config.Footer or "ASTDX UI Library",
           icon_url = config.FooterIcon or ""
       },
       timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
       thumbnail = config.Thumbnail and {url = config.Thumbnail} or nil,
       image = config.Image and {url = config.Image} or nil,
       author = config.Author or nil
   }
   
   -- Webhook data
   local webhookData = {
       username = config.Username or "ASTDX Hub",
       avatar_url = config.Avatar or "",
       content = config.Content or "",
       embeds = {embed}
   }
   
   -- Send request
   local success, response = pcall(function()
       return request({
           Url = webhookUrl,
           Method = "POST",
           Headers = {
               ["Content-Type"] = "application/json"
           },
           Body = game:GetService("HttpService"):JSONEncode(webhookData)
       })
   end)
   
   if success then
       return true
   else
       warn("Failed to send webhook:", response)
       return false
   end
end

-- Process webhook queue
task.spawn(function()
   while true do
       task.wait(1)
       local currentTime = tick()
       
       for i = #UILibrary.WebhookSystem.Queue, 1, -1 do
           local item = UILibrary.WebhookSystem.Queue[i]
           if currentTime >= item.Time then
               UILibrary:SendWebhook(item.Config)
               table.remove(UILibrary.WebhookSystem.Queue, i)
           end
       end
   end
end)

-- Webhook Logger Creation (UI Element)
function UILibrary:CreateWebhookLogger(tab, config)
   config = config or {}
   
   local WebhookLoggerData = {
       Name = config.Name or "Webhook Logger",
       WebhookUrl = config.WebhookUrl or "",
       Events = config.Events or {
           OnToggle = true,
           OnSliderChange = true,
           OnDropdownChange = true,
           OnButtonClick = true
       },
       Tab = tab,
       Enabled = false
   }
   
   -- Webhook Logger Frame
   local WebhookFrame = Instance.new("Frame")
   WebhookFrame.Name = "WebhookLogger_" .. WebhookLoggerData.Name
   WebhookFrame.Size = UDim2.new(1, 0, 0, 120)
   WebhookFrame.BackgroundColor3 = Colors.Card
   WebhookFrame.BorderSizePixel = 0
   WebhookFrame.Parent = tab.Content
   
   CreateCorner(WebhookFrame, 6)
   CreateStroke(WebhookFrame, Colors.Border, 1)
   
   -- Title
   local WebhookTitle = Instance.new("TextLabel")
   WebhookTitle.Name = "Title"
   WebhookTitle.Size = UDim2.new(1, -20, 0, 25)
   WebhookTitle.Position = UDim2.new(0, 10, 0, 5)
   WebhookTitle.BackgroundTransparency = 1
   WebhookTitle.Text = WebhookLoggerData.Name
   WebhookTitle.TextColor3 = Colors.Text
   WebhookTitle.TextSize = 13
   WebhookTitle.TextXAlignment = Enum.TextXAlignment.Left
   WebhookTitle.Font = Enum.Font.GothamBold
   WebhookTitle.Parent = WebhookFrame
   
   -- Status Indicator
   local StatusIndicator = Instance.new("Frame")
   StatusIndicator.Name = "Status"
   StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
   StatusIndicator.Position = UDim2.new(1, -20, 0, 12)
   StatusIndicator.BackgroundColor3 = Colors.Error
   StatusIndicator.BorderSizePixel = 0
   StatusIndicator.Parent = WebhookFrame
   
   CreateCorner(StatusIndicator, 4)
   
   -- Webhook URL Input
   local WebhookInput = Instance.new("TextBox")
   WebhookInput.Name = "WebhookInput"
   WebhookInput.Size = UDim2.new(1, -20, 0, 25)
   WebhookInput.Position = UDim2.new(0, 10, 0, 35)
   WebhookInput.BackgroundColor3 = Colors.Secondary
   WebhookInput.BorderSizePixel = 0
   WebhookInput.Text = WebhookLoggerData.WebhookUrl
   WebhookInput.PlaceholderText = "Enter Discord Webhook URL..."
   WebhookInput.TextColor3 = Colors.Text
   WebhookInput.PlaceholderColor3 = Colors.TextMuted
   WebhookInput.TextSize = 11
   WebhookInput.TextXAlignment = Enum.TextXAlignment.Left
   WebhookInput.Font = Enum.Font.Gotham
   WebhookInput.ClearTextOnFocus = false
   WebhookInput.Parent = WebhookFrame
   
   CreateCorner(WebhookInput, 4)
   CreateStroke(WebhookInput, Colors.Border, 1)
   
   local InputPadding = Instance.new("UIPadding")
   InputPadding.PaddingLeft = UDim.new(0, 8)
   InputPadding.PaddingRight = UDim.new(0, 8)
   InputPadding.Parent = WebhookInput
   
   -- Toggle Button
   local ToggleButton = Instance.new("TextButton")
   ToggleButton.Name = "ToggleButton"
   ToggleButton.Size = UDim2.new(0, 100, 0, 25)
   ToggleButton.Position = UDim2.new(0, 10, 0, 70)
   ToggleButton.BackgroundColor3 = Colors.Error
   ToggleButton.BorderSizePixel = 0
   ToggleButton.Text = "Disabled"
   ToggleButton.TextColor3 = Colors.Text
   ToggleButton.TextSize = 11
   ToggleButton.Font = Enum.Font.GothamBold
   ToggleButton.Parent = WebhookFrame
   
   CreateCorner(ToggleButton, 4)
   
   -- Test Button
   local TestButton = Instance.new("TextButton")
   TestButton.Name = "TestButton"
   TestButton.Size = UDim2.new(0, 80, 0, 25)
   TestButton.Position = UDim2.new(0, 120, 0, 70)
   TestButton.BackgroundColor3 = Colors.Secondary
   TestButton.BorderSizePixel = 0
   TestButton.Text = "Test"
   TestButton.TextColor3 = Colors.Text
   TestButton.TextSize = 11
   TestButton.Font = Enum.Font.GothamBold
   TestButton.Parent = WebhookFrame
   
   CreateCorner(TestButton, 4)
   
   -- Event Count Label
   local EventCountLabel = Instance.new("TextLabel")
   EventCountLabel.Name = "EventCount"
   EventCountLabel.Size = UDim2.new(1, -220, 0, 25)
   EventCountLabel.Position = UDim2.new(0, 210, 0, 70)
   EventCountLabel.BackgroundTransparency = 1
   EventCountLabel.Text = "Events Sent: 0"
   EventCountLabel.TextColor3 = Colors.TextSecondary
   EventCountLabel.TextSize = 10
   EventCountLabel.TextXAlignment = Enum.TextXAlignment.Right
   EventCountLabel.Font = Enum.Font.Gotham
   EventCountLabel.Parent = WebhookFrame
   
   -- Event Settings
   local EventSettings = Instance.new("Frame")
   EventSettings.Name = "EventSettings"
   EventSettings.Size = UDim2.new(1, -20, 0, 15)
   EventSettings.Position = UDim2.new(0, 10, 0, 100)
   EventSettings.BackgroundTransparency = 1
   EventSettings.Parent = WebhookFrame
   
   local EventsLabel = Instance.new("TextLabel")
   EventsLabel.Size = UDim2.new(1, 0, 1, 0)
   EventsLabel.BackgroundTransparency = 1
   EventsLabel.Text = "Logging: Toggle, Slider, Dropdown, Button"
   EventsLabel.TextColor3 = Colors.TextMuted
   EventsLabel.TextSize = 9
   EventsLabel.TextXAlignment = Enum.TextXAlignment.Left
   EventsLabel.Font = Enum.Font.Gotham
   EventsLabel.Parent = EventSettings
   
   local eventCount = 0
   
   -- Update webhook URL
   WebhookInput.FocusLost:Connect(function()
       WebhookLoggerData.WebhookUrl = WebhookInput.Text
   end)
   
   -- Toggle functionality
   local function ToggleLogger()
       WebhookLoggerData.Enabled = not WebhookLoggerData.Enabled
       
       if WebhookLoggerData.Enabled and WebhookLoggerData.WebhookUrl ~= "" then
           ToggleButton.BackgroundColor3 = Colors.Success
           ToggleButton.Text = "Enabled"
           StatusIndicator.BackgroundColor3 = Colors.Success
           
           -- Send enable notification
           UILibrary:SendWebhook({
               Url = WebhookLoggerData.WebhookUrl,
               Title = "Webhook Logger Enabled",
               Description = "The webhook logger has been enabled for this session.",
               Color = 4437377, -- Green
               Fields = {
                   {
                       name = "Game",
                       value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                       inline = true
                   },
                   {
                       name = "Player",
                       value = Players.LocalPlayer.Name,
                       inline = true
                   }
               }
           })
       else
           ToggleButton.BackgroundColor3 = Colors.Error
           ToggleButton.Text = "Disabled"
           StatusIndicator.BackgroundColor3 = Colors.Error
       end
   end
   
   ToggleButton.MouseButton1Click:Connect(ToggleLogger)
   
   -- Test webhook
   TestButton.MouseButton1Click:Connect(function()
       if WebhookLoggerData.WebhookUrl == "" then
           UILibrary:QueueNotification({
               Title = "Webhook Error",
               Content = "Please enter a webhook URL first",
               Type = "Error",
               Duration = 3
           })
           return
       end
       
       local success = UILibrary:SendWebhook({
           Url = WebhookLoggerData.WebhookUrl,
           Title = "Test Webhook",
           Description = "This is a test message from ASTDX UI Library",
           Color = 5814783,
           Fields = {
               {
                   name = "Status",
                   value = "✅ Working",
                   inline = true
               },
               {
                   name = "Time",
                   value = os.date("%X"),
                   inline = true
               }
           }
       })
       
       if success then
           UILibrary:QueueNotification({
               Title = "Webhook Test",
               Content = "Test message sent successfully!",
               Type = "Success",
               Duration = 3
           })
       else
           UILibrary:QueueNotification({
               Title = "Webhook Error",
               Content = "Failed to send test message",
               Type = "Error",
               Duration = 3
           })
       end
   end)
   
   -- Button hover effects
   ToggleButton.MouseEnter:Connect(function()
       if not WebhookLoggerData.Enabled then
           CreateTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.15):Play()
       else
           CreateTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(87, 201, 149)}, 0.15):Play()
       end
   end)
   
   ToggleButton.MouseLeave:Connect(function()
       if not WebhookLoggerData.Enabled then
           CreateTween(ToggleButton, {BackgroundColor3 = Colors.Error}, 0.15):Play()
       else
           CreateTween(ToggleButton, {BackgroundColor3 = Colors.Success}, 0.15):Play()
       end
   end)
   
   TestButton.MouseEnter:Connect(function()
       CreateTween(TestButton, {BackgroundColor3 = Colors.Hover}, 0.15):Play()
   end)
   
   TestButton.MouseLeave:Connect(function()
       CreateTween(TestButton, {BackgroundColor3 = Colors.Secondary}, 0.15):Play()
   end)
   
   -- Log event function
   WebhookLoggerData.LogEvent = function(eventType, data)
       if not WebhookLoggerData.Enabled or WebhookLoggerData.WebhookUrl == "" then
           return
       end
       
       eventCount = eventCount + 1
       EventCountLabel.Text = "Events Sent: " .. tostring(eventCount)
       
       local fields = {
           {
               name = "Event Type",
               value = eventType,
               inline = true
           },
           {
               name = "Time",
               value = os.date("%X"),
               inline = true
           }
       }
       
       -- Add event-specific fields
       if eventType == "Toggle" then
           table.insert(fields, {
               name = "Toggle",
               value = data.Name,
               inline = false
           })
           table.insert(fields, {
               name = "State",
               value = data.Value and "Enabled" or "Disabled",
               inline = false
           })
       elseif eventType == "Slider" then
           table.insert(fields, {
               name = "Slider",
               value = data.Name,
               inline = false
           })
           table.insert(fields, {
               name = "Value",
               value = tostring(data.Value),
               inline = false
           })
       elseif eventType == "Dropdown" then
           table.insert(fields, {
               name = "Dropdown",
               value = data.Name,
               inline = false
           })
           table.insert(fields, {
               name = "Selected",
               value = data.Value,
               inline = false
           })
       elseif eventType == "Button" then
           table.insert(fields, {
               name = "Button",
               value = data.Name,
               inline = false
           })
       end
       
       UILibrary:SendWebhook({
           Url = WebhookLoggerData.WebhookUrl,
           Title = "UI Event Logged",
           Description = "An event was triggered in the UI",
           Color = 5814783,
           Fields = fields
       })
   end
   
   -- Store references
   WebhookLoggerData.Frame = WebhookFrame
   WebhookLoggerData.Input = WebhookInput
   WebhookLoggerData.ToggleButton = ToggleButton
   WebhookLoggerData.TestButton = TestButton
   WebhookLoggerData.StatusIndicator = StatusIndicator
   
   -- Add to tab elements
   table.insert(tab.Elements, WebhookLoggerData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return WebhookLoggerData
end

-- Hook into existing elements to add webhook logging
local OriginalCreateToggle = UILibrary.CreateToggle
function UILibrary:CreateToggle(tab, config)
   local toggle = OriginalCreateToggle(self, tab, config)
   
   -- Add webhook logging
   local originalCallback = toggle.Callback
   toggle.Callback = function(value)
       originalCallback(value)
       
       -- Check for webhook loggers in this tab
       for _, element in ipairs(tab.Elements) do
           if element.LogEvent and element.Events and element.Events.OnToggle then
               element.LogEvent("Toggle", {
                   Name = toggle.Name,
                   Value = value
               })
           end
       end
   end
   
   return toggle
end

local OriginalCreateSlider = UILibrary.CreateSlider
function UILibrary:CreateSlider(tab, config)
   local slider = OriginalCreateSlider(self, tab, config)
   
   -- Add webhook logging
   local originalCallback = slider.Callback
   slider.Callback = function(value)
       originalCallback(value)
       
       -- Check for webhook loggers in this tab
       for _, element in ipairs(tab.Elements) do
           if element.LogEvent and element.Events and element.Events.OnSliderChange then
               element.LogEvent("Slider", {
                   Name = slider.Name,
                   Value = value
               })
           end
       end
   end
   
   return slider
end

local OriginalCreateDropdown = UILibrary.CreateDropdown
function UILibrary:CreateDropdown(tab, config)
   local dropdown = OriginalCreateDropdown(self, tab, config)
   
   -- Add webhook logging
   local originalCallback = dropdown.Callback
   dropdown.Callback = function(value)
       originalCallback(value)
       
       -- Check for webhook loggers in this tab
       for _, element in ipairs(tab.Elements) do
           if element.LogEvent and element.Events and element.Events.OnDropdownChange then
               element.LogEvent("Dropdown", {
                   Name = dropdown.Name,
                   Value = value
               })
           end
       end
   end
   
   return dropdown
end

local OriginalCreateButton = UILibrary.CreateButton
function UILibrary:CreateButton(tab, config)
   local button = OriginalCreateButton(self, tab, config)
   
   -- Add webhook logging
   local originalCallback = button.Callback
   button.Callback = function()
       originalCallback()
       
       -- Check for webhook loggers in this tab
       for _, element in ipairs(tab.Elements) do
           if element.LogEvent and element.Events and element.Events.OnButtonClick then
               element.LogEvent("Button", {
                   Name = button.Name
               })
           end
       end
   end
   
   return button
end

-- Webhook templates for common use cases
UILibrary.WebhookTemplates = {
   GameJoin = function(webhookUrl)
       return UILibrary:SendWebhook({
           Url = webhookUrl,
           Title = "Player Joined Game",
           Color = 4437377, -- Green
           Fields = {
               {
                   name = "Player",
                   value = Players.LocalPlayer.Name,
                   inline = true
               },
               {
                   name = "Game",
                   value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                   inline = true
               },
               {
                   name = "Server",
                   value = game.JobId or "Unknown",
                   inline = false
               }
           }
       })
   end,
   
   Error = function(webhookUrl, errorMessage)
       return UILibrary:SendWebhook({
           Url = webhookUrl,
           Title = "Error Occurred",
           Description = errorMessage,
           Color = 15548997, -- Red
           Fields = {
               {
                   name = "Player",
                   value = Players.LocalPlayer.Name,
                   inline = true
               },
               {
                   name = "Time",
                   value = os.date("%X"),
                   inline = true
               }
           }
       })
   end,
   
   Stats = function(webhookUrl, stats)
       local fields = {}
       for name, value in pairs(stats) do
           table.insert(fields, {
               name = name,
               value = tostring(value),
               inline = true
           })
       end
       
       return UILibrary:SendWebhook({
           Url = webhookUrl,
           Title = "Player Statistics",
           Color = 5814783, -- Purple
           Fields = fields
       })
   end
}

-- ================================
-- ASTDX Custom UI Library - Part 9
-- Security, Cloud Config, Performance & Macro System
-- ================================

-- Anti-Detection Features
UILibrary.Security = {
   SecureFunctions = {},
   ObfuscatedNames = {},
   RandomSeed = math.random(1000000, 9999999)
}

-- Secure function wrapper
function UILibrary.Security:SecureCall(func, ...)
   local args = {...}
   local success, result = pcall(function()
       -- Add random delay to prevent pattern detection
       task.wait(math.random() * 0.01)
       return func(table.unpack(args))
   end)
   
   if success then
       return result
   else
       warn("Secure call failed:", result)
       return nil
   end
end

-- Obfuscate UI element names
function UILibrary.Security:ObfuscateName(name)
   if not self.ObfuscatedNames[name] then
       self.ObfuscatedNames[name] = string.format("UI_%s_%d", 
           string.gsub(tostring({}), "table: ", ""), 
           self.RandomSeed
       )
   end
   return self.ObfuscatedNames[name]
end

-- Hide from common detection methods
function UILibrary.Security:SecureUI(screenGui)
   -- Randomize hierarchy
   screenGui.Name = self:ObfuscateName("Main")
   screenGui.ResetOnSpawn = false
   
   -- Try different parent locations
   local success = pcall(function()
       screenGui.Parent = CoreGui
   end)
   
   if not success then
       success = pcall(function()
           screenGui.Parent = game:GetService("CoreGui")
       end)
   end
   
   if not success then
       screenGui.Parent = PlayerGui
   end
   
   -- Anti-detection properties
   screenGui.DisplayOrder = math.random(1, 100)
   
   -- Protect descendants
   local function ProtectDescendants(parent)
       for _, child in ipairs(parent:GetDescendants()) do
           if child:IsA("GuiObject") then
               child.Name = self:ObfuscateName(child.Name)
           end
       end
   end
   
   ProtectDescendants(screenGui)
   
   -- Monitor for changes
   screenGui.DescendantAdded:Connect(function(descendant)
       if descendant:IsA("GuiObject") then
           descendant.Name = self:ObfuscateName(descendant.Name)
       end
   end)
end

-- Config Hub/Cloud Save System
UILibrary.CloudConfig = {
   BaseURL = "https://pastebin.com/raw/",
   Configs = {},
   Cache = {}
}

-- Create Config Hub UI
function UILibrary:CreateConfigHub(tab, config)
   config = config or {}
   
   local ConfigHubData = {
       Name = config.Name or "Config Hub",
       Tab = tab,
       Configs = {}
   }
   
   -- Config Hub Frame
   local ConfigHubFrame = Instance.new("Frame")
   ConfigHubFrame.Name = "ConfigHub"
   ConfigHubFrame.Size = UDim2.new(1, 0, 0, 200)
   ConfigHubFrame.BackgroundColor3 = Colors.Card
   ConfigHubFrame.BorderSizePixel = 0
   ConfigHubFrame.Parent = tab.Content
   
   CreateCorner(ConfigHubFrame, 6)
   CreateStroke(ConfigHubFrame, Colors.Border, 1)
   
   -- Title
   local ConfigTitle = Instance.new("TextLabel")
   ConfigTitle.Name = "Title"
   ConfigTitle.Size = UDim2.new(1, -20, 0, 25)
   ConfigTitle.Position = UDim2.new(0, 10, 0, 5)
   ConfigTitle.BackgroundTransparency = 1
   ConfigTitle.Text = ConfigHubData.Name
   ConfigTitle.TextColor3 = Colors.Text
   ConfigTitle.TextSize = 13
   ConfigTitle.TextXAlignment = Enum.TextXAlignment.Left
   ConfigTitle.Font = Enum.Font.GothamBold
   ConfigTitle.Parent = ConfigHubFrame
   
   -- Import Section
   local ImportFrame = Instance.new("Frame")
   ImportFrame.Name = "ImportFrame"
   ImportFrame.Size = UDim2.new(1, -20, 0, 60)
   ImportFrame.Position = UDim2.new(0, 10, 0, 35)
   ImportFrame.BackgroundTransparency = 1
   ImportFrame.Parent = ConfigHubFrame
   
   -- URL Input
   local URLInput = Instance.new("TextBox")
   URLInput.Name = "URLInput"
   URLInput.Size = UDim2.new(1, -90, 0, 25)
   URLInput.Position = UDim2.new(0, 0, 0, 0)
   URLInput.BackgroundColor3 = Colors.Secondary
   URLInput.BorderSizePixel = 0
   URLInput.Text = ""
   URLInput.PlaceholderText = "Enter Pastebin ID or URL..."
   URLInput.TextColor3 = Colors.Text
   URLInput.PlaceholderColor3 = Colors.TextMuted
   URLInput.TextSize = 11
   URLInput.TextXAlignment = Enum.TextXAlignment.Left
   URLInput.Font = Enum.Font.Gotham
   URLInput.ClearTextOnFocus = false
   URLInput.Parent = ImportFrame
   
   CreateCorner(URLInput, 4)
   CreateStroke(URLInput, Colors.Border, 1)
   
   local URLPadding = Instance.new("UIPadding")
   URLPadding.PaddingLeft = UDim.new(0, 8)
   URLPadding.PaddingRight = UDim.new(0, 8)
   URLPadding.Parent = URLInput
   
   -- Import Button
   local ImportButton = Instance.new("TextButton")
   ImportButton.Name = "ImportButton"
   ImportButton.Size = UDim2.new(0, 80, 0, 25)
   ImportButton.Position = UDim2.new(1, -80, 0, 0)
   ImportButton.BackgroundColor3 = Colors.Accent
   ImportButton.BorderSizePixel = 0
   ImportButton.Text = "Import"
   ImportButton.TextColor3 = Colors.Text
   ImportButton.TextSize = 11
   ImportButton.Font = Enum.Font.GothamBold
   ImportButton.Parent = ImportFrame
   
   CreateCorner(ImportButton, 4)
   
   -- Config Name Input
   local ConfigNameInput = Instance.new("TextBox")
   ConfigNameInput.Name = "ConfigNameInput"
   ConfigNameInput.Size = UDim2.new(1, -90, 0, 25)
   ConfigNameInput.Position = UDim2.new(0, 0, 0, 30)
   ConfigNameInput.BackgroundColor3 = Colors.Secondary
   ConfigNameInput.BorderSizePixel = 0
   ConfigNameInput.Text = ""
   ConfigNameInput.PlaceholderText = "Config name (optional)..."
   ConfigNameInput.TextColor3 = Colors.Text
   ConfigNameInput.PlaceholderColor3 = Colors.TextMuted
   ConfigNameInput.TextSize = 11
   ConfigNameInput.TextXAlignment = Enum.TextXAlignment.Left
   ConfigNameInput.Font = Enum.Font.Gotham
   ConfigNameInput.ClearTextOnFocus = false
   ConfigNameInput.Parent = ImportFrame
   
   CreateCorner(ConfigNameInput, 4)
   CreateStroke(ConfigNameInput, Colors.Border, 1)
   
   local NamePadding = Instance.new("UIPadding")
   NamePadding.PaddingLeft = UDim.new(0, 8)
   NamePadding.PaddingRight = UDim.new(0, 8)
   NamePadding.Parent = ConfigNameInput
   
   -- Export Button
   local ExportButton = Instance.new("TextButton")
   ExportButton.Name = "ExportButton"
   ExportButton.Size = UDim2.new(0, 80, 0, 25)
   ExportButton.Position = UDim2.new(1, -80, 0, 30)
   ExportButton.BackgroundColor3 = Colors.Success
   ExportButton.BorderSizePixel = 0
   ExportButton.Text = "Export"
   ExportButton.TextColor3 = Colors.Text
   ExportButton.TextSize = 11
   ExportButton.Font = Enum.Font.GothamBold
   ExportButton.Parent = ImportFrame
   
   CreateCorner(ExportButton, 4)
   
   -- Config List
   local ConfigListFrame = Instance.new("ScrollingFrame")
   ConfigListFrame.Name = "ConfigList"
   ConfigListFrame.Size = UDim2.new(1, -20, 1, -110)
   ConfigListFrame.Position = UDim2.new(0, 10, 0, 100)
   ConfigListFrame.BackgroundColor3 = Colors.Secondary
   ConfigListFrame.BorderSizePixel = 0
   ConfigListFrame.ScrollBarThickness = 3
   ConfigListFrame.ScrollBarImageColor3 = Colors.Accent
   ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
   ConfigListFrame.Parent = ConfigHubFrame
   
   CreateCorner(ConfigListFrame, 4)
   
   local ConfigListLayout = Instance.new("UIListLayout")
   ConfigListLayout.SortOrder = Enum.SortOrder.LayoutOrder
   ConfigListLayout.Padding = UDim.new(0, 5)
   ConfigListLayout.Parent = ConfigListFrame
   
   local ConfigListPadding = Instance.new("UIPadding")
   ConfigListPadding.PaddingTop = UDim.new(0, 5)
   ConfigListPadding.PaddingBottom = UDim.new(0, 5)
   ConfigListPadding.PaddingLeft = UDim.new(0, 5)
   ConfigListPadding.PaddingRight = UDim.new(0, 5)
   ConfigListPadding.Parent = ConfigListFrame
   
   -- Functions
   local function ParseURL(url)
       -- Extract Pastebin ID from various formats
       if string.find(url, "pastebin.com") then
           return string.match(url, "pastebin.com/(.+)") or string.match(url, "pastebin.com/raw/(.+)")
       else
           return url -- Assume it's already an ID
       end
   end
   
   local function AddConfigToList(configName, configData, configId)
       local ConfigItem = Instance.new("Frame")
       ConfigItem.Name = "ConfigItem"
       ConfigItem.Size = UDim2.new(1, 0, 0, 30)
       ConfigItem.BackgroundColor3 = Colors.Card
       ConfigItem.BorderSizePixel = 0
       ConfigItem.Parent = ConfigListFrame
       
       CreateCorner(ConfigItem, 4)
       
       local ConfigItemName = Instance.new("TextLabel")
       ConfigItemName.Size = UDim2.new(1, -80, 1, 0)
       ConfigItemName.Position = UDim2.new(0, 10, 0, 0)
       ConfigItemName.BackgroundTransparency = 1
       ConfigItemName.Text = configName
       ConfigItemName.TextColor3 = Colors.Text
       ConfigItemName.TextSize = 11
       ConfigItemName.TextXAlignment = Enum.TextXAlignment.Left
       ConfigItemName.Font = Enum.Font.Gotham
       ConfigItemName.Parent = ConfigItem
       
       local LoadButton = Instance.new("TextButton")
       LoadButton.Size = UDim2.new(0, 60, 0, 20)
       LoadButton.Position = UDim2.new(1, -65, 0, 5)
       LoadButton.BackgroundColor3 = Colors.Accent
       LoadButton.BorderSizePixel = 0
       LoadButton.Text = "Load"
       LoadButton.TextColor3 = Colors.Text
       LoadButton.TextSize = 10
       LoadButton.Font = Enum.Font.Gotham
       LoadButton.Parent = ConfigItem
       
       CreateCorner(LoadButton, 3)
       
       LoadButton.MouseButton1Click:Connect(function()
           local success = UILibrary:LoadConfigFromData(tab.Window, configData)
           if success then
               UILibrary:QueueNotification({
                   Title = "Config Loaded",
                   Content = "Successfully loaded config: " .. configName,
                   Type = "Success",
                   Duration = 3
               })
           else
               UILibrary:QueueNotification({
                   Title = "Load Failed",
                   Content = "Failed to load config: " .. configName,
                   Type = "Error",
                   Duration = 3
               })
           end
       end)
       
       -- Update canvas size
       ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y)
       
       -- Store config
       table.insert(ConfigHubData.Configs, {
           Name = configName,
           Data = configData,
           Id = configId,
           Item = ConfigItem
       })
   end
   
   -- Import function
   ImportButton.MouseButton1Click:Connect(function()
       local url = URLInput.Text
       if url == "" then
           UILibrary:QueueNotification({
               Title = "Import Error",
               Content = "Please enter a Pastebin ID or URL",
               Type = "Error",
               Duration = 3
           })
           return
       end
       
       local pastebinId = ParseURL(url)
       local fullUrl = UILibrary.CloudConfig.BaseURL .. pastebinId
       
       -- Check cache first
       if UILibrary.CloudConfig.Cache[pastebinId] then
           local configName = ConfigNameInput.Text ~= "" and ConfigNameInput.Text or ("Config " .. #ConfigHubData.Configs + 1)
           AddConfigToList(configName, UILibrary.CloudConfig.Cache[pastebinId], pastebinId)
           UILibrary:QueueNotification({
               Title = "Config Imported",
               Content = "Loaded config from cache",
               Type = "Success",
               Duration = 3
           })
           return
       end
       
       -- Fetch from URL
       local success, result = pcall(function()
           return game:HttpGet(fullUrl)
       end)
       
       if success then
           local configSuccess, configData = pcall(function()
               return game:GetService("HttpService"):JSONDecode(result)
           end)
           
           if configSuccess then
               -- Cache the config
               UILibrary.CloudConfig.Cache[pastebinId] = configData
               
               local configName = ConfigNameInput.Text ~= "" and ConfigNameInput.Text or ("Config " .. #ConfigHubData.Configs + 1)
               AddConfigToList(configName, configData, pastebinId)
               
               UILibrary:QueueNotification({
                   Title = "Config Imported",
                   Content = "Successfully imported config: " .. configName,
                   Type = "Success",
                   Duration = 3
               })
               
               URLInput.Text = ""
               ConfigNameInput.Text = ""
           else
               UILibrary:QueueNotification({
                   Title = "Import Error",
                   Content = "Invalid config format",
                   Type = "Error",
                   Duration = 3
               })
           end
       else
           UILibrary:QueueNotification({
               Title = "Import Error",
               Content = "Failed to fetch config from URL",
               Type = "Error",
               Duration = 3
           })
       end
   end)
   
   -- Export function
   ExportButton.MouseButton1Click:Connect(function()
       local configData = UILibrary:GetConfigData(tab.Window)
       local jsonData = game:GetService("HttpService"):JSONEncode(configData)
       
       setclipboard(jsonData)
       
       UILibrary:QueueNotification({
           Title = "Config Exported",
           Content = "Config data copied to clipboard. Paste it to Pastebin!",
           Type = "Success",
           Duration = 5
       })
   end)
   
   -- Button hover effects
   ImportButton.MouseEnter:Connect(function()
       CreateTween(ImportButton, {BackgroundColor3 = Colors.AccentHover}, 0.15):Play()
   end)
   
   ImportButton.MouseLeave:Connect(function()
       CreateTween(ImportButton, {BackgroundColor3 = Colors.Accent}, 0.15):Play()
   end)
   
   ExportButton.MouseEnter:Connect(function()
       CreateTween(ExportButton, {BackgroundColor3 = Color3.fromRGB(87, 201, 149)}, 0.15):Play()
   end)
   
   ExportButton.MouseLeave:Connect(function()
       CreateTween(ExportButton, {BackgroundColor3 = Colors.Success}, 0.15):Play()
   end)
   
   -- Store references
   ConfigHubData.Frame = ConfigHubFrame
   
   -- Add to tab elements
   table.insert(tab.Elements, ConfigHubData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return ConfigHubData
end

-- Performance Monitor
UILibrary.PerformanceMonitor = {
   Enabled = false,
   Stats = {
       FPS = 0,
       Memory = 0,
       Ping = 0,
       CPU = 0
   }
}

function UILibrary:CreatePerformanceMonitor(config)
   config = config or {}
   
   local MonitorData = {
       Position = config.Position or UDim2.new(0, 10, 0, 10),
       Size = config.Size or UDim2.new(0, 200, 0, 100),
       Draggable = config.Draggable ~= false
   }
   
   -- Monitor GUI
   local MonitorGui = Instance.new("ScreenGui")
   MonitorGui.Name = UILibrary.Security:ObfuscateName("PerformanceMonitor")
   MonitorGui.Parent = CoreGui
   MonitorGui.ResetOnSpawn = false
   
   -- Monitor Frame
   local MonitorFrame = Instance.new("Frame")
   MonitorFrame.Name = "Monitor"
   MonitorFrame.Size = MonitorData.Size
   MonitorFrame.Position = MonitorData.Position
   MonitorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
   MonitorFrame.BorderSizePixel = 0
   MonitorFrame.Parent = MonitorGui
   
   CreateCorner(MonitorFrame, 6)
   CreateStroke(MonitorFrame, Colors.Border, 1)
   
   -- Make semi-transparent
   MonitorFrame.BackgroundTransparency = 0.3
   
   -- Title
   local MonitorTitle = Instance.new("TextLabel")
   MonitorTitle.Size = UDim2.new(1, 0, 0, 20)
   MonitorTitle.BackgroundTransparency = 1
   MonitorTitle.Text = "Performance"
   MonitorTitle.TextColor3 = Colors.Text
   MonitorTitle.TextSize = 11
   MonitorTitle.Font = Enum.Font.GothamBold
   MonitorTitle.Parent = MonitorFrame
   
   -- Stats Container
   local StatsContainer = Instance.new("Frame")
   StatsContainer.Size = UDim2.new(1, -10, 1, -25)
   StatsContainer.Position = UDim2.new(0, 5, 0, 20)
   StatsContainer.BackgroundTransparency = 1
   StatsContainer.Parent = MonitorFrame
   
   -- FPS Label
   local FPSLabel = Instance.new("TextLabel")
   FPSLabel.Size = UDim2.new(0.5, 0, 0, 20)
   FPSLabel.Position = UDim2.new(0, 0, 0, 0)
   FPSLabel.BackgroundTransparency = 1
   FPSLabel.Text = "FPS: 0"
   FPSLabel.TextColor3 = Colors.Success
   FPSLabel.TextSize = 10
   FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
   FPSLabel.Font = Enum.Font.Gotham
   FPSLabel.Parent = StatsContainer
   
   -- Memory Label
   local MemoryLabel = Instance.new("TextLabel")
   MemoryLabel.Size = UDim2.new(0.5, 0, 0, 20)
   MemoryLabel.Position = UDim2.new(0.5, 0, 0, 0)
   MemoryLabel.BackgroundTransparency = 1
   MemoryLabel.Text = "Mem: 0 MB"
   MemoryLabel.TextColor3 = Colors.Warning
   MemoryLabel.TextSize = 10
   MemoryLabel.TextXAlignment = Enum.TextXAlignment.Left
   MemoryLabel.Font = Enum.Font.Gotham
   MemoryLabel.Parent = StatsContainer
   
   -- Ping Label
   local PingLabel = Instance.new("TextLabel")
   PingLabel.Size = UDim2.new(0.5, 0, 0, 20)
   PingLabel.Position = UDim2.new(0, 0, 0, 20)
   PingLabel.BackgroundTransparency = 1
   PingLabel.Text = "Ping: 0 ms"
   PingLabel.TextColor3 = Colors.Accent
   PingLabel.TextSize = 10
   PingLabel.TextXAlignment = Enum.TextXAlignment.Left
   PingLabel.Font = Enum.Font.Gotham
   PingLabel.Parent = StatsContainer
   
   -- CPU Label
   local CPULabel = Instance.new("TextLabel")
   CPULabel.Size = UDim2.new(0.5, 0, 0, 20)
   CPULabel.Position = UDim2.new(0.5, 0, 0, 20)
   CPULabel.BackgroundTransparency = 1
   CPULabel.Text = "CPU: 0%"
   CPULabel.TextColor3 = Colors.Error
   CPULabel.TextSize = 10
   CPULabel.TextXAlignment = Enum.TextXAlignment.Left
   CPULabel.Font = Enum.Font.Gotham
   CPULabel.Parent = StatsContainer
   
   -- Script Time Label
   local ScriptLabel = Instance.new("TextLabel")
   ScriptLabel.Size = UDim2.new(1, 0, 0, 20)
   ScriptLabel.Position = UDim2.new(0, 0, 0, 40)
   ScriptLabel.BackgroundTransparency = 1
   ScriptLabel.Text = "Script: 0.00 ms"
   ScriptLabel.TextColor3 = Colors.TextSecondary
   ScriptLabel.TextSize = 10
   ScriptLabel.TextXAlignment = Enum.TextXAlignment.Left
   ScriptLabel.Font = Enum.Font.Gotham
   ScriptLabel.Parent = StatsContainer
   
   -- Make draggable
   if MonitorData.Draggable then
       local dragStart = nil
       local startPos = nil
       
       MonitorFrame.InputBegan:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.MouseButton1 then
               dragStart = input.Position
               startPos = MonitorFrame.Position
               
               local connection
               connection = UserInputService.InputChanged:Connect(function(moveInput)
                   if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                       local delta = moveInput.Position - dragStart
                       MonitorFrame.Position = UDim2.new(
                           startPos.X.Scale,
                           startPos.X.Offset + delta.X,
                           startPos.Y.Scale,
                           startPos.Y.Offset + delta.Y
                       )
                   end
               end)
               
               input.Changed:Connect(function()
                   if input.UserInputState == Enum.UserInputState.End then
                       connection:Disconnect()
                   end
               end)
           end
       end)
   end
   
   -- Performance tracking
   local lastUpdate = 0
   local frameCount = 0
   local lastScriptTime = 0
   
   UILibrary.PerformanceMonitor.Enabled = true
   
   RunService.Heartbeat:Connect(function()
       if not UILibrary.PerformanceMonitor.Enabled then return end
       
       frameCount = frameCount + 1
       local currentTime = tick()
       
       if currentTime - lastUpdate >= 1 then
           -- FPS
           UILibrary.PerformanceMonitor.Stats.FPS = frameCount
           FPSLabel.Text = string.format("FPS: %d", frameCount)
           
           -- Color code FPS
           if frameCount >= 50 then
               FPSLabel.TextColor3 = Colors.Success
           elseif frameCount >= 30 then
               FPSLabel.TextColor3 = Colors.Warning
           else
               FPSLabel.TextColor3 = Colors.Error
           end
           
           frameCount = 0
           lastUpdate = currentTime
           
           -- Memory
           local memory = math.floor(collectgarbage("count") / 1024)
           UILibrary.PerformanceMonitor.Stats.Memory = memory
           MemoryLabel.Text = string.format("Mem: %d MB", memory)
           
           -- Ping
           local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
           UILibrary.PerformanceMonitor.Stats.Ping = math.floor(ping)
           PingLabel.Text = string.format("Ping: %d ms", math.floor(ping))
           
           -- CPU (approximation based on frame time)
           local frameTime = RunService.Heartbeat:Wait() * 1000
           local cpu = math.min(100, math.floor((frameTime / 16.67) * 100))
           UILibrary.PerformanceMonitor.Stats.CPU = cpu
           CPULabel.Text = string.format("CPU: %d%%", cpu)
       end
       
       -- Script execution time
       local scriptStart = tick()
       -- Measure a simple operation
       for i = 1, 100 do
           local _ = i * 2
       end
       local scriptTime = (tick() - scriptStart) * 1000
       ScriptLabel.Text = string.format("Script: %.2f ms", scriptTime)
   end)
   
   MonitorData.Gui = MonitorGui
   MonitorData.Frame = MonitorFrame
   MonitorData.Hide = function()
       MonitorGui.Enabled = false
       UILibrary.PerformanceMonitor.Enabled = false
   end
   MonitorData.Show = function()
       MonitorGui.Enabled = true
       UILibrary.PerformanceMonitor.Enabled = true
   end
   
   return MonitorData
end

-- Macro/Recording System
UILibrary.MacroSystem = {
   Recording = false,
   Playing = false,
   CurrentMacro = {},
   SavedMacros = {},
   StartTime = 0
}

function UILibrary:CreateMacroRecorder(tab, config)
   config = config or {}
   
   local MacroData = {
       Name = config.Name or "Macro Recorder",
       Tab = tab
   }
   
   -- Macro Frame
   local MacroFrame = Instance.new("Frame")
   MacroFrame.Name = "MacroRecorder"
   MacroFrame.Size = UDim2.new(1, 0, 0, 180)
   MacroFrame.BackgroundColor3 = Colors.Card
   MacroFrame.BorderSizePixel = 0
   MacroFrame.Parent = tab.Content
   
   CreateCorner(MacroFrame, 6)
   CreateStroke(MacroFrame, Colors.Border, 1)
   
   -- Title
   local MacroTitle = Instance.new("TextLabel")
   MacroTitle.Size = UDim2.new(1, -20, 0, 25)
   MacroTitle.Position = UDim2.new(0, 10, 0, 5)
   MacroTitle.BackgroundTransparency = 1
   MacroTitle.Text = MacroData.Name
   MacroTitle.TextColor3 = Colors.Text
   MacroTitle.TextSize = 13
   MacroTitle.TextXAlignment = Enum.TextXAlignment.Left
   MacroTitle.Font = Enum.Font.GothamBold
   MacroTitle.Parent = MacroFrame
   
   -- Status Label
   local StatusLabel = Instance.new("TextLabel")
   StatusLabel.Size = UDim2.new(1, -20, 0, 20)
   StatusLabel.Position = UDim2.new(0, 10, 0, 30)
   StatusLabel.BackgroundTransparency = 1
   StatusLabel.Text = "Status: Idle"
   StatusLabel.TextColor3 = Colors.TextSecondary
   StatusLabel.TextSize = 11
   StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
   StatusLabel.Font = Enum.Font.Gotham
   StatusLabel.Parent = MacroFrame
   
   -- Control Buttons Container
   local ControlsContainer = Instance.new("Frame")
   ControlsContainer.Size = UDim2.new(1, -20, 0, 30)
   ControlsContainer.Position = UDim2.new(0, 10, 0, 55)
   ControlsContainer.BackgroundTransparency = 1
   ControlsContainer.Parent = MacroFrame
   
   -- Record Button
   local RecordButton = Instance.new("TextButton")
   RecordButton.Size = UDim2.new(0, 80, 1, 0)
   RecordButton.Position = UDim2.new(0, 0, 0, 0)
   RecordButton.BackgroundColor3 = Colors.Error
   RecordButton.BorderSizePixel = 0
   RecordButton.Text = "● Record"
   RecordButton.TextColor3 = Colors.Text
   RecordButton.TextSize = 11
   RecordButton.Font = Enum.Font.GothamBold
   RecordButton.Parent = ControlsContainer
   
   CreateCorner(RecordButton, 4)
   
   -- Play Button
   local PlayButton = Instance.new("TextButton")
   PlayButton.Size = UDim2.new(0, 80, 1, 0)
   PlayButton.Position = UDim2.new(0, 85, 0, 0)
   PlayButton.BackgroundColor3 = Colors.Success
   PlayButton.BorderSizePixel = 0
   PlayButton.Text = "▶ Play"
   PlayButton.TextColor3 = Colors.Text
   PlayButton.TextSize = 11
   PlayButton.Font = Enum.Font.GothamBold
   PlayButton.Parent = ControlsContainer
   
   CreateCorner(PlayButton, 4)
   
   -- Stop Button
   local StopButton = Instance.new("TextButton")
   StopButton.Size = UDim2.new(0, 80, 1, 0)
   -- Stop Button (continued)
   StopButton.Position = UDim2.new(0, 170, 0, 0)
   StopButton.BackgroundColor3 = Colors.Secondary
   StopButton.BorderSizePixel = 0
   StopButton.Text = "■ Stop"
   StopButton.TextColor3 = Colors.Text
   StopButton.TextSize = 11
   StopButton.Font = Enum.Font.GothamBold
   StopButton.Parent = ControlsContainer
   
   CreateCorner(StopButton, 4)
   
   -- Clear Button
   local ClearButton = Instance.new("TextButton")
   ClearButton.Size = UDim2.new(0, 80, 1, 0)
   ClearButton.Position = UDim2.new(0, 255, 0, 0)
   ClearButton.BackgroundColor3 = Colors.Warning
   ClearButton.BorderSizePixel = 0
   ClearButton.Text = "Clear"
   ClearButton.TextColor3 = Colors.Text
   ClearButton.TextSize = 11
   ClearButton.Font = Enum.Font.GothamBold
   ClearButton.Parent = ControlsContainer
   
   CreateCorner(ClearButton, 4)
   
   -- Macro Settings
   local SettingsContainer = Instance.new("Frame")
   SettingsContainer.Size = UDim2.new(1, -20, 0, 25)
   SettingsContainer.Position = UDim2.new(0, 10, 0, 90)
   SettingsContainer.BackgroundTransparency = 1
   SettingsContainer.Parent = MacroFrame
   
   -- Loop Toggle
   local LoopToggle = Instance.new("Frame")
   LoopToggle.Size = UDim2.new(0, 100, 1, 0)
   LoopToggle.BackgroundTransparency = 1
   LoopToggle.Parent = SettingsContainer
   
   local LoopCheckbox = Instance.new("Frame")
   LoopCheckbox.Size = UDim2.new(0, 20, 0, 20)
   LoopCheckbox.Position = UDim2.new(0, 0, 0.5, -10)
   LoopCheckbox.BackgroundColor3 = Colors.Secondary
   LoopCheckbox.BorderSizePixel = 0
   LoopCheckbox.Parent = LoopToggle
   
   CreateCorner(LoopCheckbox, 4)
   CreateStroke(LoopCheckbox, Colors.Border, 1)
   
   local LoopCheck = Instance.new("TextLabel")
   LoopCheck.Size = UDim2.new(1, 0, 1, 0)
   LoopCheck.BackgroundTransparency = 1
   LoopCheck.Text = "✓"
   LoopCheck.TextColor3 = Colors.Success
   LoopCheck.TextSize = 14
   LoopCheck.Font = Enum.Font.GothamBold
   LoopCheck.Visible = false
   LoopCheck.Parent = LoopCheckbox
   
   local LoopLabel = Instance.new("TextLabel")
   LoopLabel.Size = UDim2.new(1, -25, 1, 0)
   LoopLabel.Position = UDim2.new(0, 25, 0, 0)
   LoopLabel.BackgroundTransparency = 1
   LoopLabel.Text = "Loop"
   LoopLabel.TextColor3 = Colors.Text
   LoopLabel.TextSize = 11
   LoopLabel.TextXAlignment = Enum.TextXAlignment.Left
   LoopLabel.Font = Enum.Font.Gotham
   LoopLabel.Parent = LoopToggle
   
   local LoopEnabled = false
   local LoopButton = Instance.new("TextButton")
   LoopButton.Size = UDim2.new(1, 0, 1, 0)
   LoopButton.BackgroundTransparency = 1
   LoopButton.Text = ""
   LoopButton.Parent = LoopToggle
   
   -- Speed Slider
   local SpeedContainer = Instance.new("Frame")
   SpeedContainer.Size = UDim2.new(1, -110, 1, 0)
   SpeedContainer.Position = UDim2.new(0, 110, 0, 0)
   SpeedContainer.BackgroundTransparency = 1
   SpeedContainer.Parent = SettingsContainer
   
   local SpeedLabel = Instance.new("TextLabel")
   SpeedLabel.Size = UDim2.new(0, 60, 1, 0)
   SpeedLabel.BackgroundTransparency = 1
   SpeedLabel.Text = "Speed: 1x"
   SpeedLabel.TextColor3 = Colors.Text
   SpeedLabel.TextSize = 11
   SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
   SpeedLabel.Font = Enum.Font.Gotham
   SpeedLabel.Parent = SpeedContainer
   
   local SpeedSlider = Instance.new("Frame")
   SpeedSlider.Size = UDim2.new(1, -70, 0, 4)
   SpeedSlider.Position = UDim2.new(0, 65, 0.5, -2)
   SpeedSlider.BackgroundColor3 = Colors.Secondary
   SpeedSlider.BorderSizePixel = 0
   SpeedSlider.Parent = SpeedContainer
   
   CreateCorner(SpeedSlider, 2)
   
   local SpeedFill = Instance.new("Frame")
   SpeedFill.Size = UDim2.new(0.5, 0, 1, 0)
   SpeedFill.BackgroundColor3 = Colors.Accent
   SpeedFill.BorderSizePixel = 0
   SpeedFill.Parent = SpeedSlider
   
   CreateCorner(SpeedFill, 2)
   
   local SpeedHandle = Instance.new("Frame")
   SpeedHandle.Size = UDim2.new(0, 12, 0, 12)
   SpeedHandle.Position = UDim2.new(1, -6, 0.5, -6)
   SpeedHandle.BackgroundColor3 = Colors.Text
   SpeedHandle.BorderSizePixel = 0
   SpeedHandle.Parent = SpeedFill
   
   CreateCorner(SpeedHandle, 6)
   
   local PlaybackSpeed = 1
   
   -- Macro Info
   local MacroInfo = Instance.new("TextLabel")
   MacroInfo.Size = UDim2.new(1, -20, 0, 20)
   MacroInfo.Position = UDim2.new(0, 10, 0, 120)
   MacroInfo.BackgroundTransparency = 1
   MacroInfo.Text = "No macro recorded"
   MacroInfo.TextColor3 = Colors.TextMuted
   MacroInfo.TextSize = 10
   MacroInfo.TextXAlignment = Enum.TextXAlignment.Left
   MacroInfo.Font = Enum.Font.Gotham
   MacroInfo.Parent = MacroFrame
   
   -- Save/Load Section
   local SaveLoadContainer = Instance.new("Frame")
   SaveLoadContainer.Size = UDim2.new(1, -20, 0, 25)
   SaveLoadContainer.Position = UDim2.new(0, 10, 0, 145)
   SaveLoadContainer.BackgroundTransparency = 1
   SaveLoadContainer.Parent = MacroFrame
   
   local MacroNameInput = Instance.new("TextBox")
   MacroNameInput.Size = UDim2.new(1, -170, 1, 0)
   MacroNameInput.BackgroundColor3 = Colors.Secondary
   MacroNameInput.BorderSizePixel = 0
   MacroNameInput.Text = ""
   MacroNameInput.PlaceholderText = "Macro name..."
   MacroNameInput.TextColor3 = Colors.Text
   MacroNameInput.PlaceholderColor3 = Colors.TextMuted
   MacroNameInput.TextSize = 10
   MacroNameInput.TextXAlignment = Enum.TextXAlignment.Left
   MacroNameInput.Font = Enum.Font.Gotham
   MacroNameInput.ClearTextOnFocus = false
   MacroNameInput.Parent = SaveLoadContainer
   
   CreateCorner(MacroNameInput, 4)
   
   local MacroNamePadding = Instance.new("UIPadding")
   MacroNamePadding.PaddingLeft = UDim.new(0, 8)
   MacroNamePadding.PaddingRight = UDim.new(0, 8)
   MacroNamePadding.Parent = MacroNameInput
   
   local SaveMacroButton = Instance.new("TextButton")
   SaveMacroButton.Size = UDim2.new(0, 80, 1, 0)
   SaveMacroButton.Position = UDim2.new(1, -165, 0, 0)
   SaveMacroButton.BackgroundColor3 = Colors.Success
   SaveMacroButton.BorderSizePixel = 0
   SaveMacroButton.Text = "Save"
   SaveMacroButton.TextColor3 = Colors.Text
   SaveMacroButton.TextSize = 10
   SaveMacroButton.Font = Enum.Font.Gotham
   SaveMacroButton.Parent = SaveLoadContainer
   
   CreateCorner(SaveMacroButton, 4)
   
   local LoadMacroButton = Instance.new("TextButton")
   LoadMacroButton.Size = UDim2.new(0, 80, 1, 0)
   LoadMacroButton.Position = UDim2.new(1, -80, 0, 0)
   LoadMacroButton.BackgroundColor3 = Colors.Accent
   LoadMacroButton.BorderSizePixel = 0
   LoadMacroButton.Text = "Load"
   LoadMacroButton.TextColor3 = Colors.Text
   LoadMacroButton.TextSize = 10
   LoadMacroButton.Font = Enum.Font.Gotham
   LoadMacroButton.Parent = SaveLoadContainer
   
   CreateCorner(LoadMacroButton, 4)
   
   -- Recording connections
   local recordingConnections = {}
   local playbackConnection = nil
   
   -- Record function
   local function StartRecording()
       if UILibrary.MacroSystem.Playing then return end
       
       UILibrary.MacroSystem.Recording = true
       UILibrary.MacroSystem.CurrentMacro = {}
       UILibrary.MacroSystem.StartTime = tick()
       
       StatusLabel.Text = "Status: Recording..."
       StatusLabel.TextColor3 = Colors.Error
       RecordButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
       RecordButton.Text = "● Recording"
       
       -- Record mouse clicks
       recordingConnections[#recordingConnections + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
           if gameProcessed then return end
           
           if input.UserInputType == Enum.UserInputType.MouseButton1 then
               local mouse = Players.LocalPlayer:GetMouse()
               table.insert(UILibrary.MacroSystem.CurrentMacro, {
                   Type = "MouseClick",
                   Position = Vector2.new(mouse.X, mouse.Y),
                   Time = tick() - UILibrary.MacroSystem.StartTime,
                   Button = "Left"
               })
           elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
               local mouse = Players.LocalPlayer:GetMouse()
               table.insert(UILibrary.MacroSystem.CurrentMacro, {
                   Type = "MouseClick",
                   Position = Vector2.new(mouse.X, mouse.Y),
                   Time = tick() - UILibrary.MacroSystem.StartTime,
                   Button = "Right"
               })
           elseif input.UserInputType == Enum.UserInputType.Keyboard then
               table.insert(UILibrary.MacroSystem.CurrentMacro, {
                   Type = "KeyPress",
                   Key = input.KeyCode,
                   Time = tick() - UILibrary.MacroSystem.StartTime
               })
           end
       end)
       
       -- Record mouse movement (sampled)
       local lastMouseRecord = 0
       recordingConnections[#recordingConnections + 1] = RunService.Heartbeat:Connect(function()
           local currentTime = tick()
           if currentTime - lastMouseRecord >= 0.1 then -- Sample every 100ms
               local mouse = Players.LocalPlayer:GetMouse()
               table.insert(UILibrary.MacroSystem.CurrentMacro, {
                   Type = "MouseMove",
                   Position = Vector2.new(mouse.X, mouse.Y),
                   Time = currentTime - UILibrary.MacroSystem.StartTime
               })
               lastMouseRecord = currentTime
           end
       end)
   end
   
   -- Stop recording
   local function StopRecording()
       UILibrary.MacroSystem.Recording = false
       
       for _, connection in ipairs(recordingConnections) do
           connection:Disconnect()
       end
       recordingConnections = {}
       
       StatusLabel.Text = "Status: Idle"
       StatusLabel.TextColor3 = Colors.TextSecondary
       RecordButton.BackgroundColor3 = Colors.Error
       RecordButton.Text = "● Record"
       
       if #UILibrary.MacroSystem.CurrentMacro > 0 then
           MacroInfo.Text = string.format("Macro: %d actions, %.1fs duration", 
               #UILibrary.MacroSystem.CurrentMacro,
               UILibrary.MacroSystem.CurrentMacro[#UILibrary.MacroSystem.CurrentMacro].Time
           )
       end
   end
   
   -- Play macro
   local function PlayMacro()
       if UILibrary.MacroSystem.Recording or #UILibrary.MacroSystem.CurrentMacro == 0 then return end
       
       UILibrary.MacroSystem.Playing = true
       StatusLabel.Text = "Status: Playing..."
       StatusLabel.TextColor3 = Colors.Success
       PlayButton.BackgroundColor3 = Color3.fromRGB(87, 201, 149)
       PlayButton.Text = "▶ Playing"
       
       local macroIndex = 1
       local startTime = tick()
       
       playbackConnection = RunService.Heartbeat:Connect(function()
           if not UILibrary.MacroSystem.Playing or macroIndex > #UILibrary.MacroSystem.CurrentMacro then
               if LoopEnabled and UILibrary.MacroSystem.Playing then
                   macroIndex = 1
                   startTime = tick()
               else
                   UILibrary.MacroSystem.Playing = false
                   playbackConnection:Disconnect()
                   StatusLabel.Text = "Status: Idle"
                   StatusLabel.TextColor3 = Colors.TextSecondary
                   PlayButton.BackgroundColor3 = Colors.Success
                   PlayButton.Text = "▶ Play"
               end
               return
           end
           
           local currentTime = (tick() - startTime) * PlaybackSpeed
           local action = UILibrary.MacroSystem.CurrentMacro[macroIndex]
           
           if currentTime >= action.Time then
               if action.Type == "MouseClick" then
                   game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                       action.Position.X,
                       action.Position.Y,
                       action.Button == "Left" and 0 or 1,
                       true,
                       game,
                       0
                   )
                   wait(0.05)
                   game:GetService("VirtualInputManager"):SendMouseButtonEvent(
                       action.Position.X,
                       action.Position.Y,
                       action.Button == "Left" and 0 or 1,
                       false,
                       game,
                       0
                   )
               elseif action.Type == "MouseMove" then
                   game:GetService("VirtualInputManager"):SendMouseMoveEvent(
                       action.Position.X,
                       action.Position.Y,
                       game
                   )
               elseif action.Type == "KeyPress" then
                   game:GetService("VirtualInputManager"):SendKeyEvent(
                       true,
                       action.Key,
                       false,
                       game
                   )
                   wait(0.05)
                   game:GetService("VirtualInputManager"):SendKeyEvent(
                       false,
                       action.Key,
                       false,
                       game
                   )
               end
               
               macroIndex = macroIndex + 1
           end
       end)
   end
   
   -- Stop playback
   local function StopPlayback()
       UILibrary.MacroSystem.Playing = false
       if playbackConnection then
           playbackConnection:Disconnect()
       end
       StatusLabel.Text = "Status: Idle"
       StatusLabel.TextColor3 = Colors.TextSecondary
       PlayButton.BackgroundColor3 = Colors.Success
       PlayButton.Text = "▶ Play"
   end
   
   -- Button handlers
   RecordButton.MouseButton1Click:Connect(function()
       if UILibrary.MacroSystem.Recording then
           StopRecording()
       else
           StartRecording()
       end
   end)
   
   PlayButton.MouseButton1Click:Connect(function()
       if UILibrary.MacroSystem.Playing then
           StopPlayback()
       else
           PlayMacro()
       end
   end)
   
   StopButton.MouseButton1Click:Connect(function()
       if UILibrary.MacroSystem.Recording then
           StopRecording()
       elseif UILibrary.MacroSystem.Playing then
           StopPlayback()
       end
   end)
   
   ClearButton.MouseButton1Click:Connect(function()
       UILibrary.MacroSystem.CurrentMacro = {}
       MacroInfo.Text = "No macro recorded"
       UILibrary:QueueNotification({
           Title = "Macro Cleared",
           Content = "Current macro has been cleared",
           Type = "Info",
           Duration = 2
       })
   end)
   
   -- Loop toggle
   LoopButton.MouseButton1Click:Connect(function()
       LoopEnabled = not LoopEnabled
       LoopCheck.Visible = LoopEnabled
       if LoopEnabled then
           LoopCheckbox.BackgroundColor3 = Colors.Success
       else
           LoopCheckbox.BackgroundColor3 = Colors.Secondary
       end
   end)
   
   -- Speed slider
   local draggingSpeed = false
   SpeedSlider.InputBegan:Connect(function(input)
       if input.UserInputType == Enum.UserInputType.MouseButton1 then
           draggingSpeed = true
       end
   end)
   
   UserInputService.InputEnded:Connect(function(input)
       if input.UserInputType == Enum.UserInputType.MouseButton1 then
           draggingSpeed = false
       end
   end)
   
   UserInputService.InputChanged:Connect(function(input)
       if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
           local mouse = Players.LocalPlayer:GetMouse()
           local relativeX = math.clamp((mouse.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
           SpeedFill.Size = UDim2.new(relativeX, 0, 1, 0)
           
           PlaybackSpeed = 0.25 + (relativeX * 3.75) -- 0.25x to 4x
           SpeedLabel.Text = string.format("Speed: %.1fx", PlaybackSpeed)
       end
   end)
   
   -- Save macro
   SaveMacroButton.MouseButton1Click:Connect(function()
       local macroName = MacroNameInput.Text
       if macroName == "" or #UILibrary.MacroSystem.CurrentMacro == 0 then
           UILibrary:QueueNotification({
               Title = "Save Failed",
               Content = "Please enter a name and record a macro first",
               Type = "Error",
               Duration = 3
           })
           return
       end
       
       UILibrary.MacroSystem.SavedMacros[macroName] = {
           Actions = UILibrary.MacroSystem.CurrentMacro,
           Date = os.date("%Y-%m-%d %H:%M:%S")
       }
       
       -- Save to file
       if writefile then
           local macroData = game:GetService("HttpService"):JSONEncode(UILibrary.MacroSystem.SavedMacros)
           writefile("ASTDX_Macros.json", macroData)
       end
       
       UILibrary:QueueNotification({
           Title = "Macro Saved",
           Content = "Macro saved as: " .. macroName,
           Type = "Success",
           Duration = 3
       })
       
       MacroNameInput.Text = ""
   end)
   
   -- Load macro
   LoadMacroButton.MouseButton1Click:Connect(function()
       local macroName = MacroNameInput.Text
       if macroName == "" then
           UILibrary:QueueNotification({
               Title = "Load Failed",
               Content = "Please enter a macro name",
               Type = "Error",
               Duration = 3
           })
           return
       end
       
       -- Try to load from file first
       if isfile and isfile("ASTDX_Macros.json") then
           local success, data = pcall(function()
               return game:GetService("HttpService"):JSONDecode(readfile("ASTDX_Macros.json"))
           end)
           if success then
               UILibrary.MacroSystem.SavedMacros = data
           end
       end
       
       if UILibrary.MacroSystem.SavedMacros[macroName] then
           UILibrary.MacroSystem.CurrentMacro = UILibrary.MacroSystem.SavedMacros[macroName].Actions
           MacroInfo.Text = string.format("Loaded: %s (%d actions)", macroName, #UILibrary.MacroSystem.CurrentMacro)
           
           UILibrary:QueueNotification({
               Title = "Macro Loaded",
               Content = "Successfully loaded macro: " .. macroName,
               Type = "Success",
               Duration = 3
           })
       else
           UILibrary:QueueNotification({
               Title = "Load Failed",
               Content = "Macro not found: " .. macroName,
               Type = "Error",
               Duration = 3
           })
       end
   end)
   
   -- Store references
   MacroData.Frame = MacroFrame
   
   -- Add to tab elements
   table.insert(tab.Elements, MacroData)
   
   -- Update tab content canvas size
   tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
   
   return MacroData
end

-- Helper functions for config system
function UILibrary:GetConfigData(window)
   local config = {}
   
   for _, tab in ipairs(window.Tabs) do
       config[tab.Name] = {}
       
       for _, element in ipairs(tab.Elements) do
           if element.Flag and element.Flag ~= "" then
               if element.CurrentValue ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentValue
               elseif element.CurrentOption ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentOption
               elseif element.CurrentKeybind ~= nil then
                   config[tab.Name][element.Flag] = element.CurrentKeybind
               elseif element.CurrentColor ~= nil then
                   config[tab.Name][element.Flag] = {
                       R = element.CurrentColor.R,
                       G = element.CurrentColor.G,
                       B = element.CurrentColor.B
                   }
               elseif element.SelectedOptions ~= nil then
                   local selected = {}
                   for option, isSelected in pairs(element.SelectedOptions) do
                       if isSelected then
                           table.insert(selected, option)
                       end
                   end
                   config[tab.Name][element.Flag] = selected
               end
           end
       end
   end
   
   return config
end

function UILibrary:LoadConfigFromData(window, configData)
   for _, tab in ipairs(window.Tabs) do
       if configData[tab.Name] then
           for _, element in ipairs(tab.Elements) do
               if element.Flag and element.Flag ~= "" and configData[tab.Name][element.Flag] ~= nil then
                   local value = configData[tab.Name][element.Flag]
                   
                   if element.Toggle then
                       element.CurrentValue = value
                       element.Toggle()
                   elseif element.SetValue then
                       element.SetValue(value)
                   elseif element.SetKeybind then
                       element.SetKeybind(value)
                   elseif type(value) == "table" and value.R and value.G and value.B then
                       element.CurrentColor = Color3.new(value.R, value.G, value.B)
                       element.Preview.BackgroundColor3 = element.CurrentColor
                       element.Callback(element.CurrentColor)
                   elseif element.SelectedOptions then
                       element.SelectedOptions = {}
                       for _, option in ipairs(value) do
                           element.SelectedOptions[option] = true
                       end
                       element.UpdateSelectedText()
                       element.Callback(value)
                   end
               end
           end
       end
   end
   
   return true
end

-- Enhanced window creation with security
local OriginalCreateWindow2 = UILibrary.CreateWindow
function UILibrary:CreateWindow(config)
   local window = OriginalCreateWindow2(self, config)
   
   -- Apply security measures
   if config.Secure ~= false then
       UILibrary.Security:SecureUI(window.ScreenGui)
   end
   
   return window
end

return UILibrary