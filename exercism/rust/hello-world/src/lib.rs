pub fn hello(name: Option<&str>) -> String {
    match name {
      Some(name) => format!("Hello, {}!", name),
      None => "Hello, World!".to_string()
    }
}
