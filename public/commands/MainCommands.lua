local Temp = {}
local LPlayer = game:GetService("Players").LocalPlayer
function Temp:Fly(Player)

end
function Temp:Chat(Player)

end
function Temp:Nil(Player)

end
function Temp:Reanimate()
	local sethiddenproperty = sethiddenproperty or set_hidden_prop
	local setsimulationradius = setsimulationradius or set_simulation_radius

	if setsimulationradius then
		setsimulationradius(1e308,1/0)
	else
		sethiddenproperty(LPlayer,"MaximumSimulationRadius",1/0)
		sethiddenproperty(LPlayer,"SimulationRadius",1e308)
	end
end
function Temp:PlayAnim(AnimId)

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

return Temp