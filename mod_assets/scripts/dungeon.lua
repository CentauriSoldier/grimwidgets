-- This file has been generated by Dungeon Editor 1.3.6

--- level 1 ---

mapName("Unnamed")
setWallSet("dungeon")
playStream("assets/samples/music/dungeon_ambient.ogg")
mapDesc([[
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
##############...###############
##############.....#############
##############.....#############
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
]])
spawn("starting_location", 14,16,3, "starting_location")
spawn("torch_holder", 15,14,0, "torch_holder_1")
	:addTorch()
spawn("script_entity", 2,0,0, "gw_debug")
	:setSource("-- this is just a placeholder for debugging purposes.\
-- When debugging a script entity you can rename this script entity for example to gw and copy paste \
-- the script entity part from mod_assets/grimwidgets/gw.lua here. \
-- so the framwork will not load the script from that lua file.\
-- Same works with any dynamically loaded script entities.\
-- Problem with the dynamically loaded script enetites is that you can't see any errors in editor they might cause\
-- so you have to copy paste them to dungeon for debugging.\
\
\
")
spawn("script_entity", 12,15,3, "debug")
	:setSource("\
-- draws size*size grid and shows mouse coordinates in upper left corner\
-- you can enable it by calling debug.grid(100), disable: debug.grid() \
-- currently works only in fullscreen mode because of g.width g.height bug\
\
function grid(size)\
\9if not size then\
\9\9gw.removeElement('grid')\
\9\9return\
\9end\
\9size = size or 100\
\9local grid = {}\
\9grid.id = 'grid'\
\9grid.size = size\
\9grid.draw = function(self,g)\
\9\9local h = math.ceil(g.height/self.size)\
\9\9local w = math.ceil(g.width/self.size)\
\9\9for x = 0,w do\
\9\9\9g.drawRect(x*self.size,0,1,g.height)\
\9\9end\
\9\9for y = 0,h do\
\9\9\9g.drawRect(0,y*self.size,g.width,1)\
\9\9end\9\9\
\9\9g.drawText('x: '..g.mouseX..', y:'..g.mouseY,20,20)\
\9\9g.drawText('g.width - '..g.width - g.mouseX..', g.height - '..g.height - g.mouseY,20,40)\
\9end\
\9gw.addElement(grid)\
end\
\
function debugGrid()\
\9grid(100)\
end\
\
function disableGrid()\
\9grid()\
end")
spawn("dungeon_wall_text", 14,15,3, "dungeon_wall_text_1")
	:setWallText("Enable mouse grid")
spawn("gw_event", 16,16,2, "gw_event_1")
	:setSource("-- is this event enabled?\
enabled = true\
\
-- name of the imeage to show\
image = \"mod_assets/images/example-image.dds\"\
image_width = 177\
image_hieght = 180\
\
\
-- buttons position\
buttons_x = 220\
buttons_y = 160\
buttons_width = 200\
\
-- initial state\
state = 1\
\
-- functions called after specific buttons being pressed\
function onHeal()\
    hudPrint(\"Healing!\")\
    state = 2\
end\
\
function onTalk()\
    hudPrint(\"Dwarf is in too much pain to talk.\")\
end\
\
function onLeave()\
    enabled = false\
end\
\
function onHealed()\
    hudPrint(\"He is healed already!\")\
end\
\
-- defines states. Each entry must have exactly two columns:\
-- first is state number, the second is description shown.\
states = {\
  { 1, \"An injured dwarf lies on the ground before you,\\n\" ..\
       \"nearly unconscious from his wounds.\" },\
  { 2, \"The healed dwarf is happy.\" }\
}\
\
-- defines possible actions in each state. Each entry has\
-- 3 values. First is state number. Second is action name\
-- (will be printed on a button). The third is a function\
-- that will be called when action is taken (i.e. button\
-- is pressed).\
actions = {\
  { 1, \"tend his wounds\", onHeal },\
  { 1, \"talk\", onTalk },\
  { 1, \"leave\", onLeave},\
  { 2, \"healed\", onHealed}\
}\
")
spawn("script_entity", 29,31,2, "spell_book")
	:setSource("-- For testing/developement purposes\
-- I hope that this case is complex enough to show the possible flaws on grimwigets.\
\
spells = {}\
offset = {\
\9x=20,\
\9y=20,\
\9line_h = 20,\
}\
\
\
function getRuneImage(runeChar)\
\9local runeMap = {\
\9\9A='rune1_fire',\
\9\9B='rune2_death',\
\9\9C='rune3_air',\
\9\9D='rune4_spirituality',\
\9\9E='rune5_balance',\
\9\9F='rune6_physicality',\
\9\9G='rune7_earth',\
\9\9H='rune8_life',\
\9\9I='rune9_water'\
\9}\
\
\9return 'mod_assets/textures/'..runeMap[runeChar]..'.tga'\
end\
\
function getRunePosition(runeChar)\
\9local  positions = {\
\9\9A = {1,1},\
\9\9B = {1,2},\
\9\9C = {1,3},\
\9\9D = {2,1},\
\9\9E = {2,2},\
\9\9F = {2,3},\
\9\9G = {3,1},\
\9\9H = {3,2},\
\9\9I = {3,3}\9\9\9\9\9\9\
\9}\
\9return positions[runeChar]\
end\
\
function setSpells(pspells)\
\9spells = {}\
\9i = 1\
\9for spellName,def in pairs(pspells) do\
\9\9table.insert(spells,i,def)\
\9\9i = i + 1\
\9end\
end\
\
function createSpellBook()\
\9local book = gw_image.create('spell_book',20,20,900,800,'mod_assets/textures/book_900.tga')\
\9book.onDraw = function(self,ctx,champion) \
\9\9if champion and champion:getClass() ~= 'Mage' then\
\9\9\9return false\
\9\9end\9\9\
\9end\
\9\
\9for _,spell in ipairs(spells) do\
\9\9local p = book:addChild(createSpellParagraf(spell))\
\9\9p:setRelativePosition('below_previous')\
\9end\
\9\
\9return book\
\
end\
\
function createSpellParagraf(spell)\
\9local p = gw_rectangle.create(spell.name,0,0,200,30)\
\9p.marginTop = 10\
\9p.marginLeft = 20\
\9p.color = {0,0,0,0}\
\9p:addChild('button3D',spell.name..'_memo',0,0,'Memorize')\
\9local text = p:addChild('text',spell.name..'_text',0,0,300,20,spell.uiname)\
\9text.marginLeft = 10\
\9text:setRelativePosition('after_previous')\
\9\
\9text.spell = spell\
\9\
\9text.onClick = function(self,ctx)\
\9\9\9if (self.spell.runes) then\
\9\9\9\9local runes = gw_rectangle.create('spell_book_runes',500,100,350,400)\
\9\9\9\9runes.color = {0,0,0,100}\
\9\9\9\9for i=1,#spell.runes do\
\9\9\9\9\9local runeChar = string.sub(spell.runes,i,i)\
\9\9\9\9\9local runeImg = runes:addChild('image','rune_'..runeChar,0,0,100,100,spell_book.getRuneImage(runeChar))\
\9\9\9\9\9local pos = spell_book.getRunePosition(runeChar)\
\9\9\9\9\9runeImg.x = pos[1] * 80 - 80\
\9\9\9\9\9runeImg.y = pos[2] * 80 - 80\
\9\9\9\9end\9\9\
\9\9\9\9local t = runes:addChild('text','rune_text',0,0,300,200,spell.description)\
\9\9\9\9t:setRelativePosition{'bottom','center'}\
\9\9\9\9gw.removeElement('spell_book_runes','skills')\
\9\9\9\9gw.addElement(runes,'skills')\
\9\9\9\9\
\9\9\9end\9\9\
\9end\
\9return p\
\9\
end\
\
function autoexec()\
\9-- testing\
\9setSpells{\
\9\9{name='fireburst',uiname='Fireburst',runes='A',description='Caster creates a quick burst of fire in front of him'},\
\9\9{name='ice_shards',uiname='Ice Shards',runes='GI',description='Caster shoots a flurry of ice shards in front of him'}\
\9}\
\9\
\9\9\
\9local book = spell_book.createSpellBook()\
\9gw.addElement(book,'skills')\
end\
")
spawn("script_entity", 28,31,2, "compass")
	:setSource("-- This example draws a compass as a GUI element. Depending on which\
-- activation mode is chosen, it can be visible all time, toggled\
-- with 'c' key or shown only when 'c' is pressed.\
\
-- draws actual compass\
-- this function is called when compass is visible all time\
function drawCompass(self, g)\
\9local x = 10\
\9local y = g.height - 200\
\9\
\9local dir = string.sub(\"NESW\", party.facing + 1, party.facing + 1)\
\9g.drawImage(\"mod_assets/textures/compass_full_\"..dir..\".tga\", x, y)\
end\
\
-- this is a simple wrapper function that is called as key press\
-- hook. It calls drawCompass function.\
function callback(g)\
\9drawCompass(self, g)\
end\
\
function autoexec()\
\9local e = {}\
\9e.id = 'compass'\
\9e.draw = drawCompass\
\9e.callback = callback\
\9\
\9-- uncomment this to enabled/disable compass by pressing C\
\9gw.setKeyHook('c', true, e.callback)\
\9\
\9-- Uncomment this to show compass by pressing C\
\9-- gw.setKeyHook('c', false, e.callback)\
\9\
\9-- Uncomment this to have compass permanently visible\
\9-- gw.addElement(e,'gui')\
end")
spawn("wall_button", 14,16,3, "wall_button_2")
	:addConnector("toggle", "gui_demo", "drawExample")
spawn("script_entity", 12,16,2, "gui_demo")
	:setSource("-- This function showcases how gwElements may be stacked together\
function drawExample()\
\
\9gw.setDefaultColor({200,200,200,255})\
\9gw.setDefaultTextColor({255,255,255,255})\
\
\9-- background yellow image\
\9local rect1 = gw_rectangle.create('rect1', 100, 50, 600, 300)\
\9rect1.color = {255, 255, 0}\
\9gw.addElement(rect1, 'gui')\
\9\
\9-- Example of image within \
\9local img1 = gw_image.create('image1', 0, 0, 177, 190, 'mod_assets/images/example-image.dds')\
\9rect1:addChild(img1)\
\9img1:setRelativePosition({'right','bottom'})\
\9\
\9local button1 = gw_button3D.create('button1', 70, 10, \"3D-ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\
\9button1.textColor = {200,100,0}\
\9\
\9button1.onClick = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button1)\
\9button1:setRelativePosition({'left','bottom'})\
\9\
\9local button2 = gw_button.create('button2', 70, 40, \"abcdefghijklmnopqrstuvwxyz\")\
\9button2.onPress = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button2)\
\
\9\
\9local button3 = gw_button.create('button3', 70, 70, \"1234567890\")\9\
\9button3.color = button1.color\
\9button3.onPress = function(self) print(self.id..' clicked') end\
\9rect1:addChild(button3)\
\9\9\
\
\9-- Create directly to parent example\
\9local button4 = rect1:addChild('button','button4', 70, 100, \"!@#$%^&*()-,.'\")\
\9button4.color = button1.color\
\9button4.onPress = function(self) print(self.id..' clicked') end\
\
\9local button5 = rect1:addChild('button','button5', 70, 100, \"After element position\")\
\9button5.color = button1.color\
\9button5:setRelativePosition({'after','button4'})\
\9button5.marginLeft = 10\
\9\
\9local button6 = rect1:addChild('button','button6', 70, 100, \"Below element position\")\
\9button6:setRelativePosition{'below','button5'}\
\9button6.marginLeft = 10\
\9button6.marginTop = 15\
\9\
\9local button7 = rect1:addChild('button','button7', 70, 100, \"After button5\")\
\9button7.color = button1.color\
\9button7:setRelativePosition({'after','button5'})\
\9button7.marginLeft = 10\9\
\9\
\9rect2 = rect1:addChild('rectangle','rect2', 0, 0, 50, 50)\
\9rect2.color={0, 0, 255}\
\9rect2:setRelativePosition{'left','top'}\
\9\
\9local rect3 = rect2:addChild('rectangle','rect3', 0, 0, 30, 30) -- rect3 in rect2, which is in rect1\
\9rect3:setRelativePosition{'middle','center'}\
\9rect3.marginTop = 5\
\9rect3.marginLeft = 10\
\9rect3.color = {255, 0, 0}\
\9rect3.onPress = function(self) \
\9\9print('rectangles can be clicked too')\
\9end\
\
\9local text1 = rect1:addChild('text','text1',0,0,200,100)\
\9text1:setRelativePosition{'bottom','center'}\
\9\
\9text1.text = \"Long text should be wrapped automatically. Does it work?\"\
\9text1.textColor = {0,255,255}\
\9\
\9local closeButton = rect1:addChild('button3D','close_rect_1',20,20,'X',30,20)\
\9closeButton.onPress = function(self)\
\9\9self:getAncestor():deactivate()\
\9end\
\9closeButton:setRelativePosition({'top','right'})\
\9\
\9\
\9gw.addElement(rect1, 'gui')\
\9\
\9\
end\
")
spawn("dungeon_wall_text_long", 14,16,3, "dungeon_wall_text_long_1")
	:setWallText("Shows gwElements (several gui elements\
that are hierarchically organized)")
spawn("script_entity", 0,0,1, "logfw_init")
	:setSource("spawn(\"LoGFramework\", party.level,1,1,0,'fwInit')\
fwInit:open() \
function main()\
   fw.debug.enabled = false\
   fwInit:close()\
end")
spawn("dungeon_door_portcullis", 17,16,3, "dungeon_door_portcullis_1")
spawn("dungeon_door_portcullis", 17,15,3, "dungeon_door_portcullis_2")
spawn("snail", 18,15,0, "snail_1")
spawn("wall_button", 14,14,3, "wall_button_3")
	:addConnector("toggle", "new_champion", "newChampion")
spawn("dungeon_wall_text", 14,14,3, "dungeon_wall_text_2")
	:setWallText("Use this button to get someone new\
in your party! The more the merrier!")
spawn("script_entity", 12,14,2, "new_champion")
	:setSource("function newChampion()\
\9newguy = {\
\9\9name = \"Rookie\",    -- just a name\
\9\9race = \"Insectoid\", -- Must be one of: Human, Minotaur, Lizardman, Insectoid\
\9\9class = \"Fighter\",  -- Must be one of: Figther, Rogue, Mage or Ranger\
\9\9sex = \"male\", \9\9-- Must be one of: male, female\
\9\9level = 3,\
\9\9portrait = \"mod_assets/textures/portraits/taghor.dds\" -- must be 128x128 dds file\
\9}\
\9\
\9addChampion(newguy)\
\
end\
\
function addChampion(newguy)\
\
\9-- first let's check if there is empty slot\
\9for i=1,4 do\
\9\9if not party:getChampion(i):getEnabled() then\
\9\9\9chosen(i, newguy)\
\9\9\9return\
\9\9end\
\9end\
\
\
\9-- background border\
\9local dialog = gw_rectangle.create('dialog', 100, 50, 660, 280)\
\9dialog.color = {128, 128, 128, 200}\
\9gw.addElement(dialog, 'gui')\
\
\9local text1 = dialog:addChild('rectangle','text1', 10, 10, 640, 50)\
\9\
\9text1.text = newguy.name .. \" would like to join your party, but since there is already four of you\"\
\9\9..\", someone else would have to go. Please pick who you want to leave behind:\"\
\9text1.color = {255,255,255}\
\9dialog:addChild(text1)\
\
\9for i=1,4 do\9\
\9\9local info = showChampion(i, party:getChampion(i))\
\9\9dialog:addChild(info)\
\9\9info.x = 10 + (i-1)*130\
\9\9info.y = 70\
\9\9info.onPress = function(self) chosen(i, newguy) end\
\
\9\9-- we could use info:setRelativePosition({'after','info'..(i-1)}) here,\
\9\9-- but that would make the rectangles to touch each other without any\
\9\9-- borders or margins\
\9end\
\9\
\9local info = showCandidate(newguy)\
\9dialog:addChild(info)\
\9info.x = 10 + 4*130\
\9info.y = 70\
\9info.onPress = function(self) chosen(5, newguy) end\
\
end\
\
function chosen(id, newguy)\
\9print(\"Chosen \"..id)\
\9\
\9-- someone from the old party has to go\
\9if (id >= 1 and id <= 4) then\
\9\9setNewChampion(id, newguy)\
\9end\
\9\
\9-- the new guy has to go\
\9if (id == 5) then\
\9\9local tmp\
\9\9if newguy.sex == \"male\" then\
\9\9\9tmp = \"him\"\
\9\9else\
\9\9\9tmp = \"her\"\
\9\9end\
\9\9hudPrint(newguy.name .. \" turns back and goes away. You never seen \"..tmp..\" again.\")\
        gw.removeElement('dialog', 'gui')\
\9end\
end\
\
function dropAllItems(champion)\
\9for slot=1,31 do\
\9\9local item = champion:getItem(slot)\
\9\9if item then\
\9\9\9local saveditem = grimq.saveItem(item)\
\9\9\9champion:removeItem(slot)\
\9\9\9grimq.loadItem(saveditem, party.level, party.x, party.y, party.facing, saveditem.id)\9\9\9\
\9\9end\9\
\9end\
end\
\
function setNewChampion(id, newguy)\
\9\
\9local x = party:getChampion(id)\
\9local old_name = x:getName()\
\9local empty_slot = x:getEnabled()\
\9x:setName(newguy.name)\
\9x:setRace(newguy.race)\
\9x:setClass(newguy.class)\
\9x:setSex(newguy.sex)\
\9x:setEnabled(true)\
\9x:setPortrait(newguy.portrait)\
\9\
\9dropAllItems(x)\
\9\
\9hudPrint(newguy.name..\" joins your party. \"..old_name.. \" will be remembered as a good fellow.\")\
\9gw.removeElement('dialog', 'gui')\
\
end\
\
function showChampion(id, champion)\
\9local info = gw_rectangle.create(\"info\"..id, 0, 0, 120, 200)\
\9info.color = {255,255,255}\
\9info.text = champion:getName()\
\9\
\9local details = gw_rectangle.create(\"details\"..id, 0, 50, 120, 150)\
\9details.color = { 192, 192, 255, 255}\
\9info:addChild(details)\
\9details.text = champion:getRace() .. \"\\n\" \
\9            .. champion:getClass() .. \"\\n\"\
\9            .. champion:getSex() .. \"\\n\"\
\9\9\9\9.. champion:getLevel() .. \" level\"\
\9details.dontwrap = true\
\9            \9\
\9return info\
end\
\
function showCandidate(champion)\
\9local info = gw_rectangle.create(\"info5\", 0, 0, 120, 200)\
\9info.color = {230, 255, 230}\
\9info.text = champion.name\
\9\
\9local details = gw_rectangle.create(\"details5\", 0, 50, 120, 150)\
\9details.color = { 192, 192, 255, 255}\
\9info:addChild(details)\
\9details.text = champion.race .. \"\\n\" \
\9            .. champion.class .. \"\\n\"\
\9            .. champion.sex .. \"\\n\"\
\9\9\9\9.. champion.level .. \" level\"\
\9details.dontwrap = true\
\9return info\
end")
spawn("lightning_rod", 14,14,3, "lightning_rod_1")
spawn("sack", 15,15,3, "sack_1")
spawn("rock", 15,15,1, "rock_1")
spawn("rock", 15,15,0, "rock_2")
spawn("lever", 14,15,3, "lever_1")
	:addConnector("activate", "debug", "debugGrid")
	:addConnector("deactivate", "debug", "disableGrid")
