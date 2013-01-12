fw_addModule('gw',[[

keyHooks = {}
elements = {
	gui = {},
	stats = {},
	skills = {},
	inventory = {}
}

function _drawGUI(g)
	_processKeyHooks(g)
	_drawElements(g,'gui')
	gw_events.processEvents(g)
end

function _drawInventory(g,champ)
	_drawElements(g,'inventory',champ)
end

function _drawStats(g,champ)
	_drawElements(g,'stats',champ)
end

function _drawSkills(g,champ)
	_drawElements(g,'skills',champ)
end

function _drawElements(g,hookName,champion)
	hookName = hookName or 'gui'
	for id,element in pairs(elements[hookName]) do
		element:draw(g,champion)
	end
end

function _processKeyHooks(g)
	for key,hookDef in pairs(keyHooks) do
		if hookDef.toggle then
			-- toggle key state and add small threshold so the state doesn't change immediately
			if not keyToggleThresholdTimer and g.keyDown(key) then
				hookDef.active = not hookDef.active
				local t = spawn('timer',party.level,0,0,1,'keyToggleThresholdTimer')
				t:setTimerInterval(0.3)
				t:addConnector('activate','gw','_destroyKeyToggleThresholdTimer')
				t:activate()
			end
			if hookDef.active then
				hookDef.callback(g)
			end	
		elseif g.keyDown(key) then
			hookDef.callback(g)
		end
	end
end

function _destroyKeyToggleThresholdTimer()
	keyToggleThresholdTimer:destroy()
end


function setKeyHook(key,ptoggle,pcallback)
	keyHooks[key] = {callback=pcallback,toggle=ptoggle,active=false}
end

function addElement(element,hookName)
	hookName = hookName or 'gui'
   	table.insert(elements[hookName],element)
end

function removeElement(id,hookName)
	hookName = hookName or 'gui'
	for i,elem in ipairs(elements[hookName]) do
		if elem.id == id then
			table.remove(elements[hookName],i)
			return
		end
	end
end
-- general element factory method
function create(elementType,id,arg1,arg2,arg3,arg4,arg5,arg6)
	local elementFactory = findEntity('gw_'..elementType)
	if (not elementFactory or elementFactory.create == nil) then
		print('Invalid grimwidgets element type: '..elementType)
	end
	return elementFactory.create(id,arg1,arg2,arg3,arg4,arg5,arg6)
end
]])