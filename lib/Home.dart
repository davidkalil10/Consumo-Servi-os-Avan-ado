import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com";

 Future<List<Post>> _recuperarPostagens() async{

  http.Response response = await http.get(_urlBase + "/posts");
  var dadosJson = json.decode(response.body);

  List<Post> postagens = List();

  for(var post in dadosJson){
    print("post" + post["title"]);
    Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
    postagens.add(p);

  }

  return postagens;

  }

  _post() async{ //inserir novo item

   Post post = new Post(120, null, "eita", "nois");

   var corpo = json.encode(
       post.toJson()
   );

   http.Response response = await http.post(
      _urlBase + "/posts",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: corpo
    );

    print("resposta: ${response.statusCode}"); //verificar se deu certo o post ou nao
    print("resposta: ${response.body}"); //resposta da api


  }

  _put() async{ //atualizar um item existente

    var corpo = json.encode(
        {
          "userId": 120,
          "id": null,
          "title": "eita",
          "body": "nois, atualizou"
        }
    );

    http.Response response = await http.put(
        _urlBase + "/posts/2", //id 2
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}"); //verificar se deu certo o post ou nao
    print("resposta: ${response.body}"); //resposta da api

  }

  _patch() async{ //atualiza como o put, porem vc so faz referencia as chaves quer quer alterar

    var corpo = json.encode(
        {
          "userId": 120,
          "body": "nois, atualizou 2"
        }
    );

    http.Response response = await http.patch(
        _urlBase + "/posts/2", //id 2
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}"); //verificar se deu certo o post ou nao
    print("resposta: ${response.body}"); //resposta da api



  }

  _delete() async{

    var corpo = json.encode(
        {
          "userId": 120,
          "id": null,
          "title": "eita",
          "body": "nois, atualizou"
        }
    );

    http.Response response = await http.delete(
        _urlBase + "/post/2"
    );

    //checar se deu certo

    if(response.statusCode.toString() == "200"){
      print("Supimpa");
    }else{
      if(response.statusCode.toString() == "404"){
        print("deu ruim");
      }
    }


    print("resposta: ${response.statusCode}"); //verificar se deu certo o post ou nao
    print("resposta: ${response.body}"); //resposta da api


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Consumo de serviço avançado"),
      ) ,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Excluir"),
                  onPressed: _delete,
                )
              ],
            ),

            Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot){

                    switch(snapshot.connectionState){
                      case ConnectionState.none :
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(snapshot.hasError){
                          print("Lista: Erro ao carregar");

                        }else{
                          print("Lista: carregou");
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index){

                                List<Post> lista = snapshot.data;
                                Post post = lista[index];

                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text(post.id.toString()),
                                );
                              }
                          );

                        }
                        break;
                    }



                  },
                ),
            )


          ],
        ),
      ) ,
    );
  }
}
