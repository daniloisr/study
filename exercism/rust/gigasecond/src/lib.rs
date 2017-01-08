extern crate chrono;

use chrono::*;

pub fn after(date: DateTime<UTC>) -> DateTime<UTC> {
  date + Duration::seconds(1_000_000_000)
}
