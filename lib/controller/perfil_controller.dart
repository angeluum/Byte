import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Leitura e atualização do perfil do usuário logado.
///
/// Os dados ficam na coleção `usuarios`, em um documento cujo id é o `uid`.
/// A foto é guardada no próprio documento, como texto (base64), no campo
/// `foto`. O e-mail vem do Firebase Authentication.
class PerfilController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User get _usuario => _auth.currentUser!;

  String get email => _usuario.email ?? '';

  /// Nome provisório, caso o documento do usuário ainda não tenha `nome`.
  String get nomePadrao {
    final parte = email.split('@').first;
    return parte.isEmpty ? 'Usuário' : parte;
  }

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('usuarios').doc(_usuario.uid);

  /// Retorna os dados do documento (ou `null` se ele não existir).
  /// Lança exceção se a leitura falhar.
  Future<Map<String, dynamic>?> carregar() async {
    final snap = await _doc.get().timeout(const Duration(seconds: 10));
    return snap.data();
  }

  Future<String?> atualizarNome(String nome) => _gravar({'nome': nome});

  /// Encerra a sessão do usuário no Firebase Authentication.
  Future<void> sair() => _auth.signOut();

  /// Passe `null` para remover a foto.
  Future<String?> atualizarFoto(String? fotoBase64) {
    return _gravar({'foto': fotoBase64 ?? FieldValue.delete()});
  }

  /// Retorna `null` em caso de sucesso, ou a mensagem de erro.
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
