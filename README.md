# Road-to-Vostok-Mods
Mods for indie survival shooter, [Road to Vostok](https://store.steampowered.com/app/1963610/Road_to_Vostok/).
# Notes
Some useful links to get started.
* [Getting started.](https://github.com/Ryhon0/VostokMods/wiki) Thank you [Ryhon](https://github.com/Ryhon0).
* [MCM configuration.](https://github.com/DoinkOink/Mod-Configuration-Menu-Road-To-Vostok/wiki) Thank you [DoinkOink](https://github.com/DoinkOink).
# Tips
To debug mod in your work environment, simply make `Main.gd` as an autoload in the `Project Settings`.<br><br>
If your mod uses any `.tres` or `.res` files, before you pack it in `.vmz` Archive make sure to open those files in any text editor and change the path field.<br>
+ <b>E.g.</b> In `ShowTimeOfDay` mod, I am using `TimeFormat.tres`. So before making the mod as archive.<br>
+ Open `.tres` file in any text editor.<br>
+ Find the `ext_resource` attribute and edit its `path` property to `res://` + consider your mod.txt as root and give path to your `Resource script.gd`.<br>
+ In this case it should look like `path="res://ShowTimeOfDay/TimeFormat.gd"`.<br><br>

In your mod, DO NOT statically type your `gdscript` types.<br>
+ <b>E.g.</b> If `Example.gd` is in the mod, don't go, `var example: Example`.<br>
