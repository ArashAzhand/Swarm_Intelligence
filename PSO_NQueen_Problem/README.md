# N-Queen Problem Solver using Particle Swarm Optimization (PSO)

## Overview

This project implements **Particle Swarm Optimization (PSO)** to solve the N-Queen problem. The N-Queen problem is a classic combinatorial optimization challenge, where the goal is to place `N` queens on an `N x N` chessboard such that no two queens attack each other (i.e., no two queens share the same row, column, or diagonal). PSO, a swarm intelligence-based optimization algorithm, is used here to find solutions efficiently.

---

## Problem Definition

The N-Queen problem requires placing `N` queens on an `N x N` chessboard so that:
1. No two queens share the same row.
2. No two queens share the same column.
3. No two queens are in line diagonally.

Given its constraints and the exponential growth of possibilities with larger `N`, the problem becomes difficult to solve by brute force. **Particle Swarm Optimization (PSO)** offers a heuristic approach to explore the solution space effectively.

---

## How PSO is Applied

### Particles
Each particle represents a potential solution (i.e., a board configuration) with `N` queens placed on the chessboard. The position of a particle is defined as a permutation of integers, where each index represents a row, and the value at that index represents the column where the queen is placed. This guarantees that no two queens share the same row or column.

### Cost Function
The cost function evaluates the number of conflicts between queens that are on the same diagonal. The fewer diagonal conflicts, the better the solution. A cost of `0` means a valid solution is found (no queens are attacking each other).

### Particle Updates
Each particle has a velocity and position, and it updates its velocity based on three components:
1. **Inertia**: Keeps the particle moving in its current direction.
2. **Cognitive component**: Pulls the particle toward its own best-known position.
3. **Social component**: Pulls the particle toward the global best-known position.

The position of each particle is then updated to ensure valid configurations where queens remain unique in rows and columns.

---

## Features of the Code

1. **Dynamic board size**: The algorithm allows you to choose any value of `N` (e.g., 8 for the standard 8-Queens problem).
2. **Visualization**: The chessboard and queen positions are visualized during each iteration. Conflicting queens are highlighted with red lines to show diagonal conflicts.
3. **Performance tracking**: The cost function is tracked across iterations, and its history is plotted to visualize the convergence.
4. **Efficient updates**: The PSO algorithm ensures valid moves for queens after updating particle positions.

---

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/ArashAzhand/Swarm_Intelligence
   ```

2. Navigate to the `PSO_NQueen_Problem` folder and run the script:
   ```bash
   cd Swarm_Intelligence/PSO_NQueen_Problem
   python pso_nqueen.py
   ```

3. Enter the desired number of queens when prompted:
   ```bash
   insert number of Queens: 8
   ```

4. The algorithm will iterate and visualize the queens on the chessboard, showing the evolution of the best solution.

---

## Example Output

```plaintext
insert number of Queens: 8
Iteration 1/100, Best Cost: 4
Iteration 2/100, Best Cost: 2
...
Iteration 8/100, Best Cost: 0
```

Once the solution is found, it will print the final board and plot the cost function history over iterations.

---

## Visualization

The queens' positions are updated in real-time, and conflicts between queens on the same diagonal are highlighted in red.

![Chessboard Visualization](output_image.png)  
_(Visualization of an N-Queens board with PSO solution)_

---

## Conclusion

This implementation leverages PSO to solve the N-Queen problem effectively, especially for large `N`. It finds a conflict-free solution by minimizing diagonal attacks in a competitive number of iterations.

If you find this repository helpful, please consider giving it a ⭐ to show your support!
