# MusclePaint

###Requirements
Processing -- https://processing.org/
OpenBCI Ganglion board (also the BLE dongle if you are using Windows)

###How to use
First clone or download a zip of this repository.  
Take all of the contents inside the folder `OpenBCI_Processing` and put them inside the root doc of your main Processing sketch directory. 
Open the file `OpenBCI_GUI.pde` and run it.  
Connect to your OpenBCI Ganglion device, choose the IP, Port, and address of the OSC messages you want to send from the GUI (localhost port 6448 with address /wek/inputs by default).  
Start the system and start streaming data, the MicroVolt value of each channel will be updated and sent in real-time over OSC.
