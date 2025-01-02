use std::fs;

type Puzzle = Vec<Vec<char>>;

enum Direction {
    NEGATIVE,
    NONE,
    POSITIVE,
}

fn set_direction(mut array: [usize; 3], index: usize, direction: Direction) -> [usize; 3] {
    match direction {
        Direction::NEGATIVE => {
            array[0] = (index as i32 - 1) as usize;
            array[1] = (index as i32 - 2) as usize;
            array[2] = (index as i32 - 3) as usize;
        }
        Direction::NONE => {
            return [index, index, index];
        }
        Direction::POSITIVE => {
            array[0] = (index as i32 + 1) as usize;
            array[1] = (index as i32 + 2) as usize;
            array[2] = (index as i32 + 3) as usize;
        }
    }
    let result: [usize; 3] = [array[0] as usize, array[1] as usize, array[2] as usize];

    return result;
}

fn is_xmas(
    puzzle: &Puzzle,
    direction_x: Direction,
    direction_y: Direction,
    x: usize,
    y: usize,
) -> bool {
    let x_array = [0, 0, 0];
    let y_array = [0, 0, 0];
    let x_array: [usize; 3] = set_direction(x_array, x, direction_x);
    let y_array: [usize; 3] = set_direction(y_array, y, direction_y);

    let xmas = format!(
        "{}{}{}{}",
        puzzle[x][y].to_string(),
        puzzle[x_array[0]][y_array[0]].to_string(),
        puzzle[x_array[1]][y_array[1]].to_string(),
        puzzle[x_array[2]][y_array[2]].to_string(),
    );

    // println!("{}", xmas);
    return xmas == "XMAS";
}

fn get_xmas_count(puzzle: &Puzzle, x: usize, y: usize) -> usize {
    let mut result = 0;

    let left = x >= 3;
    let right = x + 4 <= puzzle[0].len();
    let top = y >= 3;
    let bottom = y + 4 <= puzzle.len();

    if top {
        let top_xmas = is_xmas(&puzzle, Direction::NONE, Direction::NEGATIVE, x, y);
        if top_xmas {
            result += 1;
        }
    }
    if top && left {
        let top_left_xmas = is_xmas(&puzzle, Direction::NEGATIVE, Direction::NEGATIVE, x, y);
        if top_left_xmas {
            result += 1;
        }
    }
    if left {
        let left_xmas = is_xmas(&puzzle, Direction::NEGATIVE, Direction::NONE, x, y);
        if left_xmas {
            result += 1;
        }
    }
    if left && bottom {
        let left_bottom_xmas = is_xmas(&puzzle, Direction::NEGATIVE, Direction::POSITIVE, x, y);
        if left_bottom_xmas {
            result += 1;
        }
    }

    if bottom {
        let bottom_xmas = is_xmas(&puzzle, Direction::NONE, Direction::POSITIVE, x, y);
        if bottom_xmas {
            result += 1;
        }
    }
    if bottom && right {
        let bottom_right_xmas = is_xmas(&puzzle, Direction::POSITIVE, Direction::POSITIVE, x, y);
        if bottom_right_xmas {
            result += 1;
        }
    }

    if right {
        let right_xmas = is_xmas(&puzzle, Direction::POSITIVE, Direction::NONE, x, y);
        if right_xmas {
            result += 1;
        }
    }
    if top && right {
        let right_top_xmas = is_xmas(&puzzle, Direction::POSITIVE, Direction::NEGATIVE, x, y);
        if right_top_xmas {
            result += 1;
        }
    }

    // println!("");
    return result;
}

fn main() {
    let file = fs::read_to_string("04/input.txt").unwrap();
    let lines = file.lines().enumerate();

    let mut puzzle: Puzzle = Vec::new();

    for (index_line, line) in lines {
        puzzle.push(Vec::new());
        for (_, column) in line.char_indices() {
            puzzle[index_line].push(column);
        }
    }

    let y_len = puzzle.len();
    let x_len = puzzle[0].len();

    let mut xmas_count = 0;
    for x in 0..x_len {
        for y in 0..y_len {
            if puzzle[x][y] == 'X' {
                let count = get_xmas_count(&puzzle, x, y);
                xmas_count += count;
            }
        }
    }

    println!("{}", xmas_count);
}
