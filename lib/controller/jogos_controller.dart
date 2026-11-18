import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef ConsultaJogos = Stream<QuerySnapshot<Map<String, dynamic>>>;

class JogosController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;


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