import pytest
from main import Calculadora

@pytest.fixture
def calc():
    return Calculadora()

# --- Testes para o método soma ---
@pytest.mark.parametrize("a, b, esperado", [
    (5, 3, 8),
    (-5, -3, -8),
    (10, 0, 10),
    (2.5, 1.5, 4.0)])
def test_soma(calc, a, b, esperado):
    assert calc.soma(a, b) == esperado

# --- Testes para o método subtracao ---
@pytest.mark.parametrize("a, b, esperado", [
    (10, 4, 6),
    (4, 10, -6),
    (5, 0, 5),
    (2.5, 1.5, 1.0)])
def test_subtracao(calc, a, b, esperado):
    assert calc.subtracao(a, b) == esperado

# --- Testes para o método multiplicacao ---
@pytest.mark.parametrize("a, b, esperado", [
    (3, 4, 12),
    (-5, -5, 25),
    (100, 0, 0),
    (2.5, 4, 10.0)])
def test_multiplicacao(calc, a, b, esperado):
    assert calc.multiplicacao(a,b) == esperado

# --- Testes para o método divisao ---
@pytest.mark.parametrize("a, b, esperado", [
    (10, 2, 5),
    (5, 2, 2.5),
    (9, 3, 3),
    (7.5, 2.5, 3.0)])
def test_divisao(calc, a, b, esperado):
    assert calc.divisao(a, b) == esperado

# --- Testes para o método potencia ---
@pytest.mark.parametrize("base, expoente, esperado", [
    (2, 3, 8),
    (5, 0, 1),
    (-2, 2, 4),
    (-2, 3, -8)])
def test_potencia(calc, base, expoente, esperado):
    assert calc.potencia(base, expoente) == esperado

# --- Testes para o método raiz_quadrada ---
@pytest.mark.parametrize("numero, esperado", [
    (16, 4),
    (25, 5),
    (0, 0),
    (1, 1)])
def test_raiz_quadrada(calc, numero, esperado):
    assert calc.raiz_quadrada(numero) == esperado

def test_raiz_quadrada_numero_negativo_lanca_erro(calc):
    with pytest.raises(ValueError, match="Número negativo não tem raiz quadrada real."):
        calc.raiz_quadrada(-16)

# --- (entradas inválidas) ---
@pytest.mark.parametrize("metodo", [
    "soma",
    "subtracao",
    "multiplicacao",
    "divisao",
    "potencia"
])
@pytest.mark.parametrize("a, b", [
    (10, "a"),
    ("x", 5),
    (10, [1, 2])
])
def test_operacoes_com_nao_numeros_lancam_erro(calc, metodo, a, b):
    """
    Testa se todos os métodos de operação lançam TypeError com entradas inválidas.
    """
    # A função getattr() pega o método da classe a partir do seu nome em string
    operacao_a_testar = getattr(calc, metodo)
    
    with pytest.raises(TypeError, match="Todos os operandos devem ser números."):
        operacao_a_testar(a, b) 
