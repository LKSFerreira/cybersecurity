## Operadores Lógicos e Booleanos

Os **operadores lógicos** permitem que atribuições e comparações sejam feitas e são usados em testes condicionais (como as declarações `if`).

| Operação Lógica        | Operador | Exemplo         |
| :--------------------- | :------- | :-------------- |
| Equivalência           | `==`     | `if x == 5`     |
| Menor que              | `<`      | `if x < 5`      |
| Menor ou igual a       | `<=`     | `if x <= 5`     |
| Maior que              | `>`      | `if x > 5`      |
| Maior ou igual a       | `>=`     | `if x >= 5`     |

Os **operadores booleanos** são usados para conectar e comparar relações entre declarações. Como em uma declaração `if`, as condições podem ser verdadeiras ou falsas.

| Operação Booleana                               | Operador | Exemplo                                                                                             |
| :---------------------------------------------- | :------- | :-------------------------------------------------------------------------------------------------- |
| Ambas as condições devem ser verdadeiras para que a declaração seja verdadeira | `and`    | `if x >= 5 and x <= 100`<br>Retorna VERDADEIRO se x for um número entre 5 e 100.                  |
| Apenas uma condição da declaração precisa ser verdadeira | `or`     | `if x == 1 or x == 10`<br>Retorna VERDADEIRO se x for 1 ou 10.                                     |
| Se uma condição é o oposto de um argumento      | `not`    | `if not y`<br>Retorna VERDADEIRO se o valor de y for Falso.                                          |

Vamos ver alguns exemplos de código em Python:

```python
a = 1
if a == 1 or a > 10:
    print("a is either 1 or above 10")

name = "bob" 
hungry = True
if name == "bob" and hungry == True:
    print("bob is hungry")
elif name == "bob" and not hungry:
    print("Bob is not hungry")
else: # Se todas as outras condições if não forem atendidas
    print("Not sure who this is or if they are hungry") 
```

---
**Responda às perguntas abaixo:**

Leia a seção acima.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>