--[[
    
    Name: Love Toastify (LoveToastify.lua)

    Description: A modified version of LovelyToasts that allow for toast customization.

    Original Author: Lucy van Sandwijk
    Original: https://github.com/Loucee/Lovely-Toasts

	Version: 1.0

--]]

require ("class")

local Slicy = require("slicy")

table.unpack = table.unpack or unpack

---@class LoveToastify
LoveToastify = class(
    function(lt)
        lt._VERSION = "LoveToastify Version: 1.0"
        lt.yOffset = 15
        lt.toasts = {}

        lt.maxAlpha = 100
        lt.tapToDismiss = false
        lt.queueEnabled = false
    end
)

--#region LoveToastify Setters

function LoveToastify:setTapToDismiss(value)
    self.tapToDismiss = value
end

function LoveToastify:setQueueEnabled(value)
    self.queueEnabled = value
end

--#endregion

--#region LoveToastify Getters

function LoveToastify:getVersion()
    return self._VERSION
end

--#endregion

---@class Toast
Toast = class(
    function(toast, text, duration, position, font, textColor, patchFile)
        toast.animationDuration = 0.3
        toast.text = text
        toast.duration = duration  or (3 + (toast.animationDuration * 2))
        toast.position = position or "bottom"
        toast.alpha = 100
        toast.font = font
        toast.textColor = textColor
        toast.patch = Slicy.load(patchFile)
        toast.paddingLR = 25
        toast.paddingTB = 5
        toast.timePassed = 0.0
    end
)

function LoveToastify:update(delta)
    if (#self.toasts > 0) then
        local currentToast = self.toasts[1]

        currentToast.timePassed = currentToast.timePassed + delta

        -- Update alpha and yOffset
        if (currentToast.timePassed <= currentToast.animationDuration) then
            currentToast.alpha = math.min(100, currentToast.alpha + (100 / currentToast.animationDuration + delta))
        elseif (currentToast.timePassed >= currentToast.duration - currentToast.animationDuration) then
            currentToast.alpha = math.max(0, currentToast.alpha - (100 / currentToast.animationDuration * delta))
        end
        self.yOffset = math.max(0, self.yOffset - (self.yOffset / currentToast.animationDuration * delta))

        -- Remove Toast when duration ended
        if (currentToast.timePassed >= currentToast.duration) then
            table.remove(self.toasts, 1)
        end
    end
end

function LoveToastify:show(text, duration, position, font, color, image)
    font = font or love.graphics.getFont()
    color = color or { 1, 1, 1, 1 } -- White
    image = image or "Pane.9.png"

    local toast = Toast(text, duration, position, font, color, image)
    print(toast.text)

    if (self.queueEnabled) then
        table.insert(self.toasts, toast)
    else
        self.toasts = { toast }
    end
end

function LoveToastify:_yForPosition(position)
    local screenHeight = love.graphics.getHeight()
    if (position == "bottom") then
        return screenHeight * 0.8
    elseif (position == "top") then
        return screenHeight * 0.2
    elseif (position == "middle") then
        return screenHeight * 0.5
    end
end

function LoveToastify:draw()
    if (#self.toasts > 0) then
        local screenWidth = love.graphics.getWidth()
        local currentToast = self.toasts[1]

        local textWidth = currentToast.font:getWidth(currentToast.text)
        local textHeight = currentToast.font:getHeight()
        local textX = (screenWidth / 2) - (textWidth / 2)
        local textY = self:_yForPosition(currentToast.position) - (textHeight / 2) + self.yOffset
        
        -- Draw Toast 9Patch with Slicy
        currentToast.patch:draw(textX - currentToast.paddingLR,
                textY - currentToast.paddingTB,
                textWidth + (currentToast.paddingLR * 2),
                textHeight + (currentToast.paddingTB * 2))

        -- Draw Toast Text
        local r, g, b, a = table.unpack(currentToast.textColor)
        love.graphics.setColor(r, g, b, (a or 0.5) * (currentToast.alpha / 100))
        love.graphics.setFont(currentToast.font)
        
        local contentX, contentY, contentWidth, contentHeight = currentToast.patch:getContentWindow()
        love.graphics.setScissor(contentX, contentY, contentWidth, contentHeight)
        love.graphics.printf(currentToast.text, contentX, contentY, contentWidth, "center")
        love.graphics.setScissor()
    end
end

function LoveToastify:dismissToast(mouseX, mouseY)
    if (#self.toasts > 0 and self.tapToDismiss) then
        local currentToast = self.toasts[1]

        local toastWidth = currentToast.font:getWidth(currentToast.text) + (currentToast.paddingLR * 2)
        local toastHeight = currentToast.font:getHeight() + (currentToast.paddingTB * 2)
		local toastX = (love.graphics.getWidth() / 2) - (toastWidth / 2) - currentToast.paddingLR
		local toastY = self:_yForPosition(currentToast.position) - (toastHeight / 2) - currentToast.paddingTB
        
        if (mouseX > toastX) and (mouseX < toastX + toastWidth) and (mouseY > toastY) and (mouseY < toastY + toastHeight) then
			table.remove(self.toasts, 1)
		end

    end
end

function LoveToastify:onMouseReleased(x, y, button)
    if (button == 1) then
        self:dismissToast(x, y)
    end
end

function LoveToastify:onTouchReleased(id, x, y, dx, dy, pressure)
    self:dismissToast(x, y)
end