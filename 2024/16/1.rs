use std::cmp::Ordering;
use std::{collections::BinaryHeap, fs};

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
enum Direction {
    UP = 0,
    RIGHT = 1,
    DOWN = 2,
    LEFT = 3,
}

const DIRS: [Direction; 4] = [
    Direction::UP,
    Direction::RIGHT,
    Direction::DOWN,
    Direction::LEFT,
];

fn delta(dir: Direction) -> (isize, isize) {
    match dir {
        Direction::UP => (-1, 0),
        Direction::RIGHT => (0, 1),
        Direction::DOWN => (1, 0),
        Direction::LEFT => (0, -1),
    }
}

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
struct State {
    position: (usize, usize),
    direction: Direction,
}

#[derive(Eq, PartialEq)]
struct HeapItem {
    cost: usize,
    state: State,
}

impl Ord for HeapItem {
    fn cmp(&self, other: &Self) -> Ordering {
        // Reverse ordering → min-heap
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for HeapItem {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {
    let file = fs::read_to_string("./puzzle.txt").unwrap();
    let lines = file.lines();

    let grid: Vec<Vec<char>> = lines.map(|line| line.chars().collect()).collect();

    let mut start: (usize, usize) = (usize::MAX, usize::MAX);
    let mut end: (usize, usize) = (usize::MAX, usize::MAX);

    'for_y: for y in 0..grid.len() {
        for x in 0..grid[0].len() {
            match grid[y][x] {
                'S' => start = (y, x),
                'E' => end = (y, x),
                _ => {}
            }

            if start != (usize::MAX, usize::MAX) && end != (usize::MAX, usize::MAX) {
                break 'for_y;
            }
        }
    }

    let mut heap: BinaryHeap<HeapItem> = BinaryHeap::new();

    heap.push(HeapItem {
        cost: 0,
        state: State {
            position: start,
            direction: Direction::RIGHT,
        },
    });

    let h = grid.len();
    let w = grid[0].len();
    let mut dist = vec![vec![[usize::MAX; 4]; w]; h];
    dist[start.0][start.1][Direction::RIGHT as usize] = 0;

    let mut best_end_cost = usize::MAX;

    while let Some(item) = heap.pop() {
        let (y, x) = item.state.position;
        let dir = item.state.direction;

        if item.cost >= best_end_cost {
            break;
        }

        if item.state.position == end {
            best_end_cost = item.cost;
        }

        if item.cost > dist[y][x][dir as usize] {
            continue;
        }

        for new_dir in DIRS {
            let (delta_y, delta_x) = delta(new_dir);

            let (next_y, next_x) = (
                (y as isize + delta_y) as usize,
                (x as isize + delta_x) as usize,
            );

            if grid[next_y][next_x] != '#' {
                let turn_cost = if new_dir != dir { 1000 } else { 0 };
                let new_cost = item.cost + 1 + turn_cost;

                if new_cost < dist[next_y][next_x][new_dir as usize] {
                    dist[next_y][next_x][new_dir as usize] = new_cost;
                    heap.push(HeapItem {
                        cost: new_cost,
                        state: State {
                            position: (next_y, next_x),
                            direction: new_dir,
                        },
                    });
                }
            }
        }
    }

    let answer = (0..4).map(|d| dist[end.0][end.1][d]).min().unwrap();

    println!("{}", answer);
}
