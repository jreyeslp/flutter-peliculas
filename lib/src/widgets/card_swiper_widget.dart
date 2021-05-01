import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return CarouselSlider.builder(
      itemCount: this.peliculas.length,
      itemBuilder: (context, index, realIndex) => MoviePosterImage(
        pelicula: this.peliculas[index],
      ),
      options: CarouselOptions(
        autoPlay: true,
        height: 500,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
    );
  }
}

class MoviePosterImage extends StatelessWidget {
  final Pelicula pelicula;

  const MoviePosterImage({
    Key? key,
    required this.pelicula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        'detalle',
        arguments: this.pelicula,
      ),
      child: Hero(
        tag: pelicula.uniqueIdBanner,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/loading.gif'),
            image: NetworkImage(
              pelicula.getPosterImg(),
            ),
          ),
        ),
      ),
    );
  }
}
