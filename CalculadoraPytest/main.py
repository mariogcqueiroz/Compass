class Calculadora:

    def _validar_operandos(self, *args):
        """Método para validar se os operandos são números."""
        for operando in args:
            if not isinstance(operando, (int, float)):
                raise TypeError("Todos os operandos devem ser números.")
    def soma(self, a, b):
        self._validar_operandos(a, b)
        return a + b

    def subtracao(self, a, b):
        self._validar_operandos(a, b)
        return a - b

    def multiplicacao(self, a, b):
        self._validar_operandos(a, b)
        return a * b

    def divisao(self, a, b):
        self._validar_operandos(a, b)
        if b == 0:
            raise ValueError("Divisão por zero não é permitida.")
        return a / b

    def potencia(self, base, expoente):
        self._validar_operandos(base, expoente)
        return base ** expoente 

    def raiz_quadrada(self, numero):
        self._validar_operandos(numero)
        if numero < 0:
            raise ValueError("Número negativo não tem raiz quadrada real.")
        return numero ** 0.5