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
   StopButton.Position = UDim2.new(0, 170, 0,