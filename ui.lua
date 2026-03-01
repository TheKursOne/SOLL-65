-- =========================================================================
-- WindUI - Advanced UI Library Showcase
-- Dibuat untuk mendemonstrasikan kemampuan pustaka WindUI.
-- =========================================================================

-- Mendapatkan lingkungan global untuk kompatibilitas executor.
local globalEnv = (getgenv and getgenv()) or _G

-- Memuat pustaka WindUI dari URL GitHub.
-- PASTIKAN executor Anda mendukung HTTP GET dan loadstring.
local WindUI_URL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/src/init.lua"
local WindUI = loadstring(game:HttpGet(WindUI_URL))()

-- Inisialisasi sistem lokalisasi WindUI.
-- Teks dengan awalan 'loc:' akan mencari terjemahan di sini.
local Localization = WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            -- Strings UI Umum
            ["MAIN_TITLE"] = "WindUI Showcase",
            ["WELCOME_MSG"] = "Welcome to WindUI!",
            ["LIB_DESC"] = "A powerful and beautiful UI library for Roblox.",
            ["UI_SETTINGS"] = "UI Settings",
            ["APPEARANCE"] = "Appearance",
            ["MAIN_FEATURES"] = "Main Features",
            ["UTILITIES"] = "Utilities",
            ["CONFIGURATION"] = "Configuration Manager",
            ["SAVE_CONFIG"] = "Save Current Config",
            ["LOAD_CONFIG"] = "Load Saved Config",
            ["THEME_SELECT"] = "Select UI Theme",
            ["TRANSPARENCY"] = "Window Transparency",
            ["LOCKED_FEATURE"] = "Locked Feature",
            ["GET_STARTED"] = "Get Started",
        }
    }
})

-- Menentukan pengaturan awal untuk UI.
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Fungsi pembantu untuk membuat teks dengan efek gradient.
local function createGradientText(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

-- Menampilkan pop-up sambutan saat skrip pertama kali dimuat.
WindUI:Popup({
    Title = createGradientText("loc:WELCOME_MSG", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "loc:LIB_DESC",
    Buttons = {
        {
            Title = "loc:GET_STARTED",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

-- ==================== SETUP JENDELA UI UTAMA ====================
local Window = WindUI:CreateWindow({
    Title = "loc:MAIN_TITLE",
    Icon = "geist:window",
    Author = "loc:WELCOME_MSG",
    Folder = "WindUI_Showcase_Config", -- Folder konfigurasi untuk showcase ini
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    
    HidePanelBackground = false,
    NewElements = false,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "User profile clicked!",
                Duration = 3
            })
        end
    },
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
    
    OpenButton = {
        Title = "Open WindUI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"), 
            Color3.fromHex("#e7ff2f")
        ),
    },
})

-- Pengaturan tampilan tambahan untuk jendela UI.
Window.User:SetAnonymous(true)
Window:SetIconSize(48)

-- Menambahkan tag informasi ke jendela UI.
Window:Tag({ Title = "v" .. WindUI.Version, Color = Color3.fromHex("#30ff6a") })
Window:Tag({ Title = "Active", Color = Color3.fromHex("#315dff") })

-- Tag untuk menampilkan waktu, dengan efek warna pelangi.
local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 0,
    Color = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF0F7B"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F89B29"), Transparency = 0 },
    }, { Rotation = 45, }),
})

-- Task untuk memperbarui waktu dan efek warna pelangi.
local hue = 0
task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		
		hue = (hue + 0.01) % 1
		local rainbowColor = Color3.fromHSV(hue, 1, 1)
		
		TimeTag:SetTitle(hours .. ":" .. minutes)
		TimeTag:SetColor(rainbowColor)

		task.wait(0.06)
	end
end)

-- Menambahkan tombol ke topbar untuk mengganti tema (terang/gelap).
Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

-- Membuat bagian-bagian utama di sidebar.
local Sections = {
    Features = Window:Section({ Title = "loc:MAIN_FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:UI_SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true })
}

-- Membuat tab-tab dalam bagian-bagian tersebut.
local Tabs = {
    Features = Sections.Features:Tab({ Title = "loc:MAIN_FEATURES", Icon = "layout-grid", Desc = "Explore all available UI components." }),
    Appearance = Sections.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush", Desc = "Customize the look and feel of the UI." }),
    Config = Sections.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings", Desc = "Save and load your preferences." }),
    -- Contoh tab yang dikunci, untuk demonstrasi fitur 'locked tab'.
    LockedTab1 = Window:Tab({ Title = "loc:LOCKED_FEATURE", Icon = "lock", Locked = true, }),
    LockedTab2 = Window:Tab({ Title = "loc:LOCKED_FEATURE", Icon = "lock", Locked = true, }),
}

-- ==================== TAB: MAIN FEATURES ====================
Tabs.Features:Section({
    Title = "Interactive Components",
    TextSize = 20,
    TextTransparency = 0,
})

Tabs.Features:Section({
    Title = "Explore WindUI's powerful elements and how they work.",
    TextSize = 16,
    TextTransparency = .25,
})

Tabs.Features:Divider()

local DemoElementsSection = Tabs.Features:Section({
    Title = "General Controls",
    Icon = "puzzle",
    TextXAlignment = "Center",
    Opened = true,
    Box = true,
})

-- Contoh elemen Toggle.
local featureToggleState = false
local featureToggle = DemoElementsSection:Toggle({
    Title = "Activate Feature",
    Desc = "Toggles an example feature on or off.",
    Flag = "featureToggle",
    Value = false,
    Callback = function(state) 
        featureToggleState = state
        WindUI:Notify({
            Title = "Feature Status",
            Content = state and "Feature Activated" or "Feature Deactivated",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

-- Contoh elemen Slider.
local intensitySlider = DemoElementsSection:Slider({
    Title = "Effect Intensity",
    Desc = "Adjust the strength of an example effect.",
    Flag = "intensitySlider",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        WindUI:Notify({
            Title = "Intensity Set",
            Content = "Value: " .. math.floor(value),
            Duration = 1
        })
    end
})
intensitySlider:SetMin(20)
intensitySlider:SetMax(200)
intensitySlider:Set(100)

local dropdownValues = {}
local dropdownValuesRefresh = {}

-- Mengumpulkan nama ikon Lucide untuk dropdown.
local iconNames = {}
for name, _ in pairs(WindUI.Creator.Icons.Icons.lucide) do table.insert(iconNames, name) end

for i = 1, 10 do
    local randomIcon = iconNames[math.random(1, #iconNames)]
    table.insert(dropdownValues, {Title = "Option " .. i, Icon = randomIcon})
end

for i = 1, 2 do
    table.insert(dropdownValuesRefresh, {Title = "New Option " .. i, Icon = "zap"})
end

DemoElementsSection:Space()

-- Contoh elemen Dropdown.
local dropdown1 = DemoElementsSection:Dropdown({
    Title = "Icon Dropdown",
    Desc = "Select an option with an associated icon.",
    Values = dropdownValues,
    Flag = "dropdown1",
    SearchBarEnabled = true,
    Value = "Option 1",
    Callback = function(option)
        WindUI:Notify({
            Title = "Dropdown Selection",
            Content = "Selected: "..option.Title.." (Icon: "..option.Icon..")",
            Duration = 2
        })
    end
})

local dropdown2 = DemoElementsSection:Dropdown({
    Title = "Basic Dropdown",
    Desc = "Demonstrates a dropdown with simple text options.",
    Flag = "dropdown2", 
    Values = {
        { Title = "Choice Alpha", Icon = "alpha" },
        { Title = "Choice Beta", Icon = "beta" },
        { Title = "Choice Gamma", Icon = "gamma" },
    },
    SearchBarEnabled = true,
    Value = "Choice Alpha",
    Callback = function(option)
        WindUI:Notify({
            Title = "Dropdown Selection",
            Content = "Selected: "..option.Title,
            Duration = 2
        })
    end
})

local dropdown3 = DemoElementsSection:Dropdown({
    Title = "Dynamic Dropdown",
    Desc = "This dropdown's options can be changed dynamically.",
    Flag = "dropdown3", 
    Values = {},
    SearchBarEnabled = true,
    Value = "New Option 1", -- Default value after refresh
    Callback = function(option)
        WindUI:Notify({
            Title = "Dropdown Selection",
            Content = "Selected: "..option.Title,
            Duration = 2
        })
    end
})

dropdown3:Refresh(dropdownValuesRefresh)

DemoElementsSection:Divider()

-- Contoh elemen Button.
DemoElementsSection:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "Hello from WindUI!",
            Content = "This is a sample notification from the library.",
            Icon = "sparkles",
            Duration = 3
        })
    end
})

-- Contoh elemen Colorpicker.
DemoElementsSection:Colorpicker({
    Title = "Select Accent Color",
    Desc = "Choose a custom color for UI elements.",
    Default = Color3.fromHex("#30ff6a"),
    Transparency = 0,
    Callback = function(color, transparency)
        WindUI:Notify({
            Title = "Color Changed",
            Content = "New color: "..color:ToHex().."\nTransparency: "..transparency,
            Duration = 2
        })
    end
})

-- Contoh elemen Code Block.
DemoElementsSection:Code({
    Title = "Code Snippet",
    Desc = "A preview of code that can be copied to your clipboard.",
    Code = [[print("Hello world from WindUI!")
-- This is a simple Lua code snippet.
local uiMessage = "Enjoy using WindUI!"
for i = 1, 2 do 
    print(uiMessage .. " Iteration: " .. i)
end
]],
    OnCopy = function()
        WindUI:Notify({
            Title = "Code Copied",
            Content = "Code snippet copied to clipboard!",
            Duration = 2
        })
    end
})

-- ==================== TAB: APPEARANCE ====================
Tabs.Appearance:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize the visual experience of the UI.",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

-- Mengambil daftar tema yang tersedia.
local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local canchangetheme = true
local canchangedropdown = true

-- Dropdown untuk memilih tema UI.
local themeDropdown = Tabs.Appearance:Dropdown({
    Title = "loc:THEME_SELECT",
    Desc = "Switch between available UI themes.",
    Values = themes,
    Flag = "themeDropdown",
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = "Dark",
    Callback = function(theme)
        canchangedropdown = false
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "Theme Applied",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
        canchangedropdown = true
    end
})

-- Slider untuk mengatur transparansi jendela UI.
local transparencySlider = Tabs.Appearance:Slider({
    Title = "loc:TRANSPARENCY",
    Desc = "Adjust the overall transparency of the UI window.",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0,
    },
    Flag = "transparencySlider",
    Step = 0.1,
    Callback = function(value)
        Window:SetBackgroundTransparency(value)
        Window:SetBackgroundImageTransparency(value)
    end
})

-- Toggle untuk mode gelap.
local ThemeToggle = Tabs.Appearance:Toggle({
    Title = "Enable Dark Mode",
    Desc = "Toggle between dark and light color schemes.",
    Flag = "ThemeToggle",
    Value = true,
    Callback = function(state)
        if canchangetheme then
            WindUI:SetTheme(state and "Dark" or "Light")
        end
        if canchangedropdown then
            themeDropdown:Select(state and "Dark" or "Light")
        end
    end
})

-- Event handler saat tema UI berubah.
WindUI:OnThemeChange(function(theme)
    canchangetheme = false
    ThemeToggle:Set(theme == "Dark")
    canchangetheme = true
end)

Tabs.Appearance:Button({
    Title = "Create New Theme (Coming Soon)",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "Feature Under Development",
            Content = "This feature is currently under development!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary"
                }
            }
        })
    end
})

-- ==================== TAB: CONFIGURATION ====================
Tabs.Config:Paragraph({
    Title = "loc:CONFIGURATION",
    Desc = "Save and load your UI settings.",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local currentConfigName = "default"
local configFile = nil

-- Input field untuk nama konfigurasi.
local configInput = Tabs.Config:Input({
    Title = "Config Name",
    Desc = "Enter a name for your configuration file.",
    Value = currentConfigName,
    Callback = function(value)
        currentConfigName = value or "default"
    end
})

local ConfigManager = Window.ConfigManager

-- Memastikan ConfigManager tersedia sebelum membuat elemen terkait.
if ConfigManager then
    -- Dropdown untuk memilih konfigurasi yang sudah ada.
    Tabs.Config:Dropdown({
        Title = "Select Saved Config",
        Desc = "Choose a configuration file from your saved list.",
        Values = ConfigManager:AllConfigs(),
        Value = currentConfigName,
        AllowNone = false,
        Callback = function(value)
            currentConfigName = value or "default"
            configInput:Set(currentConfigName)
        end
    })

    ConfigManager:Init(Window)
    
    Tabs.Config:Space({ Columns = 0 })
    
    -- Tombol untuk menyimpan konfigurasi.
    Tabs.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        IconAlign = "Left",
        Justify = "Center",
        Color = Color3.fromHex("315dff"),
        Callback = function()
            configFile = ConfigManager:CreateConfig(currentConfigName)
            
            -- Mendaftarkan semua elemen UI yang ingin disimpan secara otomatis.
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("dropdown1", dropdown1)
            configFile:Register("dropdown2", dropdown2)
            configFile:Register("dropdown3", dropdown3)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            configFile:Register("ThemeToggle", ThemeToggle)
            
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "loc:SAVE_CONFIG", 
                    Content = "Configuration '"..currentConfigName.."' saved successfully!",
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to save configuration '"..currentConfigName.."'.",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Config:Space({ Columns = -1 })

    -- Tombol untuk memuat konfigurasi.
    Tabs.Config:Button({
        Title = "loc:LOAD_CONFIG",
        IconAlign = "Left",
        Justify = "Center",
        Color = Color3.fromHex("315dff"),
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(currentConfigName)
            local loadedData = configFile:Load()
            
            if loadedData then
                -- Memuat status elemen UI yang terdaftar.
                configFile:LoadRegistered()

                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ 
                    Title = "loc:LOAD_CONFIG", 
                    Content = "Configuration '"..currentConfigName.."' loaded. Last save: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                Tabs.Config:Paragraph({
                    Title = "Settings Loaded",
                    Desc = "UI settings have been applied successfully!",
                    Image = "settings-2"
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to load configuration '"..currentConfigName.."'.",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
    
    Tabs.Config:Space({ Columns = 0 })

else
    -- Pesan jika ConfigManager tidak tersedia.
    Tabs.Config:Paragraph({
        Title = "Configuration Manager Unavailable",
        Desc = "This feature requires the ConfigManager component of WindUI to be loaded.",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

-- Footer dengan informasi GitHub.
local footerSection = Window:Section({ Title = "WindUI " .. WindUI.Version })
Tabs.Config:Paragraph({
    Title = "GitHub Repository",
    Desc = "Visit the official WindUI repository for more information.",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/Footagesus/WindUI")
                WindUI:Notify({
                    Title = "Link Copied!",
                    Content = "GitHub link copied to clipboard.",
                    Duration = 2
                })
            end
        }
    }
})

-- ==================== WINDOW EVENT HANDLERS ====================
Window:OnClose(function()
    print("[WindUI Showcase] Window closed. Auto-saving configuration.")
    -- Otomatis menyimpan konfigurasi saat jendela ditutup.
    if ConfigManager and configFile then
        -- Pastikan semua elemen UI yang relevan terdaftar sebelum menyimpan.
        configFile:Register("featureToggle", featureToggle)
        configFile:Register("intensitySlider", intensitySlider)
        configFile:Register("dropdown1", dropdown1)
        configFile:Register("dropdown2", dropdown2)
        configFile:Register("dropdown3", dropdown3)
        configFile:Register("themeDropdown", themeDropdown)
        configFile:Register("transparencySlider", transparencySlider)
        configFile:Register("ThemeToggle", ThemeToggle)
        
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("[WindUI Showcase] Configuration auto-saved on close.")
    end
end)

Window:OnDestroy(function()
    print("[WindUI Showcase] Window destroyed.")
end)

Window:OnOpen(function()
    print("[WindUI Showcase] Window opened.")
end)

-- Mengaktifkan semua elemen (jika ada yang terkunci) untuk akses penuh.
Window:UnlockAll()

-- Pesan konfirmasi bahwa skrip telah dimuat.
print("[WindUI Showcase] Script Loaded Successfully!")
