fw_addModule('gw_string',[[
function stringWidth(text)
	local len = 0
	for i = 1, string.len(text) do
		local char = string.sub(text, i, i)
		if char>='A' and char<='Z' then
			len = len + 12 -- capital letters
		elseif char>='a' and char<='z' then
			len = len + 9 -- small letters
		elseif char == ' ' then
			len = len + 5 -- space
		elseif char>='0' and char<='9' then
			len = len + 9
		elseif char>='!' and char<='/' then
			len = len + 8
		else
			len = len + 10		
		end
	end
	return len
end

-- Source: http://lua-users.org/wiki/SplitJoin
function split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function wrap(text,width)
	local words = split(text,' ')
	local lines = {''}
	local len = 0
	local line = 1
	for i,word in ipairs(words) do
		len = len + stringWidth(word)
		if len > width then
			line = line + 1
			lines[line] = ''
			len = stringWidth(word)
		end
		lines[line] = lines[line]..' '..word
	end
	return lines
end

function drawLines(ctx,lines,x,y,lineHeight)
	for i,line in ipairs(lines) do
		ctx.drawText(line,x,y+(i-1)*lineHeight)
	end
end

function drawElementText(elem,ctx)
	if not elem.text then return false end
	local lines = gw_string.wrap(elem.text,elem.width)
	gw_string.drawLines(ctx,lines,elem.x + 5, elem.y + 13 + 5,20)
end

]])