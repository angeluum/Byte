import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User get _usuario => _auth.currentUser!;

  String get email => _usuario.email ?? '';

  String get nomePadrao {
    final parte = email.split('@').first;
    return parte.isEmpty ? 'Usuário' : parte;
  }

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('usuarios').doc(_usuario.uid);


  Future<Map<String, dynamic>?> carregar() async {
    final snap = await _doc.get().timeout(const Duration(seconds: 10));
    return snap.data();
  }

  Future<String?> atualizarNome(String nome) => _gravar({'nome': nome});

 
  Future<void> sair() => _auth.signOut();

  Future<String?> atualizarFoto(String? fotoBase64) {
    return _gravar({'foto': fotoBase64 ?? FieldValue.delete()});
  }

  Future<String?> _gravar(Map<String, Object?> campos) async {
    try {
      await _doc
          .set(
            {'uid': _usuario.uid, 'email': email, ...campos},
            SetOptions(merge: true),
          )
          .timeout(const Duration(seconds: 10));
      return null;
    } on TimeoutException {
      return 'Tempo esgotado. Verifique sua conexão e tente novamente.';
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return 'Sem permissão para realizar esta operação.';
      }
      return 'Não foi possível salvar. Tente novamente.';
    } catch (_) {
      return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}
