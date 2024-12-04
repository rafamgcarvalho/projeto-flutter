import 'dart:convert';

import 'package:cursos/estado.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';

class DetalhesCurso extends StatefulWidget {
  const DetalhesCurso({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesCursoState();
  }
}

enum _EstadoCurso { naoVerificado, temCurso, semCurso }

class _DetalhesCursoState extends State<DetalhesCurso> {
  late dynamic _feedEstatico;
  late dynamic _comentariosEstaticos;

  _EstadoCurso _temCurso = _EstadoCurso.naoVerificado;
  late dynamic _curso;

  List<dynamic> _comentarios = [];
  bool _carregandoComentarios = false;
  bool _temComentarios = false;

  late TextEditingController _controladorNovoComentario;

  late PageController _controladorSlides;
  late int _slideSelecionado;

  bool _curtiu = false;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _lerFeedEstatico();
    _iniciarSlides();

    _controladorNovoComentario = TextEditingController();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<void> _lerFeedEstatico() async {
    String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    conteudoJson =
        await rootBundle.loadString("lib/recursos/json/comentarios.json");
    _comentariosEstaticos = await json.decode(conteudoJson);

    _carregarCurso();
    _carregarComentarios();
  }

  // void _carregarCurso() {
  //   setState(() {
  //     _curso = _feedEstatico['cursos']
  //         .firstWhere((curso) => curso["_id"] == estadoApp.idCurso);

  //     _temCurso = _curso != null
  //         ? _EstadoCurso.temCurso
  //         : _EstadoCurso.semCurso;
  //   });
  // }

  void _carregarCurso() {
  
  if (_feedEstatico != null && _feedEstatico['cursos'] != null) {
    setState(() {
      _curso = _feedEstatico['cursos']
          .firstWhere((curso) => curso["_id"] == int.tryParse(estadoApp.idCurso.toString()), orElse: () => null);

      _temCurso = _curso != null
          ? _EstadoCurso.temCurso
          : _EstadoCurso.semCurso;
    });
  } else {
    setState(() {
      _temCurso = _EstadoCurso.semCurso;
    });
  }
}

  void _carregarComentarios() {
    setState(() {
      _carregandoComentarios = true;
    });

    var maisComentarios = [];
    _comentariosEstaticos["comentarios"].where((item) {
      return item["feed"] == estadoApp.idCurso;
    }).forEach((item) {
      maisComentarios.add(item);
    });

    setState(() {
      _carregandoComentarios = false;
      _comentarios = maisComentarios;

      _temComentarios = _comentarios.isNotEmpty;
    });
  }

  Widget _exibirMensagemcursoInexistente() {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
                    Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text("Melhores Marcas"))
                  ]),
                  GestureDetector(
                      onTap: () {
                        estadoApp.mostrarCursos();
                      },
                      child: const Icon(Icons.arrow_back))
                ])),
        body: const SizedBox.expand(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error, size: 32, color: Colors.red),
          Text("curso inexistente :(",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text("selecione outro curso na tela anterior",
              style: TextStyle(fontSize: 14))
        ])));
  }

  Widget _exibirMensagemComentariosInexistentes() {
    return const Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.error, size: 32, color: Colors.red),
      Text("não existem comentários",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red))
    ]));
  }

  Widget _exibirComentarios() {
    return Expanded(
        child: FlatList(
      data: _comentarios,
      loading: _carregandoComentarios,
      buildItem: (item, index) {
        String dataFormatada = DateFormat('dd/MM/yyyy HH:mm')
            .format(DateTime.parse(item["datetime"]));
        bool usuarioLogadoComentou = estadoApp.usuario != null &&
            estadoApp.usuario!.email == item["user"]["email"];

        return Dismissible(
          key: Key(item["_id"].toString()),
          direction: usuarioLogadoComentou
              ? DismissDirection.endToStart
              : DismissDirection.none,
          background: Container(
              alignment: Alignment.centerRight,
              child: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.delete, color: Colors.red))),
          child: Card(
              color: usuarioLogadoComentou ? Colors.green[100] : Colors.white,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(item["content"],
                            style: const TextStyle(fontSize: 12)))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 6.0),
                            child: Text(
                              dataFormatada,
                              style: const TextStyle(fontSize: 12),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              item["user"]["name"],
                              style: const TextStyle(fontSize: 12),
                            )),
                      ],
                    )),
              ])),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              final comentario = item;
              setState(() {
                _comentarios.removeAt(index);
              });

              showDialog(
                  context: context,
                  builder: (BuildContext contexto) {
                    return AlertDialog(
                      title: const Text("Deseja apagar o comentário?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _comentarios.insert(index, comentario);
                              });

                              Navigator.of(contexto).pop();
                            },
                            child: const Text("NÃO")),
                        TextButton(
                            onPressed: () {
                              setState(() {});

                              Navigator.of(contexto).pop();
                            },
                            child: const Text("SIM"))
                      ],
                    );
                  });
            }
          },
        );
      },
    ));
  }

  void _adicionarComentario() {
    String conteudo = _controladorNovoComentario.text.trim();
    if (conteudo.isNotEmpty) {
      final comentario = {
        "content": conteudo,
        "user": {
          "name": estadoApp.usuario!.nome,
          "email": estadoApp.usuario!.email,
        },
        "datetime": DateTime.now().toString(),
        "feed": estadoApp.idCurso
      };

      setState(() {
        _comentarios.insert(0, comentario);
      });

      _controladorNovoComentario.clear();
    } else {
      Toast.show("Digite um comentário",
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }
  }

  Widget _exibircurso() {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(children: [
          GestureDetector(
            onTap: () {
              estadoApp.mostrarCursos();
            },
            child: const Icon(Icons.arrow_back, size: 30),
          ),
          const Spacer(),
          Row(children: [
            Image.asset('lib/recursos/imagens/ifba-divulgao.jpg', width: 38),
            Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                  _curso["company"]["name"],
                  style: const TextStyle(fontSize: 15),
                ))
          ]),
        ]),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            child: Stack(children: [
              PageView.builder(
                itemCount: 3,
                controller: _controladorSlides,
                onPageChanged: (slide) {
                  setState(() {
                    _slideSelecionado = slide;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return Image.asset(
                    'lib/recursos/imagens/cursos1.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: [
                    usuarioLogado
                        ? IconButton(
                            onPressed: () {
                              if (_curtiu) {
                                setState(() {
                                  _curso['likes'] = _curso['likes'] - 1;

                                  _curtiu = false;
                                });
                              } else {
                                setState(() {
                                  _curso['likes'] = _curso['likes'] + 1;

                                  _curtiu = true;
                                });

                                Toast.show("Obrigado pela avaliação",
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom);
                              }
                            },
                            icon: Icon(_curtiu
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Colors.red,
                            iconSize: 26)
                        : const SizedBox.shrink(),
                    IconButton(
                        onPressed: () {
                          final texto =
                              '${_curso["course"]["name"]} por R\$ ${_curso["course"]["price"].toString()} disponível no Melhores Marcas.\n\n\nBaixe o Melhores Marcas na PlayStore!';

                          FlutterShare.share(
                              title: "Cursos Online", text: texto);
                        },
                        icon: const Icon(Icons.share),
                        color: Colors.blue,
                        iconSize: 26)
                  ]))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PageViewDotIndicator(
              currentItem: _slideSelecionado,
              count: 3,
              unselectedColor: Colors.black26,
              selectedColor: Colors.blue,
              duration: const Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      _curso["course"]["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    )),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(_curso["course"]["description"],
                        style: const TextStyle(fontSize: 12))),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
                    child: Row(children: [
                      Text(
                        "R\$ ${_curso["course"]["price"].toString()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                Text(
                                  _curso["likes"].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ]))
                    ]))
              ],
            ),
          ),
          const Center(
              child: Text(
            "Comentários",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          )),
          usuarioLogado
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextField(
                      controller: _controladorNovoComentario,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black87, width: 0.0),
                          ),
                          border: const OutlineInputBorder(),
                          hintStyle: const TextStyle(fontSize: 14),
                          hintText: 'Digite aqui seu comentário...',
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _adicionarComentario();
                              },
                              child: const Icon(Icons.send,
                                  color: Colors.black87)))))
              : const SizedBox.shrink(),
          _temComentarios
              ? _exibirComentarios()
              : _exibirMensagemComentariosInexistentes()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget DetalhesCurso = const SizedBox.shrink();

    if (_temCurso == _EstadoCurso.naoVerificado) {
      DetalhesCurso = const SizedBox.shrink();
    } else if (_temCurso == _EstadoCurso.temCurso) {
      DetalhesCurso = _exibircurso();
    } else {
      DetalhesCurso = _exibirMensagemcursoInexistente();
    }

    return DetalhesCurso;
  }
}
