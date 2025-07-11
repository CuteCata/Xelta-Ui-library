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

-- Checkbox Creation Function (Alternative to Toggle)
function UILibrary:CreateCheckbox(tab, config)
    config = config or {}
    
    local CheckboxData = {
        Name = config.Name or "Checkbox",
        CurrentValue = config.CurrentValue or false,
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or ""
    }
    
    -- Checkbox Frame
    local CheckboxFrame = Instance.new("Frame")
    CheckboxFrame.Name = "Checkbox_" .. CheckboxData.Name
    CheckboxFrame.Size = UDim2.new(1, 0, 0, 35)
    CheckboxFrame.BackgroundColor3 = Colors.Card
    CheckboxFrame.BorderSizePixel = 0
    CheckboxFrame.Parent = tab.Content
    
    CreateCorner(CheckboxFrame, 6)
    CreateStroke(CheckboxFrame, Colors.Border, 1)
    
    -- Checkbox Box
    local CheckboxBox = Instance.new("Frame")
    CheckboxBox.Name = "CheckboxBox"
    CheckboxBox.Size = UDim2.new(0, 20, 0, 20)
    CheckboxBox.Position = UDim2.new(0, 10, 0.5, -10)
    CheckboxBox.BackgroundColor3 = Colors.Secondary
    CheckboxBox.BorderSizePixel = 0
    CheckboxBox.Parent = CheckboxFrame
    
    CreateCorner(CheckboxBox, 4)
    CreateStroke(CheckboxBox, Colors.Border, 1)
    
    -- Checkbox Check Mark
    local CheckMark = Instance.new("TextLabel")
    CheckMark.Name = "CheckMark"
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.BackgroundTransparency = 1
    CheckMark.Text = "✓"
    CheckMark.TextColor3 = Colors.Success
    CheckMark.TextSize = 14
    CheckMark.Font = Enum.Font.GothamBold
    CheckMark.TextScaled = true
    CheckMark.Visible = CheckboxData.CurrentValue
    CheckMark.Parent = CheckboxBox
    
    -- Checkbox Label
    local CheckboxLabel = Instance.new("TextLabel")
    CheckboxLabel.Name = "Label"
    CheckboxLabel.Size = UDim2.new(1, -45, 1, 0)
    CheckboxLabel.Position = UDim2.new(0, 40, 0, 0)
    CheckboxLabel.BackgroundTransparency = 1
    CheckboxLabel.Text = CheckboxData.Name
    CheckboxLabel.TextColor3 = Colors.Text
    CheckboxLabel.TextSize = 12
    CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    CheckboxLabel.Font = Enum.Font.Gotham
    CheckboxLabel.Parent = CheckboxFrame
    
    -- Checkbox Button (Invisible click detector)
    local CheckboxButton = Instance.new("TextButton")
    CheckboxButton.Name = "CheckboxButton"
    CheckboxButton.Size = UDim2.new(1, 0, 1, 0)
    CheckboxButton.BackgroundTransparency = 1
    CheckboxButton.Text = ""
    CheckboxButton.Parent = CheckboxFrame
    
    -- Checkbox Function
    local function ToggleCheckbox()
        CheckboxData.CurrentValue = not CheckboxData.CurrentValue
        
        if CheckboxData.CurrentValue then
            -- Checked State
            CheckMark.Visible = true
            local checkTween = CreateTween(CheckboxBox, {
                BackgroundColor3 = Colors.Success
            }, 0.2)
            checkTween:Play()
        else
            -- Unchecked State
            CheckMark.Visible = false
            local uncheckTween = CreateTween(CheckboxBox, {
                BackgroundColor3 = Colors.Secondary
            }, 0.2)
            uncheckTween:Play()
        end
        
        -- Execute callback
        CheckboxData.Callback(CheckboxData.CurrentValue)
    end
    
    -- Set initial state
    if CheckboxData.CurrentValue then
        CheckboxBox.BackgroundColor3 = Colors.Success
        CheckMark.Visible = true
    end
    
    -- Checkbox Hover Effects
    CheckboxButton.MouseEnter:Connect(function()
        local hoverTween = CreateTween(CheckboxFrame, {
            BackgroundColor3 = Colors.Hover
        }, 0.15)
        hoverTween:Play()
    end)
    
    CheckboxButton.MouseLeave:Connect(function()
        local leaveTween = CreateTween(CheckboxFrame, {
            BackgroundColor3 = Colors.Card
        }, 0.15)
        leaveTween:Play()
    end)
    
    -- Checkbox Click Handler
    CheckboxButton.MouseButton1Click:Connect(ToggleCheckbox)
    
    -- Store references
    CheckboxData.Frame = CheckboxFrame
    CheckboxData.Box = CheckboxBox
    CheckboxData.CheckMark = CheckMark
    CheckboxData.Label = CheckboxLabel
    CheckboxData.Button = CheckboxButton
    CheckboxData.Toggle = ToggleCheckbox
    
    -- Add to tab elements
    table.insert(tab.Elements, CheckboxData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return CheckboxData
end

-- Keybind Creation Function
function UILibrary:CreateKeybind(tab, config)
    config = config or {}
    
    local KeybindData = {
        Name = config.Name or "Keybind",
        CurrentKeybind = config.CurrentKeybind or Enum.KeyCode.F,
        Callback = config.Callback or function() end,
        Tab = tab,
        Flag = config.Flag or "",
        Listening = false
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
    KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
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
    KeybindButton.Name = "KeybindButton"
    KeybindButton.Size = UDim2.new(0, 60, 0, 25)
    KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Colors.Secondary
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = KeybindData.CurrentKeybind.Name
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.TextSize = 10
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.Parent = KeybindFrame
    
    CreateCorner(KeybindButton, 4)
    CreateStroke(KeybindButton, Colors.Border, 1)
    
    -- Keybind Functions
    local function StartListening()
        KeybindData.Listening = true
        KeybindButton.Text = "..."
        KeybindButton.BackgroundColor3 = Colors.Warning
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                KeybindData.CurrentKeybind = input.KeyCode
                KeybindButton.Text = input.KeyCode.Name
                KeybindButton.BackgroundColor3 = Colors.Secondary
                KeybindData.Listening = false
                connection:Disconnect()
            end
        end)
    end
    
    -- Keybind activation
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == KeybindData.CurrentKeybind then
            KeybindData.Callback()
        end
    end)
    
    -- Keybind Button Click Handler
    KeybindButton.MouseButton1Click:Connect(StartListening)
    
    -- Keybind Hover Effects
    KeybindButton.MouseEnter:Connect(function()
        if not KeybindData.Listening then
            local hoverTween = CreateTween(KeybindButton, {
                BackgroundColor3 = Colors.Hover
            }, 0.15)
            hoverTween:Play()
        end
    end)
    
    KeybindButton.MouseLeave:Connect(function()
        if not KeybindData.Listening then
            local leaveTween = CreateTween(KeybindButton, {
                BackgroundColor3 = Colors.Secondary
            }, 0.15)
            leaveTween:Play()
        end
    end)
    
    -- Store references
    KeybindData.Frame = KeybindFrame
    KeybindData.Label = KeybindLabel
    KeybindData.Button = KeybindButton
    KeybindData.StartListening = StartListening
    
    -- Add to tab elements
    table.insert(tab.Elements, KeybindData)
    
    -- Update tab content canvas size
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y)
    
    return KeybindData
end

-- Return the library
return UILibrary