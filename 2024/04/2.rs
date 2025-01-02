use std::fs;

type Puzzle = Vec<Vec<char>>;

fn is_xmas(puzzle: &Puzzle, x: usize, y: usize) -> bool {
    let mut result = 0;
    if format!(
        "{}{}{}",
        puzzle[x - 1][y - 1].to_string(),
        puzzle[x][y].to_string(),
        puzzle[x + 1][y + 1].to_string(),
    ) == "MAS"
    {
        result += 1;
    }

    if format!(
        "{}{}{}",
        puzzle[x + 1][y - 1].to_string(),
        puzzle[x][y].to_string(),
        puzzle[x - 1][y + 1].to_string(),
    ) == "MAS"
    {
        result += 1;
    }

    if format!(
        "{}{}{}",
        puzzle[x + 1][y + 1].to_string(),
        puzzle[x][y].to_string(),
        puzzle[x - 1][y - 1].to_string(),
    ) == "MAS"
    {
        result += 1;
    }

    if format!(
        "{}{}{}",
        puzzle[x - 1][y + 1].to_string(),
        puzzle[x][y].to_string(),
        puzzle[x + 1][y - 1].to_string(),
    ) == "MAS"
    {
        result += 1;
    }

    return result == 2;
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

    let y_len = puzzle.len() - 1;
    let x_len = puzzle[0].len() - 1;

    let mut xmas_count = 0;
    for x in 1..x_len {
        for y in 1..y_len {
            if puzzle[x][y] == 'A' {
                if is_xmas(&puzzle, x, y) {
                    xmas_count += 1;
                }
            }
        }
    }

    println!("{}", xmas_count);
}
