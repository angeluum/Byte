import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {

  static const int _minCaracteres = 3;

  static const String _nomeInicial = 'Nome do Usuário';
  static const String _email = 'usuario@email.com';

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController(text: _nomeInicial);


  String _nomeSalvo = _nomeInicial;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
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

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      setState(() => _nomeSalvo = _nomeController.text.trim());
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  void _cancelar() {
    _formKey.currentState!.reset();
    _nomeController.text = _nomeSalvo;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final inicial = _nomeSalvo.isEmpty
        ? '?'
        : _nomeSalvo.characters.first.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: cores.primaryContainer,
                        child: Text(
                          inicial,
                          style: textos.displaySmall?.copyWith(
                            color: cores.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      _email,
                      textAlign: TextAlign.center,
                      style: textos.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Nome
                    TextFormField(
                      controller: _nomeController,
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
                    const SizedBox(height: 16),

                    // E-mail
                    TextFormField(
                      initialValue: _email,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        helperText: 'O e-mail não pode ser alterado aqui.',
                        prefixIcon: Icon(Icons.email_outlined),
                        suffixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Salvar alterações
                    FilledButton(
                      onPressed: _salvar,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Salvar alterações'),
                    ),
                    const SizedBox(height: 12),

                    // Cancelar edições
                    OutlinedButton(
                      onPressed: _cancelar,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
