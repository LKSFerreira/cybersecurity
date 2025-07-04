## Introdução às Funções

À medida que os programas começam a ficar maiores e mais complexos, parte do seu código se tornará repetitiva, escrevendo o mesmo código para fazer os mesmos cálculos, e é aqui que as funções entram. Uma **função** é um bloco de código que pode ser chamado em diferentes lugares do seu programa.

Você poderia ter uma função para realizar um cálculo, como a distância entre dois pontos em um mapa, ou para exibir texto formatado com base em certas condições. Ter funções remove código repetitivo, pois o propósito da função pode ser usado várias vezes ao longo de um programa.

```python
def sayHello(name):
     print("Hello " + name + "! Nice to meet you.")

sayHello("ben") # A saída é: Hello ben! Nice to meet you
```

Existem alguns componentes chave que podemos notar nesta função:

*   A palavra-chave `def` indica o início de uma função. A palavra-chave é seguida por um nome que o programador define e que pode ser usado para chamar a função. Em nosso exemplo, é `sayHello`.
*   Após o nome da função, há um par de parênteses `()` que contêm valores de entrada, dados que podemos passar para a função. Em nosso exemplo, é uma variável chamada `name`.
*   Dois pontos `:` marcam o final do cabeçalho da função.
*   Na função, observe a **indentação**. Semelhante às declarações `if`, qualquer coisa após os dois pontos que está indentada é considerada parte da função.

Uma função também pode retornar um resultado, veja o bloco de código abaixo:

```python
def calcCost(item):
     if(item == "sweets"):
          return 3.99
     elif (item == "oranges"):
          return 1.99
     else:
          return 0.99

spent = 10
spent = spent + calcCost("sweets")
print("You have spent:" + str(spent))
```

Se chamarmos a função `calcCost` e passarmos `"sweets"` como o parâmetro `item`, a função retornará um número decimal (float). No código acima, pegamos uma variável chamada `spent` e adicionamos o custo de `"sweets"` através da função `calcCost`. Quando chamamos `calcCost`, ela retornará o número `3.99`; este número será adicionado à variável `spent`, resultando em um total de `13.99`.

---
**Responda às perguntas abaixo:**

Você investiu em Bitcoin e quer escrever um programa que lhe diga quando o valor do Bitcoin cai abaixo de um determinado valor em dólares.

No editor de código, clique na aba "bitcoin.py". Escreva uma função chamada `bitcoinToUSD` com dois parâmetros: `bitcoin_amount`, a quantidade de Bitcoin que você possui, e `bitcoin_value_usd`, o valor do bitcoin em USD. A função deve retornar `usd_value`, que é o seu valor de bitcoin em USD (para calcular isso, na função, você multiplica a variável `bitcoin_amount` pela variável `bitcoin_value_usd` e retorna o valor). O início da função deve se parecer com isto:

```python
def bitcoinToUSD(bitcoin_amount, bitcoin_value_usd):
```

Uma vez que você tenha escrito a função `bitcoinToUSD`, use-a para calcular o valor do seu Bitcoin em USD e, em seguida, crie uma declaração `if` para determinar se o valor cai abaixo de $30.000; se cair, exiba uma mensagem para alertá-lo (através de uma declaração `print`).
<details>
  <summary>Clique para ver a resposta</summary>
  THM{BITCOIN_INVESTOR}
</details>

1 Bitcoin agora vale $24.000. No editor de código, na linha 14, atualize o valor da variável `bitcoin_to_usd` para 24000 e veja se seu programa Python reconhece que seu investimento está abaixo do limiar de $30.000.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>