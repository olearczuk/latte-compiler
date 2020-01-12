# PYTHON 3 ONLY

from os import system, listdir, path
from sys import argv
import subprocess


yellow = "\u001b[33m"
green = "\u001b[32m"
red = "\u001b[31m"
blue = "\u001b[34m"
cyan = "\u001b[36m"
reset = "\u001b[0m"
magenta = "\u001b[35m"


if len(argv) < 3:
    print("Arguments: <dir with tests> ./latc_x86 <silent/normal - optional>")
    exit(1)
else:
    cmd = argv[2].split(" ")

dirr = argv[1]
while dirr.endswith("/"):
    dirr = dirr[:-1]

if system("make") != 0:
    exit()

good_counter = 0
bad_counter = 0
def runFile(f, is_silent):
    global good_counter
    global bad_counter
    print(magenta + "FILE " + yellow + f + cyan)

    if is_silent == False:
        system("cat " + f)
        print("\n" + magenta + "FILE END")

    should_end = False

    res = subprocess.run(cmd + [f], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if res.returncode == 0:
        binary_name = f[:-4]
        res_file_name = binary_name + ".res"
        res_file = open(res_file_name, "w")
        output_file = binary_name + ".output"
        input_file = binary_name + ".input"

        if path.isfile(input_file):
            subprocess.run(binary_name, stdin=open(input_file, "r"), stdout=res_file, stderr=subprocess.PIPE)
        else:
            subprocess.run(binary_name, stdout=res_file, stderr=subprocess.PIPE)
        
        diff_command = "diff " + output_file + " " + res_file_name
        diff = subprocess.run(["diff", output_file, res_file_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        if diff.returncode == 0:
            print(green)
            print("TEST PASSED")
            good_counter += 1
            should_end = False
        else:
            print(red)
            print("\n------ CORRECT ------")
            system("cat " + output_file)
            print("\n------ ACTUAL ------")
            system("cat " + res_file_name)
            print("\n------ DIFF ------")
            system(diff_command)
            should_end = True
    else:
        print(red)
        print(res.stderr.decode("utf-8"))
        print(res.stdout.decode("utf-8"))
        bad_counter += 1
        should_end = False
    
    if is_silent == False:
        print(reset)
        a = input("Press Enter to continue, q to quit...\n")
        if 'q' in a:
            return True
        print("")
        return False
    else:
        return should_end


if len(argv) < 4:
    for f in listdir(dirr):
        if f.endswith(".lat") and runFile(dirr + "/" + f, False):
            break
elif argv[3] == "silent":
    for f in listdir(dirr):
        if f.endswith(".lat") and runFile(dirr + "/" + f, True):
            break
    print(reset)
    print("Good runs: ", good_counter)
    print("Bad runs: ", bad_counter)
