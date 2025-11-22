import sys

preliminaryMapPath = sys.argv[1]
buildFolder = sys.argv[2]

with open(preliminaryMapPath) as mapFile:
    for line in mapFile:
        if "GODDARD_SIZE" in line:
            tokens = line.split()
            with open(f"{buildFolder}/goddard.txt", "w+") as outputFile:
                sz = int(tokens[0], 16)
                sz += 16
                sz &= 0xFFFFFFF0
                outputFile.write(f"GODDARD_SIZE = 0x{sz:X};\n")
            sys.exit(0)
