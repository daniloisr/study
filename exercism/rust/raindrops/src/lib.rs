pub fn raindrops(i: u64) -> String {
    let mut sounds = "".to_string();

    if i % 3 == 0 { sounds.push_str("Pling") }
    if i % 5 == 0 { sounds.push_str("Plang") };
    if i % 7 == 0 { sounds.push_str("Plong") };

    if sounds == "" {
        i.to_string()
    } else {
        sounds
    }
}
