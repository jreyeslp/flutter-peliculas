import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula =
        ModalRoute.of(context)!.settings.arguments as Pelicula;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _createAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10.0,
                ),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _casting(pelicula),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: FadeIn(
          delay: Duration(milliseconds: 250),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              pelicula.title!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
        background: Hero(
          tag: pelicula.uniqueIdBanner,
          child: FadeInImage(
            image: NetworkImage(
              pelicula.getBackgroundImg(),
            ),
            placeholder: AssetImage('assets/img/loading.gif'),
            fadeInDuration: Duration(milliseconds: 150),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                (15.0),
              ),
              child: Image(
                image: NetworkImage(
                  pelicula.getPosterImg(),
                ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeIn(
                    delay: Duration(milliseconds: 250),
                    child: Text(pelicula.originalTitle!,
                        style: Theme.of(context).textTheme.headline6,
                        overflow: TextOverflow.ellipsis)),
                SizedBox(height: 5.0),
                FadeIn(
                  delay: Duration(milliseconds: 350),
                  child: Text(pelicula.originalTitle!,
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(height: 5.0),
                FadeIn(
                  delay: Duration(milliseconds: 450),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.star_rate_rounded,
                          color: Colors.yellow.shade600),
                      Text(pelicula.voteAverage.toString(),
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Text(
        pelicula.overview!,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _casting(Pelicula pelicula) {
    final provider = PeliculasProvider();

    return FutureBuilder(
      future: provider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createCastWidget(snapshot.data as List<Actor>);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createCastWidget(List<Actor> cast) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        controller: PageController(
          viewportFraction: 0.3,
        ),
        itemBuilder: (context, i) {
          return _actorCard(context, cast[i]);
        },
      ),
    );
  }

  Widget _actorCard(BuildContext context, Actor actor) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 90,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FadeInImage(
              height: 140.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(
                actor.getProfileImg(),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            actor.name!,
            style: Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
