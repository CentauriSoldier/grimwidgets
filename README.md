grimwidgets
===========

Written by Xanathar, JKos, Thomson. Includes large chunks of
code written by Mahric.

## DESCRIPTION

The goal of this project is to develop a flexible framework
for handling graphical rich events in Legend of Grimrock
(http://grimrock.net) game. In particular, its goals are
support for:

- generic widgets, like buttons, dialogs, text elements etc.
- Powerfull api for making custom GUIs
- encounters with NPCs
- shops
- scripted events

## INSTALLATION

TODO

## Demo
The easiest way to see grimwidgets examples is to download working demo.
You can do this by going to [project website](https://github.com/xanathar/grimwidgets)
and clicking [download](https://github.com/xanathar/grimwidgets/archive/master.zip) 
(the cloud button with ZIP written on it). It will download a zip file
that you should extract into your dungeons directory. Depending on your OS,
this will be:

- c:\Users\\[login]\Documents\Almost Human\Legend of Grimrock\Dungeons (Windows)
- ~/Library/Application Support/Almost Human/Legend of Grimrock/Dungeons (Mac OS)
- ~/.local/share/Almost Human/Legend of Grimrock/Dugeons (Linux)

Start Dungeon Editor in Grimrock and open the project. There will be many buttons
and items. Play with them to see various aspects of grimwidgets. You can then
start looking into the scripts to see how specific features are achieved.

## Using grimwidgets

Grimwidgets is a powerful framework that allows Object Oriented
Programming (OOP) with object hierarchy and inheritance. Experienced
programmers will enjoy it a lot. On the other hand, an average modder
without programming background may not know what all that means, so
grimwidgets provides a number of very simple to use functions to achieve
common tasks, like displaying a yes/no popup.

## High Level (Easy) Interface
If you prefer ease of use, this is the interface for you. If you rather
prefer flexibility and andvanced features, see Low level interface in 
follow up sections below.

### Simple dialog box
To display a dialog box with a single OK button use the following function
```lua
    Dialog.quickDialog(text_to_display)
```
This will display the text with a single OK button. The window will disappear
when the user clicks OK. You can also pass additional parameter, which is a
function name. That function will be called when the user clicks ok.
```lua
    Dialog.quickDialog(text_to_display, function_name)
```
#### Simple dialog box example

For example if you want to display a popup and once the window is closed, then
first party champion levels up. You could write the following code:
```lua
    function strangeMist()
        Dialog.quickDialog([[Your party approaches an eerie mist.
        One of you tries to touch it. Mist disappears and you feel enlightened.]],
        clicked)
    end

    function clicked()
        party:getChampion(1):levelUp()
    end
```
Now you must make sure that the strangeMist() function is called at the appropriate
time. You can hook it to (potentially invisible) pressure plate, to timer, to
lever etc. Once the strangeMist() is triggered, it will display the dialog box.
You may note that the text is specified with double brackets. This is Lua way of 
defining multi-line strings. Once the user clicks ok, the clicked() function is called.
You can do whatever you want there - print out something, spawn new items, open doors
etc.

An example run of such a GUI:

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-ok.png)

### Yes/No Dialog
It is useful to ask a simple yes/no questions and get user's response. You can
create such a dialog using the following functions:
```lua
    dialogId Dialog.quickYesNoDialog(text, callback, npcId)
```
text specifies text to display, callback is a name of the function that will be
called after user clicks something. npcId is an optional Non-Player Character (NPC)
identifier if you use NPC module. You can specify nil here if you don't want to
use it.

Once the dialog is created, it is not displayed yet. It can be displayed using
the following call:
```lua
    Dialog.activate(dialogId, callback)
```
Make sure you pass dialogId returned by Dialog.quickYesNoDialog here.

#### Yes/No dialog example
Here's an example dialog to test player's courage:
```lua
    function yesNoQuestion()
        local dialogId = Dialog.quickYesNoDialog("Hey! Are you brave?", callback, nil)
        Dialog.activate(dialogId, calback)
    end

    function callBack(answer)
        if answer == "Yes" then
            hudPrint("Yeah, right...")
        end
        if answer == "No" then
            hudPrint("Run for your life! There's killer snail after you")
        end
    end
```
![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-yes-no.png)

### Dialog box with custom buttons

It is often useful to let the user make a decision or ask about something.
This is slightly more complicated and requires couple steps:
```lua
    dialogId Dialog.new(text, buttonText, npcId)
```  
text is a text to be displayed. buttonText is the text on a first button.
npcId is an optional parameter that specify Non-Player Character (NPC) identifier.
It is only usable if you also use NPC module. If not using NPCs, specify nil here.
This method returns dialogId. Make sure you store it in a variable, because
you'll need it to add other buttons or show the dialog.

Now you can add additional buttons using the following call:
```lua
    Dialog.addButton(dialogId, buttonText)
```    
Once you have added all buttons, you can display the window:
```lua
    Dialog.activate(dialogId, callback)
```   
This will display dialog specified by dialogId (as returned by Dialog.new())
and will call callback function after the user clicks one of the buttons.

#### Dialog box with custom buttons example
Let's imagine a case where user meets a big ogre and he asks the party to leave. The
options would be to apologize and or insult the ogre. The following code can be used
to achieve that goal:
```lua
    agree ="I'm going already!"
    refuse = "Right, make me!"

    function clickOgre()
        local text = "Hey! What are you doing here? Leave while you can!"
        
        -- This created a new dialog with text written on it and a single 
        -- button that has value of agree variable written on it
        local dialogId = Dialog.new(text, agree, nil)
        
        -- Add another button that will challenge the ogre
        Dialog.addButton(dialogId, refuse)
        
        -- Display our dialog and call clicked method when user chooses something
        Dialog.activate(Dialog, clicked)
    end

    fucntion clicked(clickedText)
    	if clickedText == agree then
    	    hudPrint("Party if full of chickens!")
    	end
    	if clickedText == refuse then
    	    hudPrint("Ogre is now furious!")
    	end
    end
```
![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-custom.png)

### Dialog box with extra widgets

TODO

![](https://raw.github.com/xanathar/grimwidgets/master/doc/dialog-widgets.png)

### New Party Members
It is possible to specify that a new champion wants to join your party. The
following code allows that:
```lua
function newChampion()
	newguy = {
		name = "Taghor",    -- just a name
		race = "Insectoid", -- must be one of: Human, Minotaur, Lizardman, Insectoid
		class = "Mage",     -- must be one of: Figther, Rogue, Mage or Ranger
		sex = "male", 		-- must be one of: male, female
		level = 3,          -- character's level
		portrait = "mod_assets/textures/portraits/taghor.dds", -- must be 128x128 dds file
		
		-- allowed skills: air_magic, armors, assassination, athletics, axes, daggers, 
		-- dodge, earth_magic, fire_magic, ice_magic, maces, missile_weapons, spellcraft,
		-- staves, swords, throwing_weapons and unarmed_combat
		skills = { fire_magic = 10, earth_magic = 20, air_magic = 30, ice_magic = 40 },
				
		-- allowed traits: aggressive, agile, athletic, aura, cold_resistant, evasive, 
		-- fire_resistant, fist_fighter, head_hunter, healthy, lightning_speed,
		-- natural_armor, poison_resistant, skilled, strong_mind, tough
		-- Traits must be specified in quotes.
		-- Typically each character has 2 traits, but you can specify more or less.
		traits = { "lightning_speed", "tough", "skilled", "head_hunter", "aura" },
		
		health = 80, 		  -- Maximum health
		current_health = 70,  -- Current health
		
		energy = 300,         -- Maximum energy
		current_energy = 250, -- Current energy

		strength = 12,        -- Strength
		dexterity = 11,       -- Dexterity
		vitality = 10,        -- Vitality
		willpower = 9,        -- Willpower
		
		protection = 25,      -- protection
		evasion = 30, 		  -- evasion
				
		-- Resist fire/cold/poison/shock (remember that those values will be modified by bonuses
		-- from fire, cold, poison or shock magic
		resist_fire = 11,
		resist_cold = 22,
		resist_poison = 33,
		resist_shock = 44,
		
		-- items: Notation item_name = slot. Slots numbering: 1 (head), 2 (torso), 3 (legs), 4 (feet), 
		-- 5 (cloak), 6 (neck), 7 (left hand), 8 (right hand), 9 (gaunlets), 10 (bracers), 11-31 (backpack
		-- slots) or 0 (any empty slot in backpack)
		-- Make sure you put things in the right slot. Wrong slot (e.g. attempt to try boots on head)
		-- will make the item spawn to fail.
		items = { battle_axe = 0, lurker_hood = 1, lurker_vest = 2, lurker_pants = 3, lurker_boots = 4 },
		
		-- food: 0 (starving) to 1000 (just ate the whole cow)
		food = 100
		
	}

	-- Call addChampion method. It will add new guy to the party if there are suitable slots and will
	-- display a GUI prompt selecting a party member to drop if your party is already 4 guys
	gw_party.addChampion(newguy)
end
```
Typically the party is made of 4 champions from the beginning, which happens to be
the maximum number. If there is space left (i.e. there are 3 or less champions), the
new guy joins in immediately. If the party is full, a dialog box appear asking
which one to leave behind. It is possible to choose the new guy, which effectively
means that the new guy does not join.

Due to Grimrock scripting API limitation, it is not possible for a new guy to have
level lower than the one that he/she replaces.

The GUI for a new guy to join looks like this:

![](https://raw.github.com/xanathar/grimwidgets/master/doc/party-join.png)



### Generic book
Grimwidgets provides a convenient way to define a generic purpose book. It
may be used as a diary, spellbook, questlog, bestiary, or anything else
used to keep information.

First step is to create a book:
```lua
    book gw_book.create(id)
```    
This call will create and return a book object that will use specified id. Make
sure that your id is unique. The next step is to specify book text color. The rest
of this section assumes that there is an object called book that is an instance
of the book created with gw_book.create().
```lua
    book.textColor = { red, green, blue, alpha }
```    
This specifies color of the text. red, green, blue and alpha all take values from
0 to 255. Alpha 0 means totally transparent and 255 means totally opaque. This
applies to all following additions. 

The next step is to define first page header:
```lua
    book:addPageHeader(pageNumber, headerText)
```    
After that a text can be added:
```lua
    book:addPageText(pageNumber, text)
```
You can also add images to the book:
```lua
    book:addPageImage(pageNumber, pathToImage, width, height)
```
It is possible to define columns on a page. Just add regular text with a addPageText
call, and then adjust its width:
```lua
    local column1 = book:addPageText(1,"Want multiple columns?")
    column1.width = 100
    col1:calculateHeight()
    local column2 = book:addPageText(1,"Here you go")
    column2:setRelativePosition('after_previous')
    column2.width = 200
```
After the book is created and contains all required content, you should use it
as any other gwElement. See section below caled "How to use gwElement?".

#### Book example
The following code could be used to create an example book:
```lua
    local book = gw_book.create('test_book_1')
    book.textColor = {100,100,100,210}

    -- Define page 1 (with 2 sections)
    book:addPageHeader(1,'This is the header of the 1st page.')
    book:addPageText(1, [[This is a multiline
    text about nothing specific.
    Just a text]])
    book:addPageHeader(1,'Second header')
    book:addPageText(1,"There may be many header on the same page")

    -- Define page 2 (with image and multiple columns)
    book.textColor = {200,200,200,210}
    book:addPageHeader(2,'Different font color for this page.')
    book:addPageText(2,'Lets and an image here')
    book:addPageImage(2,'mod_assets/textures/compass_full_E.tga',200,200)
    book:addPageText(2,'and some text below it')

    -- Define multiple columns (still on page 2)
    local col1 = book:addPageText(2,'Want multiple columns?')
    col1.width = 100
    col1:calculateHeight()
    local col2 =book:addPageText(2,'Here you go')
    col2:setRelativePosition('after_previous')
    col2.width = 200
    			
    book:openPagePair(1)
			
    gw.addElement(book)
```
The following example can produce the following result:
![](https://raw.github.com/xanathar/grimwidgets/master/doc/book.png)

    

## Low Level (Flexible) Interface
The most common reason to use grimwidgets is to display message popups.

### Available grimwidget elements


- gw_element
- gw_button
- gw_button3D
- gw_rectangle

### gw_element

gw\_element is the base element (or "class") of the all other gw-elements, which means that all other gw-elements do inherit all properties, methods and hooks of the gw\_element. 
It isn't drawn at all if you add it to the gui, but it can be used as a invisible container for other elements (like div in html).

####Constructor
gw_element.create(id, x, y, width, height)

####Properties

- id: (string) Identifier of the element. Not required for child elements.
- x: (int) horizontal position of the element. 
- y: (int) vertical position of the element
- marginLeft: (int, default 0) Margin to the element on the left side.
- marginTop: (int, default 0) Margin to the element on the top.
- width: (int, default 0) element width
- height: (int, default 0) element height
- parent: (gw_element) parent of the element
- children: (table of gw_element:s) 
- firstMousePressPoint = nil
- color: (table of integer:s) color of the element {red,green,blue,alpha} eg. {200,200,0,255}
- textColor: (table of integer:s) color of the element text {red,green,blue,alpha}
- textSize: (string) possible values are "tiny","small","medium","large"
- active: (boolean, default = true) if active = false then the element is not drawn.

####Public methods
- addChild(gw_element) 
- setRelativePosition(position): (string or table of strings) top,middle,bottom,left,center,right,after_previous,below_previous
- moveAfter(gw_element)
- moveBelow(gw_element)
- getAncestor() returns the first parent of the element 
- deactivate() deactivates the element (and it's possible child elements) so that it's not drawn.
- activate() activates the element so the element id drawn
- getChild(gw_element.id) returns the child element by id

####"Private" methods
These are called automatically by the framework and are important only if you are creating your own widgets.
- drawSelf(self,ctx,[champion]) 
- draw(self,ctx,[champion]) 

####Hooks
- onPress(self)
- onClick(self) 
- onDraw(self,ctx,champion)


### How to use gwElement?
There are many ways gwElements can be used.

First obvious one is to just diplay it. The following call can be used for that
purpose:

    gw.addElement(gwElement, hookName)

gwElement is a gwElement object, e.g. book. hookName specifies when the gwElement
should be displayed. Currently available hooks are: 'gui' (display always, after GUI
elements are diplayed), 'inventory' (display only when champion inventory is open),
'stats' (display only when statistics are open) or 'skills' (open only when skills
are open). If not specified, the default 'gui' will be assumed.

Once you decide that you no longer wish to see gwElement, you should remove it:

    gw.removeElement(gwElement, hookName)

It is possible to access one widget that is currently being displayed if you know
its id:

    gw.getElement(id, hookName)

It will return gwElement with a specified id (or nil if no such gwElement exists).

## Developing your own widgets
