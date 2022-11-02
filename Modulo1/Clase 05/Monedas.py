# Juego de las monedas

import random as rnd

class Pila:
    def __init__(self):
        self.game = list(rnd.sample(range(1,21),20))

    def sacar(self):
        return self.game.pop()

    def mostrar(self):
        print("\n",self.game,"\n")

    def jugar(self):
        print("\n\n",'COMIENZA EL JUEGO',"\n")
        print("\n",'Esta es la lista de números. La suma de los elementos retirados debe ser lo más cercana a 50, sin pasarse.')
        print("\n",'La puntuación será de 10 - la cantidad que te hayan faltado retirar, sin pasarse de 50.')
        self.mostrar()
        pull = input("Ingrese la cantidad de elementos a retirar: ")
        while not pull.isdecimal() or int(pull) > 20:
            pull = input("La cantidad de elementos a retirar debe ser un entero menor a 20: ")
        pull = int(pull)
        total = 0
        faltaron = 0
        for i in range(pull):
            total += self.sacar()
        if total > 50:
            print(f"\nHAS PERDIDO. La suma de los objetos retirados es {total}")
        else:
            print(f"\nGANASTE! La suma de los objetos retirados es {total}")
            while total <= 50:  
                total += self.sacar()
                if total <= 50: faltaron +=1
            print(f"Tu puntuación es de 10 - {faltaron} = {10 - faltaron}")

Juego = Pila()
Juego.jugar()