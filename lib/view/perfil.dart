import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/perfil_controller.dart';
import 'componentes.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  static const int _minCaracteres = 3;

  // Limite de tamanho da foto (o documento do Firestore aceita até 1 MiB).
  static const int _limiteFotoBytes = 700 * 1024;

  final _controller = PerfilController();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  bool _carregando = true;
  bool _erroCarga = false;
  bool _salvando = false;
  bool _enviandoFoto = false;

  String _nomeSalvo = '';
  Uint8List? _foto;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  /// Lê o nome e a foto do documento do usuário na coleção `usuarios`.
  Future<void> _carregar() async {
    try {
      final dados = await _controller.carregar();
      if (!mounted) return;

      final nome = (dados?['nome'] as String?)?.trim();
      final foto = dados?['foto'] as String?;

      setState(() {
        _nomeSalvo =
            (nome == null || nome.isEmpty) ? _controller.nomePadrao : nome;
        _nomeController.text = _nomeSalvo;
        _foto = foto == null ? null : base64Decode(foto);
        _carregando = false;
        _erroCarga = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erroCarga = true;
      });
    }
  }

  void _tentarNovamente() {
    setState(() {
      _carregando = true;
      _erroCarga = false;
    });
    _carregar();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) {
      return 'Informe o nome.';
    }
    if (nome.length < _minCaracteres) {
      return 'O nome deve ter pelo menos $_minCaracteres caracteres.';
    }
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text.trim();
    FocusScope.of(context).unfocus();
    setState(() => _salvando = true);

    final erro = await _controller.atualizarNome(nome);

    if (!mounted) return;
    setState(() {
      _salvando = false;
      if (erro == null) _nomeSalvo = nome;
    });
    _mensagem(erro ?? 'Perfil atualizado com sucesso!');
  }

  void _cancelar() {
    _formKey.currentState!.reset();
    _nomeController.text = _nomeSalvo;
    FocusScope.of(context).unfocus();
  }

  Future<void> _sair() async {
    await _controller.sair();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (rota) => false);
  }

  Future<void> _escolherFoto() async {
    final acao = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, 'galeria'),
            ),
            if (_foto != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remover foto'),
                onTap: () => Navigator.pop(context, 'remover'),
              ),
          ],
        ),
      ),
    );
    if (!mounted || acao == null) return;

    if (acao == 'remover') {
      await _salvarFoto(null);
      return;
    }

    final arquivo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 70,
    );
    if (arquivo == null) return;

    final bytes = await arquivo.readAsBytes();
    if (!mounted) return;

    if (bytes.length > _limiteFotoBytes) {
      _mensagem('A imagem é muito grande. Escolha uma foto menor.');
      return;
    }
    await _salvarFoto(bytes);
  }

  Future<void> _salvarFoto(Uint8List? bytes) async {
    setState(() => _enviandoFoto = true);

    final erro = await _controller.atualizarFoto(
      bytes == null ? null : base64Encode(bytes),
    );

    if (!mounted) return;
    setState(() {
      _enviandoFoto = false;
      if (erro == null) _foto = bytes;
    });
    _mensagem(
      erro ?? (bytes == null ? 'Foto removida.' : 'Foto atualizada!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(child: _corpo(context)),
    );
  }

  Widget _corpo(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erroCarga) {
      return ErroCarregar(onTentarNovamente: _tentarNovamente);
    }

    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final inicial =
        _nomeSalvo.isEmpty ? '?' : _nomeSalvo.characters.first.toUpperCase();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Foto de perfil
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: cores.primaryContainer,
                        backgroundImage:
                            _foto == null ? null : MemoryImage(_foto!),
                        child: _enviandoFoto
                            ? const CircularProgressIndicator()
                            : (_foto == null
                                ? Text(
                                    inicial,
                                    style: textos.displaySmall?.copyWith(
                                      color: cores.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: cores.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _enviandoFoto ? null : _escolherFoto,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: cores.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _nomeSalvo,
                  textAlign: TextAlign.center,
                  style: textos.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _controller.email,
                  textAlign: TextAlign.center,
                  style: textos.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Nome
                TextFormField(
                  controller: _nomeController,
                  enabled: !_salvando,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _salvar(),
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarNome,
                ),
                const SizedBox(height: 24),

                // Salvar alterações
                FilledButton(
                  onPressed: _salvando ? null : _salvar,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _salvando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar alterações'),
                ),
                const SizedBox(height: 12),

                // Cancelar edições
                OutlinedButton(
                  onPressed: _salvando ? null : _cancelar,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),

                // Sair da conta
                TextButton.icon(
                  onPressed: _salvando ? null : _sair,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair da conta'),
                  style: TextButton.styleFrom(
                    foregroundColor: cores.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
