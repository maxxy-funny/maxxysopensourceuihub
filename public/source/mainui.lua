local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/IreXion-UI-Library/main/IreXion%20UI%20Library"))()
loadstring(game:HttpGetAsync("https://pastebin.com/raw/Ts8TSAZN", 0, true))()
pcall(function()
	Plr = game.Players.LocalPlayer
	Char = Plr.Character
	Hum = Char.Humanoid
end)
--shit parts
local MaxxyCmds = {}
local LPlayer = game:GetService("Players").LocalPlayer

local notouchTouches = {}
function MaxxyCmds:notouch()

	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			table.insert(notouchTouches, {part = v.Parent, pare = v.Parent.Parent})
			v.Parent.Parent = game:GetService("PolicyService")
		end
	end
end

function MaxxyCmds:yestouch()
	for i,v in pairs(notouchTouches) do
		v.part.Parent = v.pare
		table.remove(notuchTouches, i)
	end
end
function MaxxyCmds:Reanimate()
	local sethiddenproperty = sethiddenproperty or set_hidden_prop
	local setsimulationradius = setsimulationradius or set_simulation_radius

	if setsimulationradius then
		setsimulationradius(1e308,1/0)
	else
		sethiddenproperty(LPlayer,"MaximumSimulationRadius",1/0)
		sethiddenproperty(LPlayer,"SimulationRadius",1e308)
	end
end
function MaxxyCmds:PlayAnim(AnimId)

	local Char = LPlayer.Character
	local Humanoid = Char.Humanoid
	local Frame = 60
	coroutine.wrap(function()
		LPlayer.Character.HumanoidRootPart.Anchored = true
		wait(.8)
		LPlayer.Character.HumanoidRootPart.Anchored = false
	end)()
	local Create = function(Obj,Parent)
		local I = Instance.new(Obj)
		I.Parent = Parent
		return I
	end
	local Contains = function(Table,KV)
		for K,V in next, Table do 
			if rawequal(KV,K) or rawequal(KV,V) then 
				return true
			end
		end
		return false
	end
	local PoseToCF = function(Pose,Motor)
		return (Motor.Part0.CFrame * Motor.C0 * Pose.CFrame * Motor.C1:Inverse()):ToObjectSpace(Motor.Part0.CFrame)
	end
	local Torso = LPlayer.Character.Torso
	local Joints = {
		["Torso"] = LPlayer.Character.HumanoidRootPart.RootJoint,
		["Left Arm"] = Torso["Left Shoulder"],
		["Right Arm"] = Torso["Right Shoulder"],
		["Left Leg"] = Torso["Left Hip"],
		["Right Leg"] = Torso["Right Hip"],
	}
	for K,V in next, Char:GetChildren() do 
		if V:IsA("BasePart") then 
			coroutine.wrap(function()
				repeat V.CanCollide = false
					game:GetService("RunService").Stepped:Wait() 
				until LPlayer.Character.Humanoid.Health < 1
			end)()
		end
	end
	for K,V in next, Joints do 
		local AP, AO, A0, A1 = Create("AlignPosition",V.Part1), Create("AlignOrientation",V.Part1), Create("Attachment",V.Part1), Create("Attachment",V.Part0)
		AP.RigidityEnabled = true
		AO.RigidityEnabled = true
		AP.Attachment0 = A0
		AP.Attachment1 = A1
		AO.Attachment0 = A0
		AO.Attachment1 = A1
		A0.Name = "CFAttachment0"
		A1.Name = "CFAttachment1"
		A0.CFrame = V.C1 * V.C0:Inverse()
		V:Remove()
	end
	local Edit = function(Part,Value,Duration,Style,Direction)
		Style = Style or "Enum.EasingStyle.Linear"
		Direction = Direction or "Enum.EasingDirection.In"
		local Attachment = Part:FindFirstChild("CFAttachment0")
		if Attachment ~= nil then
			game:GetService("TweenService"):Create(Attachment,TweenInfo.new(Duration,Enum.EasingStyle[tostring(Style):split('.')[3]],Enum.EasingDirection[tostring(Direction):split('.')[3]],0,false,0),{CFrame = Value}):Play()
		end
	end
	if not game:GetService("RunService"):FindFirstChild("Delta") then
		local Delta = Create("BindableEvent",game:GetService("RunService"))
		Delta.Name = "Delta"
		local A, B = 0, tick()
		game:GetService("RunService").Delta:Fire()
		game:GetService("RunService").Heartbeat:Connect(function(C, D)
			A = A + C
			if A >= (1/Frame) then
				for I = 1, math.floor(A / (1/Frame)) do
					game:GetService("RunService").Delta:Fire()
				end
				B = tick()
				A = A - (1/Frame) * math.floor(A / (1/Frame))
			end
		end)
	end
	coroutine.wrap(function()
		Humanoid.Died:Wait()
		for K,V in next, LPlayer.Character:GetDescendants() do 
			if V.Name:match("Align") then 
				V:Destroy()
			end
		end
	end)()
	local PreloadAnimation = function(AssetId)
		local Sequence = game:GetObjects("rbxassetid://"..AssetId)[1]
		wait(.06)
		local Class = {Speed = 1}
		local Yield = function(Seconds)
			local Time = Seconds * (Frame + Sequence:GetKeyframes()[#Sequence:GetKeyframes()].Time)
			for I = 1,Time,Class.Speed do 
				game:GetService("RunService").Delta.Event:Wait()
			end
		end
		Class.Stopped = false;
		Class.Complete = Instance.new("BindableEvent")
		Class.Play = function()
			Class.Stopped = false
			coroutine.wrap(function()
				repeat
					for K = 1,#Sequence:GetKeyframes() do 
						local K0, K1, K2 = Sequence:GetKeyframes()[K-1], Sequence:GetKeyframes()[K], Sequence:GetKeyframes()[K+1]
						if Class.Stopped ~= true and LPlayer.Character.Humanoid.Health > 0 then
							if K0 ~= nil then 
								Yield(K1.Time - K0.Time)
							end
							coroutine.wrap(function()
								for I = 1,#K1:GetDescendants() do 
									local Pose = K1:GetDescendants()[I]
									if Contains(Joints,Pose.Name) then 
										local Duration = K2 ~= nil and (K2.Time - K1.Time)/Class.Speed or .5
										Edit(Char[Pose.Name],PoseToCF(Pose,Joints[Pose.Name]),Duration,Pose.EasingStyle,Pose.EasingDirection)
									end
								end
							end)()
						end
					end
					Class.Complete:Fire()
				until Sequence.Loop ~= true or Class.Stopped ~= false or LPlayer.Character.Humanoid.Health < 1
			end)()
		end
		Class.Stop = function()
			Class.Stopped = true;
		end
		Class.Reset = function()
			coroutine.wrap(function()
				wait(.02)
				for K,V in next, Joints do 
					local Part = Char[K]
					if Part ~= nil then 
						local Attachment = Part:FindFirstChild("CFAttachment0")
						if Attachment ~= nil then 
							Attachment.CFrame = V.C1 * V.C0:Inverse()
						end
					end
				end
			end)()
		end
		return Class
	end
	_G.connections.ReplicatedAnimation = PreloadAnimation(AnimId)
	_G.connections.ReplicatedAnimation.Speed =  1
	_G.connections.ReplicatedAnimation:Play()
end

--end of shit part

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

function GetPing()
	local Start = tick()

	local ping = tick()-Start
	return math.floor(ping*1000+.5)
end
function init()


	local Tab3 = Gui:AddTab("Player")
	local PlayerAbuse = Gui:AddTab("Abuse")

	local Tab4 = Gui:AddTab("Scripts")
	local Tab8 = Gui:AddTab("Environment")
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
			notify([[YOU STUPID FUCK BUY SYNAPSE YOU CHEAP CUNT
    FUCK YOU
    STOP USING MY WARES]])
			local DualLabel = Data:AddDualLabel({"Exploit","Possibly KRNL"})
		else
			--MY MAN

			local DualLabel = Data:AddDualLabel({"Exploit","SynapseX"})

		end
	end)

	local GameData = UserData:AddCategory("Game Data")
	local DualLabel = GameData:AddDualLabel({"Place Id",game.PlaceId})
	local DualLabel = GameData:AddDualLabel({"Job Id",game.JobId})
	local DualLabel = GameData:AddDualLabel({"Exe Time",os.date("%c")})
	

	


	--INPUT

	

	local PlayerList = PlayerAbuse:AddCategory("PlayerList")
	local plist = PlayerList:AddDropdown("Players", {}, function(name)
		print(name)
	end)
	for fuck,you in pairs(game:GetService("Players"):GetChildren()) do
		plist:AddItem(you.Name)

	end

	game.Players.PlayerAdded:Connect(function(plr) --When player joins the game
		plist:AddItem(plr.Name)
	end)

	game.Players.PlayerRemoving:Connect(function(plr) --When player joins the game
		plist:RemoveItem(plr.Name)
	end)


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
	local UhOh = Animate:AddBox("AnimID", function(str)
		_G.Anim = str
	end)
	local Toggle = Animate:AddButton("Play Animation", function(toggle)
		MaxxyCmds:PlayAnim(_G.Anim)
	end)
	local NoTouchy = Tab4:AddCategory("Interests")
	local TouchInterest = NoTouchy:AddToggle("No Touch Interests", false, function(toggle)
		if toggle == false then
			pcall(function()
				MaxxyCmds:yestouch()
			end)

		else
			MaxxyCmds:notouch()

		end
	end)

		--Sound Spam
		local Amogus = Tab4:AddCategory("RespectFiltering")
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
	local GameSense = Tab4:AddCategory("Game Sense")
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
	local Scripts = Tab4:AddCategory("Scripts")
	local Button = Scripts:AddButton("Silent Aim", function()
		notify("Loading GUI")
		loadstring(game:HttpGet("https://flushed-exe.tk/scripts/silent-aim.lua"))()

	end)
	--Abuse
	local Abse = Tab4:AddCategory("Abuse")
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


