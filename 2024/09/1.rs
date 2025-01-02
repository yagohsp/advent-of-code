use std::{fs, sync::LazyLock};

static FILE: LazyLock<String> = LazyLock::new(|| {
    let file = fs::read_to_string("09/input.txt").expect("");

    file.lines().collect()
});

fn main() {
    part1();
    part2();
}

fn part1() {
    let mut blocks: Vec<String> = Vec::new();

    let mut id: u32 = 0;

    for (index, char) in FILE.chars().enumerate() {
        let quantity = char.to_digit(10).unwrap();
        let mut new_char = String::from(".");

        if index % 2 == 0 {
            new_char = id.to_string();
            id += 1;
        }
        for _ in 0..quantity {
            blocks.push(new_char.to_string());
        }
    }

    let mut index = 0;
    loop {
        if index >= blocks.len() {
            break;
        }

        if blocks[index] == "." {
            loop {
                let new_char = blocks.pop().unwrap();
                if new_char != "." {
                    blocks[index] = new_char;
                    break;
                }
            }
        }
        index += 1;
    }

    let mut count = 0;
    for (index, char) in blocks.iter().enumerate() {
        let num: usize = char.parse().unwrap();
        count += num * index;
    }

    println!("Part 1 - {}", count);
}

fn part2() {
    // Parse the input to separate file and free space blocks
    let mut files: Vec<(usize, usize)> = Vec::new();
    let mut id = 0;
    let mut is_file = true;

    for char in FILE.chars() {
        let size = char.to_digit(10).unwrap() as usize;
        if size > 0 {
            if is_file {
                files.push((id, size));
                id += 1;
            } else {
                files.push((usize::MAX, size)); // usize::MAX represents free space
            }
        }
        is_file = !is_file;
    }
    // Move files to the leftmost spans of free space blocks that can fit the file
    for file_id in (0..id).rev() {
        let mut file_index = None;
        let mut file_size = 0;

        // Locate the file in the vector
        for (index, (fid, size)) in files.iter().enumerate() {
            if *fid == file_id {
                file_index = Some(index);
                file_size = *size;
                break;
            }
        }

        if let Some(file_index) = file_index {
            // Attempt to move the file to the leftmost span of free space blocks
            let mut free_space_index = None;
            let mut free_space_size = 0;

            for (index, (fid, size)) in files.iter().enumerate() {
                if index >= file_index {
                    break;
                }
                if *fid == usize::MAX && *size >= file_size {
                    free_space_index = Some(index);
                    free_space_size = *size;
                    break;
                }
            }

            if let Some(free_space_index) = free_space_index {
                // Move the file to the free space
                files[free_space_index] = (file_id, file_size);
                files[file_index] = (usize::MAX, file_size);

                // If there's remaining free space, insert a new entry for it
                if free_space_size > file_size {
                    files.insert(
                        free_space_index + 1,
                        (usize::MAX, free_space_size - file_size),
                    );
                }
            }
        }
    }

    let mut vec: Vec<usize> = Vec::new();
    for (fid, size) in files.clone() {
        if fid != usize::MAX {
            for _ in 0..size {
                vec.push(fid);
            }
        } else {
            for _ in 0..size {
                vec.push(usize::MAX);
            }
        }
    }

    let mut checksum = 0;

    for (index, v) in vec.iter().enumerate() {
        if *v != usize::MAX {
            checksum += v * index;
        }
    }

    println!("Part 2 - {}", checksum);
}
