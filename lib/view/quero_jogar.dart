import 'package:flutter/material.dart';

/// Funcionalidade 2: lista de jogos que o usuário quer jogar no futuro.
/// Colocar em: lib/views/quero_jogar.dart
class QueroJogarView extends StatefulWidget {
  const QueroJogarView({super.key});

  @override
  State<QueroJogarView> createState() => _QueroJogarViewState();
}

class _QueroJogarViewState extends State<QueroJogarView> {
 
  final List<String> _jogos = [
    'GTA 6',
    'Crimson Desert',
    'Battlefield 6',
    'Super Mario Wonder',
    'God of War',
    'Earthbound',
  ];

    final List<String> _sub = [
    '2026',
    '2026',
    '2025',
    '2023',
    '2018',
    '1994',
  ];

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximas jogatinas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _jogos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Sua lista está vazia.\nToque em "Adicionar" para começar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
              itemCount: _jogos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: cores.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.sports_esports_outlined,
                        color: cores.outline),
                  ),
                  title: Text(_jogos[i]),
                  subtitle: const Text('Gênero do jogo, n esquecer!!!'),
                ),
              ),
            ),
    );
  }
}