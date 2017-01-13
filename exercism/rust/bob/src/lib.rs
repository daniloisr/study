pub fn reply(s: &str) -> &str {
    match s {
        "" => "Fine. Be that way!",
        s if s.ends_with("?") => "Sure.",
        s if s == s.to_uppercase() => "Whoa, chill out!",
        _ => "Whatever."
    }
}
