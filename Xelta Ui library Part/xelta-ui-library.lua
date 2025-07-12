--[[
    Modern UI Library - Part 1 (Core System)
    โครงสร้างหลักและระบบพื้นฐานที่สามารถ extend ได้ใน Part อื่นๆ
    
    วิธีใช้งาน:
    local UI = loadstring(game:HttpGet("URL"))()
    local Window = UI:CreateWindow("Script Name")
    local Tab = Window:CreateTab("Home", "house")
    Tab:CreateButton("Click Me", function() print("Clicked!") end)
]]

-- Services และ Dependencies
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- ตรวจสอบ Executor และหา Parent ที่เหมาะสม
local function GetUIParent()
    local success, result = pcall(function()
        return CoreGui
    end)
    
    if not success then
        -- สำหรับ Mobile Executors ที่อาจไม่รองรับ CoreGui
        return Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return CoreGui
end

-- Lucide Icons (จะเพิ่มเต็มใน Part 2)
local Icons = {
    ["house"] = "rbxassetid://10734919336",
    ["zap"] = "rbxassetid://10734950309",
    ["x"] = "rbxassetid://10734950309",
    ["minus"] = "rbxassetid://10734896206",
    ["square"] = "rbxassetid://10734898547"
}

-- Theme Configuration
local Theme = {
    -- สีหลัก
    Background = Color3.fromRGB(15, 15, 15),
    SecondaryBackground = Color3.fromRGB(20, 20, 20),
    TertiaryBackground = Color3.fromRGB(25, 25, 25),
    
    -- สีข้อความ
    TextColor = Color3.fromRGB(255, 255, 255),
    DimmedText = Color3.fromRGB(180, 180, 180),
    
    -- สี Accent
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(71, 82, 196),
    
    -- อื่นๆ
    Border = Color3.fromRGB(35, 35, 35),
    Shadow = Color3.fromRGB(0, 0, 0),
    
    -- Animation Settings
    AnimationSpeed = 0.3,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out
}

-- Utility Functions Module
local Utility = {}

-- สร้าง Instance พร้อม Properties
function Utility:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    
    -- Set Properties
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    
    -- Add Children
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    
    return instance
end

-- Animation Helper
function Utility:Tween(instance, properties, duration)
    duration = duration or Theme.AnimationSpeed
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Theme.EasingStyle, Theme.EasingDirection),
        properties
    )
    
    tween:Play()
    return tween
end

-- Make Draggable (รองรับทั้ง PC และ Mobile)
function Utility:MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    dragHandle.InputBegan:Connect(function(input)
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- Main UI Library
local UILibrary = {}
UILibrary.__index = UILibrary

-- Window Class (ใช้ Metatable เพื่อให้ extend ได้)
local Window = {}
Window.__index = Window

-- Tab Class (ใช้ Metatable เพื่อให้ extend ได้)
local Tab = {}
Tab.__index = Tab

-- สร้าง UI Library Instance
function UILibrary:CreateWindow(title)
    -- ตรวจสอบและลบ UI เก่า
    local existingUI = GetUIParent():FindFirstChild("ModernUILibrary")
    if existingUI then
        existingUI:Destroy()
    end
    
    -- สร้าง Window Object ด้วย Metatable
    local windowInstance = setmetatable({}, Window)
    
    -- สร้าง Main Frame
    windowInstance.ScreenGui = Utility:Create("ScreenGui", {
        Name = "ModernUILibrary",
        Parent = GetUIParent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Background Blur (เฉพาะ PC)
    if UserInputService.KeyboardEnabled then
        windowInstance.Blur = Utility:Create("BlurEffect", {
            Size = 0,
            Parent = game:GetService("Lighting")
        })
    end
    
    -- Main Window Frame
    windowInstance.MainFrame = Utility:Create("Frame", {
        Name = "MainWindow",
        Parent = windowInstance.ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -400, 0.5, -300),
        Size = UDim2.new(0, 800, 0, 600),
        ClipsDescendants = true
    })
    
    -- เพิ่ม Corner Radius
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = windowInstance.MainFrame
    })
    
    -- เพิ่ม Shadow
    windowInstance.Shadow = Utility:Create("ImageLabel", {
        Name = "Shadow",
        Parent = windowInstance.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://10734919336", -- จะเปลี่ยนเป็น shadow image ใน Part 2
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(20, 20, 280, 280)
    })
    
    -- Top Bar
    windowInstance.TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Parent = windowInstance.MainFrame,
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    -- Title Label (มุมซ้ายบน)
    windowInstance.TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = windowInstance.TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, -15, 1, 0),
        Font = Enum.Font.Gotham,
        Text = title or "Modern UI",
        TextColor3 = Theme.TextColor,
        TextScaled = false,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Control Buttons Container (มุมขวาบน)
    windowInstance.ControlButtons = Utility:Create("Frame", {
        Name = "ControlButtons",
        Parent = windowInstance.TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -120, 0, 5),
        Size = UDim2.new(0, 110, 0, 30)
    })
    
    -- สร้างปุ่มควบคุม
    local function createControlButton(name, icon, position, callback)
        local button = Utility:Create("TextButton", {
            Name = name,
            Parent = windowInstance.ControlButtons,
            BackgroundColor3 = Theme.TertiaryBackground,
            BorderSizePixel = 0,
            Position = position,
            Size = UDim2.new(0, 30, 0, 30),
            Text = "",
            AutoButtonColor = false
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = button
        })
        
        local iconLabel = Utility:Create("ImageLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -8, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = Icons[icon] or "",
            ImageColor3 = Theme.DimmedText
        })
        
        button.MouseButton1Click:Connect(callback)
        
        -- Hover Effect
        button.MouseEnter:Connect(function()
            Utility:Tween(button, {BackgroundColor3 = Theme.Border}, 0.2)
            Utility:Tween(iconLabel, {ImageColor3 = Theme.TextColor}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Utility:Tween(button, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
            Utility:Tween(iconLabel, {ImageColor3 = Theme.DimmedText}, 0.2)
        end)
        
        return button
    end
    
    -- Minimize Button
    windowInstance.MinimizeButton = createControlButton(
        "Minimize", "minus", UDim2.new(0, 0, 0, 0),
        function()
            windowInstance:Minimize()
        end
    )
    
    -- Fullscreen Button  
    windowInstance.FullscreenButton = createControlButton(
        "Fullscreen", "square", UDim2.new(0, 35, 0, 0),
        function()
            windowInstance:ToggleFullscreen()
        end
    )
    
    -- Close Button
    windowInstance.CloseButton = createControlButton(
        "Close", "x", UDim2.new(0, 70, 0, 0),
        function()
            windowInstance:Destroy()
        end
    )
    
    -- Content Container
    windowInstance.ContentContainer = Utility:Create("Frame", {
        Name = "ContentContainer",
        Parent = windowInstance.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40)
    })
    
    -- Tab Container (ด้านซ้าย)
    windowInstance.TabContainer = Utility:Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = windowInstance.ContentContainer,
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    Utility:Create("UIListLayout", {
        Parent = windowInstance.TabContainer,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Utility:Create("UIPadding", {
        Parent = windowInstance.TabContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- Tab Content Container
    windowInstance.TabContent = Utility:Create("Frame", {
        Name = "TabContent",
        Parent = windowInstance.ContentContainer,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -200, 1, 0)
    })
    
    -- Initialize properties
    windowInstance.Tabs = {}
    windowInstance.ActiveTab = nil
    windowInstance.IsFullscreen = false
    windowInstance.IsMinimized = false
    windowInstance.OriginalSize = windowInstance.MainFrame.Size
    windowInstance.OriginalPosition = windowInstance.MainFrame.Position
    
    -- Make window draggable
    Utility:MakeDraggable(windowInstance.MainFrame, windowInstance.TopBar)
    
    -- Animate entrance
    windowInstance.MainFrame.Position = UDim2.new(0.5, -400, 1.5, 0)
    Utility:Tween(windowInstance.MainFrame, {
        Position = UDim2.new(0.5, -400, 0.5, -300)
    }, 0.5)
    
    if windowInstance.Blur then
        Utility:Tween(windowInstance.Blur, {Size = 20}, 0.5)
    end
    
    return windowInstance
end

-- Window Methods
function Window:CreateTab(name, icon)
    local tabInstance = setmetatable({}, Tab)
    
    -- Tab Button
    tabInstance.Button = Utility:Create("TextButton", {
        Name = name,
        Parent = self.TabContainer,
        BackgroundColor3 = Theme.TertiaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 40),
        Text = "",
        AutoButtonColor = false
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabInstance.Button
    })
    
    -- Tab Content Layout
    local tabLayout = Utility:Create("Frame", {
        Name = "TabLayout",
        Parent = tabInstance.Button,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    
    -- Icon
    if icon and Icons[icon] then
        tabInstance.Icon = Utility:Create("ImageLabel", {
            Parent = tabLayout,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = Icons[icon],
            ImageColor3 = Theme.DimmedText
        })
    end
    
    -- Tab Name
    tabInstance.Label = Utility:Create("TextLabel", {
        Parent = tabLayout,
        BackgroundTransparency = 1,
        Position = icon and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 10, 0, 0),
        Size = icon and UDim2.new(1, -50, 1, 0) or UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Theme.DimmedText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Page
    tabInstance.Page = Utility:Create("ScrollingFrame", {
        Name = name .. "Page",
        Parent = self.TabContent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false
    })
    
    Utility:Create("UIListLayout", {
        Parent = tabInstance.Page,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Utility:Create("UIPadding", {
        Parent = tabInstance.Page,
        PaddingTop = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20)
    })
    
    -- Tab Click Handler
    tabInstance.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tabInstance)
    end)
    
    -- Hover Effects
    tabInstance.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= tabInstance then
            Utility:Tween(tabInstance.Button, {
                BackgroundColor3 = Theme.Border
            }, 0.2)
        end
    end)
    
    tabInstance.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabInstance then
            Utility:Tween(tabInstance.Button, {
                BackgroundColor3 = Theme.TertiaryBackground
            }, 0.2)
        end
    end)
    
    -- Initialize
    tabInstance.Window = self
    tabInstance.Elements = {}
    
    -- Add to tabs list
    table.insert(self.Tabs, tabInstance)
    
    -- Select first tab
    if #self.Tabs == 1 then
        self:SelectTab(tabInstance)
    end
    
    -- Update canvas size
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * 45)
    
    return tabInstance
end

function Window:SelectTab(tab)
    -- Deselect previous tab
    if self.ActiveTab then
        self.ActiveTab.Page.Visible = false
        Utility:Tween(self.ActiveTab.Button, {
            BackgroundColor3 = Theme.TertiaryBackground
        }, 0.2)
        Utility:Tween(self.ActiveTab.Label, {
            TextColor3 = Theme.DimmedText
        }, 0.2)
        if self.ActiveTab.Icon then
            Utility:Tween(self.ActiveTab.Icon, {
                ImageColor3 = Theme.DimmedText
            }, 0.2)
        end
    end
    
    -- Select new tab
    self.ActiveTab = tab
    tab.Page.Visible = true
    Utility:Tween(tab.Button, {
        BackgroundColor3 = Theme.Accent
    }, 0.2)
    Utility:Tween(tab.Label, {
        TextColor3 = Theme.TextColor
    }, 0.2)
    if tab.Icon then
        Utility:Tween(tab.Icon, {
            ImageColor3 = Theme.TextColor
        }, 0.2)
    end
end

function Window:Minimize()
    if self.IsMinimized then
        -- Restore
        self.ContentContainer.Visible = true
        Utility:Tween(self.MainFrame, {
            Size = self.OriginalSize
        }, 0.3)
    else
        -- Minimize
        self.OriginalSize = self.MainFrame.Size
        self.ContentContainer.Visible = false
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(0, 400, 0, 40)
        }, 0.3)
    end
    self.IsMinimized = not self.IsMinimized
end

function Window:ToggleFullscreen()
    if self.IsFullscreen then
        -- Exit fullscreen
        Utility:Tween(self.MainFrame, {
            Size = self.OriginalSize,
            Position = self.OriginalPosition
        }, 0.3)
    else
        -- Enter fullscreen
        self.OriginalSize = self.MainFrame.Size
        self.OriginalPosition = self.MainFrame.Position
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10)
        }, 0.3)
    end
    self.IsFullscreen = not self.IsFullscreen
end

function Window:Destroy()
    if self.Blur then
        Utility:Tween(self.Blur, {Size = 0}, 0.3)
        task.wait(0.3)
        self.Blur:Destroy()
    end
    
    Utility:Tween(self.MainFrame, {
        Position = UDim2.new(0.5, -400, 1.5, 0)
    }, 0.3)
    
    task.wait(0.3)
    self.ScreenGui:Destroy()
end

-- Tab Methods (Basic - จะเพิ่มใน Part 2)
function Tab:CreateButton(text, callback)
    local button = {}
    
    button.Frame = Utility:Create("Frame", {
        Parent = self.Page,
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45)
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = button.Frame
    })
    
    button.Button = Utility:Create("TextButton", {
        Parent = button.Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextColor,
        TextSize = 14
    })
    
    button.Button.MouseButton1Click:Connect(callback or function() end)
    
    -- Hover effect
    button.Frame.MouseEnter:Connect(function()
        Utility:Tween(button.Frame, {
            BackgroundColor3 = Theme.TertiaryBackground
        }, 0.2)
    end)
    
    button.Frame.MouseLeave:Connect(function()
        Utility:Tween(button.Frame, {
            BackgroundColor3 = Theme.SecondaryBackground
        }, 0.2)
    end)
    
    -- Update canvas size
    local listLayout = self.Page:FindFirstChildOfClass("UIListLayout")
    if listLayout then
        self.Page.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 40)
    end
    
    table.insert(self.Elements, button)
    return button
end

-- ส่งคืน Library
return UILibrary
