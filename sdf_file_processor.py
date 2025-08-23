def file_process(file_name):
    f = open(file_name)
    lines = f.readlines()
    f.close()

    short_name = file_name.split("-")[0][0]+file_name.split("-")[1][0]+file_name.split("-")[2][0]+"-"+file_name.split("-")[3]+"-"+file_name.split("-")[4]
    w = open(short_name,"w")
    value = []
    for i in range(len(lines)):
        if "u-235" in lines[i] and "fission" in lines[i] and "0      0" in lines[i+1]:
            for j in range(51):
                if j != 50:
                    for k in range(5):
                        w.write(lines[i+j+4].split()[k])
                        w.write("\n")
                else:
                    for k in range(2):
                        w.write(lines[i+j+4].split()[k])
                        w.write("\n")
    w.close()

file_names = ["HEU-MET-FAST-015-001-ce_v8.0-clutch.sdf", "HEU-MET-FAST-016-001-ce_v8.0-clutch.sdf", "HEU-SOL-THERM-001-001-v8.0-252.sdf"]

for file_name in file_names:
    file_process(file_name)

f = open(file_name)
lines = f.readlines()
f.close()

boundary_file = "scale_252group_boundaries"
w = open(boundary_file,"w")
value = []
for i in range(len(lines)):
    if "energy boundaries:" in lines[i]:
        for j in range(51):
            if j != 50:
                for k in range(5):
                    w.write(lines[i+j+1].split()[k])
                    w.write("\n")
            else:
                for k in range(3):
                    w.write(lines[i+j+1].split()[k])
                    w.write("\n")
w.close()
