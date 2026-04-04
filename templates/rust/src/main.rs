fn main() {
  println!("2 + 2 = {}", add(2, 2));
}

pub fn add(left: u64, right: u64) -> u64 {
  left + right
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn two_plus_two_equals_four() {
    let result = add(2, 2);
    assert_eq!(result, 4);
  }
}
