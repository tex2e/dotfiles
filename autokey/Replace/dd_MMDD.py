# Enter script code
import datetime
now = datetime.datetime.now()
output = str(now.month) + '/' + str(now.day)
keyboard.send_keys(output)