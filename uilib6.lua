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

-- Return enhanced library
return UILibrary
