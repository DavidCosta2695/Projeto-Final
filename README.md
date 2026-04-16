# 🏠 HouseConnect - Gestor e Matcher Imobiliário

## 📖 Descrição do Projeto
O **HouseConnect** é uma aplicação móvel desenvolvida em Flutter para Android, concebida para simplificar a gestão de carteira de consultores imobiliários. A aplicação resolve o problema do cruzamento manual de dados entre a procura e a oferta. 

O objetivo principal é permitir que o consultor registe tanto as necessidades específicas de um comprador como as características dos imóveis que tem para venda, permitindo que o software faça o "match" automático. Além disso, funciona como um histórico de interações, garantindo que nenhuma oportunidade de negócio se perca por falta de acompanhamento.

## 👥 Público-Alvo
* **Consultores Imobiliários:** Profissionais que necessitam de organizar os seus contactos e imóveis de forma rápida e eficiente.
* **Agentes de Angariação:** Profissionais focados em encontrar o comprador ideal para propriedades recém-angariadas.

## ✨ Funcionalidades Principais
A aplicação está estruturada em torno de três pilares fundamentais:

1.  **Gestão de Clientes (Procura):**
    * Registo de dados pessoais (Primeiro e último nome, contacto telefónico), etc.
    * Definição de perfil de procura: Tipologia (T2, T3, etc.), Comodidades (piscina, varanda, casa de banho privada) e outras características chave.
2.  **Gestão de Imóveis (Oferta):**
    * Inserção de imóveis disponíveis para venda ou recém-angariados.
    * Catalogação detalhada baseada nos mesmos critérios de filtragem dos clientes.
3.  **Algoritmo de Matching Inteligente:**
    * Cruzamento automático de dados: ao selecionar um cliente, o sistema apresenta instantaneamente os imóveis que cumprem os requisitos inseridos.
4.  **Base de Dados de Contactos:**
    * Registo cronológico de quando o cliente contactou o consultor, permitindo uma gestão eficaz do funil de vendas.

## 💻 Tecnologias Utilizadas
* **Framework:** [Flutter](https://flutter.dev/)
* **Linguagem:** [Dart](https://dart.dev/)
* **Base de Dados:** SQLite (para armazenamento local) ou Firebase Firestore (para sincronização em nuvem).
* **Design:** Material Design 3.

## 🗓️ Cronograma Simplificado
* **1:** Configuração do ambiente, desenho da arquitetura da base de dados e criação dos modelos (Cliente e Imóvel).
* **2:** Desenvolvimento das interfaces de utilizador (UI) para registo de clientes e imóveis.
* **3:** Implementação da lógica de persistência de dados (CRUD) e registo de contactos.
* **4:** Desenvolvimento do motor de *matching* e filtros de pesquisa.
* **5:** Testes de integração, correção de bugs e finalização da documentação.

## ⚠️ Desafios Técnicos Previstos
* **Lógica de Filtragem:** Criar um algoritmo de pesquisa eficiente que consiga lidar com múltiplos critérios opcionais (ex: um cliente que aceita T2 ou T3, mas exige obrigatoriamente piscina).
* **Gestão de Estado:** Garantir que, ao adicionar um novo imóvel, a lista de matches de um cliente seja atualizada de forma fluida.
* **Persistência de Datas:** Manipular corretamente os formatos de data e hora para o histórico de contactos, garantindo que a ordenação cronológica seja precisa.
* **User Experience (UX):** Tornar o formulário de características do imóvel intuitivo, evitando que o excesso de opções torne a app complexa de utilizar.