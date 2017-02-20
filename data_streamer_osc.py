import OSC
import time
import sys

if __name__ == '__main__':
    c = OSC.OSCClient()
    c.connect(('localhost', 6448))   # localhost, port 6448
    oscmsg = OSC.OSCMessage()
    oscmsg.setAddress("/wek/inputs")

    if len(sys.argv) < 2:
        print "USAGE: python data_streamer_osc.py 'FILE_NAME'"
        exit(1)

    filename = sys.argv[1]

    file = open(filename,"r")
    while 1:
        oscmsg.clear("/wek/inputs")
        where = file.tell()
        line = file.readline()
        if not line:
            time.sleep(1)
            file.seek(where)
        else:
            columns = line.split(',')
            columns = [col.strip() for col in columns]
            if len(columns) == 9:
                col1 = float(columns[1])
                col2 = float(columns[2])
                col3 = float(columns[3])
                col4 = float(columns[4])
                oscmsg.append(col1)
                oscmsg.append(col2)
                oscmsg.append(col3)
                oscmsg.append(col4)
                c.send(oscmsg)
                print col1, col2, col3, col4

