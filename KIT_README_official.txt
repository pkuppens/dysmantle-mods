This package contains various tools for modding 10tons Ltd. games. Use them at your own risk! There's no documentation on how to use this stuff.

ALL TOOLS ARE PROVIDED AS-IS WITH NO SUPPORT OR (LOL) WARRANTY.

See the different subfolders for README.txts with more information. 

How to enable developer mode
============================

Some of the tools work without developer mode enable as long as you launch the game with the correct features (see below).
Sometimes you may still want to enable the full developer mode.

Copy the file developer.xml to the same folder where the game prog.xml file is to unlock developer mode. Restart the game. 
You may notice more buttons appearing in the UI.

BACK UP YOUR SAVES BEFORE USING THESE TOOLS IF YOU WISH TO CONTINUE "NORMAL" GAMEPLAY.
It's very easy to mess up saves by accident when working in developer mode. For example when pressing CONTROL+a, autotesting mode is enabled and the AI player starts playing the game. When the mode is enabled, your game state is altered permanently and marked as test save which affects all sorts of things.


How to create mods
==================

Run the game with mods. You can do this by passing the following command line parameters to the game executable:

DYSMANTLE.exe --features MODS,STAGE_EDITOR,SHADEGROWN_DEVELOPMENT_ENVIRONMENT

or you can launch the game from a launcher depending on the service you are using.

When you start the game, you should see Mods button appear in the main menu. Click it, see the disclaimer and consider if you want to agree, 
click the small hammer & wrench icon and choose Create Mod.. option. Follow the instructions there.

To test your mod, enable the mod in the subscribed mods list and click Apply Mods. You may also need to restart the game in some cases.


How to override game files in your mod
======================================

All the files you place in your mod folder (the folder where the mod-info.xml is located) will override any base game files and folders.
For example if you'd add a file /actors/players/survivor-male.xml in your mod folder it would override the player character.
You can use use thetools/nx-pak-took.exe to unpack the game files to see what's inside.
