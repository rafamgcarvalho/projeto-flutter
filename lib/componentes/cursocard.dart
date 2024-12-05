import 'package:cursos/estado.dart';
import 'package:flutter/material.dart';

class CursoCard extends StatelessWidget {
  final dynamic curso;

  const CursoCard({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    String cursoImagem = curso["course"]["blobs"][0]["file"];
    String logoEmpresa = curso['company']['logo'];
    String nomeEmpresa = curso["company"]["name"];
    String nomecurso = curso["course"]["name"];
    String descricaocurso = curso["course"]["description"];
    String precocurso = curso['course']['price'].toString();

    return GestureDetector(
      onTap: () => estadoApp.mostrarDetalhes(curso["_id"]),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagemcurso(cursoImagem),
            const SizedBox(height: 8),
            _buildInformacoesEmpresa(logoEmpresa, nomeEmpresa),
            const SizedBox(height: 8),
            _buildNomecurso(nomecurso),
            const SizedBox(height: 4),
            _buildDescricaocurso(descricaocurso),
            const Spacer(),
            _buildPrecocurso(precocurso),
          ],
        ),
      ),
    );
  }

  Widget _buildImagemcurso(String imagem) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.asset(
        'lib/recursos/imagens/$imagem',
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInformacoesEmpresa(String logo, String nome) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade100,
            child: Image.asset('lib/recursos/imagens/$logo', fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),
          Text(
            nome,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildNomecurso(String nome) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        nome,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildDescricaocurso(String descricao) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        descricao,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPrecocurso(String preco) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        "R\$ $preco",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}