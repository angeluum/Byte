import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  static const String _nomeApp = 'Byte';
  static const String _objetivo =
      '\nO Byte é um aplicativo de agreagador de notas para jogos. Nele, o usuário '
      'pode registrar os jogos que já jogou, dar notas, escrever análises, '
      'montar sua lista de jogos para jogar depois e compartilhar suas '
      'opiniões com outros jogadores.'
      '\n\n\nProjeto idealizado e criado por Ângelo Avezum Marques da Silva, '
      'para mais projetos como esse, acesse github.com/angeluum'
      '\n\n\n PS: Santos Futebol Clube, o maior de todos!!!!';


  static const String _disciplina = 'Programação em dispositivos móveis';
  static const String _instituicao = 'Fatec - Ribeirão Preto';
  static const String _professor = 'Rodrigo de Oliveira Plotze';

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logotipo (mesmo das outras telas)
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.sports_esports,
                      size: 80,
                      color: cores.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nomeApp,
                    textAlign: TextAlign.center,
                    style: textos.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Objetivo do aplicativo
                  _SecaoCard(
                    icone: Icons.flag_outlined,
                    titulo: 'Objetivo',
                    filhos: [
                      Text(_objetivo, style: textos.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // integrante da equipe
                  const SizedBox(height: 16),

                  // Informações adicionais (opcionais no RF004)
                  const _SecaoCard(
                    icone: Icons.school_outlined,
                    titulo: 'Informações acadêmicas',
                    filhos: [
                      _LinhaInfo(rotulo: 'Disciplina', valor: _disciplina),
                      _LinhaInfo(rotulo: 'Instituição', valor: _instituicao),
                      _LinhaInfo(rotulo: 'Professor', valor: _professor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cartão com ícone e título, usado para agrupar cada seção da tela.
class _SecaoCard extends StatelessWidget {
  const _SecaoCard({
    required this.icone,
    required this.titulo,
    required this.filhos,
  });

  final IconData icone;
  final String titulo;
  final List<Widget> filhos;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: cores.primary),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...filhos,
          ],
        ),
      ),
    );
  }
}

/// Linha "rótulo: valor" para as informações acadêmicas.
class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              rotulo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(valor, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}