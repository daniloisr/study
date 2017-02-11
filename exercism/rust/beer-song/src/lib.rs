// Ultra ugly, but works :D
pub fn verse(i: i32) -> String {
    match i {
        0 => "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n".to_string(),
        1 => "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n".to_string(),
        2 => format!("{} bottles of beer on the wall, {} bottles of beer.\nTake one down and pass it around, {} bottle of beer on the wall.\n", i, i, i - 1),
        _ => format!("{} bottles of beer on the wall, {} bottles of beer.\nTake one down and pass it around, {} bottles of beer on the wall.\n", i, i, i - 1)
    }
}

pub fn sing(from: i32, to: i32) -> String {
    let mut result = String::new();
    for x in 0..(from - to + 1) {
        result.push_str(&*verse(from - x));
        if from - x != to {
            result.push_str("\n");
        }
    }
    result
}
