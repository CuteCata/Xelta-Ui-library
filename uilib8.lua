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

-- Return enhanced library
return UILibrary