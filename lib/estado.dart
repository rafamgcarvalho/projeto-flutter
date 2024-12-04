import 'package:cursos/autenticador.dart';
import 'package:flutter/material.dart';

enum Situacao { mostrandoCursos, mostrandoDetalhes }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoCursos;
  Situacao get situacao => _situacao;

  late int _idCurso;
  int get idCurso => _idCurso;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  void mostrarCursos() {
    _situacao = Situacao.mostrandoCursos;

    notifyListeners();
  }

  void mostrarDetalhes(int idCurso) {
    _situacao = Situacao.mostrandoDetalhes;
    _idCurso = idCurso;

    notifyListeners();
  }

  void onLogin(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void onLogout() {
    _usuario = null;

    notifyListeners();
  }
}

late EstadoApp estadoApp;

