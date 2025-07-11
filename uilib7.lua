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

-- Return enhanced library
return UILibrary