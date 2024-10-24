Before you commit
* Format
* Spell check
* Document everything you touched
* Make sure it all works

# Minor
* Make it possible to open status menu when selecting a destination
* Rename Dark to Eldrich and Light to Holy
* Merge EVs for Strength, Pierce, and Int
* Have option to display stat details all at once
* Bring weapon stats up to par with data sheet
* Renovate debug menu
	* Split into debug options and the others.
	* Add debug constant to control whether the setting is displayed in the main map menu

# Major
* Document classes (roll this out gradually so I don't burn out)
* Add options menu
	* Smooth Scrolling
	* Config file
	* Make one for faster map animations.
	* One for volume
* Implement effective damage
	* Display effective damage on status screen.
* Implement weapon rank bonuses
* Investigate particles.
* Implement terrain stars and a terrain status menu.
* Make movement and related tiles behave more like in AW:DoR
* Add combat preview even if attacking is not possible
* Add rescue when clicking on an ally
* Replace movement/attack tile calls with units having different ActionTileStates
	* display_current_attack_tiles should allow displaying support tiles
* Have level up play sfx even when volume is muted
* Add class relative power
* Add options config for volume
* Add the remaining sub menus of the main map menu
* Make GhostUnit a child of Unit and remove jankiness
* Make attack Animations skippable
* Dual Wielding
* Implement durability
* Implement authority
* Implement AI
* Implement staves
	* Duration = (staff might) + (mag - target res)/4
	* Automatically hover over a unit if they are the only one that needs healing
* Implement split screen like in demo
* Replace test map with Thracia chapter 1
* Replace map attack animations with Thracia counterparts
* Implement a project system
* Do something about the way input works
* Implement gaining EVs
	* Have units gain +0.02 movement EVs per tile traversed

# Long-term
* Dungeon crawler thing.
* FERemix/Age of Emblem?
* Implement FE5 Chapter 1
* Make game based on design document
