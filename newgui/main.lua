local menu, UI, framework, fonts, black_bg, blur_effect, flags, pointers, watermark;
do -- checks
    if (not game:IsLoaded()) then
        repeat game.Loaded:Wait() until game:IsLoaded();
    end;
    --
    do -- initialize menu
        menu = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/X9tL7eQzM2wVp4d/Z4mXe9TrQ1vBp7L/refs/heads/main/newgui/main.lua"))();
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
            function visualenhancements:color_tab()
                do -- esp colors
                    local esp_colors = tabs["colors"]:section({name = "esp", risky = false, side = "left"});
                    --
                    esp_colors:colorpicker({ name = "Name Color", description = "Names color", flag = "Names Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Box Color", description = "Boxes color", flag = "Boxes Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Filled Box Color", description = "Filled Boxes color", flag = "Filled Boxes Accent", default = color3_new(0, 0,0)});
                    local gradient_healthbar = esp_colors:colorpicker({ name = "Healthbar Gradient", description = "Healthbar top", flag = "Healthbar Top Gradient", default = color3_new(0, 1, 0)});
                    gradient_healthbar:colorpicker({ name = "Healthbar Gradient", description = "Healthbar bottom", flag = "Healthbar Bottom Gradient", default = color3_new(1, 0, 0)});
                    esp_colors:colorpicker({ name = "Distance Color", description = "Distances color", flag = "Distance Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Weapon Color", description = "Weapons color", flag = "Weapon Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Arrows Color", description = "Arrows color", flag = "Arrows Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Skeleton Color", description = "Skeleton color", flag = "Skeleton Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "ViewAngle Color", description = "Viewangles color", flag = "ViewAngle Accent", default = color3_new(1, 1, 1)});
                    esp_colors:colorpicker({ name = "Visible Icon Color", description = "Icon color", flag = "Visible Icon Accent", default = color3_new(1, 0, 0)});
                    esp_colors:colorpicker({ name = "Chams Color", description = "Chams color", flag = "Chams Accent", default = color3_new(1, 1, 1)});
                end;
                --
                do -- misc colors
                    local misc_colors = tabs["colors"]:section({name = "misc", risky = false, side = "center"});
                    --

                end;
                --
                do -- lighting colors
                    local lighting_colors = tabs["colors"]:section({name = "lighting", risky = false, side = "right"});
                    --
                    lighting_colors:colorpicker({ name = "Ambient", description = "Ambient color", flag = "Ambient Accent", default = Color3.new(1, 1, 1)});
                    lighting_colors:colorpicker({ name = "Outdoor Ambient", description = "OutdoorAmbient color", flag = "OutdoorAmbient Accent", default = Color3.new(1, 1, 1)});
                    lighting_colors:colorpicker({ name = "Tint Color", description = "Change Tint color", flag = "Tint Color", default = color_correct.TintColor or Color3.fromRGB(255, 255, 255), callback = function(state) color_correct.TintColor = state; end});
                end
                --
                do -- extra colors
                    local extra_colors = tabs["colors"]:section({name = "extra", risky = false, side = "right"});
                    --
                    extra_colors:colorpicker({ name = "Highlight Color", description = "Target color", flag = "Highlight Accent", default = color3_new(1, 0, 0)});
                    extra_colors:colorpicker({ name = "Snaplines Color", description = "Snaplines color", flag = "Snaplines Accent", default = color3_new(1, 1, 1)});
                    extra_colors:colorpicker({ name = "Highlight FOV Color", description = "Target FOV color", flag = "Highlight FOV Accent", default = color3_new(1, 0, 0)});
                    extra_colors:colorpicker({ name = "FOV Filled Color", description = "FOV Filled color", flag = "FOV Filled Accent", default = color3_new(1, 1, 1)});
                    local fov_gradient = extra_colors:colorpicker({ name = "FOV Gradient", description = "FOV color", flag = "FOV Gradient Left", default = color3_new(1, 1, 1)});
                    fov_gradient:colorpicker({ name = "FOV Gradient", description = "FOV color", flag = "FOV Gradient Right", default = color3_new(1, 1, 1)});
                end;
            end;
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
                local chams;
                do -- create chams
                    chams = Instance.new("Highlight", player.Character);
                    chams.Enabled = false;
                end
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
                    chams:Destroy();
                    esp_holder:Destroy();
                    arrows_holder:Destroy();
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
                    --
                    player_esp.update_esp = LPH_NO_VIRTUALIZE(function()
                        local character = player.Character;
                        local humanoid = character and character:FindFirstChild("Humanoid");
                        local hrp = character and character:FindFirstChild("HumanoidRootPart");

                        if humanoid and (humanoid.Health <= 0 and not died_check) then
                            died_check = true;
                            pcall(destroy_esp);
                            return;
                        end;           

                        local cframe, size, position;
                        if bounds then
                            cframe, size, position = unpack(bounds);
                        else
                            cframe, size, position = player_esp.functions.get_boundings(character);
                        end;

                        if (not position) then return end;

                        local max_distance = (camera.CFrame.Position - position).Magnitude / 3.57;

                        if (not character and humanoid and hrp) then return end;
                        
                        do -- ESP
                            if (not flags["ESP Teamcheck"] or (player ~= local_player and (local_player.Team ~= player.Team or not local_player.Team or not player.Team))) then
                                local pos, on_screen = camera:WorldToScreenPoint(position);
                                local height = math.tan(math.rad(camera.FieldOfView / 2)) * 2 * pos.Z;
                                local scale = vec2_new((viewport_size.Y / height) * size.X, (viewport_size.Y / height) * size.Y);

                                do -- fonts
                                    for _, v in ipairs({"name", "distance", "weapon"}) do
                                        local current_font = drawings[v].FontFace;
                                        local new_font, new_size;

                                        if flags["ESP Fonts"] == "Proggy" then
                                            new_font, new_size = fonts.proggytiny, 9;
                                        elseif flags["ESP Fonts"] == "Pixel" then
                                            new_font, new_size = fonts.smallest_pixel, 9;
                                        elseif flags["ESP Fonts"] == "Templeos" then
                                            new_font, new_size = fonts.templeos, 6;
                                        elseif flags["ESP Fonts"] == "Medodica" then
                                            new_font, new_size = fonts.medodica, 14;
                                        end;

                                        if new_font and current_font ~= new_font then
                                            drawings[v].FontFace = new_font;
                                            drawings[v].TextSize = new_size;
                                        end;
                                    end;
                                end;

                                do -- chams
                                    if (on_screen) and flags["Enable Chams"] then
                                        chams.Enabled = true;
                                        chams.DepthMode = flags["Chams Visible Check"] == "Always Visible" and Enum.HighlightDepthMode["AlwaysOnTop"] or Enum.HighlightDepthMode["Occluded"];
                                        chams.FillTransparency = flags["Chams Opacity"] / 100;
                                        chams.OutlineTransparency = flags["Chams Opacity"] / 100;
                                        chams.FillColor = chams.FillColor:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Chams Accent"], 0.02);
                                        chams.OutlineColor = chams.OutlineColor:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Chams Accent"], 0.02);
                                        if (flags["Chams Thermal"]) then
                                            local breathe_effect = math.atan(math.sin(tick() * 3)) * 2 / math.pi
                                            chams.FillTransparency = flags["Chams Opacity"] * breathe_effect * 0.01
                                            chams.OutlineTransparency = flags["Chams Opacity"] * breathe_effect * 0.01
                                        end;
                                    else
                                        chams.Enabled = false;
                                    end;
                                end;

                                do -- view angle
                                    if (on_screen) and flags["Enable ViewAngle"] and character and character:FindFirstChild("Head") then
                                        local head_pos = camera:WorldToScreenPoint(character.Head.Position);
                                        local look_dir = character.Head.CFrame.LookVector;
                                        local line_length = flags["ViewAngle Length"];
                                        local end_pos = character.Head.Position + (look_dir * line_length);
                                        local end_point = camera:WorldToScreenPoint(end_pos);
                                    
                                        local positions = {
                                            Head = Vector2.new(head_pos.X, head_pos.Y),
                                            Look = Vector2.new(end_point.X, end_point.Y),
                                        };
                                    
                                        if (flags["Rainbow Skeletons/ViewAngle"]) then
                                            local hue = (tick() * 0.2) % 1;
                                            local rainbowColor = Color3.fromHSV(hue, 0.5, 1);
                                        
                                            for _, part in pairs(viewangle_parts) do
                                                part.BackgroundColor3 = part.BackgroundColor3:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or rainbowColor, 0.02)
                                            end;
                                        else
                                            for _, part in pairs(viewangle_parts) do
                                                part.BackgroundColor3 = part.BackgroundColor3:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["ViewAngle Accent"], 0.02)
                                            end;
                                        end;    
                                    
                                        if (flags["Outline Skeletons/ViewAngle"]) then
                                            for _, part in pairs(viewangle_parts) do
                                                part.BorderSizePixel = 1;
                                            end;
                                        else
                                            for _, part in pairs(viewangle_parts) do
                                                part.BorderSizePixel = 0;
                                            end;
                                        end;
                                    
                                        if (viewangle_parts.Head) then
                                            linepos(viewangle_parts.Head, positions.Head, positions.Look, 1, character.Head.Position);
                                            for _, part in pairs(viewangle_parts) do
                                                part.Visible = true;
                                            end;
                                        end;
                                    else
                                        for _, part in pairs(viewangle_parts) do
                                            part.Visible = false;
                                        end;
                                    end;                                                                                                                                                                                                                                                                                      
                                end;

                                do -- skeletons
                                    if (on_screen) and flags["Enable Skeletons"] and character and character:FindFirstChild("UpperTorso") and character:FindFirstChild("HumanoidRootPart") then
                                        local get_parts = {
                                            "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
                                            "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                                            "RightUpperLeg", "RightLowerLeg", "RightFoot"
                                        };
                                    
                                        for _, v in pairs(get_parts) do
                                            if not character:FindFirstChild(v) then
                                                return;
                                            end
                                        end
                                    
                                        local positions = {}
                                        for _, v in pairs(get_parts) do
                                            local world_pos = character[v].Position;
                                            local screenPos, onScreen = camera:WorldToScreenPoint(world_pos);
                                    
                                            if onScreen and screenPos.Z > 0 then
                                                positions[v] = Vector2.new(screenPos.X, screenPos.Y);
                                            else
                                                return;
                                            end;
                                        end;

                                        local border_size = flags["Outline Skeletons/ViewAngle"] and 1 or 0;
                                        for _, part in pairs(parts) do
                                            part.BorderSizePixel = border_size;
                                        end;

                                        local target_color;
                                        if flags["Rainbow Skeletons/ViewAngle"] then
                                            local hue = (tick() * 0.2) % 1;
                                            target_color = Color3.fromHSV(hue, 0.5, 1);
                                        else
                                            target_color = flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"] or flags["Skeleton Accent"];
                                        end;
                                    
                                        for _, part in pairs(parts) do
                                            part.BackgroundColor3 = part.BackgroundColor3:Lerp(target_color, 0.02);
                                        end;
                                    
                                        local root = character.HumanoidRootPart.Position
                                        linepos(parts.UpperTorso_LowerTorso, positions.UpperTorso, positions.LowerTorso, flags["Skeleton Thickness"], root);
                                        linepos(parts.UpperTorso_LeftUpperArm, positions.UpperTorso, positions.LeftUpperArm, flags["Skeleton Thickness"], root);
                                        linepos(parts.LeftUpperArm_LeftLowerArm, positions.LeftUpperArm, positions.LeftLowerArm, flags["Skeleton Thickness"], root);
                                        linepos(parts.LeftLowerArm_LeftHand, positions.LeftLowerArm, positions.LeftHand, flags["Skeleton Thickness"], root);
                                        linepos(parts.UpperTorso_RightUpperArm, positions.UpperTorso, positions.RightUpperArm, flags["Skeleton Thickness"], root);
                                        linepos(parts.RightUpperArm_RightLowerArm, positions.RightUpperArm, positions.RightLowerArm, flags["Skeleton Thickness"], root);
                                        linepos(parts.RightLowerArm_RightHand, positions.RightLowerArm, positions.RightHand, flags["Skeleton Thickness"], root);
                                        linepos(parts.LowerTorso_LeftUpperLeg, positions.LowerTorso, positions.LeftUpperLeg, flags["Skeleton Thickness"], root);
                                        linepos(parts.LeftUpperLeg_LeftLowerLeg, positions.LeftUpperLeg, positions.LeftLowerLeg, flags["Skeleton Thickness"], root);
                                        linepos(parts.LeftLowerLeg_LeftFoot, positions.LeftLowerLeg, positions.LeftFoot, flags["Skeleton Thickness"], root);
                                        linepos(parts.LowerTorso_RightUpperLeg, positions.LowerTorso, positions.RightUpperLeg, flags["Skeleton Thickness"], root);
                                        linepos(parts.RightUpperLeg_RightLowerLeg, positions.RightUpperLeg, positions.RightLowerLeg, flags["Skeleton Thickness"], root);
                                        linepos(parts.RightLowerLeg_RightFoot, positions.RightLowerLeg, positions.RightFoot, flags["Skeleton Thickness"], root);

                                        for _, part in pairs(parts) do
                                            part.Visible = true;
                                        end;
                                    else
                                        for _, part in pairs(parts) do
                                            part.Visible = false;
                                        end;
                                    end;                           
                                end;

                                do -- arrows
                                    if (not on_screen) and flags["Enable Arrows"] then
                                        if (hrp) then
                                            drawings.Arrow.Visible = true;
                                            drawings.Arrow.Size = UDim2.new(0, flags["Arrow Size"], 0, flags["Arrow Size"]);
                                            drawings.Arrow.ImageColor3 = flags["Arrows Accent"];

                                            local center = flags["Arrows From"] == "Screen" and viewport_size / 2 or uis:GetMouseLocation();
                                            local proj = camera.CFrame:PointToObjectSpace(hrp.Position);
                                            local angle = math.atan2(proj.Z, proj.X);
                                            local circularX = center.X + math.cos(angle) * flags["OOF Radius"];
                                            local circularY = center.Y + math.sin(angle) * flags["OOF Radius"];

                                            drawings.Arrow.Image = (flags["Arrow Points"] == "Three") and "http://www.roblox.com/asset/?id=282305485" or "http://www.roblox.com/asset/?id=15000587389";
                                            drawings.Arrow.Position = UDim2.new(0, circularX - drawings.Arrow.Size.X.Offset / 2, 0, circularY - drawings.Arrow.Size.Y.Offset / 2);
                                            drawings.Arrow.Rotation = math.deg(angle) + 90;
                                            drawings.Arrow.ImageTransparency = (math.sin(tick() * 2) * 0.5 + 0.5);
                                        else
                                            drawings.Arrow.Visible = false;
                                        end;
                                    else
                                        drawings.Arrow.Visible = false;
                                    end;
                                end;

                                do -- top icon
                                    if (on_screen) and flags["Enable Visible Icons"] then
                                        if player_esp.functions.is_visible(character) then
                                            drawings.icon_top.Image = "rbxassetid://14239914881";
                                            drawings.icon_top.ImageColor3 = drawings.icon_top.ImageColor3:Lerp(Color3.fromRGB(0, 255, 0), 0.02);
                                        else
                                            drawings.icon_top.Image = "rbxassetid://14239920245";
                                            drawings.icon_top.ImageColor3 = drawings.icon_top.ImageColor3:Lerp(flags["Visible Icon Accent"], 0.02);
                                        end;
                                        drawings.icon_top.Visible = true;
                                        drawings.icon_top.Position = udim2_new(0, pos.X, 0, pos.Y - scale.Y / 2 - 25);
                                        drawings.icon_top.Size = UDim2.new(0, 28, 0, 28);
                                    else
                                        drawings.icon_top.Visible = false;
                                    end;
                                end;

                                do -- flags
                                    if (on_screen) and flags["Enable Flags"] then
                                        local box_side = pos.X + (scale.X / 2);
                                        local box_top = pos.Y - (scale.Y / 2);
                                        if (table.find(flags["Flags Type"], "Visible") and player_esp.functions.is_visible(character)) then
                                            drawings.flag1.Visible = true;
                                            drawings.flag1.Text = "VIS";
                                            drawings.flag1.Position = UDim2.new(0, box_side + 17, 0, box_top + 3);
                                        else
                                            drawings.flag1.Text = "";
                                            drawings.flag1.Visible = false;
                                        end;
                                    else
                                        drawings.flag1.Visible = false;
                                    end;
                                end;

                                do -- names
                                    if (on_screen) and flags["Enable Names"] then
                                        drawings.name.Visible = true;
                                        drawings.name.TextColor3 = drawings.name.TextColor3:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Names Accent"], 0.02);
                                        drawings.name.Position = udim2_new(0, pos.X, 0, pos.Y - scale.Y / 2 - 7);
                                    else
                                        drawings.name.Visible = false;
                                    end;
                                end;

                                do -- boxes
                                    if (on_screen) and flags["Enable Boxes"] then
                                        drawings.box.Size = UDim2.new(0, scale.X - 1, 0, scale.Y - 1);
                                        drawings.box2.Size = UDim2.new(0, scale.X + 1, 0, scale.Y + 1);

                                        drawings.box.Position = UDim2.new(0, pos.X - (scale.X / 2), 0, pos.Y - (scale.Y / 2) + 3);
                                        drawings.box2.Position = UDim2.new(0, pos.X - (scale.X / 2) - 1, 0, pos.Y - (scale.Y / 2) + 2);

                                        if (flags["Boxes Filled"]) then
                                            drawings.box.BackgroundTransparency = flags["Boxes Filled Opacity"] / 100;
                                            drawings.box.BackgroundColor3 = flags["Filled Boxes Accent"];
                                        else
                                            drawings.box.BackgroundTransparency = 1;
                                        end;

                                        drawings.box.Visible = true;
                                        drawings.box2.Visible = true;
                                        drawings.Outline2.Color = drawings.Outline2.Color:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Boxes Accent"], 0.02);
                                    else
                                        drawings.box.Visible = false;
                                        drawings.box2.Visible = false;
                                    end;
                                end;

                                do -- distances
                                    if (on_screen) and flags["Enable Distances"] then
                                        local bottom_offset = (flags["Enable Healthbar"] and flags["Healthbar Side"] == "Bottom") and 28 or 22;
                                        drawings.distance.Position = UDim2.new(0, pos.X, 0, pos.Y + scale.Y / 2 + bottom_offset);
                                        drawings.distance.TextXAlignment = Enum.TextXAlignment.Center
                                        drawings.distance.Visible = true;
                                        drawings.distance.TextColor3 = drawings.distance.TextColor3:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Distance Accent"], 0.02);
                                        drawings.distance.Text = string.format("%dM", math.floor(max_distance));
                                    else
                                        drawings.distance.Visible = false;
                                    end;
                                end;

                                do -- weapon
                                    if (on_screen) and flags["Enable Weapons"] then
                                        drawings.weapon.Visible = true;
                                        local bottom_offset = (flags["Enable Healthbar"] and flags["Healthbar Side"] == "Bottom") and 17 or 11;
                                        drawings.weapon.Position = UDim2.new(0, pos.X, 0, pos.Y + scale.Y / 2 + bottom_offset);
                                        drawings.weapon.TextColor3 = drawings.weapon.TextColor3:Lerp((flags["Highlight ESP"] and highlight_player == player and flags["Highlight Accent"]) and flags["Highlight Accent"] or flags["Weapon Accent"], 0.02);
                                        drawings.weapon.Text = player_esp.functions.get_tool(player);
                                    else
                                        drawings.weapon.Visible = false;
                                    end;
                                end;

                                do -- healthbar
                                    if (on_screen) and flags["Enable Healthbar"] and humanoid and humanoid.Health then
                                        local health, max_health = math.floor(humanoid.Health), humanoid.MaxHealth
                                        local health_color = Color3.new(1, 0, 0):lerp(Color3.new(0.7, 0.8, 0), math.clamp(health / max_health, 0, 1))
                                        health_color = health_color:lerp(Color3.new(0, 1, 0), math.clamp((health / max_health - 0.5) * 2, 0, 1))
                                        local health_offset = math.floor((max_health - health) / 10) * 0.1

                                        do -- healthbar animation
                                            tween.health_start = tween.health_start or 0
                                            tween.health_transition_start = tween.health_transition_start or health
                                            tween.health_transition_old = tween.health_transition_old or health
                                            tween.current_health = tween.current_health or health

                                            if health ~= tween.health_transition_start then
                                                tween.health_transition_old, tween.health_transition_start, tween.health_start = tween.current_health, health, tick()
                                            end;
                                        end;

                                        local progress = math.clamp((tick() - tween.health_start) / 0.2, 0, 1)
                                        tween.current_health = tween.health_transition_old + (tween.health_transition_start - tween.health_transition_old) * progress

                                        if progress >= 1 then
                                            tween.current_health, tween.health_transition_old, tween.health_transition_start, tween.health_start = health, health, health, 0
                                        end;

                                        drawings.Healthbar.Visible = true
                                        drawings.BehindHealthbar.Visible = true

                                        local bar_width = flags["Healthbar Width"]
                                        local bar_height_adjust = 3
                                        local target_height = scale.Y * (tween.current_health / max_health) + bar_height_adjust
                                        local target_width = scale.X * (tween.current_health / max_health) + bar_height_adjust

                                        if flags["Healthbar Side"] == "Left" then
                                            local bar_offset = 6 + math.max(0, bar_width)
                                            drawings.Healthbar.Position = UDim2.new(0, pos.X - scale.X / 2 - bar_offset, 0, pos.Y - scale.Y / 2 + scale.Y * (1 - tween.current_health / max_health) + 1)
                                            drawings.BehindHealthbar.Position = UDim2.new(0, pos.X - scale.X / 2 - bar_offset, 0, pos.Y - scale.Y / 2 + 1)
                                            drawings.Healthbar.Size = UDim2.new(0, bar_width, 0, target_height)
                                            drawings.BehindHealthbar.Size = UDim2.new(0, bar_width, 0, scale.Y + bar_height_adjust)

                                            drawings.HealthbarGradient.Rotation = -90
                                            health_offset = math.clamp(health_offset, 0, 1)
                                            drawings.HealthbarGradient.Offset = Vector2.new(0, -health_offset)
                                        elseif flags["Healthbar Side"] == "Bottom" then
                                            local bottom_y = pos.Y + scale.Y / 2 + 8
                                            drawings.Healthbar.Position = UDim2.new(0, pos.X - scale.X / 2 - 2, 0, bottom_y)
                                            drawings.BehindHealthbar.Position = UDim2.new(0, pos.X - scale.X / 2 - 2, 0, bottom_y)
                                            drawings.Healthbar.Size = UDim2.new(0, target_width, 0, bar_width)
                                            drawings.BehindHealthbar.Size = UDim2.new(0, scale.X + bar_height_adjust, 0, bar_width)

                                            drawings.HealthbarGradient.Rotation = 0
                                            health_offset = math.clamp(health_offset, 0, 1)
                                            drawings.HealthbarGradient.Offset = Vector2.new(health_offset, 0)
                                        end;

                                        if flags["Lerp Health"] then
                                            drawings.HealthbarGradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, health_color), ColorSequenceKeypoint.new(1, health_color) };
                                        else
                                            drawings.HealthbarGradient.Color = ColorSequence.new{
                                                ColorSequenceKeypoint.new(0, flags["Healthbar Bottom Gradient"]),
                                                ColorSequenceKeypoint.new(1, flags["Healthbar Top Gradient"])
                                            };
                                        end;
                                    else
                                        drawings.Healthbar.Visible = false;
                                        drawings.BehindHealthbar.Visible = false;
                                    end;
                                end;
                                --
                            else
                                for _, v in ipairs({"name", "flag1", "icon_top", "box", "box2", "distance", "weapon", "BehindHealthbar", "Healthbar", "Arrow"}) do
                                    drawings[v].Visible = false;
                                end;
                                for _, part in pairs(parts) do
                                    part.Visible = false;
                                end;   
                                for _, part in pairs(viewangle_parts) do
                                    part.Visible = false;
                                end;
                                chams.Enabled = false;
                            end;
                        end;
                    end);
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
            do -- debug
                do -- menu
                    local debug = tabs["debug"]:section({name = "debug", side = "left"});
                    --
                    debug:keybind({name = "Keybind 1", description = "This is a keybind", default = UI.ui_key, usekey = true, ignore = true, callback = function(state) UI.ui_key = state end});
                    debug:toggle({name = "Toggle 1", description = "This is a toggle", default = false, flag = "toggle1", callback = function(state) setfpscap(999) end});
                    debug:slider({name = "Slider 1", min = 0, max = 100, default = 5, decimals = 1, suffix = "px", flag = "slider1", callback = function(state) print(state) end});
                    debug:dropdown({name = "Dropdown 1", description = "This is a dropdown", options = {"Left", "Bottom"}, default = "Left", flag = "Healthbar Side"});
                    
                end;
                do -- themes
                    local themes = tabs["debug"]:section({name = "themes", side = "center"});
                    --
                    themes:listbox({ flag = "theme_list", options = {"Default", "blue baby", "quantum", "off white", "the hub", "fatality", "gamesense"}, scrollingmax = 5})                    
                    themes:button({ name = "load", callback = function()
                        UI:LoadTheme(flags["theme_list"])
                    end})                    
                end;
            end;
        end;
        --
        do -- drawings
            do -- fov circle
                local FieldOfView = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), IgnoreGuiInset = true });
                local Frame = player_esp.functions.create_drawing("Frame", { Visible = false, BackgroundTransparency = 1, Size = UDim2.new(0, flags["FOV Radius"] * 2, 0, flags["FOV Radius"] * 2), Position = UDim2.new(0, 0, 0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Parent = FieldOfView, ZIndex = 2 });
                local UICorner = player_esp.functions.create_drawing("UICorner", { CornerRadius = udim_new(1, 0), Parent = Frame });
                local Frame2 = player_esp.functions.create_drawing("Frame", { Visible = false, BackgroundTransparency = 1, Size = UDim2.new(0, flags["FOV Radius"] * 2, 0, flags["FOV Radius"] * 2), Position = UDim2.new(0, 0, 0, 0), AnchorPoint = Vector2.new(0.5, 0.5), Parent = FieldOfView, ZIndex = 1 });
                local UICorner2 = player_esp.functions.create_drawing("UICorner", { CornerRadius = udim_new(1, 0), Parent = Frame2 });
                local Stroke = player_esp.functions.create_drawing("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2, Transparency = 0, Parent = Frame })
                local Stroke2 = player_esp.functions.create_drawing("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 4, Transparency = 0, Parent = Frame2 })
                local Gradient = player_esp.functions.create_drawing("UIGradient", {  Parent = Stroke });
                -- returns
                fov_circle.FieldOfView = FieldOfView;
                fov_circle.Frame = Frame;
                fov_circle.Frame2 = Frame2;
                fov_circle.Gradient = Gradient;
                fov_circle.Stroke = Stroke;
                fov_circle.Stroke2 = Stroke2;
            end;
            --
            do -- snaplines
                local snaplines = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), IgnoreGuiInset = true });
                local line = player_esp.functions.create_drawing("Frame", { BackgroundTransparency = 0, AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 2, Parent = snaplines });
                local ui_stroke = player_esp.functions.create_drawing("UIStroke", { Parent = line, Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Enabled = true, Transparency = 0, LineJoinMode = Enum.LineJoinMode.Miter });
                -- returns
                snap_lines.snaplines = snaplines;
                snap_lines.line = line;
                snap_lines.ui_stroke = ui_stroke;
            end;
            --
            do -- flags
                do -- speedhack
                    local speedhack = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), IgnoreGuiInset = true });
                    local text = player_esp.functions.create_drawing("TextLabel", { BackgroundTransparency = 0, AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 2, Position = UDim2.new(0.5, 0, 0.5, 0), TextColor3 = Color3.fromRGB(255, 255, 0), TextStrokeTransparency = 0, TextStrokeColor3 = color3_rgb(0, 0, 0), TextSize = 9, FontFace = fonts.smallest_pixel, Text = "SpeedHack", Parent = speedhack });
                    -- returns
                    speed_hack.speedhack = speedhack;
                    speed_hack.text = text;
                end;
                --
                do -- spiderman
                    local spiderman = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), IgnoreGuiInset = true });
                    local text = player_esp.functions.create_drawing("TextLabel", { BackgroundTransparency = 0, AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 2, Position = UDim2.new(0.5, 0, 0.507, 0), TextColor3 = Color3.fromRGB(255, 0, 0), TextStrokeTransparency = 0, TextStrokeColor3 = color3_rgb(0, 0, 0), TextSize = 9, FontFace = fonts.smallest_pixel, Text = "SpiderClimb", Parent = spiderman });
                    -- returns
                    spider_man.spiderman = spiderman;
                    spider_man.text = text;
                end;
            end;
            -- 
            do -- info viewer
                local infoviewer = player_esp.functions.create_drawing("ScreenGui", { Parent = cloneref(gethui()), IgnoreGuiInset = true });
                local background = player_esp.functions.create_drawing("Frame", { BackgroundTransparency = 0, BorderColor3 = Color3.fromRGB(15, 15, 16), BorderSizePixel = 1, Size = UDim2.new(0, 200, 0, 130), BackgroundColor3 = Color3.fromRGB(7,7,8), AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 99, Parent = infoviewer });
                local icon = player_esp.functions.create_drawing("ImageLabel", { Parent = background, Size = UDim2.new(0, 75, 0, 75), Position = UDim2.new(1, -82, 0, 8), BackgroundTransparency = 1, ZIndex = 999 });
                local UICorner = player_esp.functions.create_drawing("UICorner", { CornerRadius = udim_new(1, 0), Parent = icon });
                local name_label = player_esp.functions.create_drawing("TextLabel", { Parent = background, Size = UDim2.new(0, 75, 0, 20), Position = UDim2.new(1, -82, 0, 8 + 75), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd });          
                local health_label = player_esp.functions.create_drawing("TextLabel", {Parent = background, Size = UDim2.new(0, 200, 0, 20), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left})
                local weapon_label = player_esp.functions.create_drawing("TextLabel", {Parent = background, Size = UDim2.new(0, 200, 0, 20), Position = UDim2.new(0, 10, 0, 28), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left})
                local armor_label = player_esp.functions.create_drawing("TextLabel", {Parent = background, Size = UDim2.new(0, 200, 0, 20), Position = UDim2.new(0, 10, 0, 48), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left})
                local team_label = player_esp.functions.create_drawing("TextLabel", {Parent = background, Size = UDim2.new(0, 200, 0, 20), Position = UDim2.new(0, 10, 0, 68), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left})
                local distance_label = player_esp.functions.create_drawing("TextLabel", {Parent = background, Size = UDim2.new(0, 200, 0, 20), Position = UDim2.new(0, 10, 0, 88), BackgroundTransparency = 1, ZIndex = 999, TextSize = 9, FontFace = fonts.proggytiny, TextColor3 = Color3.fromRGB(255, 255, 255), TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left})
                local healthbar_background = player_esp.functions.create_drawing("Frame", { Parent = background, Size = UDim2.new(0, 190, 0, 8), Position = UDim2.new(0.5, -95, 1, -16), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, ZIndex = 99 });
                local healthbar = player_esp.functions.create_drawing("Frame", { Parent = healthbar_background, Size = UDim2.new(0, 188, 0, 6), Position = UDim2.new(0.5, -94, 0, 1), BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, ZIndex = 100 });
                -- returns
                info_viewer.infoviewer = infoviewer;
                info_viewer.background = background;
                info_viewer.icon = icon;
                info_viewer.name_label = name_label;
                info_viewer.health_label = health_label;
                info_viewer.weapon_label = weapon_label;
                info_viewer.armor_label = armor_label;
                info_viewer.team_label = team_label;
                info_viewer.distance_label = distance_label;         
                info_viewer.healthbar = healthbar;
                info_viewer.healthbar_background = healthbar_background;   
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
            local local_chams_highlight = Instance.new("Highlight");
            local_chams_highlight.Parent = local_char;
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
                            local display_game = "Universal"
                            watermark:update_text(string.format(
                                'Visual Enhancements | PING <font color="%s">%d</font> | FPS <font color="%s">%d</font> | Game <font color="%s">%s</font>',
                                accent, avg_ping, accent, avg_fps, accent, display_game
                            ))
                        end                        
                    end;

                    do -- the stuff
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
                        do -- omni sprint
                            if (flags["Speedhack"] and (uis:IsKeyDown(Enum.KeyCode.W) or uis:IsKeyDown(Enum.KeyCode.A) or uis:IsKeyDown(Enum.KeyCode.S) or uis:IsKeyDown(Enum.KeyCode.D))) then
                                speed_hack.text.Visible = true;

                                local plr_model = local_char;
                                if (plr_model and plr_model:FindFirstChild("HumanoidRootPart")) then
                                    local root = plr_model:FindFirstChild("HumanoidRootPart");
                                    if (root) then
                                        local dir, look = Vector3.new(), camera.CFrame.LookVector;
                        
                                        for k, v in pairs({
                                            [Enum.KeyCode.W] = Vector3.new(look.X, 0, look.Z); 
                                            [Enum.KeyCode.A] = Vector3.new(look.Z, 0, -look.X); 
                                            [Enum.KeyCode.S] = Vector3.new(-look.X, 0, -look.Z); 
                                            [Enum.KeyCode.D] = Vector3.new(-look.Z, 0, look.X)
                                        }) do
                                            if uis:IsKeyDown(k) then 
                                                dir += v;
                                            end;
                                        end;
                        
                                        if (dir.Magnitude > 0) then 
                                            root.Velocity = dir.Unit * flags["Speedhack Speed"] + Vector3.new(0, root.Velocity.Y, 0);
                                        end;
                                    end;
                                end;
                            else
                                speed_hack.text.Visible = false;
                            end;
                        end;       
                        --
                        do -- spiderclimb
                            if (flags["Spiderclimb"] and flags["Spiderclimb Key"]) then
                                spider_man.text.Visible = true;
                                local plr_model = local_char or local_player.CharacterAdded:Wait();
                        
                                if (plr_model and plr_model:FindFirstChild("HumanoidRootPart")) then
                                    local hrp = plr_model.HumanoidRootPart;
                                    local climb_speed = flags["Spiderclimb Speed"];

                                    local current_velocity = hrp.AssemblyLinearVelocity;
                                    local vertical_velocity = Vector3.new(0, climb_speed, 0);
                        
                                    hrp.CFrame = hrp.CFrame * CFrame.new(0, climb_speed * 0.1, 0);
                                    hrp.AssemblyLinearVelocity = Vector3.new(current_velocity.X, vertical_velocity.Y, current_velocity.Z);
                                end;
                            else
                                spider_man.text.Visible = false;
                            end;                 
                        end;                                                                                    
                        -- 
                        do -- noclip
                            if (flags["noclip"] and flags["noclip_key"]) then
                                local plr_model = local_char or local_player.CharacterAdded:Wait();
                                if plr_model then
                                    for _, child in pairs(plr_model:GetDescendants()) do
                                        if child:IsA("BasePart") then
                                            if flags["noclip_key"] then
                                                child.CanCollide = false;
                                            else
                                                child.CanCollide = true;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        -- 
                        do -- resolution
                            if (flags["screen_res"]) then
                                local width = flags["screen_width"] / viewport_size.X;
                                local height = flags["screen_height"] / viewport_size.Y;
                                
                                camera.CFrame = camera.CFrame * CFrame.new(
                                    0, 0, 0, 
                                    width, 0, 0, 
                                    0, height, 0, 
                                    0, 0, 1
                                );
                            end;
                        end;            
                        --
                        do -- viewmodel
                            if (flags["Viewmodel Enabled"]) then
                                local camera_cframe = camera.CFrame
                                local offset = (camera_cframe.LookVector * -flags["Zpos"]) + (camera_cframe.RightVector * flags["Xpos"]) + (camera_cframe.UpVector * flags["Ypos"])
                                camera.CFrame = camera_cframe + offset
                            end;
                        end;
                        --
                        do -- local chams
                            if (flags["Local Chams"]) then
                                local_chams_highlight.FillColor = flags["Local Chams accent"];
                                local_chams_highlight.FillTransparency = flags["Local Chams Opacity"] / 100;
                                local_chams_highlight.OutlineColor = flags["Local Chams accent"];
                                local_chams_highlight.OutlineTransparency = flags["Local Chams Opacity"] / 100;
                                local_chams_highlight.Enabled = true;
                            else
                                local_chams_highlight.Enabled = false;
                            end;
                        end;
                        --
                        do -- fov circle
                            if (flags["Enable FOV"]) then
                                fov_circle.Frame.Visible = true;
                                fov_circle.Frame.BackgroundColor3 = fov_circle.Frame.BackgroundColor3:Lerp((flags["Highlight FOV"] and highlight_player and flags["Highlight FOV Accent"]) and flags["Highlight FOV Accent"] or flags["FOV Filled Accent"], 0.02);

                                if (flags["Enable Filled FOV"]) then
                                    fov_circle.Frame.BackgroundTransparency = flags["FOV Filled Opacity"] / 100;
                                else
                                    fov_circle.Frame.BackgroundTransparency = 1;
                                end;

                                local size = flags["FOV Radius"] * 2 / math.tan(math.rad(camera.FieldOfView / 2));
                                fov_circle.Frame.Size = UDim2.new(0, size, 0, size);
                                fov_circle.Frame.Position = UDim2.new(0, uis:GetMouseLocation().X, 0, uis:GetMouseLocation().Y);

                                if (flags["Enable Outlined FOV"]) then
                                    fov_circle.Frame2.Visible = true;
                                    fov_circle.Frame2.Size = UDim2.new(0, size - 2, 0, size - 2);
                                    fov_circle.Frame2.Position = UDim2.new(0, uis:GetMouseLocation().X, 0, uis:GetMouseLocation().Y);
                                else
                                    fov_circle.Frame2.Visible = false;
                                end;

                                if (flags["Highlight FOV"] and highlight_player) then
                                    local target = (flags["Highlight FOV"] and highlight_player and flags["Highlight FOV Accent"]) and flags["Highlight FOV Accent"] or nil;
                                    if typeof(target) == "Color3" then
                                        local lerpL = fov_circle.Gradient.Color.Keypoints[1].Value:Lerp(target, 0.02);
                                        local lerpR = fov_circle.Gradient.Color.Keypoints[2].Value:Lerp(target, 0.02);
                                        fov_circle.Gradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, lerpL), ColorSequenceKeypoint.new(1, lerpR) };
                                    end;
                                else
                                    fov_circle.Gradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, flags["FOV Gradient Left"]), ColorSequenceKeypoint.new(1, flags["FOV Gradient Right"]) };
                                end;

                                local spin_speed = flags["FOV Animation Speed"] / 2;
                                fov_rotation = fov_rotation + (tick() - fov_tick) * spin_speed * math.cos(math.pi / 4 * tick() - math.pi / 2);
                                fov_tick = tick();
                                fov_circle.Gradient.Rotation = fov_rotation;
                            else
                                fov_circle.Frame.Visible = false;
                                fov_circle.Frame2.Visible = false;
                            end;
                        end;
                        -- 
                        do -- info viewer
                            if (flags["Enable Aim-Assist"] and flags["Info Viewer"]) then
                                if (entry and closest_part) then
                                    local success, imagedata = pcall(function()
                                        return players:GetUserThumbnailAsync(entry.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                                    end);
                            
                                    if (success) then
                                        info_viewer.icon.Image = imagedata;
                                    end;
                            
                                    if (entry and entry.Name) then
                                        info_viewer.name_label.Text = tostring(entry.DisplayName);
                                    else
                                        info_viewer.name_label.Text = "No Entry";
                                    end;
                            
                                    info_viewer.background.Position = UDim2.new(flags["Info X-Pos"] / 100, 0, flags["Info Y-Pos"] / 100, 0);
                                    info_viewer.background.Visible = true;
                            
                                    local humanoid = entry and entry.Character and entry.Character:FindFirstChild("Humanoid")
                                    local health = humanoid and math.floor(humanoid.Health) or 100
                                    local max_health = humanoid and math.floor(humanoid.MaxHealth) or 100
                                    local health_percentage = health / max_health
                                    local weapon = (entry and player_esp.functions.get_tool(entry)) or "No Item";
                                    local armor = (entry and entry.Character and entry.Character:FindFirstChild("Armor") and entry.Character.Armor:FindFirstChild("Name") and entry.Character.Armor.Name) or "No Armour";
                                    local team = (entry and entry.Team and entry.Team.Name) or "No Team";
                            
                                    info_viewer.health_label.Text = "Health: " .. health .. "/" .. max_health;
                                    info_viewer.weapon_label.Text = "Weapon: " .. weapon;
                                    info_viewer.armor_label.Text = "Armor: " .. armor;
                                    info_viewer.team_label.Text = "Team: " .. team;
                                    info_viewer.distance_label.Text = "Distance: " .. math.floor(target_enhancements.target.distance) .. "s";
                            
                                    local health_color = Color3.new(1, 0, 0):lerp(Color3.new(0.7, 0.8, 0), math.clamp(health / max_health, 0, 1))
                                    health_color = health_color:lerp(Color3.new(0, 1, 0), math.clamp((health / max_health - 0.5) * 2, 0, 1))
                            
                                    local target_width = 188 * health_percentage
                                    info_viewer.healthbar.Size = UDim2.new(0, target_width, 0, 6)
                                    info_viewer.healthbar.BackgroundColor3 = health_color
                                else
                                    info_viewer.background.Visible = false;
                                end;
                            else
                                info_viewer.background.Visible = false;
                            end;                                                                                                  
                        end;
                        --
                        do -- snaplines
                            if (flags["Enable Aim-Assist"] and flags["Enable Snaplines"]) then
                                local line = snap_lines.line;
                                if (closest_part) then
                                    local screen_pos = camera:WorldToViewportPoint(closest_part.Position);
                                    local from = Vector2.new(screen_pos.X, screen_pos.Y);
                                    local to = uis:GetMouseLocation();
                                    local offset = to - from;
                                    local middle = from + offset * 0.5;
                                    local distance = offset.Magnitude;

                                    local line = snap_lines.line;
                                    line.Position = UDim2.new(0, middle.X, 0, middle.Y);
                                    line.Rotation = math.deg(math.atan2(offset.Y, offset.X));
                                    line.Size = UDim2.new(0, math.floor(distance + 0.5), 0, 1);
                                    line.BackgroundColor3 = flags["Snaplines Accent"];
                                    line.Visible = true;
                                else
                                    line.Visible = false;
                                end
                            else
                                snap_lines.line.Visible = false;
                            end;
                        end;
                        --
                        do -- aimbot
                            if (target_enhancements.target.entry and target_enhancements.target.part and target_enhancements.target.entry ~= local_player) then
                                if (flags["Enable Aim-Assist"] and table.find(flags["Aimbot Mode"], "Aimbot")) and aiming then
                                    local enemy_pos = target_enhancements.target.part.Position;
                                    camera.CFrame = flags["Aimbot Speed"] ~= 1 and camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, enemy_pos), flags["Aimbot Speed"]) or CFrame.lookAt(camera.CFrame.Position, enemy_pos);
                                end;
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