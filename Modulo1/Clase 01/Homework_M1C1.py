# ConversionBinario.py


def Conversor_por_restos(numero):
    resultado = ""
    entero = int(numero)
    decimal = numero - entero
    if entero > 0:
        while entero:
            resultado = str(entero % 2) + resultado
            entero //= 2
    else: resultado = "0"
    if decimal > 0:
        resultado += "."
        while decimal:
            resultado += str(int(decimal * 2))
            decimal = decimal * 2 - int(decimal * 2)
    return resultado


def Conversor_por_pesos(numero):
    from math import log2
    resultado = ""
    entero = int(numero)
    decimal = numero - entero
    if entero > 0:
        exp = int(log2(entero))
        while exp >= 0:
            if entero >= 2**exp:
                resultado += "1"
                entero -= 2**exp
                exp -= 1
            else:
                resultado += "0"
                exp -= 1
    else: resultado = "0"
    if decimal > 0:
        exp = -1
        resultado += "."
        while decimal:
            if decimal >= 2**exp:
                resultado += "1"
                decimal -= 2**exp
                exp -= 1
            else:
                resultado += "0"
                exp -= 1
    return resultado


for i in range(1,20):
#   print(Conversor_por_pesos(1/i))
    print(Conversor_por_restos(10/i))