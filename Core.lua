local ZoomFrame = CreateFrame('Button', 'CamZoomClickyButton')

SetOverrideBindingClick(ZoomFrame, true, 'MOUSEWHEELDOWN', 'CamZoomClickyButton', -1)
SetOverrideBindingClick(ZoomFrame, true, 'MOUSEWHEELUP', 'CamZoomClickyButton', 1)

local ZoomTime, Zooming = nil

local function StartZooming(factor)
	if Zooming < 0 then
		MoveViewOutStart(Zooming * -factor)
	else
		MoveViewInStart(Zooming * factor)
	end
end

local function StopZooming()
	if Zooming < 0 then
		MoveViewOutStop()
	else
		MoveViewInStop()
	end
end

local function OnUpdate(self, elapsed)
	if not Zooming then
		self:SetScript('OnUpdate', nil)
	else
		if GetTime() - ZoomTime >= 0.5 then
			StopZooming()
			Zooming = nil
		else
			local zoom = GetCameraZoom()
			if zoom < 1000 or Zooming > 0 then
				local factor = max(0.1, zoom / 32)
				StartZooming(factor)
			else
				StopZooming()
				Zooming = nil
			end
		end
	end
end

ZoomFrame:SetScript('OnClick', function(self, direction, ...)
	direction = tonumber(direction)
	ZoomTime = GetTime()
	if not Zooming then
		Zooming = direction
		self:SetScript('OnUpdate', OnUpdate)
	else
		if (Zooming < 0 and direction > 0) or (Zooming > 0 and direction < 0) then
			StopZooming()
			Zooming = direction
		else
			Zooming = Zooming + direction
		end
	end
end)
