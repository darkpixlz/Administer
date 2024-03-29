-- darkpixlz 2022 - 2024

-- Administer

task.wait(2)
local Settings = game.ReplicatedStorage:WaitForChild("AdministerRemotes"):WaitForChild("SettingsRemotes"):WaitForChild("RequestSettings"):InvokeServer()

for i, v in pairs(Settings) do
	local ClonedTemplate 

	if type(v["Value"]) == "boolean" then
		ClonedTemplate = script.Parent.Page.BoolTemplate:Clone()
		ClonedTemplate.Parent = script.Parent.Page
		ClonedTemplate.Name = v["Name"]
		ClonedTemplate.SettingName.Text = v["Name"]
		ClonedTemplate.Parent = script.Parent.Page
		ClonedTemplate.Description.Text = v["Description"]
		ClonedTemplate.Visible = true


		if v["Value"] == false then
			game:GetService("TweenService"):Create(ClonedTemplate.Action, TweenInfo.new(.5), {BackgroundColor3 = Color3.fromRGB(61, 255, 116)}):Play()
			ClonedTemplate.Action.Text = "Enable"
		else
			game:GetService("TweenService"):Create(ClonedTemplate.Action, TweenInfo.new(.5), {BackgroundColor3 = Color3.fromRGB(255, 82, 85)}):Play()
			ClonedTemplate.Action.Text = "Disable"
		end

		ClonedTemplate.Action.MouseButton1Click:Connect(function()
			local Result = game.ReplicatedStorage.AdministerRemotes.SettingsRemotes.ChangeSetting:InvokeServer(v["Name"], not v["Value"])

			if Result[1] then
				ClonedTemplate.Action.Text = Result[2]
				if v["Value"] == false then
					game:GetService("TweenService"):Create(ClonedTemplate.Action, TweenInfo.new(.5), {BackgroundColor3 = Color3.fromRGB(255, 82, 85)}):Play()
					task.delay(2.5, function()
						ClonedTemplate.Action.Text = "Disable"
					end)
					v["Value"] = true
				else
					game:GetService("TweenService"):Create(ClonedTemplate.Action, TweenInfo.new(.5), {BackgroundColor3 = Color3.fromRGB(61, 255, 116)}):Play()
					task.delay(5, function()
						ClonedTemplate.Action.Text = "Enable"
					end)
					v["Value"] = false
				end
			else
				ClonedTemplate.Action.Text = `Try again later: ({Result[2]})`
				task.delay(2.5, function()
					if v["Value"] == false then			
						ClonedTemplate.Action.Text = "Enable"
					else
						ClonedTemplate.Action.Text = "Disable"
					end
				end)
			end
		end)
	elseif type(v["Value"]) == "string" or type(v["Value"]) == "number" then
		local ClonedTemplate = script.Parent.Page.InputTemplate:Clone()
		ClonedTemplate.Parent = script.Parent.Page
		ClonedTemplate.Name = v["Name"]
		ClonedTemplate.SettingName.Text = v["Name"]
		ClonedTemplate.Parent = script.Parent.Page
		ClonedTemplate.Description.Text = v["Description"]
		ClonedTemplate.Action.Text = v["Value"]
		ClonedTemplate.Visible = true

		ClonedTemplate.Action.FocusLost:Connect(function(WasEnter,Input)
			if WasEnter then
				v["Value"] = ClonedTemplate.Action.Text
				local Result = game.ReplicatedStorage.AdministerRemotes.SettingsRemotes.ChangeSetting:InvokeServer(v["Name"], ClonedTemplate.Action.Text)

				ClonedTemplate.Action.Text = Result[2]
				task.delay(2.5, function()
					ClonedTemplate.Action.Text = v["Value"]
				end)
			end
		end)
	end
end