import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class MovieSearch extends SearchDelegate {
  final movies = ['peli 1', 'peli 2', 'jajaja', 'jejeje'];
  final recentMovies = ['peli 1', 'peli 2'];

  String selected = '';

  final provider = PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar generado por el Delegate
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.redAccent,
        child: Text(selected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias de búsqueda al escribir

    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: provider.searchMovie(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!;

            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(
                      movie.getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(movie.title!),
                  onTap: () {
                    close(context, null);
                    Navigator.pushNamed(
                      context,
                      'detalle',
                      arguments: movie,
                    );
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias de búsqueda al escribir

  //   final suggestionList = (query.isEmpty)
  //       ? recentMovies
  //       : movies
  //           .where(
  //               (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(suggestionList[i]),
  //         onTap: () {
  //           selected = suggestionList[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //     itemCount: suggestionList.length,
  //   );
  // }
}
