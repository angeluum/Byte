<div align="center">

# 🎮 Byte

**A rede social para quem joga.**
Registre o que você jogou, dê notas, escreva análises e compartilhe sua opinião com outros jogadores.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material_Design_3-757575?style=for-the-badge&logo=materialdesign&logoColor=white)
![Status](https://img.shields.io/badge/status-em_desenvolvimento-yellow?style=for-the-badge)

</div>

---

## 📖 Sobre o projeto

O **Byte** é um aplicativo multiplataforma de avaliação de jogos, no estilo de um *Letterboxd* para games. A ideia é que cada jogador tenha seu próprio espaço para catalogar os jogos que já jogou, avaliar cada um deles e descobrir o que a comunidade está jogando.

Este projeto foi desenvolvido como trabalho prático da disciplina de Flutter, no curso de **Análise e Desenvolvimento de Sistemas** da **Fatec**.

> 📌 **Parte 1:** nesta etapa o foco é a camada de **view** (interfaces gráficas e fluxo de navegação). A lógica de negócio e o gerenciamento de estado com `ChangeNotifier` serão integrados nas próximas etapas.

## ✨ Funcionalidades

### Já implementadas

- [x] **Login** com validação de campos vazios e formato de e-mail
- [x] **Cadastro de usuário** com nome, e-mail, telefone, senha e confirmação de senha
- [x] **Recuperação de senha** ("Esqueceu a senha?")
- [x] **Sobre**, com objetivo do app, equipe e informações acadêmicas

### Em desenvolvimento

- [ ] **Perfil do usuário** (visualização e edição do nome)
- [ ] Listagem de dados com `ListView`/`GridView`
- [ ] Gerenciamento de estado com `ChangeNotifier`

## 🖼️ Telas

| Login | Cadastro | Esqueceu a senha | Sobre |
| :---: | :---: | :---: | :---: |
| ![Login](docs/screenshots/login.png) | ![Cadastro](docs/screenshots/cadastro.png) | ![Esqueceu a senha](docs/screenshots/esqueceu.png) | ![Sobre](docs/screenshots/sobre.png) |

## 🛠️ Tecnologias

- [Flutter](https://flutter.dev/) e [Dart](https://dart.dev/)
- [`device_preview`](https://pub.dev/packages/device_preview) para visualizar o app com moldura de celular durante o desenvolvimento

## 🚀 Como executar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado
- Um dispositivo, emulador ou o navegador Chrome

Para conferir se está tudo certo no seu ambiente:

```bash
flutter doctor
```

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/SEU-USUARIO/Byte.git

# 2. Entre na pasta do projeto
cd Byte

# 3. Instale as dependências
flutter pub get

# 4. Execute o app (no Chrome, por exemplo)
flutter run -d chrome
```

## 🧭 Fluxo de navegação

```
Login ──► Cadastro ──► Home
  │
  ├──► Esqueceu a senha ──► (volta ao Login)
  │
  └──► Sobre
```

## 👥 Equipe

|Ângelo Avezum Marques da Silva | [@angeluum](https://github.com/angeluum) |

## 🎥 Vídeo de apresentação

Fazer um vídeo !!!!

## 🎓 Contexto acadêmico

- **Instituição:** Fatec
- **Curso:** Análise e Desenvolvimento de Sistemas
- **Disciplina:** Programação em Dispositivos Móveis
- **Professor:** Rodrigo de Oliveira Plotze

---

<div align="center">

Feito com 💜 e Flutter
Santos Futebol Clube!!!

</div>