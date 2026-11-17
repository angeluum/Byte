import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/jogos_controller.dart';
import 'componentes.dart';

/// Lista de jogos avaliados pelo usuário, com nota e crítica.
/// Coleção do Firestore: `avaliacoes`.
class AvaliacoesView extends StatefulWidget {
  const AvaliacoesView({super.key});

  @override
  State<AvaliacoesView> createState() => _AvaliacoesViewState();
}

class _AvaliacoesViewState extends State<AvaliacoesView> {
  final _controller = JogosController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _controller.streamAvaliacoes();
  }

  void _recarregar() {
    setState(() => _stream = _controller.streamAvaliacoes());
  }

  Future<void> _abrirFormulario() {
    return showDialog<void>(
      context: context,
      builder: (_) => _FormAvaliacao(controller: _controller),
    );
  }

  Future<void> _excluir(String id) async {
    final erro = await _controller.excluirAvaliacao(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(erro ?? 'Avaliação removida.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas avaliações'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Avaliar'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErroCarregar(onTentarNovamente: _recarregar);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = [...snapshot.data!.docs]..sort(
              (a, b) =>
                  dataCriacao(b.data()).compareTo(dataCriacao(a.data())),
            );

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Você ainda não avaliou nenhum jogo.\n'
                  'Toque em "Avaliar" para começar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 96),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final dados = doc.data();
              final nota = (dados['nota'] as num?)?.toInt() ?? 0;
              final critica = (dados['critica'] ?? '') as String;

              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: cores.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.star_outline, color: cores.outline),
                  ),
                  title: Text(dados['titulo'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (n) => Icon(
                                n < nota ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Text(dados['genero'] ?? ''),
                        ],
                      ),
                      if (critica.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(critica),
                      ],
                    ],
                  ),
                  isThreeLine: critica.isNotEmpty,
                  trailing: IconButton(
                    tooltip: 'Remover',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _excluir(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Formulário de inserção (RF003) exibido em um diálogo.
class _FormAvaliacao extends StatefulWidget {
  const _FormAvaliacao({required this.controller});

  final JogosController controller;

  @override
  State<_FormAvaliacao> createState() => _FormAvaliacaoState();
}

class _FormAvaliacaoState extends State<_FormAvaliacao> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _criticaController = TextEditingController();
  String _genero = generosJogos.first;
  int _nota = 0;
  bool _salvando = false;
  String? _erro;

  @override
  void dispose() {
    _tituloController.dispose();
    _criticaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nota == 0) {
      setState(() => _erro = 'Escolha uma nota de 1 a 5 estrelas.');
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _salvando = true;
      _erro = null;
    });

    final erro = await widget.controller.adicionarAvaliacao(
      titulo: _tituloController.text.trim(),
      genero: _genero,
      nota: _nota,
      critica: _criticaController.text.trim(),
    );

    if (!mounted) return;
    if (erro == null) {
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Avaliação salva com sucesso!')),
      );
    } else {
      setState(() {
        _salvando = false;
        _erro = erro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Avaliar jogo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                enabled: !_salvando,
                textCapitalization: TextCapitalization.words,
                maxLength: 80,
                decoration: const InputDecoration(
                  labelText: 'Título do jogo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o título do jogo.'
                    : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _genero,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                items: generosJogos
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged:
                    _salvando ? null : (v) => setState(() => _genero = v!),
              ),
              const SizedBox(height: 16),
              const Text('Nota'),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    tooltip: '${i + 1}',
                    onPressed:
                        _salvando ? null : () => setState(() => _nota = i + 1),
                    icon: Icon(
                      i < _nota ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _criticaController,
                enabled: !_salvando,
                maxLines: 3,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Crítica (opcional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              if (_erro != null) ...[
                const SizedBox(height: 8),
                Text(
                  _erro!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvando ? null : _salvar,
          child: _salvando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}