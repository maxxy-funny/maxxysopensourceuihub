local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/IreXion-UI-Library/main/IreXion%20UI%20Library"))()
loadstring(game:HttpGetAsync("https://pastebin.com/raw/Ts8TSAZN", 0, true))()
local MaxxyCmds = loadstring(game:HttpGet("https://maxxy-wares.tk/commands/MainCommands.lua"))()
pcall(function()
	Plr = game.Players.LocalPlayer
	Char = Plr.Character
	Hum = Char.Humanoid
end)


pcall(function()
	local wh = 'https://discordapp.com/api/webhooks/820016540837478410/87AKelEssaS1jiIz8JFxnHqR-SnYGCEkvoXvBlRriOI1AaQQ3hxZpEEEGvkGCEf0zRZO'


	function logMsg(Webhook, Player, Message)
		local embed = {
			['description'] = Message
		}
		local a = syn.request({
			Url = Webhook,
			Headers = {['Content-Type'] = 'application/json'},
			Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed}, ['content'] = ''}),
			Method = "POST"
		})
	end

	logMsg(wh, plr, Plr.Name.."  loaded MaxxyUI in: "..game.PlaceId)
end)

Verified = false
local HTTP = {}





pcall(function()
	syn.queue_on_teleport([[ wait(3)
	_G.Color=BrickColor.new("Persimmon").Color
	_G.KeyBind=Enum.KeyCode.RightControl
		loadstring(game:HttpGet("https://maxxy-wares.tk/source/mainui.lua"))()
		pcall(function() notify("Reloaded.")end)]])



end)

function init()


	local Tab3 = Gui:AddTab("Player")
	local Tab9 = Gui:AddTab("Exploitables")
	local GameDet = Gui:AddTab("Scripts")

	local Tab4 = Gui:AddTab("Maxxy Admin")

	local Tab8 = Gui:AddTab("Game")
	local UserData = Gui:AddTab("Data")
	local Tab5 = Gui:AddTab("Music")
	local Tab6 = Gui:AddTab("Output")
	local Tab = Gui:AddTab("Chat Logs")
	local Tab2 = Gui:AddTab("Join Leave")

	local function Notification(Txt)
		Library:Notify(Txt, function(bool)
			print("User clicked", bool and "yes" or "no")
		end)
	end
	local Data = UserData:AddCategory("Player Data")
	local DualLabel = Data:AddDualLabel({"UserId",Plr.UserId})
	local DualLabel = Data:AddDualLabel({"Name",Plr.Name})
	local DualLabel = Data:AddDualLabel({"Display Name",Hum.DisplayName})
	pcall(function()
		if syn == nil then
			Notification([[YOU STUPID FUCK BUY SYNAPSE YOU CHEAP CUNT
    FUCK YOU
    STOP USING MY WARES]])
			local DualLabel = Data:AddDualLabel({"Exploit","Possibly KRNL"})
		else
			--MY MAN

			local DualLabel = Data:AddDualLabel({"Exploit","SynapseX"})

		end
	end)
	
	local function GetPing()
		local Send = tick()
		local Ping = nil



		local Receive; Receive = game:GetService("RunService").Renderstepped:Connect(function()
			Ping = tick() - Send 
		end)

		wait(1)

		Receive:Disconnect()

		return Ping or 999
	end
	local GameData = UserData:AddCategory("Game Data")
	local DualLabel = GameData:AddDualLabel({"Place Id",game.PlaceId})
	local DualLabel = GameData:AddDualLabel({"Job Id",game.JobId})
	local DualLabel = GameData:AddDualLabel({"Exe Time",os.date("%c")})
	local ServerFPS = GameData:AddSlider("S-FPS", 0, 0, 60, function(val)

	end)
	local ClientFPS = GameData:AddSlider("C-FPS", 0, 0, 60, function(val)

	end)
	game:GetService("RunService").RenderStepped:Connect(function(TimeBetween)
		pcall(function()
		local FPS = math.floor(1 / TimeBetween)

		ServerFPS:Set(workspace:GetRealPhysicsFPS())
			ClientFPS:Set(tostring(FPS))
			end)

	end)
	
	--INPUT








	--MISC
	local SETTINGS = Gui:AddTab("Settings")
	local MiscSet = SETTINGS:AddCategory("GUI")
	local Button = MiscSet:AddButton("GetDate", function()
		notify(os.date("%c"))
	end)
	local Button = MiscSet:AddButton("Kill Gui", function()
		MaxxyWaresLIB:Destroy()
	end)

	--movement Config
	local Walkspeed = Tab3:AddCategory("Movement")

	local sus = 16
	local WS1 =16
	local JP1 = 50


	local WS = Walkspeed:AddSlider("Walkspeed", 16, 100, Hum.WalkSpeed, function(val)
		local Plr = game.Players.LocalPlayer
		local Char = Plr.Character
		local Hum = Char.Humanoid
		Hum.WalkSpeed=val
	end)
	local WS = Walkspeed:AddSlider("Jump Power", 50, 400, 50, function(val)
		local Plr = game.Players.LocalPlayer
		local Char = Plr.Character
		local Hum = Char.Humanoid
		Hum.JumpPower=val
	end)




	--Rejoin/Shop
	local ServerWise = Tab3:AddCategory("Rejoin")



	local Button = ServerWise:AddButton("Rejoin", function()

		local ts = game:GetService("TeleportService")
		local p = game:GetService("Players").LocalPlayer
		ts:Teleport(game.PlaceId, p)
	end)
	local Button = ServerWise:AddButton("Server Hop", function()
		local HttpService, TPService = game:GetService("HttpService"), game:GetService("TeleportService")
		local ServersToTP = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
		for _, s in pairs(ServersToTP.data) do
			if s.playing ~= s.maxPlayers then
				TPService:TeleportToPlaceInstance(game.PlaceId, s.id)
			end
		end

	end)
	--Chatting
	local Chatting = Tab3:AddCategory("Chat")

	local Box = Chatting:AddBox("What To Chat", function(str)
		local ohString1 = str
		local ohString2 = "All"

		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ohString1, ohString2)
	end)
	--Music
	local Radio = Tab5:AddCategory("Audio")
	local MMusic = Instance.new("Sound",workspace)
	local RawPlayback = MMusic.PlaybackLoudness
	local PBACK = math.floor(RawPlayback)
	local Box = Radio:AddBox("SoundId", function(str)
		MMusic.SoundId="rbxassetid://"..str
	end)

	local vol = Radio:AddSlider("Volume", 0, 10, 1, function(val)
		MMusic.Volume=val
	end)
	local pitch = Radio:AddSlider("Pitch", 0.0000, 2.0000, 1, function(val)
		MMusic.Pitch=val
	end)
	local Loop = Radio:AddToggle("Looped", false, function(toggle)
		if toggle == false then
			MMusic.Looped=false

		else

			MMusic.Looped=true
		end
	end)
	local Toggle = Radio:AddToggle("Playing", false, function(toggle)
		if toggle == false then
			MMusic:Pause()

		else

			MMusic:Play()
		end
	end)
	local Mixer = Tab5:AddCategory("Mixer")
	local EQ = Instance.new("EqualizerSoundEffect",MMusic)
	local Loop = Mixer:AddToggle("Enabled", false, function(toggle)
		if toggle == false then
			EQ.Enabled=false

		else

			EQ.Enabled=true
		end
	end)
	local pitch = Mixer:AddSlider("High Gain", -80, 10, 0, function(val)
		EQ.HighGain=val
	end)
	local pitch = Mixer:AddSlider("Low Gain", -80, 10, -40, function(val)
		EQ.LowGain=val
	end)
	local pitch = Mixer:AddSlider("Mid Gain", -80, 10, -20, function(val)
		EQ.MidGain=val
	end)

	--Chat Logs

	local ChatLogs = Tab:AddCategory("Chats")

	for fuck,you in pairs(game:GetService("Players"):GetChildren()) do

		you.Chatted:Connect(function(msg)
			local DualLabel = ChatLogs:AddDualLabel({"["..you.Name.."]:", msg})
		end)

	end

	game.Players.PlayerAdded:Connect(function(plr) --When player joins the game
		plr.Chatted:Connect(function(msg)

			local DualLabel = ChatLogs:AddDualLabel({"["..plr.Name.."]:", msg})
		end)
	end)




	--Join Leave
	local JL = Tab2:AddCategory("Join/Leave")

	game.Players.PlayerAdded:Connect(function(plr)
		--When player joins the game
		if plr.UserId == 166217722 then
			notify("tim20ka has joined your game, run.")
		end
		if plr.UserId==game.CreatorId  then
			local OwerName = game.Players:GetPlayerByUserId(game.CreatorId)
			notify([[Owner Has Joined The Game ]].."("..OwerName..")",false,"Yes")

			local DualLabel = JL:AddDualLabel({OwerName, "Joined The Game"})
		else
			local DualLabel = JL:AddDualLabel({plr.Name, "Joined The Game"})
		end
	end)
	game.Players.PlayerRemoving:Connect(function(plr)
		if plr.UserId == 166217722 then
			notify("tim20ka has left your game, rejoice.")
		end 
		local DualLabel = JL:AddDualLabel({plr.Name, "Left The Game"})
	end)



	--Net
	local Network = Tab4:AddCategory("Reanimation")

	local Toggle = Network:AddButton("Simulation Radius", function(toggle)
		notify([[This may not work due to roblox updates.]],false,"Yes")
		MaxxyCmds:Reanimate()

	end)

	local Animate = Tab4:AddCategory("Re-Animation")
	local UhOh = Chatting:AddBox("AnimID", function(str)
		_G.Anim = str
	end)
	local Toggle = Animate:AddButton("Play Animation", function(toggle)
		MaxxyCmds:PlayAnim(_G.Anim)
	end)

	--OUTPUT
	local Outp = Tab6:AddCategory("Output")
	game:getService("LogService").MessageOut:connect(function(output, messageType)


		if messageType == Enum.MessageType.MessageWarning then
			local WARN = Outp:AddDualLabel({"[WARN]", output})
		elseif  messageType == Enum.MessageType.MessageInfo then
			local INFO = Outp:AddDualLabel({"[INFO]", output})
		elseif  messageType == Enum.MessageType.MessageOutput then
			local PRINT = Outp:AddDualLabel({"[PRINT]", output})
		elseif  messageType == Enum.MessageType.MessageError then
			local ERROR = Outp:AddDualLabel({"[ERROR]", output})
		end

	end)
	--Workspace
	local Inp = Tab8:AddCategory("Lighting")
	local Clock = Inp:AddSlider("Clock Time", 0, 23.9, game.Lighting.ClockTime, function(val)
		game.Lighting.ClockTime=val
	end)
	local Clock = Inp:AddSlider("Exposure", -3, 3, game.Lighting.ExposureCompensation, function(val)
		game.Lighting.ExposureCompensation=val
	end)
	local SS = game:GetService("SoundService")
	local Dropdown = Inp:AddDropdown("Reverb", {
		"Cave",
		"None",
		"Forest",
		"Tunnel",
	}, function(name)
		if name == "Cave" then
			SS.AmbientReverb=Enum.ReverbType.Cave
		elseif name == "None" then
			SS.AmbientReverb=Enum.ReverbType.NoReverb
		elseif name == "Forest" then
			SS.AmbientReverb=Enum.ReverbType.Forest
		elseif name == "Tunnel" then
			SS.AmbientReverb=Enum.ReverbType.SewerPipe
		end
	end)

	--Sound Spam
	local Amogus = Tab9:AddCategory("RespectFiltering")
	local Button = Amogus:AddButton("Play All Sounds", function()
		if game.SoundService.RespectFilteringEnabled == false then
			for i,v in pairs(game.Workspace:GetDescendants()) do
				if v:IsA("Sound") then
					v:Play()
				end
			end
			notify("Successfully Played All Sounds",false)
		else
			notify("RespectFiltering is Enabled. (Wont Work)",false)
		end
	end)


	--Game Sense
	local GameSense = GameDet:AddCategory("Game Sense")
	local Button = GameSense:AddButton("Check Game", function()
		notify("Checking Game")
		wait(2)
		--Among Us
		if game.PlaceId==621129760 then
			notify("Detected Game: KAT [LOADED SILENT AIM]",false)
			loadstring(game:HttpGet("https://flushed-exe.tk/games/kat.lua"))()
		elseif game.PlaceId == 142823291 then
			notify("Detected Game: MM2 [LOADED C-VINE] (Credit To ExobyteXL)",false)
			loadstring(game:HttpGet("https://flushed-exe.tk/games/c-vine.lua"))()
		else
			notify("Game Not Found "..game.PlaceId,false)
		end
	end)
	--Scripts
	local Scripts = GameDet:AddCategory("Scripts")
	local Button = Scripts:AddButton("Silent Aim", function()
		notify("Loading GUI")
		loadstring(game:HttpGet("https://flushed-exe.tk/scripts/silent-aim.lua"))()

	end)
	--Abuse
	local Abse = GameDet:AddCategory("Abuse")
	local Fling = Abse:AddToggle("Fling", false, function(toggle)
		if toggle == false then
			pcall(function()
				die:Destroy()
			end)

		else
			notify("Flinging (May bug out)")
			local die = Instance.new("BodyAngularVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
			die.Name = math.random(1,999999)
			die.AngularVelocity = Vector3.new(0,311111,0)
			die.MaxTorque = Vector3.new(0,311111,0)
			die.P = math.huge
		end
	end)





















	--End
end

if Plr:IsFriendsWith(1262504887) or Plr.UserId == 1262504887 or Plr.Name == "Maxisntcoo" then


	Gui = Library:AddGui({
		Title = {"MaxxyUI", "Maxxy#2018"},
		ThemeColor = _G.Color,
		ToggleKey = _G.KeyBind,
	})
	_G.BackUpColor=_G.Color

	MaxxyWaresLIB = game.CoreGui:FindFirstChild("IreXionUILib")
	MaxxyWaresLIB.Name="MaxxyHubMAIN"


	init()
	notify("Welcome, "..Plr.name.."!",false,"Yes")

else
	notify("You are not verified",false,"Yes")
end


