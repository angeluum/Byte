import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/jogos_controller.dart';
import 'componentes.dart';

const List<String> _plataformas = [
  'PC',
  'PlayStation',
  'Xbox',
  'Nintendo',
  'Mobile',
];
const List<String> _prioridades = ['Alta', 'Média', 'Baixa'];

class QueroJogarView extends StatefulWidget {
  const QueroJogarView({super.key});

  @override
  State<QueroJogarView> createState() => _QueroJogarViewState();
}

class _QueroJogarViewState extends State<QueroJogarView> {
  final _controller = JogosController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _controller.streamQueroJogar();
  }

  void _recarregar() {
    setState(() => _stream = _controller.streamQueroJogar());
  }

  Future<void> _abrirFormulario() {
    return showDialog<void>(
      context: context,
      builder: (_) => _FormQueroJogar(controller: _controller),
    );
  }

  Future<void> _excluir(String id) async {
    final erro = await _controller.excluirQueroJogar(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(erro ?? 'Jogo removido da lista.')),
    );
  }

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
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
                  'Sua lista está vazia.\nToque em "Adicionar" para começar.',
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
                    child: Icon(
                      Icons.sports_esports_outlined,
                      color: cores.outline,
                    ),
                  ),
                  title: Text(dados['titulo'] ?? ''),
                  subtitle: Text(
                    '${dados['genero'] ?? ''} • ${dados['plataforma'] ?? ''}'
                    '\nPrioridade: ${dados['prioridade'] ?? ''}',
                  ),
                  isThreeLine: true,
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

class _FormQueroJogar extends StatefulWidget {
  const _FormQueroJogar({required this.controller});

  final JogosController controller;

  @override
  State<_FormQueroJogar> createState() => _FormQueroJogarState();
}

class _FormQueroJogarState extends State<_FormQueroJogar> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  String _genero = generosJogos.first;
  String _plataforma = _plataformas.first;
  String _prioridade = _prioridades[1];
  bool _salvando = false;
  String? _erro;

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _salvando = true;
      _erro = null;
    });

    final erro = await widget.controller.adicionarQueroJogar(
      titulo: _tituloController.text.trim(),
      genero: _genero,
      plataforma: _plataforma,
      prioridade: _prioridade,
    );

    if (!mounted) return;
    if (erro == null) {
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Jogo adicionado com sucesso!')),
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
      title: const Text('Adicionar jogo'),
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
              DropdownButtonFormField<String>(
                initialValue: _plataforma,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Plataforma',
                  border: OutlineInputBorder(),
                ),
                items: _plataformas
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged:
                    _salvando ? null : (v) => setState(() => _plataforma = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _prioridade,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                ),
                items: _prioridades
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged:
                    _salvando ? null : (v) => setState(() => _prioridade = v!),
              ),
              if (_erro != null) ...[
                const SizedBox(height: 12),
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