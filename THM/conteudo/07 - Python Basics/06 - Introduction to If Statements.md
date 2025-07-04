## Projeto de Envio: Introdução às Declarações `if`

O uso de "declarações `if`" permite que os programas tomem decisões. Elas permitem que um programa tome uma decisão com base em uma condição. Abaixo está um exemplo de como uma declaração `if` pode ser usada para determinar a seção de código (qual declaração `print`) a ser usada.

```python
if age < 17:
    print('You are NOT old enough to drive')
else:
    print('You are old enough to drive')
```

No exemplo, se você for menor de 17 anos, o programa exibirá o texto "Você NÃO tem idade suficiente para dirigir"; no entanto, se você tiver mais de 17 anos, o programa exibirá "Você tem idade suficiente para dirigir". Dependendo de uma condição (neste exemplo, é a variável `age`), o programa executará diferentes seções de código.

Existem alguns componentes chave que notamos em nosso exemplo de código acima:

*   A palavra-chave `if` indica o início da declaração `if`, seguida por um conjunto de condições.
*   A declaração `if` só é executada se a condição (ou conjunto de condições) for verdadeira. Em nosso exemplo, é `age < 17`; se essa condição for verdadeira (a idade for inferior a 17), o código dentro da declaração `if` é executado. Se as condições não forem atendidas, o programa executará por padrão o código mostrado na parte `else` da declaração `if`.
*   Dois pontos `:` marcam o final da declaração `if`.
*   Note a **indentação**. Qualquer coisa após os dois pontos que está indentada é considerada parte da declaração `if`, que o programa executará.

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5bec5dfd73790a7d06282266/room-content/24fbdd3df0afe5215613d6be2f328f45.png">

As declarações `if` são essenciais na programação e serão algo que você usará muito.

---
**Responda às perguntas abaixo:**

Neste exercício, vamos codificar uma pequena aplicação que calcula e exibe o custo de envio para um cliente com base em quanto ele gastou.
No editor de código, clique na aba "shipping.py" e siga as instruções para completar esta tarefa.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>

Uma vez que você tenha escrito a aplicação na aba shipping.py do editor de código, uma flag aparecerá, que é a resposta para esta pergunta.
<details>
  <summary>Clique para ver a resposta</summary>
  THM{IF_STATEMENT_SHOPPING}
</details>

Em shipping.py, na linha 15 (ao usar a Dica do Editor de Código), altere a variável `customer_basket_cost` para 101 e execute seu código novamente. Você receberá uma flag (se o custo total estiver correto com base no seu código); a flag é a resposta para esta pergunta.
<details>
  <summary>Clique para ver a resposta</summary>
  THM{MY_FIRST_APP}
</details>