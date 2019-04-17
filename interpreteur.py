def format(line):
    return line.replace(" R", " ").replace(" @", " ")

def interpreteur(nom_file):
    fichier = open(nom_file,"r")
    lignes = fichier.readlines()
    lignes = [format(line) for line in lignes]

    index = 0
    i = 0
    while index < len(lignes):
        print(i+1)
        i = execLine(lignes[index].split(),i)
        if i != index+1:
            print("JUMP")
            index = i
        else:
            index+=1
        print(registres)
        print(mem)
    fichier.close()
    print("Registres : ")
    print(registres)
    print("Memoire : ")
    print(mem)

def execLine(instr,i):
    if (instr[0] == "AFC"):
        print(instr)
        registres[int(instr[1])] = int(instr[2])
    elif (instr[0] == "STORE"):
        print(instr)
        mem[int(instr[1])] = registres[int(instr[2])]
    elif (instr[0] == "LOAD"):
        print(instr)
        registres[int(instr[1])] = mem[int(instr[2])]
    elif (instr[0] == "EQU"):
        print(instr)
        print(registres[int(instr[2])])
        print(registres[int(instr[3])])
        if (registres[int(instr[2])] == registres[int(instr[3])]):
            registres[int(instr[1])] = 1
        else:
            registres[int(instr[1])] = 0
    elif (instr[0] == "INF"):
        print(instr)
        print(registres[int(instr[2])])
        print(registres[int(instr[3])])
        if (registres[int(instr[2])] < registres[int(instr[3])]):
            registres[int(instr[1])] = 1
        else:
            registres[int(instr[1])] = 0
    elif (instr[0] == "SUP"):
        print(instr)
        print(registres[int(instr[2])])
        print(registres[int(instr[3])])
        if (registres[int(instr[2])] > registres[int(instr[3])]):
            registres[int(instr[1])] = 1
        else:
            registres[int(instr[1])] = 0
    elif (instr[0] == "JMPC"):
        print(instr)
        if registres[int(instr[2])] == 0:
            return int(instr[1])-1
    elif (instr[0] == "JMP"):
        print(instr)
        return int(instr[1])-1
    elif (instr[0] == "MUL"):
        print(instr)
        registres[int(instr[1])] = registres[int(instr[2])] * registres[int(instr[3])]
    elif (instr[0] == "ADD"):
        print(instr)
        registres[int(instr[1])] = registres[int(instr[2])] + registres[int(instr[3])]
    elif (instr[0] == "DIV"):
        print(instr)
        registres[int(instr[1])] = registres[int(instr[2])] / registres[int(instr[3])]
    elif (instr[0] == "SUB"):
        print(instr)
        registres[int(instr[1])] = registres[int(instr[2])] - registres[int(instr[3])]
    else:
        print("ERROR !")
    return i+1

registres = [-1,-1,-1,-1,-1,-1]
mem = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
interpreteur("instructions.asm")
