import 'dart:convert';

import 'package:cursos/autenticador.dart';
import 'package:cursos/componentes/cursocard.dart';
import 'package:cursos/estado.dart';
// import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Cursos extends StatefulWidget {
  const Cursos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CursosState();
  }
}

const int tamanhoPagina = 4;

class _CursosState extends State<Cursos> {
  late dynamic _feedEstatico;
  List<dynamic> _cursos = [];

  int _proximaPagina = 1;
  bool _carregando = false;

  late TextEditingController _controladorFiltragem;
  String _filtro = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _controladorFiltragem = TextEditingController();
    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    _carregarCursos();
  }

  void _carregarCursos() {
    setState(() {
      _carregando = true;
    });

    var maisCursos = [];
    if (_filtro.isNotEmpty) {
      _feedEstatico["cursos"].where((item) {
        String nome = item["course"]["name"];

        return nome.toLowerCase().contains(_filtro.toLowerCase());
      }).forEach((item) {
        maisCursos.add(item);
      });
    } else {
      maisCursos = _cursos;

      final totalCursosParaCarregar = _proximaPagina * tamanhoPagina;
      if (_feedEstatico["cursos"].length >= totalCursosParaCarregar) {
        maisCursos =
            _feedEstatico["cursos"].sublist(0, totalCursosParaCarregar);
      }
    }

    setState(() {
      _cursos = maisCursos;
      _proximaPagina = _proximaPagina + 1;

      _carregando = false;
    });
  }

  Future<void> _atualizarCursos() async {
    _cursos = [];
    _proximaPagina = 1;

    _carregarCursos();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            elevation: 5,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[800]!, Colors.grey[400]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Cursos Online',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'lib/recursos/imagens/logoc.png',
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controladorFiltragem,
                            onSubmitted: (descricao) {
                              _filtro = descricao;
                              _atualizarCursos();
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Pesquisar...',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            if (usuarioLogado) {
                              setState(() {
                                estadoApp.onLogout();
                              });
                              Toast.show("Desconectado",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom);
                            } else {
                              Usuario usuario =
                                  Usuario("rafael", "fanfones.10@gmali.com");
                              setState(() {
                                estadoApp.onLogin(usuario);
                              });
                              Toast.show("Conectado",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom);
                            }
                          },
                          icon:
                              Icon(usuarioLogado ? Icons.logout : Icons.login),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: SizedBox(
                      height: 400,
                      child: CursoCard(curso: _cursos[index]),
                    ),
                  ),
                );
              },
              childCount: _cursos.length,
            ),
          ),
        ],
      ),
    );
  }
}