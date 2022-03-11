# Slide Puzzle

![Photo Booth Header][logo]

## Getting Started 🚀

To run the project either use the launch configuration in VSCode/Android Studio or use the following command:

```sh
$ flutter run -d chrome
```

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Inspiration
I got the inspiration for the project from one of my first coding projects! Back in high school I built a tunnel game where the user had to rotate pipes to make them connect. This is similar but with sliding. I've come a long way since then!

## What it does
Water Slide's objective is to slide the tiles around until all of them are in some way connected to the water source. The water source is the cross pipe.

## How we built it
For the animation I used Rive. Each tile has a `fill` and `unfill` animation that gets toggled on and off using the Rive Controller. I used 2 layers for the water - a lighter shade that goes in one direction and a darker shade that goes in the other. 

For the puzzle logic I implemented a depth first search graph traversal algorithm (never thought I'd use it IRL). I also added extra attributes to the tiles to determine what kind of pipe it is.

Lastly, I deployed the project using Vercel

## Challenges we ran into
One of the main challenges was animating the water so it looks fluid. It took a lot of trial and error until I finally got something I was happy with.

Another challenge was the code. I went off the existing source code provided in the resources so I spent some time figuring out where everything was and what I would need to change.

## Accomplishments that we're proud of
Building a working game that's actually fun to play. I shared it with friends and family and they all seem to enjoy it.

## What we learned
I learned that water is NOT easy to animate. And in general animation is very difficult. Thanks to Rive it made my job a little easier. Overall it was a very fun and rewarding experience.

## What's next for Water Slide
I really want to add more levels in the future as well as a leaderboard (which was requested by a few)


[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/
[logo]: art/header.png