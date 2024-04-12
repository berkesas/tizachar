# Tizachar
Fast command launcher for Windows

Tizachar is simple AutoIt script for a shortcut system to increase personal productivity. The idea is that many computers users today are very good at using their keyboards and using mouse to click on menus or shortcut icons for just launching programs is not very effective. Moreover, shortcut icons cause too much desktop clutter and nowadays can affect privacy as well. 

Therefore Tizachar takes a list of commands from a text file and lists them in a simple dialog window. Users can enter an ID number or some text based shortcut of a command to launch the pre-defined program for that command. For example, "dws" can be used to quickly open "Downloads" folder, or "cp" can be used to open "Control Panel". By using this you will be able to clean your desktop at the same time getting even more productive.

The number of commands and their purposes are up to you. It depends on your creativity. You can also assign keyboard shortcuts in AutoIt SendKey format.

# How to use
1. Prepare your tizachar.txt file with commands. Choose your most-frequently-used folders, programs, other scripts following the sample tizachar.txt file. The order of parameters is fixed.
2. Compile the tizachar.au3 file with AutoIt.
3. In the system tray you will see the launcher. You can right click on the icon to see "Show" and "Exit" menu. If you click "Show" all commands are listed.
4. You can also launch it by pressing "Ctrl+Numpad0" which is the default key combination for displaying/hiding the main window.
5. Enter the ID or Code of the command you want to run. The program will run and the commands window will be hidden back to the system tray.

# Future
Todo list
- making display window fit in the screen size
- increase localizibality/support for multiple languages
- improving general usability


