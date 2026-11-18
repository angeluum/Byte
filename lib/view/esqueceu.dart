import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class EsqueceuView extends StatefulWidget {
  const EsqueceuView({super.key});

  @override
  State<EsqueceuView> createState() => _EsqueceuViewState();
}

class _EsqueceuViewState extends State<EsqueceuView> {
  final _auth = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static final _emailRegex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _auth.dispose();
    super.dispose();
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail cadastrado.';
    }
    if (!_emailRegex.hasMatch(valor.trim())) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  Future<void> _solicitarRecuperacao() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final ok = await _auth.recuperarSenha(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Se o e-mail estiver cadastrado, enviamos as instruções para $email.'
              : _auth.erro!,
        ),
      ),
    );
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
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
                      'Recuperar senha',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Informe o e-mail da sua conta e enviaremos as instruções para redefinir a senha',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _solicitarRecuperacao(),
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validarEmail,
                    ),
                    const SizedBox(height: 24),

                    ListenableBuilder(
                      listenable: _auth,
                      builder: (_, __) => FilledButton(
                        onPressed:
                            _auth.carregando ? null : _solicitarRecuperacao,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _auth.carregando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Recuperar senha'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Voltar ao login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Lembrou a senha?'),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Entrar'),
                        ),
                      ],
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
