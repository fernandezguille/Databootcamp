# Juego de las jarras

import time

class Jarra:
    def __init__(self,capacidad):
        self.capacidad = capacidad
        self.cantidad = 0

    def llenar(self):
        self.cantidad = self.capacidad
        
    def vaciar(self):
        self.cantidad = 0

class juego_jarras:
    def __init__(self):
        self.jarrito3 = Jarra(3)
        self.jarra5 = Jarra(5)

    def fin(self):
        print("\nGANASTE!!\n" if self.jarra5.cantidad == 4 else "\nPERDISTE\n")
        quit()

    def mostrar(self):
        print(f"\nEstado de las Jarras: Jarra de 3L:{self.jarrito3.cantidad} - Jarra de 5L:{self.jarra5.cantidad}")
        time.sleep(.3)

    def volcar3a5(self):
        while self.jarrito3.cantidad > 0 and self.jarra5.cantidad < 5:
                    self.jarrito3.cantidad -= 1
                    self.jarra5.cantidad += 1

    def volcar5a3(self):
        while self.jarra5.cantidad > 0 and self.jarrito3.cantidad < 3:
                    self.jarra5.cantidad -= 1
                    self.jarrito3.cantidad += 1

    def invalido(self):
        print('\nSolo son validas las opciones del 0 al 7')

    def usa_switch(self,char):
        opciones = {'0': self.fin,
                        '1': self.jarrito3.llenar,
                        '2': self.jarra5.llenar,
                        '3': self.jarrito3.vaciar,
                        '4': self.jarra5.vaciar,
                        '5': self.volcar3a5,
                        '6': self.volcar5a3} 
        return opciones.get(char, self.invalido)()

    def jugar(self):
        print("\n\n",'COMIENZA EL JUEGO',"\n")
        print('Tienes 2 jarras vacías, de 5 y 3 litros, sin graduar. Debes conseguir 4 litros utilizando las siguientes chares:')
        print("(puedes introducir una sequencia de pasos)")
        orden = ""
        self.mostrar()
        while orden != "0":
            print('\n 0: "Terminar el juego\n','1: "Llenar la jarra de 3 litros\n','2: "Llenar la jarra de 5 litros\n',\
            '3: "Vaciar la jarra de 3 litros\n','4: "Vaciar la jarra de 5 litros\n',\
            '5: "Verter el contenido de la jarra de 3 litros en la de 5 litros\n','6: "Verter el contenido de la jarra de 5 litros en la de 3 litros\n')
            orden = (input("Ingrese la/s opción/es: "))
            for char in orden:
                self.usa_switch(char)
                self.mostrar()
                
Juego = juego_jarras()
Juego.jugar()