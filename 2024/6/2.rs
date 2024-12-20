use std::fs;
fn print_all(matrix: &Vec<Vec<char>>) {
    for row in matrix.iter() {
        for c in row.iter() {
            print!("{}", c);
        }
        println!("");
    }
    println!("");
}

fn get_position(matrix: &Vec<Vec<char>>) -> (usize, usize) {
    for (x, row) in matrix.iter().enumerate() {
        for (y, c) in row.iter().enumerate() {
            if *c == '^' {
                return (x, y);
            }
        }
    }
    return (0, 0);
}

impl Dir {
    fn next(&self) -> Self {
        match self {
            Dir::Right => Dir::Down,
            Dir::Down => Dir::Left,
            Dir::Left => Dir::Top,
            Dir::Top => Dir::Right,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
enum Dir {
    Right,
    Down,
    Left,
    Top,
}

fn move_position(
    matrix: &mut Vec<Vec<char>>,
    position: &mut (usize, usize),
    direction: &mut Dir,
) -> (usize, usize, Dir) {
    loop {
        let mut next_position: (isize, isize) = (position.0 as isize, position.1 as isize);

        match direction {
            Dir::Left => next_position = (next_position.0, next_position.1 - 1),
            Dir::Right => next_position = (next_position.0, next_position.1 + 1),
            Dir::Top => next_position = (next_position.0 - 1, next_position.1),
            Dir::Down => next_position = (next_position.0 + 1, next_position.1),
        };

        if next_position.0 < 0
            || next_position.1 < 0
            || next_position.0 > (matrix.len() - 1) as isize
            || next_position.1 > (matrix.len() - 1) as isize
        {
            return (1000, 1000, Dir::Top);
        }

        let next_position: (usize, usize) = (next_position.0 as usize, next_position.1 as usize);

        let next_char = matrix[next_position.0][next_position.1];

        if next_char == '#' {
            *direction = direction.next();
            return move_position(matrix, position, direction);
        }

        *position = next_position;

        return (position.0, position.1, direction.clone());
    }
}

fn main() {
    let file =
        fs::read_to_string("6/input.txt").expect("");
    let lines: Vec<&str> = file.lines().collect();

    let mut map: Vec<Vec<char>> = lines.iter().map(|line| line.chars().collect()).collect();
    let map = &mut map;
    let mut paths: Vec<(usize, usize, Dir)> = Vec::new();
    let direction = &mut Dir::Top;

    let starting_position = get_position(map);
    let position = &mut starting_position.clone();

    loop {
        let res = move_position(map, position, direction);

        if res.0 == 1000 {
            break;
        }

        paths.push((position.0, position.1, direction.clone()));
    }

    let mut count = 0;

    loop {
        let mut passed: Vec<(usize, usize, Dir)> = Vec::new();
        let block_position = (paths[0].0, paths[0].1);

        let dir = &mut Dir::Top;
        let loop_position = &mut starting_position.clone();

        map[block_position.0][block_position.1] = '#';

        loop {
            let new_position = move_position(map, loop_position, dir);

            if passed.contains(&(new_position.0, new_position.1, dir.clone())) {
                // println!("{}", passed.len());
                // map[block_position.0][block_position.1] = '0';
                // print_all(map);
                count += 1;
                break;
            }

            if new_position.0 == 1000 {
                break;
            }

            passed.push(new_position);
        }

        println!("{}", paths.len());
        map[block_position.0][block_position.1] = '.';

        paths.remove(0);

        if paths.len() == 1 {
            break;
        }
    }

    println!("");
    println!("{}", count);
}
