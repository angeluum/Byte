import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef ConsultaJogos = Stream<QuerySnapshot<Map<String, dynamic>>>;

/// Acesso ao Firestore para as coleções `quero_jogar` e `avaliacoes`
/// (RF003 - inserção e RF004 - recuperação em tempo real).
///
/// Todo documento guarda o `uid` do usuário dono. As consultas filtram por
/// esse uid e as regras de segurança do Firestore impedem o acesso aos
/// dados de outros usuários.
///
/// Os métodos de escrita retornam `null` em caso de sucesso, ou a mensagem
/// de erro (em português) para a tela exibir.
class JogosController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ---------------------------------------------------------------------
  // quero_jogar
  // ---------------------------------------------------------------------

  ConsultaJogos streamQueroJogar() {
    return _db
        .collection('quero_jogar')
        .where('uid', isEqualTo: _uid)
        .snapshots();
  }

  Future<String?> adicionarQueroJogar({
    required String titulo,
    required String genero,
    required String plataforma,
    required String prioridade,
  }) {
    return _executar(() async {
      await _db.collection('quero_jogar').add({
        'uid': _uid,
        'titulo': titulo,
        'genero': genero,
        'plataforma': plataforma,
        'prioridade': prioridade,
        'criadoEm': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<String?> excluirQueroJogar(String id) {
    return _executar(() => _db.collection('quero_jogar').doc(id).delete());
  }

  // ---------------------------------------------------------------------
  // avaliacoes
  // ---------------------------------------------------------------------

  ConsultaJogos streamAvaliacoes() {
    return _db
        .collection('avaliacoes')
        .where('uid', isEqualTo: _uid)
        .snapshots();
  }

  Future<String?> adicionarAvaliacao({
    required String titulo,
    required String genero,
    required int nota,
    required String critica,
  }) {
    return _executar(() async {
      await _db.collection('avaliacoes').add({
        'uid': _uid,
        'titulo': titulo,
        'genero': genero,
        'nota': nota,
        'critica': critica,
        'criadoEm': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<String?> excluirAvaliacao(String id) {
    return _executar(() => _db.collection('avaliacoes').doc(id).delete());
  }

  // ---------------------------------------------------------------------

  Future<String?> _executar(Future<void> Function() acao) async {
    try {
      await acao().timeout(const Duration(seconds: 10));
      return null;
    } on TimeoutException {
      return 'Tempo esgotado. Verifique sua conexão e tente novamente.';
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return 'Sem permissão para realizar esta operação.';
      }
      return 'Não foi possível concluir a operação. Tente novamente.';
    } catch (_) {
      return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}