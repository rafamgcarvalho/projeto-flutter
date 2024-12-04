// import 'dart:convert';

// import 'package:cursos/autenticador.dart';
// import 'package:cursos/componentes/cursocard.dart';
// import 'package:cursos/estado.dart';
// import 'package:flat_list/flat_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:toast/toast.dart';

// class Cursos extends StatefulWidget {
//   const Cursos({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _CursosState();
//   }
// }

// const int tamanhoPagina = 4;

// class _CursosState extends State<Cursos> {
//   late dynamic _feedEstatico;
//   List<dynamic> _cursos = [];

//   int _proximaPagina = 1;
//   bool _carregando = false;

//   late TextEditingController _controladorFiltragem;
//   String _filtro = "";

//   @override
//   void initState() {
//     super.initState();

//     ToastContext().init(context);

//     _controladorFiltragem = TextEditingController();
//     _lerFeedEstatico();
//   }

//   Future<void> _lerFeedEstatico() async {
//     final String conteudoJson =
//         await rootBundle.loadString("lib/recursos/json/feed.json");
//     _feedEstatico = await json.decode(conteudoJson);

//     _carregarCursos();
//   }

//   void _carregarCursos() {
//     setState(() {
//       _carregando = true;
//     });

//     var maisCursos = [];
//     if (_filtro.isNotEmpty) {
//       _feedEstatico["cursos"].where((item) {
//         String nome = item["course"]["name"];

//         return nome.toLowerCase().contains(_filtro.toLowerCase());
//       }).forEach((item) {
//         maisCursos.add(item);
//       });
//     } else {
//       maisCursos = _cursos;

//       final totalCursosParaCarregar = _proximaPagina * tamanhoPagina;
//       if (_feedEstatico["cursos"].length >= totalCursosParaCarregar) {
//         maisCursos =
//             _feedEstatico["cursos"].sublist(0, totalCursosParaCarregar);
//       }
//     }

//     setState(() {
//       _cursos = maisCursos;
//       _proximaPagina = _proximaPagina + 1;

//       _carregando = false;
//     });
//   }

//   Future<void> _atualizarCursos() async {
//     _cursos = [];
//     _proximaPagina = 1;

//     _carregarCursos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool usuarioLogado = estadoApp.usuario != null;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue, // Cor de fundo do AppBar
//         automaticallyImplyLeading: false, // Remove o ícone de "voltar"
//         elevation: 0, // Remove a sombra da AppBar
//         title: Column(
//           children: [
//             // "Div" para o nome do aplicativo
//             Container(
//               width: double.infinity, // A largura da div vai ocupar toda a tela
//               padding: EdgeInsets.symmetric(
//                   vertical: 20), // Margem superior e inferior
//               color: Colors.blue, // Cor de fundo da "div"
//               child: const Text(
//                 'Cursos Online', // Nome do aplicativo
//                 textAlign: TextAlign.center, // Centraliza o texto
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white, // Cor do texto
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // "Div" para a imagem, ocupando toda a largura da tela
//           Container(
//             width:
//                 double.infinity, // A largura da imagem vai ocupar toda a tela
//             child: Image.asset(
//               'lib/recursos/imagens/logoc.png', // Caminho da imagem do logo
//               fit: BoxFit
//                   .cover, // A imagem vai cobrir toda a largura e manter a proporção
//               height: 200, // Ajuste o tamanho da imagem conforme necessário
//             ),
//           ),

//           // Barra de pesquisa e ícones de login/logout abaixo da imagem
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controladorFiltragem,
//                     onSubmitted: (descricao) {
//                       _filtro = descricao;
//                       _atualizarCursos();
//                     },
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       suffixIcon: Icon(Icons.search),
//                       hintText: 'Pesquisar...',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                     width:
//                         10), // Espaço entre a pesquisa e o ícone de login/logout
//                 usuarioLogado
//                     ? IconButton(
//                         onPressed: () {
//                           setState(() {
//                             estadoApp.onLogout();
//                           });
//                           Toast.show("Desconectado",
//                               duration: Toast.lengthLong,
//                               gravity: Toast.bottom);
//                         },
//                         icon: const Icon(Icons.logout))
//                     : IconButton(
//                         onPressed: () {
//                           Usuario usuario =
//                               Usuario("rafael", "fanfones.10@gmali.com");
//                           setState(() {
//                             estadoApp.onLogin(usuario);
//                           });
//                           Toast.show("Conectado",
//                               duration: Toast.lengthLong,
//                               gravity: Toast.bottom);
//                         },
//                         icon: const Icon(Icons.login)),
//               ],
//             ),
//           ),

//           // Espaço entre a barra de pesquisa e a lista de Cursos
//           SizedBox(height: 20),

//           // Lista de Cursos (ou cursos, conforme sua aplicação)
//           Expanded(
//             child: FlatList(
//               data: _cursos,
//               numColumns: 2,
//               loading: _carregando,
//               onRefresh: () {
//                 _filtro = "";
//                 _controladorFiltragem.clear();
//                 return _atualizarCursos();
//               },
//               onEndReached: () => _carregarCursos(),
//               buildItem: (item, int indice) {
//                 return SizedBox(height: 400, child: CursoCard(curso: item));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
          // SliverAppBar com a imagem e barra de pesquisa
          SliverAppBar(
            expandedHeight: 300.0, // Tamanho do SliverAppBar
            floating: false,
            pinned: true, // Fixa o SliverAppBar
            elevation: 5, // Cria uma leve sombra para destacar a barra
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container para o título com fundo azul
                  Container(
                    width: double.infinity,
                    color: Colors.blue, // Cor de fundo da área do título
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Cursos Online',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do título para contraste
                      ),
                    ),
                  ),
                  // Imagem do logo
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'lib/recursos/imagens/logoc.png',
                      fit: BoxFit.cover,
                      height: 150, // Ajuste conforme necessário
                    ),
                  ),
                  // Barra de pesquisa e login/logout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controladorFiltragem,
                            onSubmitted: (descricao) {
                              _filtro = descricao;
                              _atualizarCursos();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Pesquisar...',
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        usuarioLogado
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    estadoApp.onLogout();
                                  });
                                  Toast.show("Desconectado",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom);
                                },
                                icon: const Icon(Icons.logout))
                            : IconButton(
                                onPressed: () {
                                  Usuario usuario =
                                      Usuario("rafael", "fanfones.10@gmali.com");
                                  setState(() {
                                    estadoApp.onLogin(usuario);
                                  });
                                  Toast.show("Conectado",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom);
                                },
                                icon: const Icon(Icons.login)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de cursos
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SizedBox(
                    height: 400, // Ajuste para os cards de cursos
                    child: CursoCard(curso: _cursos[index]),
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