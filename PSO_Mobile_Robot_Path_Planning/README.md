## Particle Swarm Optimization (PSO) for Mobile Robot Path Planning

### Problem Definition:
The objective of this project is to solve the **robot path planning** problem, where a robot needs to navigate from a given start position to a target goal position within a grid-based environment, while avoiding obstacles. The robot should find the optimal path that minimizes the overall distance and avoids obstacles. Path planning is critical for autonomous mobile robots, particularly in scenarios such as navigation in unfamiliar or cluttered environments.

### Approach:
In this project, I implemented a path planning solution using **Particle Swarm Optimization (PSO)**, a swarm intelligence algorithm inspired by the social behavior of birds. PSO is well-suited for optimization problems and is used here to explore the best possible path through the grid.

### Grid Map:
The environment is modeled as a 2D grid, where each cell represents either free space (`0`) or an obstacle (`1`). The robot must move from the bottom-left corner (start) to the top-right corner (goal), navigating around the obstacles.

### Algorithm:
- **PSO Structure**: A swarm of particles is initialized, where each particle represents a potential solution—a set of intermediate stop points that define a path from the start to the goal. Each particle has its own velocity and position, updated based on personal and global best positions.
  
- **Fitness Evaluation**: The fitness function evaluates each particle's path based on its total distance and penalties for colliding with obstacles or leaving the grid boundaries. The goal is to minimize the fitness value, with the shortest valid path being the best.

- **Swarm Dynamics**: Particles iteratively update their positions using both personal and global learning coefficients to converge on the optimal solution. The velocities adjust according to the particle’s own best-known position (personal best) and the global best position across all particles, ensuring a balance between exploration and exploitation.

### Key Features:
- **Obstacle Avoidance**: The algorithm penalizes paths that pass through obstacles, encouraging particles to search for alternative, feasible paths.
- **Convergence Monitoring**: A convergence curve shows the optimization process, visualizing how the best fitness value changes over iterations.
- **Visualization**: The code includes visualization of the grid environment, obstacle locations, and the best-found path from start to goal.

### Code Structure:
- `generate_random_stop_points`: Initializes random stop points for each particle within the grid.
- `evaluate_fitness`: Computes the fitness of each particle’s path based on distance and obstacle collisions.
- `generate_path_segment`: Uses Bresenham's Line Algorithm to determine the exact grid cells traversed between two points.
- **Main Loop**: Iterates through multiple generations of particles, updating their velocities and positions to converge on an optimal solution.

### Results:
The PSO algorithm successfully finds a valid path from the start to the goal while navigating around obstacles. The best path is visualized, and the convergence curve demonstrates how the algorithm improves the solution over time.

![image](https://github.com/user-attachments/assets/dd321d4a-3d5d-49c0-b496-d9c10d49a708)
