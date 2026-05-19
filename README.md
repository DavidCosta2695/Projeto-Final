# 🏠 HouseConnect

## 📖 Sobre o Projeto
O **HouseConnect** é uma aplicação móvel profissional desenvolvida em Flutter, concebida para revolucionar o dia a dia dos consultores imobiliários. 

O sistema resolve um dos maiores problemas das agências imobiliárias: o cruzamento manual de dados entre a procura (clientes) e a oferta (imóveis em carteira). Através de um algoritmo de *matching* inteligente e de uma base de dados sincronizada na nuvem, o consultor consegue, em segundos, encontrar a casa perfeita para o cliente perfeito.

## ✨ Funcionalidades Principais

* 🔐 **Autenticação Segura:** Login e Registo suportados por Email/Password (com verificação obrigatória de email) e integração nativa com **Google Sign-In**.
* 📊 **Dashboard Dinâmico:** Um painel de controlo em tempo real que exibe os totais do negócio e gráficos de barras com a distribuição de procura e oferta por tipologia.
* 👥 **Gestão de Clientes (CRM):**
  * Criação, edição e remoção de clientes.
  * Avatares automáticos e apresentação de dados com *Chips* visuais (Material Design).
  * Sistema de filtros avançados em tempo real (Slider de Orçamento, Tipologia, Comodidades).
* 🏠 **Gestão de Imóveis:**
  * Registo completo de propriedades com captura de fotografia (Câmara ou Galeria) convertida em formato Base64.
  * Design premium em formato "Cartão" com ecrãs de detalhe que deslizam suavemente (Modal Bottom Sheets).
* 🎯 **Algoritmo de Matching:** Cruzamento automático e instantâneo. A app avalia o orçamento do cliente, localização, tipologia, garagem e piscina, sugerindo apenas os imóveis 100% compatíveis.
* ⚙️ **Gestão de Perfil:** Personalização da conta do consultor (Nome, Foto de Perfil customizada e número de Telemóvel).

## 💻 Tecnologias Utilizadas

A aplicação foi construída utilizando as melhores práticas e pacotes do ecossistema mobile moderno:
* **Framework:** [Flutter](https://flutter.dev/) (Suporte multiplataforma)
* **Linguagem:** [Dart](https://dart.dev/)
* **Base de Dados (BaaS):** [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore) (NoSQL e sincronização em tempo real).
* **Autenticação:** Firebase Authentication + Google OAuth2.
* **Formatadores:** `intl` para formatação nativa de moeda (Euros).
* **Media:** `image_picker` para acesso nativo à câmara e galeria de fotos.
* **UI/UX:** Material Design 3, *RangeSliders*, *ChoiceChips* e navegação fluida por *Drawers*.



## 🚀 Como Executar o Projeto

1. Certifica-te que tens o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na tua máquina.
2. Clonar este repositório:
   git clone [https://github.com/DavidCosta2695/Projeto-Final.git]

<table>
  <tr>
    <td><img src="C:\Users\Luis Santana\Desktop\projeto_final\projeto_Final\prints\Login.png" width="200"/></td>
    <td><img src="C:\Users\Luis Santana\Desktop\projeto_final\projeto_Final\prints\Dashboard.png" width="200"/></td>
    <td><img src="C:\Users\Luis Santana\Desktop\projeto_final\projeto_Final\prints\Clientes.png" width="200"/></td>
    <td><img src="C:\Users\Luis Santana\Desktop\projeto_final\projeto_Final\prints\filtragem.png" width="200"/></td>
  </tr>
</table>
