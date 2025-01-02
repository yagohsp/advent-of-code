use std::fs;

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
    count: &mut usize,
) {
    loop {
        let mut next_position = *position;

        match direction {
            Dir::Left => next_position = (next_position.0, next_position.1 - 1),
            Dir::Right => next_position = (next_position.0, next_position.1 + 1),
            Dir::Top => next_position = (next_position.0 - 1, next_position.1),
            Dir::Down => next_position = (next_position.0 + 1, next_position.1),
        };

        let next_char = matrix[next_position.0][next_position.1];

        if next_char == '#' {
            *direction = direction.next();
        } else {
            *position = next_position;
            if next_char != '0' {
                *count += 1;
                matrix[next_position.0][next_position.1] = '0';
            }
            return;
        }
    }
}

fn main() {
    let file = fs::read_to_string("06/input.txt").expect("");
    let lines: Vec<&str> = file.lines().collect();

    let position = &mut lines
        .clone()
        .iter()
        .enumerate()
        .find_map(|(index, value)| {
            let mut chars = value.chars();

            match chars.position(|c| c == '^') {
                None => None,
                Some(c_index) => Some((index, c_index)),
            }
        })
        .unwrap();

    println!("{:?}", position);

    let direction = &mut Dir::Top;

    let count = &mut 1;

    let mut matrix: Vec<Vec<char>> = lines.iter().map(|line| line.chars().collect()).collect();
    let matrix: &mut Vec<Vec<char>> = &mut matrix;

    while position.0 < lines[0].len() - 1 {
        move_position(matrix, position, direction, count);
    }

    println!("{:#?}", count);
}
