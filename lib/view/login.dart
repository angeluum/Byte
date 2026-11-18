import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _auth = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  static final _emailRegex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _auth.dispose();
    super.dispose();
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail.';
    }
    if (!_emailRegex.hasMatch(valor.trim())) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe a senha.';
    }
    return null;
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _auth.entrar(
      _emailController.text.trim(),
      _senhaController.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_auth.erro!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      height: 120,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.sports_esports,
                        size: 96,
                        color: cores.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Byte',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Avalie, registre e compartilhe seus jogos',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validarEmail,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _senhaController,
                      obscureText: _ocultarSenha,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _entrar(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _ocultarSenha
                              ? 'Mostrar senha'
                              : 'Ocultar senha',
                          icon: Icon(
                            _ocultarSenha
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _ocultarSenha = !_ocultarSenha),
                        ),
                      ),
                      validator: _validarSenha,
                    ),

                    // Esqueceu a senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/esqueceu-senha'),
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ListenableBuilder(
                      listenable: _auth,
                      builder: (_, __) => FilledButton(
                        onPressed: _auth.carregando ? null : _entrar,
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
                            : const Text('Entrar'),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Ainda não tem conta?'),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/cadastro'),
                          child: const Text('Cadastre-se'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/sobre'),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Sobre o Byte'),
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
