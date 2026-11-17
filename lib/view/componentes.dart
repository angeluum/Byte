import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const List<String> generosJogos = [
  'Ação',
  'Aventura',
  'RPG',
  'Estratégia',
  'Esporte',
  'Corrida',
  'Terror',
  'Simulação',
  'Outro',
];

/// Data de criação de um documento. Enquanto o servidor ainda não confirmou
/// a gravação, o campo vem nulo e usamos a hora atual para ordenar.
DateTime dataCriacao(Map<String, dynamic> dados) {
  final valor = dados['criadoEm'];
  return valor is Timestamp ? valor.toDate() : DateTime.now();
}

/// Mensagem exibida quando a leitura do Firestore falha (RF004),
/// com botão para o usuário tentar novamente.
class ErroCarregar extends StatelessWidget {
  const ErroCarregar({super.key, required this.onTentarNovamente});

  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Não foi possível carregar os dados.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}