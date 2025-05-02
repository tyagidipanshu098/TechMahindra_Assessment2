import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;
  List<int> winningCells = [];

  void _handleTap(int index) {
    if (board[index].isEmpty && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        if (_checkWinner(currentPlayer)) {
          gameOver = true;
        } else if (!board.contains('')) {
          gameOver = true;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (pattern.every((index) => board[index] == player)) {
        winningCells = pattern;
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board.fillRange(0, 9, '');
      currentPlayer = 'X';
      gameOver = false;
      winningCells.clear();
    });
  }

  Widget _buildGridItem(int index) {
    bool isWinningCell = winningCells.contains(index);
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 2),
          color: isWinningCell ? Colors.green : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              gameOver
                  ? (winningCells.isEmpty
                      ? "It's a Draw!"
                      : '$currentPlayer Wins!')
                  : 'Turn: $currentPlayer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => _buildGridItem(index),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reset Game', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
