import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool carregando = false;
  String? erro;

  void _iniciar() {
    carregando = true;
    erro = null;
    notifyListeners();
  }

  void _finalizar([String? mensagemErro]) {
    carregando = false;
    erro = mensagemErro;
    notifyListeners();
  }


  Future<bool> entrar(String email, String senha) async {
    _iniciar();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _finalizar();
      return true;
    } on FirebaseAuthException catch (e) {
      _finalizar(_traduzirErro(e.code));
      return false;
    } catch (_) {
      _finalizar('Ocorreu um erro inesperado. Tente novamente.');
      return false;
    }
  }


  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    _iniciar();
    UserCredential? credencial;
    try {
      credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final uid = credencial.user!.uid;

      await _db.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      _finalizar();
      return true;
    } on FirebaseAuthException catch (e) {
      _finalizar(_traduzirErro(e.code));
      return false;
    } on FirebaseException catch (_) {

      try {
        await credencial?.user?.delete();
      } catch (_) {}
      _finalizar('Não foi possível salvar seus dados. Tente novamente.');
      return false;
    } catch (_) {
      _finalizar('Ocorreu um erro inesperado. Tente novamente.');
      return false;
    }
  }


  Future<bool> recuperarSenha(String email) async {
    _iniciar();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _finalizar();
      return true;
    } on FirebaseAuthException catch (e) {
      _finalizar(_traduzirErro(e.code));
      return false;
    } catch (_) {
      _finalizar('Ocorreu um erro inesperado. Tente novamente.');
      return false;
    }
  }

  Future<void> sair() => _auth.signOut();

  String _traduzirErro(String codigo) {
    switch (codigo) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Não foi possível concluir a operação. Tente novamente.';
    }
  }
}
