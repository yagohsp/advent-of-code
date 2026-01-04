use std::fs;

const SIZE_X: usize = 101;
const SIZE_Y: usize = 103;

fn main() {
    let file = fs::read_to_string("./puzzle.txt").expect("");
    let lines = file.lines();

    'for_i: for i in 0..10000 {
        let mut grid: [[usize; SIZE_X]; SIZE_Y] = [[0; SIZE_X]; SIZE_Y];
        for line in lines.clone() {
            let values: Vec<&str> = line.split(" ").collect();

            let position = values[0].split_at(2).1;
            let position: Vec<&str> = position.split(",").collect();
            let position_x = position[0].parse::<isize>().unwrap();
            let position_y = position[1].parse::<isize>().unwrap();

            let direction = values[1].split_at(2).1;
            let direction: Vec<&str> = direction.split(",").collect();
            let direction_x = direction[0].parse::<isize>().unwrap();
            let direction_y = direction[1].parse::<isize>().unwrap();

            let mut final_x = (position_x + direction_x * i as isize) % SIZE_X as isize;
            let mut final_y = (position_y + direction_y * i as isize) % SIZE_Y as isize;

            if final_x < 0 {
                final_x = SIZE_X as isize + final_x;
            }

            if final_y < 0 {
                final_y = SIZE_Y as isize + final_y;
            }

            let final_x = final_x as usize;
            let final_y = final_y as usize;

            grid[final_y][final_x] += 1;
        }

        for rows in grid {
            for column in rows {
                if column > 1 {
                    continue 'for_i;
                }
            }
        }

        println!("{}", i);

        break;
    }
}
