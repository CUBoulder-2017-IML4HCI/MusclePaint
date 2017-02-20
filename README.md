# MusclePaint

###Requirements
First, download the OpenBCI GUI here: http://openbci.com/index.php/downloads  

For the Python script you will need to install PyOSC.

###How to use
Power up OpenBCI Ganglion board and run the OpenBCI GUI. Depending on where you save your GUI executable, you will see a SavedData/ folder get created after you stream data to the GUI for the first time.  

When you run the python script you will want to take note of the full filepath of the log file the OpenBCI GUI is currently writing the live stream of data to (example: "/Applications/SavedData/OpenBCI-RAW-2017-02-19_19-41-50.txt")

Run the python script:  
`python data_streamer_osc.py /Applications/SavedData/OpenBCI-RAW-2017-02-19_19-41-50.txt`  
but replace the filepath with the correct one for your live stream of data.

The Python script sends to localhost port 6448 by default.
