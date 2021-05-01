import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula>? peliculas;
  final Function nextPage;

  MovieHorizontal({required this.peliculas, required this.nextPage});

  final _pageController = new PageController(
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >
          _pageController.position.maxScrollExtent - 200) {
        this.nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemBuilder: (context, i) => _tarjeta(peliculas![i], context),
        itemCount: peliculas!.length,
      ),
    );
  }

  Widget _tarjeta(Pelicula pelicula, BuildContext context) {
    final movieCard = Container(
      margin: EdgeInsets.only(left: 15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  image: NetworkImage(
                    pelicula.getPosterImg(),
                  ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: 100,
            child: Text(
              pelicula.title!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: movieCard,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
