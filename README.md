<div align="center">

<img width="396" height="195" alt="Image" src="https://github.com/user-attachments/assets/6014d6df-c0b3-43e2-9a48-1c72e1c4ee14" />

**A rede social para quem joga.**
Registre o que você jogou, dê notas, escreva análises e compartilhe sua opinião com outros jogadores.

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
| <img width="532" height="937" alt="Image" src="https://github.com/user-attachments/assets/dceead4a-902f-419e-961e-422a8d3ad8af" /> |<img width="508" height="904" alt="Image" src="https://github.com/user-attachments/assets/cb8f95db-310d-40ef-876f-2b6522e4f1d6" />| <img width="573" height="920" alt="Image" src="https://github.com/user-attachments/assets/773542dd-1aa2-4abf-a880-83892983fb3f" /> | <img width="537" height="919" alt="Image" src="https://github.com/user-attachments/assets/18f467ea-b3c8-477e-9f5f-9617ddfc98a0" /> |

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

|Ângelo Avezum Marques da Silva | GitHub: [@angeluum](https://github.com/angeluum) | 

## 🎥 Vídeo de apresentação

Fazer um vídeo !!!!

## 🎓 Contexto acadêmico

- **Instituição:** Fatec
- **Curso:** Análise e Desenvolvimento de Sistemas
- **Disciplina:** Programação em Dispositivos Móveis
- **Professor:** Rodrigo de Oliveira Plotze

---

<div align="center">

Feito com 💜 e Flutter.
Santos Futebol Clube!!!

</div>