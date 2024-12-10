use std::{
    collections::{HashMap, HashSet},
    error::Error,
};

const INPUT: &str = include_str!("./input.txt");

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum Tile {
    Empty,
    Object,
    Up,
    Down,
    Left,
    Right,
}

fn get_input() -> HashMap<(isize, isize), Tile> {
    HashMap::from_iter(
        INPUT
            .trim()
            .lines()
            .enumerate()
            .flat_map(|(line_no, line)| {
                line.chars().enumerate().map(move |(tile_no, tile_char)| {
                    let tile = match tile_char {
                        '.' => Tile::Empty,
                        '#' => Tile::Object,
                        '^' => Tile::Up,
                        '>' => Tile::Right,
                        '<' => Tile::Left,
                        'v' => Tile::Down,
                        _ => unreachable!(),
                    };
                    ((line_no as isize, tile_no as isize), tile)
                })
            }),
    )
}

pub fn first_star() -> Result<(), Box<dyn Error + 'static>> {
    let mut guard_route = get_input();
    let mut visited: HashSet<(isize, isize)> = HashSet::new();
    let (mut guard_pos, mut guard_facing) = guard_route
        .iter()
        .find_map(|(pos, tile)| match tile {
            Tile::Up | Tile::Down | Tile::Left | Tile::Right => Some((*pos, *tile)),
            _ => None,
        })
        .unwrap();
    guard_route.insert(guard_pos, Tile::Empty);

    while guard_route.contains_key(&guard_pos) {
        visited.insert(guard_pos);
        let next_pos = match guard_facing {
            Tile::Up => (guard_pos.0 - 1, guard_pos.1),
            Tile::Down => (guard_pos.0 + 1, guard_pos.1),
            Tile::Left => (guard_pos.0, guard_pos.1 - 1),
            Tile::Right => (guard_pos.0, guard_pos.1 + 1),
            _ => unreachable!(),
        };
        guard_pos = if let Some(tile) = guard_route.get(&next_pos) {
            if *tile != Tile::Empty {
                guard_facing = match guard_facing {
                    Tile::Up => Tile::Right,
                    Tile::Down => Tile::Left,
                    Tile::Left => Tile::Up,
                    Tile::Right => Tile::Down,
                    _ => unreachable!(),
                };
                guard_pos
            } else {
                next_pos
            }
        } else {
            next_pos
        }
    }
    println!(
        "During her shift, the guard will visit {} tiles",
        visited.len()
    );
    Ok(())
}

fn test_loop(guard: ((isize, isize), Tile), guard_map: &HashMap<(isize, isize), Tile>) -> bool {
    let (mut guard_pos, mut guard_facing) = guard;
    let mut visited = HashSet::new();
    while guard_map.contains_key(&guard_pos) {
        if !visited.insert((guard_pos, guard_facing)) {
            return true;
        }
        let (next_pos, next_face) = match guard_facing {
            Tile::Up => ((guard_pos.0 - 1, guard_pos.1), Tile::Right),
            Tile::Down => ((guard_pos.0 + 1, guard_pos.1), Tile::Left),
            Tile::Left => ((guard_pos.0, guard_pos.1 - 1), Tile::Up),
            Tile::Right => ((guard_pos.0, guard_pos.1 + 1), Tile::Down),
            _ => unreachable!(),
        };

        (guard_pos, guard_facing) = if let Some(tile) = guard_map.get(&next_pos) {
            if *tile == Tile::Empty {
                (next_pos, guard_facing)
            } else {
                (guard_pos, next_face)
            }
        } else {
            (next_pos, guard_facing)
        }
    }
    false
}

pub fn main() -> Result<(), Box<dyn Error + 'static>> {
    let mut guard_route = get_input();
    let mut obstacles = HashSet::new();
    let mut visited = HashSet::new();
    let (mut guard_pos, mut guard_facing) = guard_route
        .iter()
        .find_map(|(pos, tile)| match tile {
            Tile::Up | Tile::Down | Tile::Left | Tile::Right => Some((*pos, *tile)),
            _ => None,
        })
        .unwrap();
    guard_route.insert(guard_pos, Tile::Empty);
    let invalid_obstacle = guard_pos;

    while guard_route.contains_key(&guard_pos) {
        visited.insert(guard_pos);
        let (next_pos, next_face) = match guard_facing {
            Tile::Up => ((guard_pos.0 - 1, guard_pos.1), Tile::Right),
            Tile::Down => ((guard_pos.0 + 1, guard_pos.1), Tile::Left),
            Tile::Left => ((guard_pos.0, guard_pos.1 - 1), Tile::Up),
            Tile::Right => ((guard_pos.0, guard_pos.1 + 1), Tile::Down),
            _ => unreachable!(),
        };

        (guard_pos, guard_facing) = if let Some(tile) = guard_route.get(&next_pos) {
            if *tile == Tile::Empty {
                if guard_route.contains_key(&next_pos)
                    && next_pos != invalid_obstacle
                    && !visited.contains(&next_pos)
                {
                    guard_route.insert(next_pos, Tile::Object);
                    if test_loop((guard_pos, next_face), &guard_route) {
                        obstacles.insert(next_pos);
                    }
                    guard_route.insert(next_pos, Tile::Empty);
                }
                (next_pos, guard_facing)
            } else {
                (guard_pos, next_face)
            }
        } else {
            (next_pos, guard_facing)
        }
    }

    println!(
        "There are {} possible positions to create a loop",
        obstacles.len()
    );
    Ok(())
}
