<div align="center">

<img width="396" height="195" alt="Image" src="https://github.com/user-attachments/assets/6014d6df-c0b3-43e2-9a48-1c72e1c4ee14" />

**A rede social para quem joga.**
Registre o que você jogou, dê notas, escreva análises e compartilhe sua opinião com outros jogadores.

</div>

---

## 📖 Sobre o projeto

O **Byte** é um aplicativo multiplataforma de avaliação de jogos, no estilo de um *Letterboxd* para games. A ideia é que cada jogador tenha seu próprio espaço para catalogar os jogos que já jogou, avaliar cada um deles e organizar a lista do que quer jogar no futuro.

Este projeto foi desenvolvido como trabalho prático da disciplina de Flutter, no curso de **Análise e Desenvolvimento de Sistemas** da **Fatec**.

> 📌 **Parte 1:** camada de **view** (interfaces gráficas e fluxo de navegação).
>
> 📌 **Parte 2:** integração com o **Firebase** (Authentication, Cloud Firestore e Hosting), com os dados separados por usuário.

## ✨ Funcionalidades

### Já implementadas

- [x] **Login** com Firebase Authentication (e-mail e senha), com indicador de progresso e mensagens de erro em português
- [x] **Cadastro de usuário** com nome, e-mail, telefone, senha e confirmação de senha; os dados adicionais são gravados na coleção `usuarios` do Firestore
- [x] **Recuperação de senha** por e-mail ("Esqueceu a senha?")
- [x] **Quero jogar:** inserção, listagem em tempo real e remoção de jogos (coleção `quero_jogar`)
- [x] **Avaliações:** nota de 1 a 5 estrelas e crítica para cada jogo, listadas em tempo real (coleção `avaliacoes`)
- [x] **Isolamento por usuário:** cada usuário vê e altera somente os seus próprios dados (regras de segurança do Firestore)
- [x] **Sobre**, com objetivo do app, equipe e informações acadêmicas

### Em desenvolvimento

- [ ] **Perfil do usuário** lendo e atualizando os dados reais da coleção `usuarios`
- [ ] Aba **Críticas** (por enquanto, é um espaço reservado)
- [ ] Publicação no **Firebase Hosting**
- [ ] Implementação de uma API que possua um catálogo de jogos nela.

## 🖼️ Telas

| Login | Cadastro | Esqueceu a senha | Sobre |
| :---: | :---: | :---: | :---: |
| <img width="532" height="937" alt="Image" src="https://github.com/user-attachments/assets/dceead4a-902f-419e-961e-422a8d3ad8af" /> |<img width="508" height="904" alt="Image" src="https://github.com/user-attachments/assets/cb8f95db-310d-40ef-876f-2b6522e4f1d6" />| <img width="573" height="920" alt="Image" src="https://github.com/user-attachments/assets/773542dd-1aa2-4abf-a880-83892983fb3f" /> | <img width="537" height="919" alt="Image" src="https://github.com/user-attachments/assets/18f467ea-b3c8-477e-9f5f-9617ddfc98a0" /> |

> As telas de **Quero jogar** e **Avaliações** ainda não têm capturas de tela neste README.

## 🛠️ Tecnologias

- [Flutter](https://flutter.dev/) e [Dart](https://dart.dev/)
- [Firebase Authentication](https://firebase.google.com/docs/auth): login, cadastro e recuperação de senha
- [Cloud Firestore](https://firebase.google.com/docs/firestore): banco de dados em tempo real (`StreamBuilder` + `ListView`)
- [Firebase Hosting](https://firebase.google.com/docs/hosting): publicação da versão web
- [`firebase_core`](https://pub.dev/packages/firebase_core), [`firebase_auth`](https://pub.dev/packages/firebase_auth) e [`cloud_firestore`](https://pub.dev/packages/cloud_firestore)
- [`device_preview`](https://pub.dev/packages/device_preview) para visualizar o app com moldura de celular durante o desenvolvimento

## 🗂️ Estrutura do projeto

```
lib/
├── controller/
│   ├── auth_controller.dart     # login, cadastro e recuperação de senha
│   └── jogos_controller.dart    # leitura e gravação no Firestore
├── view/
│   ├── avaliacoes.dart
│   ├── cadastro.dart
│   ├── componentes.dart         # widgets e funções compartilhados
│   ├── esqueceu.dart
│   ├── home.dart
│   ├── login.dart
│   ├── perfil.dart
│   ├── quero_jogar.dart
│   └── sobre.dart
├── firebase_options.dart        # gerado pelo FlutterFire CLI
└── main.dart
```

## 🔥 Banco de dados (Cloud Firestore)

Todos os documentos pertencem a um usuário e guardam o campo `uid`.

| Coleção | Campos |
| --- | --- |
| `usuarios` (id do documento = `uid`) | `uid`, `nome`, `email`, `telefone`, `criadoEm` |
| `avaliacoes` | `uid`, `titulo`, `genero`, `nota` (número), `critica`, `criadoEm` |
| `quero_jogar` | `uid`, `titulo`, `genero`, `plataforma`, `prioridade`, `criadoEm` |

### Regras de segurança

<details>
<summary>Ver regras do Firestore</summary>

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Perfil: cada usuário acessa somente o próprio documento (id = uid).
    match /usuarios/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // Avaliações e lista "quero jogar": cada documento guarda o uid do dono.
    match /avaliacoes/{id} {
      allow create: if request.auth != null
                    && request.resource.data.uid == request.auth.uid;
      allow read, update, delete: if request.auth != null
                    && resource.data.uid == request.auth.uid;
    }

    match /quero_jogar/{id} {
      allow create: if request.auth != null
                    && request.resource.data.uid == request.auth.uid;
      allow read, update, delete: if request.auth != null
                    && resource.data.uid == request.auth.uid;
    }
  }
}
```

</details>

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

O arquivo `lib/firebase_options.dart` já está no repositório, então não é preciso configurar o Firebase para executar o app. As chaves de um app Firebase no cliente não são secretas; a proteção dos dados vem das regras de segurança do Firestore descritas acima.

### Publicação (Firebase Hosting)

```bash
flutter build web
firebase deploy --only hosting
```

🌐 **App publicado:** _(link será adicionado após a publicação)_

## 🧭 Fluxo de navegação

```
Login ──► Home (Início │ Quero jogar │ Avaliações │ Críticas │ Perfil)
  │            │
  │            └──► Sair ──► Login
  │
  ├──► Cadastro ──► Home
  │
  ├──► Esqueceu a senha ──► (volta ao Login)
  │
  └──► Sobre
```

## 👥 Equipe

|Ângelo Avezum Marques da Silva | GitHub: [@angeluum](https://github.com/angeluum) | 

## 🎥 Vídeo de apresentação

_(https://youtu.be/-zjjbmzD7bI)_

## 🎓 Contexto acadêmico

- **Instituição:** Fatec - Ribeirão Preto
- **Curso:** Análise e Desenvolvimento de Sistemas
- **Disciplina:** Programação em Dispositivos Móveis
- **Professor:** Rodrigo de Oliveira Plotze

---

<div align="center">

Feito com 💜 e Flutter.
Santos Futebol Clube!!!

</div>
