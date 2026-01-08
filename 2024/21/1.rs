use std::fs;

fn main() {
    let file = fs::read_to_string("./example.txt").expect("");
    let lines = file.lines();

    for line in lines {
        let line_values: Vec<_> = line.split("   ").collect();
    }
}
