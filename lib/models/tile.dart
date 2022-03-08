import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}
class Tile extends Equatable {
  /// {@macro tile}
  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    this.isWhitespace = false,
    this.up = false,
    this.down = false,
    this.left = false,
    this.right = false,
  });

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Denote if the [Tile] gets water from above
  final bool up;

  /// Denote if the [Tile] gets water from below
  final bool down;

  /// Denote if the [Tile] gets water from the right
  final bool right;

  /// Denote if the [Tile] gets water from the elft
  final bool left;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      isWhitespace: isWhitespace,
      up: up,
      down: down,
      left: left,
      right: right,
    );
  }

  @override
  List<Object> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhitespace,
        up,
        down,
        left,
        right,
      ];
}
