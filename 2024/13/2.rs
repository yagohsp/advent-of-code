use std::error::Error;
use std::fmt;
use std::fs;

// Estrutura para representar os coeficientes de um sistema de 2 equações lineares
struct Coefficients {
    a1: f64,
    b1: f64,
    c1: f64,
    a2: f64,
    b2: f64,
    c2: f64,
}

// Estrutura para representar a solução do sistema
struct Solution {
    x: f64,
    y: f64,
}

// Função que usa a Regra de Cramer para resolver o sistema de equações lineares
fn solve_cramers_rule(coeffs: Coefficients) -> Option<Solution> {
    // Calculando o determinante da matriz dos coeficientes
    let d = coeffs.a1 * coeffs.b2 - coeffs.a2 * coeffs.b1;

    // Calculando os determinantes das matrizes para x e y
    let dx = coeffs.c1 * coeffs.b2 - coeffs.c2 * coeffs.b1;
    let dy = coeffs.a1 * coeffs.c2 - coeffs.a2 * coeffs.c1;

    // Calculando os valores de x e y
    let x = dx / d;
    let y = dy / d;

    if x.fract() == 0.0 && y.fract() == 0.0 {
        return Some(Solution { x, y });
    }

    None
}

struct XY {
    x: f64,
    y: f64,
}

struct Machine {
    a: XY,
    b: XY,
    prize: XY,
}

fn main() {
    let file = fs::read_to_string("13/input.txt").expect("");
    let mut lines: Vec<&str> = Vec::new();

    for line in file.lines() {
        if line != "" {
            lines.push(line);
        }
    }

    let machines_count = lines.len() / 3;
    let mut machines: Vec<Machine> = Vec::new();

    for m_index in 0..machines_count {
        let l_index = m_index * 3;

        let a: Vec<&str> = lines[l_index].split("A: X+").collect();
        let a: Vec<&str> = a[1].split(", Y+").collect();
        let (a_x, a_y) = (a[0].parse().unwrap(), a[1].parse().unwrap());

        let b: Vec<&str> = lines[l_index + 1].split("B: X+").collect();
        let b: Vec<&str> = b[1].split(", Y+").collect();
        let (b_x, b_y) = (b[0].parse().unwrap(), b[1].parse().unwrap());

        let prize: Vec<&str> = lines[l_index + 2].split("X=").collect();
        let prize: Vec<&str> = prize[1].split(", Y=").collect();
        let (mut prize_a, mut prize_b) = (prize[0].parse().unwrap(), prize[1].parse().unwrap());
        prize_a += 10000000000000.0;
        prize_b += 10000000000000.0;

        let machine = Machine {
            a: XY { x: a_x, y: a_y },
            b: XY { x: b_x, y: b_y },
            prize: XY {
                x: prize_a,
                y: prize_b,
            },
        };
        machines.push(machine);
    }

    let mut tokens: Vec<f64> = Vec::new();

    for machine in machines {
        let button_a = (machine.a.x, machine.a.y);
        let button_b = (machine.b.x, machine.b.y);
        let (prize_x, prize_y) = (machine.prize.x, machine.prize.y);

        let coeffs = Coefficients {
            a1: button_a.0,
            a2: button_a.1,
            b1: button_b.0,
            b2: button_b.1,
            c1: prize_x,
            c2: prize_y,
        };

        match solve_cramers_rule(coeffs) {
            Some(solution) => tokens.push(solution.x * 3.0 + solution.y),
            _ => {}
        }
    }

    let total: f64 = tokens.iter().sum();
    println!("{:?}", total as usize);
}
