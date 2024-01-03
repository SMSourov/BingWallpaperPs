# Import the module
from gi.repository import Notify, GdkPixbuf
import sys

# Initialize
Notify.init("BingWallpaperPS")

# Create a notification object
# title = "BingWallpaperPS"
# fileName = "Give a file name here. Usually the file names aren't too long. Or may be. Who knows? I don't care. Why should I care. It is not mandatory for me."
# image = GdkPixbuf.Pixbuf.new_from_file("/home/sourov/Documents/Bing/Bing wallpaper/FHD/20231229 - Oud West neighborhood, Amsterdam, Netherlands_FHD.jpg")

# Define the value given in command line. sys.argv[0] means the file
title = str(sys.argv[1])
message = str(sys.argv[2])
# image = sys.argv[3]

# # Make an object for the image
# pixbufImage = GdkPixbuf.Pixbuf.new_from_file(image)

# Show the statement
notification = Notify.Notification.new(title, message)

# # Define the image for the notification
# notification.set_image_from_pixbuf(pixbufImage)


# Define the button action
def buttonAction():
    pass

# Make a button
notification.add_action(
    "action_click",
    "Great!",
    buttonAction,
    None
)

# Show the notification
notification.show()
