## INICIO CODIGO AYUDANTIA
import sys

lines = sys.stdin.readlines()

init = len(lines) - 1
while "robotOn(" not in lines[init]:
    init -= 1

atoms = lines[init].split(" ")

rangoX = []
rangoY = []
tiempo = []

estanterias = []
obstaculos = []

robots = []
cajas = []


for line in atoms:
    if line[0:6] != "rangeX":
        continue
    line = line.replace("rangeX", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    rangoX.append(int(line))

for line in atoms:
    if line[0:6] != "rangeY":
        continue
    line = line.replace("rangeY", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    rangoY.append(int(line))


for line in atoms:
    if line[0:4] != "time":
        continue
    line = line.replace("time", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    tiempo.append(int(line))


for line in atoms:
    if line[0:4] != "goal":
        continue
    line = line.replace("goal", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    tup = line.split(",")
    estanterias.append([int(tup[0]), int(tup[1])])

for line in atoms:
    if line[0:8] != "obstacle":
        continue
    line = line.replace("obstacle", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    tup = line.split(",")
    obstaculos.append([int(tup[0]), int(tup[1])])


for line in atoms:
    if line[0:7] != "robotOn":
        continue
    line = line.replace("robotOn", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    tup = line.split(",")
    robots.append([int(tup[0]), int(tup[1]), int(tup[2]), int(tup[3])])

for line in atoms:
    if line[0:5] != "boxOn":
        continue
    line = line.replace("boxOn", "")
    line = line.replace("(", "")
    line = line.replace(")", "")
    tup = line.split(",")
    cajas.append([int(tup[0]), int(tup[1]), int(tup[2]), int(tup[3]), int(tup[4])])

## FIN CODIGO AYUDANTIA


## INICIO CODIGO DE ESCRITURA ARCHIVO
f = open('salida.txt','w')

# Rango y tiempo
# "dimensionX,dimensionY"
f.write(f"{max(rangoX)},{max(rangoY)}\n")
# Tiempo maximo
f.write(f"{max(tiempo)}\n")

# Estanterias
# "E,posX,posY"
for estanteria in estanterias:
    f.write(f"E,{estanteria[0]},{estanteria[1]}\n")

# Obstaculos
# "O,posX,posY"
for obstaculo in obstaculos:
    f.write(f"O,{obstaculo[0]},{obstaculo[1]}\n")

# Robots
# "R,id,posX,posY,tiempo"
for robot in robots:
    f.write(f"R,{robot[0]},{robot[1]},{robot[2]},{robot[3]}\n")

# Cajas
# "C,id,posX,posY,posZ,tiempo"
for caja in cajas:
    f.write(f"C,{caja[0]},{caja[1]},{caja[2]},{caja[3]},{caja[4]}\n")

f.close()