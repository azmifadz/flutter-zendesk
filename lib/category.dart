import 'package:flutter/material.dart';

@immutable
class Category {

  const Category({
    this.id,
    this.url,
    this.name
  });

  /// Gets the ID of the category
  final int id;

  /// Gets the API URL of the category
  final String url;

  /// Gets the name of the category
  final String name;

}