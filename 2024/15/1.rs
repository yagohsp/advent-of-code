use std::fs;

fn move_char(grid: &mut Vec<Vec<char>>, position: &mut (usize, usize), direction: char) -> bool {
    let (y, x) = *position;

    let (delta_y, delta_x) = match direction {
        'v' => (1, 0),
        '^' => (-1, 0),
        '>' => (0, 1),
        '<' => (0, -1),
        _ => return false,
    };

    let next_y = (y as isize + delta_y) as usize;
    let next_x = (x as isize + delta_x) as usize;

    let next = grid[next_y][next_x];

    let moved = match next {
        '#' => false,
        'O' => {
            let mut next_pos = (next_y, next_x);
            move_char(grid, &mut next_pos, direction)
        }
        _ => true,
    };

    if !moved {
        return false;
    }

    grid[next_y][next_x] = grid[y][x];
    grid[y][x] = '.';

    if grid[next_y][next_x] == '@' {
        *position = (next_y, next_x);
    }

    true
}

fn main() {
    let file = fs::read_to_string("./puzzle.txt").unwrap();
    let mut map = file.lines();

    let movements = map.next_back().unwrap();
    map.next_back();

    let mut position: (usize, usize) = (0, 0);

    let mut grid: Vec<Vec<char>> = map
        .enumerate()
        .map(|(y, line)| {
            line.chars()
                .enumerate()
                .map(|(x, c)| {
                    if c == '@' {
                        position = (y, x);
                    }
                    c
                })
                .collect()
        })
        .collect();

    for direction in movements.chars() {
        move_char(&mut grid, &mut position, direction);
    }

    let mut sum = 0;

    for (y_i, y) in grid.iter().enumerate() {
        for (x_i, x) in y.iter().enumerate() {
            if *x == 'O' {
                sum += 100 * y_i + x_i;
            }
        }
    }

    println!("{}", sum);
}
