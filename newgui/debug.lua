--[[
    
    -- hub script
    -- @thejudge1488
]]
local menu, UI, framework, fonts, black_bg, blur_effect, flags, pointers, watermark;
do -- checks
    if (not game:IsLoaded()) then
        repeat game.Loaded:Wait() until game:IsLoaded();
    end;
    --
    do -- initialize menu
        menu = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/VseeTy/robloxScriptt/refs/heads/main/newgui/menu.lua"))();
        UI, framework, fonts, black_bg, blur_effect = menu[1],menu[2],menu[3],menu[4],menu[5];
        flags, pointers = UI.flags, UI.Pointers; getfenv(0)["UI"], getfenv(0)["Flags"], getfenv(0)["Pointers"] = UI, flags, pointers;
        watermark = UI:watermark({ name = 'visual enhancements' });
    end;
    --
    if (not LPH_OBFUSCATED) then
        function LPH_NO_VIRTUALIZE(f) return f end
        function LPH_JIT(...) return ... end
        function LPH_JIT_MAX(...) return ... end
        function LPH_NO_UPVALUES(f) return (function(...) return f(...) end) end
        function LPH_ENCSTR(...) return ... end
        function LPH_ENCNUM(...) return ... end
        function LPH_CRASH() return print(debug.traceback()) end
    end;
end;
-- logic
local renv = getrenv();
local clone, services = clonefunction, framework["services"];
local instance_new, udim2_new, udim_new, vec2_new, color3_rgb, color3_new = clone(renv.Instance.new), clone(renv.UDim2.new), clone(renv.UDim.new), clone(renv.Vector2.new), clone(renv.Color3.fromRGB), clone(renv.Color3.new);
--
local window = UI:window({ name = 'visual enhancements', size = udim2_new(0, 750, 0, 500) });
local tabs = {
    ["misc"] = window:tabs({name = "misc", icon = "http://www.roblox.com/asset/?id=106161162193936", size = udim2_new(0, 35, 0, 35)}),
    ["settings"] = window:tabs({name = "settings", icon = "http://www.roblox.com/asset/?id=133853738117744", size = udim2_new(0, 34, 0, 34)}), -- http://www.roblox.com/asset/?id=11348555035
    ["debug"] = window:tabs({name = "debug", icon = "http://www.roblox.com/asset/?id=11663743444", size = udim2_new(0, 35, 0, 35)})
};
--
do -- main
    local visualenhancements = {};
    visualenhancements.__index = visualenhancements;

    function visualenhancements.new()
        local self = setmetatable({}, visualenhancements);
        self.functions = {};
        return self;
    end;

    -- services
    local Workspace     = services["Workspace"];
    local run_service   = services["runService"];
    local players       = services["players"];
    local uis           = services["userInputService"];
    local tween_service = services["tweenService"];
    local stats         = services["stats"];
    local get_team      = services["teams"];
    local lighting      = services["lighting"];

    -- variables
    local teams         = get_team:GetTeams();
    local camera        = Workspace["CurrentCamera"];
    local viewport_size = camera["ViewportSize"];
    local local_player  = players["LocalPlayer"];
    local lplayer_name  = local_player["Name"];
    local local_char    = local_player.Character or local_player.CharacterAdded:Wait();
    local get_mouse     = local_player:GetMouse();
    local sky           = lighting:FindFirstChildOfClass("Sky") or cloneref(Instance.new("Sky", lighting));
    local color_correct = lighting:FindFirstChildOfClass("ColorCorrectionEffect") or cloneref(Instance.new("ColorCorrectionEffect", lighting));
    local fps           = stats.Workspace["Heartbeat"];
    local ping          = stats.Network.ServerStatsItem["Data Ping"];

    -- extra
    local fov_tick, fov_rotation = tick(), 0;
    local fov_circle, snap_lines, speed_hack, spider_man, info_viewer, skys, sounds = {}, {}, {}, {}, {}, {}, {};

    -- lighting cache
    local lighting_cache = {
        Brightness = game:GetService("Lighting").Brightness;
        ClockTime = game:GetService("Lighting").ClockTime;
        Ambient = game:GetService("Lighting").Ambient;
		OutdoorAmbient = game:GetService("Lighting").OutdoorAmbient;
        FogEnd = game:GetService("Lighting").FogEnd;
        FieldOfView = game:GetService("Workspace").CurrentCamera.FieldOfView
    };

    -- skyboxes
    local skyboxes = {
		["Vaporwave"]      = {"1417494030"; "1417494146"; "1417494253"; "1417494402"; "1417494499"; "1417494643"};
		["Redshift"]       = {"401664839"; "401664862"; "401664960"; "401664881"; "401664901"; "401664936"};
		["Desert"]         = {"1013852"; "1013853"; "1013850"; "1013851"; "1013849"; "1013854"};
		["Blaze"]          = {"150939022"; "150939038"; "150939047"; "150939056"; "150939063"; "150939082"};
		["Among Us"]       = {"5752463190"; "5752463190"; "5752463190"; "5752463190"; "5752463190"; "5752463190"};
		["Space Wave2"]    = {"1233158420"; "1233158838"; "1233157105"; "1233157640"; "1233157995"; "1233159158"};
		["Turquoise Wave"] = {"47974894"; "47974690"; "47974821"; "47974776"; "47974859"; "47974909"};
		["Dark Night"]     = {"6285719338"; "6285721078"; "6285722964"; "6285724682"; "6285726335"; "6285730635"};
		["Bright Pink"]    = {"271042516"; "271077243"; "271042556"; "271042310"; "271042467"; "271077958"};
        ["Oblivion Lost"]  = {"5103110171", "5102993828", "5103111020", "5103112417", "5103113734", "5102993828"},
        ["Setting Sun"]    = {"626460377", "626460216", "626460513", "626473032", "626458639", "626460625"},
	};

    -- esp library
    local highlight_player = nil;
    local player_esp = {
        player_cache = {},
        drawing_cache = {},

        childadded_connections = {},
        childremoved_connections = {},
        functions = {},
    };

    -- targetting
    local aiming, entry, closest_part = false;
    local target_enhancements = {
        target = {
            entry = nil,
            part = nil,
            distance = math.huge
        },
    };

    do -- create tables
        for v in pairs(skyboxes) do table.insert(skys, v) end;
        --for name in pairs(hit_sounds) do table.insert(sounds, name) end
    end

    do -- handling
        local function assist_keybind(input)
            return input.UserInputType == flags["Aim-Assist Keybind"] or input.KeyCode == flags["Aim-Assist Keybind"];
        end;

        uis.InputBegan:Connect(function(input, processed)
            if (not processed and assist_keybind(input)) then
                aiming = true;
            end;
        end);
        
        uis.InputEnded:Connect(function(input, processed)
            if (not processed and assist_keybind(input)) then
                aiming = false;
            end;
        end);
        --
        local_player.CharacterAdded:Connect(function(character)
            local_char = character;
        end);
    end;

    do -- initialize main
        local enhancements = visualenhancements.new();
        do -- functions
            -- 
            player_esp.functions.is_visible = function(character)
                if not character or character == local_player.Character then
                    return false;
                end;
            
                local part = character.PrimaryPart
                if not part then return false end
            
                local raycast_params = RaycastParams.new()
                raycast_params.FilterType = Enum.RaycastFilterType.Blacklist
                raycast_params.FilterDescendantsInstances = {local_player.Character, camera};
            
                local RaycastResult = workspace:Raycast(camera.CFrame.p, (part.Position - camera.CFrame.p).Unit * 10000, raycast_params)
                return RaycastResult and RaycastResult.Instance and RaycastResult.Instance:IsDescendantOf(character)
            end;         
            --
            local function cache_character_parts(character)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return {} end

                if humanoid.RigType == Enum.HumanoidRigType.R6 then
                    return { "Head", "Torso", "LeftLeg", "RightLeg", "LeftArm", "RightArm" };
                elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
                    return { "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftLeg", "RightLeg", "LeftFoot", "RightFoot" };
                end
                return {};
            end;
            --
            player_esp.functions.get_player = function()
                target_enhancements.target.entry = nil
                target_enhancements.target.part = nil
                target_enhancements.target.distance = flags["Enable FOV"] and flags["FOV Radius"] / math.tan(math.rad(camera.FieldOfView / 2)) or math.huge
            
                local mouse_position, cam_position = uis:GetMouseLocation(), camera.CFrame.Position
                local closest_entry, closest_part = nil, nil
                local part_cache = {}
                local ignore_team_check = #teams == 0 or (#teams == 1 and flags["Friendly Check"])
            
                for _, player in ipairs(players:GetPlayers()) do
                    if player == local_player then continue end;
                    local character = player.Character;
                    if character and character:FindFirstChild("Humanoid") then
                        if not flags["Friendly Check"] or ignore_team_check or player ~= local_player and (not player.Team or not local_player.Team or player.Team ~= local_player.Team) then
                        else
                            continue;
                        end;
            
                        if (not part_cache[player]) then
                            part_cache[player] = cache_character_parts(character);
                        end;
            
                        local bones_to_check = flags["Aimbot Bone"] == "Random" and part_cache[player] or { flags["Aimbot Bone"] }
                        for _, part_name in ipairs(bones_to_check) do
                            local part = character:FindFirstChild(part_name);
                            if part then
                                local screen_pos, on_screen = camera:WorldToViewportPoint(part.Position)
                                if on_screen then
                                    local mouse_distance = (Vector2.new(screen_pos.X, screen_pos.Y) - Vector2.new(mouse_position.X, mouse_position.Y)).Magnitude
                                    local distance_to_target = (part.Position - cam_position).Magnitude / 3.57
                                    local is_part_visible = not flags["Visible Check"] or (player ~= local_player and player_esp.functions.is_visible(character))
                                    if distance_to_target <= (flags["Aimbot Max Distance"] or math.huge) and is_part_visible then
                                        if mouse_distance < target_enhancements.target.distance or (mouse_distance == target_enhancements.target.distance and distance_to_target < (target_enhancements.target.part and (target_enhancements.target.part.Position - cam_position).Magnitude or math.huge)) then
                                            closest_entry = player
                                            closest_part = part
                                            target_enhancements.target.distance = mouse_distance
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            
                return closest_entry, closest_part;
            end; 
            --
            player_esp.functions.create_drawing = function(class, prop, ...)
                local inst = (typeof(class) == "string") and (instance_new(class)) or (class);
                for property, val in pairs(prop) do
                    inst[property] = val;
                end
                for _, t in {...} do
                    table.insert(t, inst);
                end
                return inst;
            end;
            --
            player_esp.functions.get_boundings = function(model)
                local hrp = model:FindFirstChild("HumanoidRootPart");
                if hrp then
                    local cframe, size = model:GetBoundingBox();
                    size = Vector3.new(math.min(size.X, 2.5), math.min(size.Y, 6), math.min(size.Z, 5));
                    return hrp.CFrame, size, hrp.Position;
                end;
                return nil;
            end;        
            --
            player_esp.functions.get_tool = function(player)
                if not player or not player.Character then
                    return "No Item";
                end;

                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") then 
                        return tool.Name;
                    end;
                end;
            
                return "No Item"
            end;          
        end;
        --
        do -- player esp
            player_esp.update_player_ESP = function(player)
                if (player.Name == lplayer_name) then
                    return;
                end;
                --
                local esp_holder = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), Name = "esp_holder" });
                local arrows_holder = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), Name = "arrows_holder", IgnoreGuiInset = true });
                local drawings = {
                    -- text
                    name = player_esp.functions.create_drawing("TextLabel", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = color3_rgb(0, 0, 0),
                        FontFace = fonts.proggytiny,
                        TextSize = 9,
                        Text = player.DisplayName,
                        TextXAlignment = Enum.TextXAlignment.Center
                    }),
                    distance = player_esp.functions.create_drawing("TextLabel", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = color3_rgb(0, 0, 0),
                        FontFace = fonts.proggytiny,
                        TextSize = 9,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    weapon = player_esp.functions.create_drawing("TextLabel", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = color3_rgb(0, 0, 0),
                        FontFace = fonts.proggytiny,
                        TextSize = 9,
                        TextXAlignment = Enum.TextXAlignment.Center
                    }),
                    -- text strokes
                    name_stroke = player_esp.functions.create_drawing("UIStroke", { -- fade out
                        Thickness = 1,
                        LineJoinMode = Enum.LineJoinMode.Round,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = Color3.fromRGB(0, 0, 0)
                    }),
                    distance_stroke = player_esp.functions.create_drawing("UIStroke", {
                        Thickness = 1,
                        LineJoinMode = Enum.LineJoinMode.Round,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = Color3.fromRGB(0, 0, 0)
                    }),
                    weapon_stroke = player_esp.functions.create_drawing("UIStroke", {
                        Thickness = 1,
                        LineJoinMode = Enum.LineJoinMode.Round,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = Color3.fromRGB(0, 0, 0)
                    }),
                    -- box
                    box = player_esp.functions.create_drawing("Frame", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        ZIndex = -999
                    }),
                    box2 = player_esp.functions.create_drawing("Frame", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        ZIndex = 999
                    }),
                    Outline = player_esp.functions.create_drawing("UIStroke", {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 3,
                        Transparency = 0,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Enabled = true
                    }),
                    Outline2 = player_esp.functions.create_drawing("UIStroke", {
                        Thickness = 1,
                        Enabled = true,
                        LineJoinMode = Enum.LineJoinMode.Miter
                    }),
                    -- healthbar
                    BehindHealthbar = player_esp.functions.create_drawing("Frame", {
                        Parent = esp_holder,
                        ZIndex = -1,
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        BackgroundTransparency = 0,
                        BorderSizePixel = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0)
                    }),
                    Healthbar = player_esp.functions.create_drawing("Frame", {
                        Parent = esp_holder,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0,
                        BorderSizePixel = 0
                    }),
                    HealthbarGradient = player_esp.functions.create_drawing("UIGradient", {
                        Enabled = true,
                        Rotation = -90
                    }),
                    -- arrow
                    Arrow = player_esp.functions.create_drawing("ImageLabel", {
                        Parent = arrows_holder,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5)
                    }),
                    -- icon top
                    icon_top = player_esp.functions.create_drawing("ImageLabel", {
                        Image = "rbxassetid://14239914881",
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5)
                    }),
                    -- flags
                    flag1 = player_esp.functions.create_drawing("TextLabel", {
                        Parent = esp_holder,
                        BackgroundTransparency = 1,
                        TextStrokeTransparency = 0,
                        TextColor3 = Color3.fromRGB(0, 255, 0),
                        TextStrokeColor3 = color3_rgb(0, 0, 0),
                        FontFace = fonts.smallest_pixel,
                        TextSize = 9,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    flag1_stroke = player_esp.functions.create_drawing("UIStroke", {
                        Thickness = 1,
                        LineJoinMode = Enum.LineJoinMode.Round,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = Color3.fromRGB(0, 0, 0)
                    }),
                };
                --
                local linepos = function(frame, from, to, thickness, plrpos)
                    local c = (from + to) / 2
                    local o = to - from + Vector2.new(0, 1)
                    local d = (plrpos - camera.CFrame.p).Magnitude
                    frame.Position = UDim2.new(0, c.X, 0, c.Y)
                    frame.Rotation = math.atan2(o.Y, o.X) * 180 / math.pi
                
                    frame.Size = UDim2.new(0, o.Magnitude, 0, thickness)
                end;
                --
                local function createline()
                    local frame = Instance.new("Frame", esp_holder)
                    frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    frame.ZIndex = -999
                    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    frame.BorderSizePixel = 0
                    frame.Visible = false
                    return frame
                end;                
                --
                drawings.name_stroke.Parent = drawings.name;
                drawings.distance_stroke.Parent = drawings.distance;
                drawings.weapon_stroke.Parent = drawings.weapon;
                drawings.flag1_stroke.Parent = drawings.flag1;
                drawings.HealthbarGradient.Parent = drawings.Healthbar;
                drawings.Outline.Parent = drawings.box;
                drawings.Outline2.Parent = drawings.box2;
                --
                table.insert(player_esp.drawing_cache, {
                    name = drawings.name,
                    distance = drawings.distance,
                    weapon = drawings.weapon,
                    box = drawings.box,
                    flag1 = drawings.flag1,
                    box2 = drawings.box2,
                    healthbar = drawings.BehindHealthbar,
                    healthbar2 = drawings.Healthbar,
                    Arrow = drawings.Arrow,
                    icon_top = drawings.icon_top,
                    esp_holder = esp_holder,
                    arrows_holder = arrows_holder,
                    update_conn = nil,
                    player = player
                });
                --
                local bounds;
                local function destroy_esp()
                    bounds = { player_esp.functions.get_boundings(player.Character) };

                    local steps = 25;
                    for i = 1, steps do
                        for _, v in ipairs({"name", "flag1", "icon_top", "name_stroke", "box", "distance", "distance_stroke", "weapon", "weapon_stroke", "Outline", "Outline2", "BehindHealthbar", "Healthbar", "Arrow"}) do
                            local drawing = drawings[v];
                            if drawing:IsA("TextLabel") then
                                drawing.TextStrokeTransparency = i / steps;
                                drawing.TextTransparency = i / steps;
                            elseif drawing:IsA("UIStroke") then
                                drawing.Transparency = i / steps;
                            elseif drawing:IsA("Frame") then
                                drawing.BackgroundTransparency = i / steps;
                            end;
                        end;
                        wait(1 / steps);
                    end;

                    bounds = nil;
                    for _, v in ipairs({"name", "flag1", "icon_top", "box", "box2", "distance", "weapon", "BehindHealthbar", "Healthbar", "Arrow"}) do
                        drawings[v].Visible = false;
                    end;
                end;
                --
                do -- update esp
                    local died_check = false;
                    local tween = {
                        health_start = 0,
                        health_transition_start = 0,
                        health_transition_old = 0,
                        current_health = 0
                    };
                    local parts = {
                        UpperTorso_LowerTorso 		= createline(); UpperTorso_LeftUpperArm 	= createline(); UpperTorso_RightUpperArm 	= createline();
                        LeftUpperArm_LeftLowerArm 	= createline(); LeftLowerArm_LeftHand 		= createline(); LeftUpperLeg_LeftLowerLeg 	= createline(); LeftLowerLeg_LeftFoot 		= createline();
                        RightUpperArm_RightLowerArm = createline(); RightLowerArm_RightHand 	= createline(); RightUpperLeg_RightLowerLeg = createline(); RightLowerLeg_RightFoot 	= createline();
                        LowerTorso_LeftUpperLeg 	= createline(); LowerTorso_RightUpperLeg 	= createline();
                    };
                    local viewangle_parts = {
                        Head 		                = createline();
                    };
                end;

                local cache = player_esp.drawing_cache[#player_esp.drawing_cache];
                cache.update_conn = run_service["RenderStepped"]:Connect((player_esp.update_esp));
            end;

            player_esp.remove_player_ESP = function(player)
                for _, cache in ipairs(player_esp.drawing_cache) do
                    if cache.player == player then
                        if cache.update_conn then
                            cache.update_conn:Disconnect();
                        end;
                        cache.esp_holder:Destroy();
                        cache.arrows_holder:Destroy();
                        table.remove(player_esp.drawing_cache, _);
                        break;
                    end;
                end;
            end;

            player_esp.on_player_added = function(player)
                local connections = {};
                connections.character_added = player.CharacterAdded:Connect(function()
                    player_esp.update_player_ESP(player);
                end);
                connections.character_removing = player.CharacterRemoving:Connect(function()
                    player_esp.remove_player_ESP(player);
                end);

                player_esp.connection_cache = player_esp.connection_cache or {}
                table.insert(player_esp.connection_cache, { player = player, connections = connections });

                if player.Character then
                    player_esp.update_player_ESP(player);
                end;
            end;

            player_esp.handle_existing_players = function()
                local player_list = players:GetPlayers();
                for i = 1, #player_list do
                    local player = player_list[i];
                    if player.Name ~= lplayer_name then
                        player_esp.on_player_added(player);
                    end;
                end;
            end;

            players.PlayerAdded:Connect(player_esp.on_player_added)
            players.PlayerRemoving:Connect(function(player)
                player_esp.remove_player_ESP(player);
                for i, cache in ipairs(player_esp.connection_cache) do
                    if cache.player == player then
                        for _, conn in pairs(cache.connections) do
                            conn:Disconnect();
                        end;
                        table.remove(player_esp.connection_cache, i);
                        break;
                    end;
                end;
            end);

            player_esp.handle_existing_players();
        end;
        --
        do -- UI
            --
            do -- settings
                do -- menu
                    local settings = tabs["settings"]:section({name = "settings", side = "left"});
                    --
                    settings:keybind({name = "Menu Keybind", description = "Open/Hide Menu", default = UI.ui_key, usekey = true, ignore = true, callback = function(state) UI.ui_key = state end});
                    settings:toggle({name = "Watermark", description = "Shows watermark", default = true, flag = "show watermark", callback = function(state) watermark:SetVisible(state); end});
                    settings:toggle({name = "Keybinds", description = "Shows keybinds", default = false, flag = "show keybinds", callback = function(state) UI.keybind_list:SetVisible(state) end});
                    settings:toggle({name = "Unlock FPS", description = "No-FPS Cap", default = false, flag = "unlock fps", callback = function(state) setfpscap(999) end});
                    settings:slider({name = "Horizontal", min = 0, max = 100, default = 50, decimals = 1, suffix = "px", flag = "watermark_x", callback = function(state) watermark:Position(state / 100, nil) end});
                    settings:slider({name = "Vertical", min = 0, max = 100, default = 5, decimals = 1, suffix = "px", flag = "watermark_y", callback = function(state) watermark:Position(nil, state / 100) end});
                    settings:dropdown({name = "Menu Font", description = "Custom fonts for Menu", options = {"Proggy", "Templeos", "Pixel", "Rubik",}, default = "Rubik", flag = "Menu Fonts", callback = function(state)
                        local fonts = {
                            ["Proggy"] = {fonts.proggytiny, 9},
                            ["Templeos"] = {fonts.templeos, 6},
                            ["Pixel"] = {fonts.smallest_pixel, 9},
                            Rubik = {Font.new([[rbxassetid://12187365977]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal), 12},
                        };
                        for _, v in ipairs({UI.menu_gui, UI.watermark_gui, UI.keybind_screen_gui}) do
                            for _, obj in ipairs(v:GetDescendants()) do
                                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                                    obj.FontFace, obj.TextSize = table.unpack(fonts[state]);
                                end;
                            end;
                        end;
                    end});
                end;
                --
                do -- extra
                    local extra = tabs["settings"]:section({name = "extra", side = "left"});
                    --
                    extra:button({name = "exit", callback = function()
                        game:Shutdown();
                    end});
                    --
                    extra:button({name = "rejoin", callback = function()
                        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, local_player); end);
                    end});
                end;
                --
                do -- presets
                    local presets = tabs["settings"]:section({name = "configs", side = "center"});
                    --
                    presets:textbox({ flag = "cfg_name", name = "config name" });
                    local ConfigList = presets:listbox({ flag = "cfg_list", options = {}, scrollingmax = 5 });
                    --
                    local CurrentList = {};
                    local function cfg_list()
                        local List = {}
                        for _, file in ipairs(listfiles("CONFIGS")) do
                            List[#List + 1] = file:match("CONFIGS\\(.*)%.cfg");
                        end;
                        if #List ~= #CurrentList or table.concat(List) ~= table.concat(CurrentList) then
                            CurrentList = List;
                            ConfigList:Refresh(CurrentList);
                        end;
                    end;
                    --
                    presets:button({ Name = "create", Callback = function()
                        pcall(function()
                            local config_name = flags["cfg_name"];
                            if config_name ~= "" and not isfile("CONFIGS/" .. config_name .. ".cfg") then
                                writefile("CONFIGS/" .. config_name .. ".cfg", UI:GetConfig());
                                --library:notification("created config [".. config_name .."].", 5, color3_new(0, 1, 0))
                                cfg_list()
                            end;
                        end);
                    end});
                    --
                    presets:button({ Name = "save", Callback = function()
                        pcall(function()
                            local selected_config = flags["cfg_list"];
                            if selected_config then
                                writefile("CONFIGS/" .. selected_config .. ".cfg", UI:GetConfig());
                                --library:notification("saved config [".. selected_config .."].", 5, color3_new(0, 1, 0))
                                cfg_list()
                            end;
                        end);
                    end});
                    --
                    presets:button({ Name = "load", Callback = function()
                        pcall(function()
                            local selected_config = flags["cfg_list"];
                            if selected_config then
                                UI:LoadConfig(readfile("CONFIGS/" .. selected_config .. ".cfg"));
                                --library:notification("loaded config [".. selected_config .."].", 5, color3_new(0, 1, 0))
                                cfg_list()
                            end;
                        end);
                    end});
                    --
                    presets:button({ Name = "delete", Callback = function()
                        pcall(function()
                            local selected_config = flags["cfg_list"];
                            if selected_config then
                                delfile("CONFIGS/" .. selected_config .. ".cfg");
                                --library:notification("deleted config [".. selected_config .."].", 5, color3_new(1, 0, 0))
                                cfg_list()
                            end;
                        end);
                    end});
                    cfg_list();
                end;
                --
                do -- themes
                    local themes = tabs["settings"]:section({name = "themes", side = "right"});
                    --
                    themes:listbox({ flag = "theme_list", options = {"Default", "blue baby", "quantum", "off white", "the hub", "fatality", "gamesense"}, scrollingmax = 5})                    
                    themes:button({ name = "load", callback = function()
                        UI:LoadTheme(flags["theme_list"])
                    end})                    
                end;
            end;

            do -- debug
                do -- menu
                    local debug = tabs["debug"]:section({name = "debug", side = "left"});
                    debug:keybind({name = "Keybind 1", description = "This is a keybind", flag = "keybinddebug_key", mode = "Toggle", usekey = false, callback =
                    function()
                        if(flags["keybinddebug_key"] == true or flags["keybinddebug_key"] == false) then
                            print("Callback | Keybind 1 | State : " .. tostring(flags["keybinddebug_key"]))
                        end
                    end});
                    debug:toggle({name = "Toggle 1", description = "This is a toggle", default = false, flag = "toggleAutofarm"});
                    debug:slider({name = "Slider 1", min = 0, max = 100, default = 5, decimals = 1, suffix = "px", flag = "slider1", callback = function(state) print("Callback | Slider1 | Value : " .. state) end});
                    local lastOption = "Left"
                    debug:dropdown({name = "Dropdown 1", description = "This is a dropdown", options = {"Left", "Bottom", "Top"}, default = "Left", flag = "Dropdown1", callback = 
                    function(options)
                        if options ~= lastOption then
                            print("Callback | Dropdown 1 | Status : ".. options)
                            lastOption = options
                        end
                    end});
                    debug:button({ name = "Button 1", callback = function()
                        print("Callback | Button 1 !")
                    end})
                end;
            end;
            do -- misc
                do -- menu
                    local debug = tabs["misc"]:section({name = "misc", side = "left"});
                    debug:keybind({name = "AutoFarm", description = "Put a key", flag = "keybind_autofarm", mode = "Toggle", usekey = false});
                    debug:keybind({name = "AutoSell", description = "Put a key", flag = "keybind_autosell", mode = "Toggle", usekey = false, callback = 
                    function()
                        if flags["keybind_autosell"] then
                            local plr = game.Players.LocalPlayer.Name
                            local plrPos = game.Workspace[plr].HumanoidRootPart.Position
                            local sellPos = Vector3.new(-401.36480712890625, 92.03533172607422, 266.11175537109375)

                            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(sellPos)
                            wait(0.2)
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.SellAll:FireServer()
                            wait(0.2)
                            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(plrPos)
                        end
                    end});
                end;
            end;
        end;
        --
        do -- looping
            --
            local loops = {
                watermark = { e = 0, time = 1.33; },
                --esp = { e = 0, time = 0; },
            };
            --
            do -- connections
                framework.modules.signals.connection(run_service["RenderStepped"], LPH_NO_VIRTUALIZE(function()
                    local time = tick();
                    if (flags["Enable Aim-Assist"]) then
                        entry, closest_part = player_esp.functions.get_player();
                    end;

                    do -- update target
                        if closest_part and (closest_part ~= target_enhancements.target.part) then
                            target_enhancements.target.part = closest_part;
                            target_enhancements.target.entry = entry;
                            target_enhancements.target.distance = (closest_part.Position - camera.CFrame.Position).Magnitude / 3.57;
                        end;
                    end;

                    highlight_player = target_enhancements.target.entry; --- highlight

                    do -- watermark
                        if (flags["show watermark"] and (time - loops.watermark.e >= loops.watermark.time)) then
                            loops.watermark.e = time
                            local selectedTheme, accentColor = UI:GetSelectedThemeAndAccent()
                            local accent = string.format("#%02X%02X%02X", accentColor.R * 255, accentColor.G * 255, accentColor.B * 255)
                            local avg_fps = fps:GetValue()
                            local avg_ping = math.floor(ping:GetValue())
                            local display_game = "Ultime Mining Tycoon"
                            watermark:update_text(string.format(
                                'mScript | PING <font color="%s">%d</font> | FPS <font color="%s">%d</font> | Game <font color="%s">%s</font>',
                                accent, avg_ping, accent, avg_fps, accent, display_game
                            ))
                        end                        
                    end;

                    do -- the stuff
                        if flags["keybind_autofarm"] then
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.RequestRandomOre:FireServer()
                            wait(0.2)
                        end
                        do -- lighting
                            if (flags["luminance"]) then
                                if lighting.Brightness ~= (flags["luminance"] and flags["luminance_amm"] or lighting_cache.Brightness) then
                                    lighting.Brightness = flags["luminance"] and flags["luminance_amm"] or lighting_cache.Brightness;
                                end;
                            else
                                lighting.Brightness = lighting_cache.Brightness;
                            end;

                            if (flags["remove_fog"]) then
                                if lighting.FogEnd ~= 9e9 then
                                    lighting.FogEnd = 9e9;
                                end;
                            else
                                if lighting.FogEnd ~= lighting_cache.FogEnd then
                                    lighting.FogEnd = lighting_cache.FogEnd;
                                end;
                            end;

                            if (flags["force_time"]) then
                                if lighting.ClockTime ~= (flags["force_time"] and flags["clock_time"] or lighting_cache.ClockTime) then
                                    lighting.ClockTime = flags["force_time"] and flags["clock_time"] or lighting_cache.ClockTime
                                end;
                            else
                                lighting.ClockTime = lighting_cache.ClockTime;
                            end;

                            if (flags["ambience"]) then
                                if lighting.Ambient ~= (flags["ambience"] and flags["Ambient Accent"] or lighting_cache.Ambient) then
                                    lighting.Ambient = flags["ambience"] and flags["Ambient Accent"] or lighting_cache.Ambient;
                                end;

                                if lighting.OutdoorAmbient ~= (flags["ambience"] and flags["OutdoorAmbient Accent"] or lighting_cache.OutdoorAmbient) then
                                    lighting.OutdoorAmbient = flags["ambience"] and flags["OutdoorAmbient Accent"] or lighting_cache.OutdoorAmbient;
                                end;
                            else
                                lighting.Ambient = lighting_cache.Ambient;
                                lighting.OutdoorAmbient = lighting_cache.OutdoorAmbient;
                            end;
                        end;
                        -- 
                    end;
                end));
            end;
            --
            do --

            end;
        end;
    end;
end;