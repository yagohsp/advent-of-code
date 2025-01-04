use std::{fs, sync::LazyLock};

static FILE: LazyLock<Vec<Vec<char>>> = LazyLock::new(|| {
    let file = fs::read_to_string("12/input.txt").expect("");
    let mut vec: Vec<Vec<char>> = Vec::new();

    for line in file.lines() {
        vec.push(line.chars().collect());
    }

    vec
});

const MAX_LEN: usize = 139;

fn main() {
    // part1();
    part2();
}

fn print(map: &Vec<Vec<char>>) {
    for x in map {
        println!("{:?}", x);
    }
    println!("",);
}

fn get_perimeter1(map: &mut Vec<Vec<char>>, (y, x): (usize, usize)) -> usize {
    let char = map[y][x];
    let mut perimeter = 0;

    map[y][x] = '#';

    if x < MAX_LEN {
        if map[y][x + 1] == char {
            perimeter += get_perimeter1(map, (y, x + 1));
        } else if map[y][x + 1] != '#' {
            perimeter += 1;
        }
    } else {
        perimeter += 1;
    }

    if y < MAX_LEN {
        if map[y + 1][x] == char {
            perimeter += get_perimeter1(map, (y + 1, x));
        } else if map[y + 1][x] != '#' {
            perimeter += 1;
        }
    } else {
        perimeter += 1;
    }
    if y > 0 {
        if map[y - 1][x] == char {
            perimeter += get_perimeter1(map, (y - 1, x));
        } else if map[y - 1][x] != '#' {
            perimeter += 1;
        }
    } else {
        perimeter += 1;
    }

    if x > 0 {
        if map[y][x - 1] == char {
            perimeter += get_perimeter1(map, (y, x - 1));
        } else if map[y][x - 1] != '#' {
            perimeter += 1;
        }
    } else {
        perimeter += 1;
    }

    perimeter
}

fn contains(target: char, char: char) -> bool {
    vec!['#', char].contains(&target)
}

fn check_top(map: &Vec<Vec<char>>, (y, x): (usize, usize), char: char) -> bool {
    if y > 0 && contains(map[y - 1][x], char) {
        return false;
    }

    if x > 0 && contains(map[y][x - 1], char) {
        if y > 0 && contains(map[y - 1][x - 1], char) {
            return true;
        }
        return false;
    }

    true
}
fn check_bottom(map: &Vec<Vec<char>>, (y, x): (usize, usize), char: char) -> bool {
    if y < MAX_LEN && contains(map[y + 1][x], char) {
        return false;
    }

    if x > 0 && contains(map[y][x - 1], char) {
        if y < MAX_LEN && contains(map[y + 1][x - 1], char) {
            return true;
        }
        return false;
    }

    true
}
fn check_left(map: &Vec<Vec<char>>, (y, x): (usize, usize), char: char) -> bool {
    if x > 0 && contains(map[y][x - 1], char) {
        return false;
    }

    if y > 0 && contains(map[y - 1][x], char) {
        if x > 0 && contains(map[y - 1][x - 1], char) {
            return true;
        }
        return false;
    }

    true
}
fn check_right(map: &Vec<Vec<char>>, (y, x): (usize, usize), char: char) -> bool {
    if x < MAX_LEN && contains(map[y][x + 1], char) {
        return false;
    }

    if y > 0 && contains(map[y - 1][x], char) {
        if x < MAX_LEN && contains(map[y - 1][x + 1], char) {
            return true;
        }
        return false;
    }

    true
}

fn get_perimeter2(map: &mut Vec<Vec<char>>, (y, x): (usize, usize)) -> usize {
    let char = map[y][x];
    let mut perimeter = 0;
    let mut sum_perimeter = 0;
    map[y][x] = '#';

    //esquerda
    if x > 0 {
        if map[y][x - 1] == char {
            sum_perimeter += get_perimeter2(map, (y, x - 1));
        }
    }

    //direita
    if x < MAX_LEN {
        if map[y][x + 1] == char {
            sum_perimeter += get_perimeter2(map, (y, x + 1));
        }
    }

    //baixo
    if y < MAX_LEN {
        if map[y + 1][x] == char {
            sum_perimeter += get_perimeter2(map, (y + 1, x));
        }
    }

    //esquerda
    if y > 0 {
        if map[y - 1][x] == char {
            sum_perimeter += get_perimeter2(map, (y - 1, x));
        }
    }
    if check_top(map, (y, x), char) {
        perimeter += 1;
        // println!("top");
    }

    if check_bottom(map, (y, x), char) {
        perimeter += 1;
        // println!("bottom");
    }

    if check_left(map, (y, x), char) {
        perimeter += 1;
        // println!("left");
    }

    if check_right(map, (y, x), char) {
        perimeter += 1;
        // println!("right");
    }

    // map[y][x] = 'X';
    // println!("{}: {} - {:?}", char, perimeter, (x, y));
    // print(&map);
    // map[y][x] = '#';

    perimeter + sum_perimeter
}

fn get_area(map: &mut Vec<Vec<char>>) -> usize {
    let mut area = 0;

    for y in 0..MAX_LEN + 1 {
        for x in 0..MAX_LEN + 1 {
            if map[y][x] == '#' {
                area += 1;
                map[y][x] = '.';
            }
        }
    }

    area
}

fn part1() {
    let mut map = FILE.clone();

    let mut sum = 0;

    for y in 0..MAX_LEN + 1 {
        for x in 0..MAX_LEN + 1 {
            let char = map[y][x];

            if char != '.' {
                let perimeter = get_perimeter1(&mut map, (y, x));
                let area = get_area(&mut map);

                println!("{} - {} * {}", char, area, perimeter);

                sum += area * perimeter;
            }
        }
    }

    println!("Part 1 - {}", sum);
}

fn part2() {
    let mut map = FILE.clone();

    let mut sum = 0;

    for y in 0..MAX_LEN + 1 {
        for x in 0..MAX_LEN + 1 {
            let char = map[y][x];

            if char != '.' {
                let perimeter = get_perimeter2(&mut map, (y, x));
                let area = get_area(&mut map);

                println!("{}: a-{} * p-{}", char, area, perimeter);

                sum += area * perimeter;
            }
        }
    }

    println!("Part 2 - {}", sum);
}
