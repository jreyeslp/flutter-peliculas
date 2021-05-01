import 'dart:async';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeliculasProvider {
  String _apikey = '8c422f544ca0137ae208ca99508d65c6';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  String _region = 'es';

  int _popularityPage = 0;
  bool _loading = false;

  List<Pelicula> _popular = [];

  // --- BEGIN POPULAR MOVIES STREAM --- //

  final _popularStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularSink => _popularStreamController.sink.add;
  Stream<List<Pelicula>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController.close();
  }

  // --- END POPULAR MOVIES STREAM --- //

  Future<List<Pelicula>> _invokeMoviesHttp(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getNowPlayingMovies() async {
    final url = Uri.https(
      _url,
      '3/movie/now_playing',
      {'api_key': _apikey, 'language': _language, 'region': _region},
    );

    return await _invokeMoviesHttp(url);
  }

  Future<List<Pelicula>> getPopularMovies() async {
    if (_loading) return [];

    _loading = true;

    _popularityPage++;

    final url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apikey,
        'language': _language,
        'region': _region,
        'page': _popularityPage.toString()
      },
    );

    final resp = await _invokeMoviesHttp(url);

    _popular.addAll(resp);
    popularSink(_popular);

    _loading = false;
    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(
      _url,
      '3/movie/$movieId/credits',
      {
        'api_key': _apikey,
        'language': _language,
      },
    );

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {
        'api_key': _apikey,
        'language': _language,
        'region': _region,
        'query': query
      },
    );

    return await _invokeMoviesHttp(url);
  }
}
