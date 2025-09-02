def calcular_alturas_barras(valores, altura_max=82, altura_min=9):
    if not valores:
        return []

    valor_min = min(valores)
    valor_max = max(valores)

    if valor_max == valor_min:
        return [altura_max for _ in valores]

    alturas = []
    for v in valores:
        altura = altura_min + (v - valor_min) / (valor_max - valor_min) * (altura_max - altura_min)
        alturas.append(round(altura))
    return alturas