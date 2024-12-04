import 'package:cursos/estado.dart';
import 'package:flutter/material.dart';

class CursoCard extends StatelessWidget {
  final dynamic curso;

  const CursoCard({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    // Obtém o nome da imagem do primeiro blob
    String cursoImagem = curso["course"]["blobs"][0]["file"];
    String logoEmpresa = curso['company']['logo'];
    String nomeEmpresa = curso["company"]["name"];
    String nomecurso = curso["course"]["name"];
    String descricaocurso = curso["course"]["description"];
    String precocurso = curso['course']['price'].toString();

    return GestureDetector(
      onTap: () => estadoApp.mostrarDetalhes(curso["_id"]),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagemcurso(cursoImagem),
            _buildInformacoesEmpresa(logoEmpresa, nomeEmpresa),
            _buildNomecurso(nomecurso),
            _buildDescricaocurso(descricaocurso),
            _buildPrecocurso(precocurso),
          ],
        ),
      ),
    );
  }

  Widget _buildImagemcurso(String imagem) {
    return Image.asset('lib/recursos/imagens/$imagem');
  }

  Widget _buildInformacoesEmpresa(String logo, String nome) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset('lib/recursos/imagens/$logo'),
        ),
        const SizedBox(width: 5),
        Text(nome, style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _buildNomecurso(String nome) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        nome,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildDescricaocurso(String descricao) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(descricao),
    );
  }

  Widget _buildPrecocurso(String preco) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Text("R\$ $preco"),
    );
  }
}
