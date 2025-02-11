import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TicTac extends StatefulWidget {
  const TicTac({super.key});

  @override
  State<TicTac> createState() => _TicTacState();
}

class _TicTacState extends State<TicTac> {
  Color baseColor = const Color(0xFFF2F2F2);

  int O_wins = 0;

  int X_wins = 0;
  int filled = 0;
  String currentPlayer = 'O';
  List highlightIndex = [];

  List value = ['*', '*', '*', '*', '*', '*', '*', '*', '*'];

  checkPlaces(v1, v2, v3) {
    if (value[v1] != '*' && value[v1] == value[v2] && value[v1] == value[v3]) {
      highlightIndex.addAll([v1, v2, v3]);
      return true;
    }

    return false;
  }

  checkWin() {
    // Row check
    if (checkPlaces(0, 1, 2) || checkPlaces(3, 4, 5) || checkPlaces(6, 7, 8)) {
      return true;
    }

    // Column check
    else if (checkPlaces(0, 3, 6) ||
        checkPlaces(1, 4, 7) ||
        checkPlaces(2, 5, 8)) {
      return true;
    }

    // Diagonal Check
    else if (checkPlaces(2, 4, 6) || checkPlaces(0, 4, 8)) {
      return true;
    } else {
      return false;
    }
  }

  reset() {
    currentPlayer = 'O';
    filled = 0;
    value = ['*', '*', '*', '*', '*', '*', '*', '*', '*'];
    highlightIndex = [];
    setState(() {});
  }

  resetPlayerCounters() {
    O_wins = 0;
    X_wins = 0;
    setState(() {});
  }

  setvalue(index) {
    value[index] = currentPlayer;
    setState(() {});

    var result = checkWin();

    if (result) {
     
      Get.snackbar('Yay Player : $currentPlayer', 'You won this round',
         
          icon: const Icon(Icons.celebration_rounded),
          shouldIconPulse: true,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20));

      currentPlayer == 'O' ? O_wins += 1 : X_wins += 1;

      Future.delayed(const Duration(milliseconds: 3500), () {
        reset();
      });
    } else {
      filled += 1;
      currentPlayer = currentPlayer == 'O' ? 'X' : 'O';

      if (filled == 9) {
        Get.snackbar('Round Draw', 'Start new one',
            icon: const Icon(Icons.restart_alt_sharp),
            shouldIconPulse: true,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20));
        reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
     
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'TIC TAC TOE',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      'O Wins : $O_wins',
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'X Wins : $X_wins',
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (value[index] == '*') {
                            setvalue(index);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ClayContainer(
                              color: baseColor,
                              borderRadius: 10,
                              child: Stack(
                                children: [
                                  Center(
                                      child: Text(
                                    '${value[index]}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  )),
                                  highlightIndex.contains(index)
                                      ? const SpinKitCircle(
                                          color: Colors.redAccent,
                                        )
                                      : Container()
                                ],
                              )),
                        ),
                      );
                    }),
              ),

              const SizedBox(height: 20), // Add some spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: reset, child: const Text("Clean")),
                  ElevatedButton(
                      onPressed: resetPlayerCounters, child: const Text("Reset"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
