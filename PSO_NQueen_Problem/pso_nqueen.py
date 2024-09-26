import numpy as np
import matplotlib.pyplot as plt
import time

class Particle:
    def __init__(self, n):
        self.position = np.random.permutation(n) # this garantes that there is unique queen in every row and column
        self.velocity = np.zeros(n)
        self.best_position = self.position.copy()
        self.best_cost = self.calculate_cost()

    def calculate_cost(self):
        cost = 0
        n = len(self.position)
        for i in range(n):
            for j in range(i + 1, n): # due to unique queen in every row and column we only check for diagonal hits
                if abs(self.position[i] - self.position[j]) == j - i:
                    cost += 1
        return cost
    

    def update_velocity(self, global_best_position, w=0.5, c1=1.5, c2=1.5):
        r1 = np.random.rand(len(self.position))
        r2 = np.random.rand(len(self.position))
        cognitive = c1 * r1 * (self.best_position - self.position)
        social = c2 * r2 * (global_best_position - self.position)
        self.velocity = (w * self.velocity) + cognitive + social


    def update_position(self):
        new_position = np.round(self.position + self.velocity).astype(int)
        new_position = np.clip(new_position, 0, len(self.position) - 1) # to ensure it doesn't step over the board limit after the update 
        
        # this is because queens must still be unique in row and columns
        unique_positions = set(new_position)
        while len(unique_positions) < len(self.position):
            for i in range(len(new_position)):
                if list(new_position).count(new_position[i]) > 1:
                    new_position[i] = np.random.randint(0, len(self.position))
            unique_positions = set(new_position)
        
        self.position = new_position
        
        if self.calculate_cost() < self.best_cost:
            self.best_cost = self.calculate_cost()
            self.best_position = self.position.copy()


def PSO_nQueen(board_size, num_particles=30, max_iter=100):
    particles = [Particle(board_size) for _ in range(num_particles)]

    global_best_position = particles[0].position
    global_best_cost = particles[0].calculate_cost()

    for particle in particles:
        curr_cost = particle.calculate_cost()
        if curr_cost < global_best_cost:
            global_best_cost = curr_cost
            global_best_position = particle.position.copy()

    cost_history = []

    fig, ax = plt.subplots()

    for i in range(max_iter):
        for particle in particles:
            particle.update_velocity(global_best_position)
            particle.update_position()
            curr_cost = particle.calculate_cost()

            if curr_cost < global_best_cost:
                global_best_cost = curr_cost
                global_best_position = particle.position.copy()

        cost_history.append(global_best_cost)
        print(f"Iteration {i + 1}/{max_iter}, Best Cost: {global_best_cost}")

        plot_board(global_best_position, global_best_cost, i + 1, fig, ax)
        plt.pause(2)

        if global_best_cost == 0:
            break

    plt.show()
    return global_best_position, cost_history


def plot_board(position, best_cost, iteration, fig, ax):
    n = len(position)
    ax.clear()

    for i in range(n):
        for j in range(n):
            if (i + j) % 2 == 0:
                ax.add_patch(plt.Rectangle((i, j), 1, 1, color='white'))
            else:
                ax.add_patch(plt.Rectangle((i, j), 1, 1, color='gray'))
                
    for i in range(n):
        ax.add_patch(plt.Circle((i + 0.5, position[i] + 0.5), 0.3, color='yellow'))

    for i in range(n):
        for j in range(i + 1, n):
            if abs(position[i] - position[j]) == j - i:
                ax.plot([i + 0.5, j + 0.5], [position[i] + 0.5, position[j] + 0.5], 'r-', lw=2)

    ax.set_xlim(0, n)
    ax.set_ylim(0, n)
    ax.set_xticks(range(n))
    ax.set_yticks(range(n))
    ax.invert_yaxis()
    ax.set_yticklabels(range(n))
    ax.set_title(f"Iteration {iteration}, Hits={best_cost}")
    fig.canvas.draw()


def plot_cost_history(cost_history):
    plt.figure()
    plt.plot(cost_history, label='Cost Function')
    plt.xlabel('Iteration')
    plt.ylabel('Cost')
    plt.title('Cost Function over Iterations')
    plt.legend()
    plt.show()

def print_board(position):
    n = len(position)
    board = np.zeros((n, n), dtype=int)
    for i in range(n):
        board[i, position[i]] = 1
    for row in board:
        print(" ".join(str(int(val)) for val in row))
    print()


if __name__ == "__main__":
    n = int(input("insert number of Queens: "))  
    best_position, cost_history = PSO_nQueen(n)
    print_board(best_position)
    plot_cost_history(cost_history)
