import 'package:flutter/material.dart';

class EsqueceuView extends StatefulWidget {
  const EsqueceuView({super.key});

  @override
  State<EsqueceuView> createState() => _EsqueceuViewState();
}

class _EsqueceuViewState extends State<EsqueceuView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static final _emailRegex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
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

  void _solicitarRecuperacao() {
    if (_formKey.currentState!.validate()) {
      // TODO: chamar o controller (ChangeNotifier) para verificar se o e-mail
      // está associado a uma conta cadastrada e iniciar a recuperação.
      // Se não existir conta, exibir uma mensagem de erro apropriada.
      final email = _emailController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enviamos as instruções de redefinição para $email.'),
        ),
      );
      Navigator.pop(context);
    }
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
                    // Logotipo (mesmo das telas de login e cadastro)
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
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Informe o e-mail da sua conta e enviaremos as instruções para redefinir a senha',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // E-mail cadastrado
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

                    // Botão para solicitar a recuperação
                    FilledButton(
                      onPressed: _solicitarRecuperacao,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Recuperar senha'),
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