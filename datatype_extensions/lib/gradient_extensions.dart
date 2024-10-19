import 'package:flutter/material.dart';

const List<double> _defaultStops = [0, .05, .1, .15, .2, .25, .3, .35, .4, .45, .5, .55, .6, .65, .7, .75, .8, .85, .9, .95, 1];

const List<double> _cosValues = [
  0,
  .02447174,
  .0954915,
  .20610737,
  .3454915,
  .5,
  .6545085,
  .79389263,
  .9045085,
  .97552826,
  1,
  .97552826,
  .9045085,
  .79389263,
  .6545085,
  .5,
  .3454915,
  .20610737,
  .0954915,
  .02447174,
  0,
];

const List<double> _hillTopValues = [
  0,
  .024313725,
  .45098039,
  .62745098,
  .75294118,
  .85490196,
  .92156863,
  .96078431,
  .98823529,
  1,
  1,
  1,
  .98823529,
  .96078431,
  .92156863,
  .85490196,
  .75294118,
  .62745098,
  .45098039,
  .024313725,
  0,
];

const List<double> _balancedValues = [
  0,
  .04633829,
  .16658928,
  .33251046,
  .50847137,
  .67745098,
  .81474458,
  .91071681,
  .97148993,
  .99755283,
  1,
  .99755283,
  .97148993,
  .91071681,
  .81474458,
  .67745098,
  .50847137,
  .33251046,
  .16658928,
  .04633829,
  0,
];

class WavyGradient {
  const WavyGradient.hillTop({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.color,
    this.tileMode = TileMode.clamp,
  }) : _opacity = _hillTopValues;

  const WavyGradient.balanced({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.color,
    this.tileMode = TileMode.clamp,
  }) : _opacity = _balancedValues;

  const WavyGradient.cos({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.color,
    this.tileMode = TileMode.clamp,
  }) : _opacity = _cosValues;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Color color;
  final TileMode tileMode;
  final List<double> _opacity;

  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: _opacity.map(color.withOpacity).toList(),
      stops: _defaultStops,
      tileMode: tileMode,
    ).createShader(rect);
  }
}
