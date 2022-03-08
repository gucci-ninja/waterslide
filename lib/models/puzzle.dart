import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

// A 3x3 puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template puzzle}
/// Model for a puzzle.
/// {@endtemplate}
class Puzzle extends Equatable {
  /// {@macro puzzle}
  const Puzzle({required this.tiles});

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<Tile> tiles;

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  /// Gets the single whitespace tile object in the puzzle.
  Tile getWhitespaceTile() {
    return tiles.singleWhere((tile) => tile.isWhitespace);
  }

  /// Gets the tile relative to the whitespace tile in the puzzle
  /// defined by [relativeOffset].
  Tile? getTileRelativeToWhitespaceTile(Offset relativeOffset) {
    final whitespaceTile = getWhitespaceTile();
    return tiles.singleWhereOrNull(
      (tile) =>
          tile.currentPosition.x ==
              whitespaceTile.currentPosition.x + relativeOffset.dx &&
          tile.currentPosition.y ==
              whitespaceTile.currentPosition.y + relativeOffset.dy,
    );
  }

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles2() {
    final whitespaceTile = getWhitespaceTile();
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.currentPosition == tile.correctPosition) {
          numberOfCorrectTiles++;
        }
      }
    }
    print(numberOfCorrectTiles);
    return numberOfCorrectTiles;
  }

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles() {
    print(tiles);
    // If the first tile is not getting water, return 0
    if (!tiles[0].up && !tiles[0].left) {
      return 0;
    }
    final size = getDimension();
    final array = List.generate(
        size, (i) => List.filled(size, -1, growable: false),
        growable: false);
    array[0][0] = 1;
    _dfs(0, 1, tiles[0], array, size);
    _dfs(1, 0, tiles[0], array, size);
    // final whitespaceTile = getWhitespaceTile();
    var numberOfCorrectTiles = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (array[i][j] == 1) {
          numberOfCorrectTiles++;
        }
      }
    }
    print(numberOfCorrectTiles);
    return numberOfCorrectTiles;
  }

  void _dfs(int row, int col, Tile prevTile, List<List> array, int size) {
    // Check if out of bounds
    if (row < 0 || row >= size || col < 0 || col >= size) {
      return;
    }

    // check if already checked
    if (array[row][col] == 1) {
      return;
    }

    final tile = tiles[row * size + col];
    if (_isConnected(tile, prevTile)) {
      array[row][col] = 1;
      // call on all directions
      _dfs(row, col + 1, tile, array, size);
      _dfs(row, col - 1, tile, array, size);
      _dfs(row + 1, col, tile, array, size);
      _dfs(row - 1, col, tile, array, size);
    } else {
      return;
    }
    return;
  }

  bool _isConnected(Tile curr, Tile prev) {
    final whitespaceTile = getWhitespaceTile();
    if (curr == whitespaceTile || prev == whitespaceTile) {
      return false;
    }
    // If to the right of previous tile
    if (prev.currentPosition.x + 1 == curr.currentPosition.x) {
      return curr.left && prev.right;
    }
    // If to the left of previous tile
    if (prev.currentPosition.x - 1 == curr.currentPosition.x) {
      return curr.right && prev.left;
    }
    // If below previous tile
    if (prev.currentPosition.y + 1 == curr.currentPosition.y) {
      return curr.up && prev.down;
    }
    // If above previous tile
    if (prev.currentPosition.x - 1 == curr.currentPosition.y) {
      return curr.down && prev.up;
    }
    return false;
  }

  /// Determines if the puzzle is completed.
  bool isComplete() {
    return (tiles.length - 1) - getNumberOfCorrectTiles() == 0;
  }

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }
    return true;
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final size = getDimension();
    final height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhitespace);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) =>
            tile.currentPosition.x == shiftPointX &&
            tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(List<Tile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }
    return Puzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    return Puzzle(tiles: sortedTiles);
  }

  @override
  List<Object> get props => [tiles];
}
