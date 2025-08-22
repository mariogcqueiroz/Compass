import pytest
from calculadora import Calculadora

@pytest.fixture
def calc():
    return Calculadora()

def test_soma(calc):
    assert calc.soma(2, 3) == 5
    assert calc.soma(-1, 1) == 0

def test_subtracao(calc):
    assert calc.subtracao(10, 5) == 5
    assert calc.subtracao(0, 3) == -3

def test_multiplicacao(calc):
    assert calc.multiplicacao(4, 3) == 12
    assert calc.multiplicacao(-2, 3) == -6

def test_divisao(calc):
    assert calc.divisao(10, 2) == 5
    assert calc.divisao(9, 3) == 3
    with pytest.raises(ValueError):
        calc.divisao(5, 0)
