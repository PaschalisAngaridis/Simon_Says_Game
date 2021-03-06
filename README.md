# Simon_Says_Game
The purpose of the work is the design and implementation on a reprogrammable logic board (FPGA) of the game Simon Says.
For those who have not played the game, the purpose of the game is the repetition of a sequence of 
illuminated or non-illuminated colors which becomes larger with each successful repetition.

Rules of the game 
To start the game you must firstly press RESET .Continuously the presentation of the sequence will begin.
In the first phase one of the four colors will be appear for half second,
so the player must press the specific color from the keyboard.
If the player press a wrong key from the keyboard the player lose and the game stop. On the other hand If 
the player take the right decision the game continuous and the points of the player increased by 1. 
Then the process repeated with the same way but in every step added one new color.

Circuit Structure 
The circuit you are called to draw follows the general structure shown in the figure below.
First, it's a good idea to separate the VGA display functions from the rest of the circuit.
The basic entity that will implement the game will simply send to the screen more color it 
wants to flashes via the blinkColor signal and from there on the VGA controller will take over 
viewing and synchronizing the screen with flashing. Next you need to separate the function of the
keyboard which will give the main unit only the information about which key was pressed (of the 4 that will 
correspond to the colors of the game) via colorPressed signals, while hiding from this function and keybclock and keybdata processing.

![image](https://user-images.githubusercontent.com/71699869/96465283-74f76580-1231-11eb-85b0-e4c8fb81f8ca.png)

The first step in your implementation is just to view a saved color sequence without user involvement.
This circuit displays one by one its colors so far sequence generated by reading them from the color
sequence memory in which the new color is saved at the start of a new round. Then you can repeat the same
experiment only the colors to be shown can be has been put one after the other by the user from the keyboard, 
without following its rules game.


