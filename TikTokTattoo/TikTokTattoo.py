import pyautogui
import time
import os

file_path = r"C:\Users\Owner\Documents\Processing\projects\TikTokTattoo\command.txt"
userInput = 'l'
commentsOpen = False
shareOpen = False
page = "fyp"

print("Listening for commands...")

while True:
    if os.path.exists(file_path):
        with open(file_path, "r") as file:
            command = file.read().strip()

        # userInput = input("enter a char: ")
        # if userInput == 'y':
        #     x, y = pyautogui.position()
        #     print(f"Captured Position: ({x}, {y})")
        #     break

        if command == "swipe up":
            print("Swiping Up")
            pyautogui.press("down")

        elif command == "swipe down":
            print("Swiping Down")
            pyautogui.press("up")

        elif command == "like":
            print("Liking/Unliking Video")
            pyautogui.press("l")

        elif command == "cycle":
            if commentsOpen:
                pyautogui.moveTo(42, 192)
                pyautogui.click()
                commentsOpen = False
            if page == "fyp": #switces page to following
                print("Switching to Following Page")
                pyautogui.moveTo(249, 443)
                pyautogui.click()
                page = "following"
            else: #switches page to fyp
                print("Switching to For You Page")
                pyautogui.moveTo(253, 330)
                pyautogui.click()
                page = "fyp"

        elif command == "pause":
            print("Pausing/Unpausing Video")
            pyautogui.moveTo(589, 655)
            pyautogui.click()

        elif command == "share": 
            print("Opening/Closing Share Menu")
            if commentsOpen:
                if shareOpen == False:
                    pyautogui.moveTo(1359, 460)
                    pyautogui.click()
                    shareOpen = True
                else:
                    pyautogui.moveTo(1359, 430)
                    pyautogui.click()
                    shareOpen = False
            else:
                pyautogui.moveTo(1012, 997)
                pyautogui.click()

        elif command == "follow":
            print("Followed Creator")
            if commentsOpen:
                pyautogui.moveTo(1310, 230)
                pyautogui.click()
            else:
                pyautogui.moveTo(1075, 645)
                pyautogui.click()

        elif command == "comment":
            if commentsOpen:
                print("Closing comment section")
                pyautogui.moveTo(42, 192)
                pyautogui.click()
                commentsOpen = False
            else:
                print("Opening comment section")
                pyautogui.moveTo(1005, 790)
                pyautogui.click()
                commentsOpen = True
            
        elif command == "favorite":
            print("Favorited/Unfavorited Video")
            if commentsOpen:
                pyautogui.moveTo(1038, 416)
                pyautogui.click()
            else:
                pyautogui.moveTo(1019, 894)
                pyautogui.click()

        elif command == "download":
            print("Download Opened/Closed")
            pyautogui.moveTo(589, 655)
            pyautogui.rightClick()
            pyautogui.moveTo(620, 685)
            pyautogui.click()

        elif command == "mute":
            print("Mute/UnMuted Video")
            pyautogui.press("m")

        elif command == "refresh":
            print("Refreshed Page")
            pyautogui.hotkey("ctrl", "r")

        with open(file_path, "w") as file:
            file.write("")
    else:
        print(f"File '{file_path}' not found.")  # Print message if the file doesn't exist
    time.sleep(0.5)
