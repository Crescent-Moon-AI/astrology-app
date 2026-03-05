//! Astrology calculation API functions for flutter_rust_bridge.
//!
//! Thin wrappers delegating to `astro_ffi` — FRB codegen scans these
//! signatures to generate corresponding Dart bindings.

/// Calculate a natal chart. Returns JSON string.
pub fn calculate_natal_chart(
    birth_date: String,
    birth_time: String,
    latitude: f64,
    longitude: f64,
    timezone: f64,
    house_system: String,
    name: String,
    location: String,
) -> Result<String, String> {
    astro_ffi::calculate_natal_chart(
        birth_date,
        birth_time,
        latitude,
        longitude,
        timezone,
        house_system,
        name,
        location,
    )
}

/// Calculate all chart types (natal, transit, progressions, returns).
/// Input and output as JSON strings.
pub fn calculate_multi(input_json: String) -> Result<String, String> {
    astro_ffi::calculate_multi(input_json)
}

/// Calculate synastry between two people. Input/output as JSON strings.
pub fn calculate_synastry_chart(input_json: String) -> Result<String, String> {
    astro_ffi::calculate_synastry_chart(input_json)
}

/// Calculate progressions. Returns JSON string.
pub fn calculate_progressions(
    birth_date: String,
    birth_time: String,
    latitude: f64,
    longitude: f64,
    timezone: f64,
    house_system: String,
    progression_date: String,
    method: String,
) -> Result<String, String> {
    astro_ffi::calculate_progressions(
        birth_date,
        birth_time,
        latitude,
        longitude,
        timezone,
        house_system,
        progression_date,
        method,
    )
}

/// Find solar return chart for a given year. Returns JSON string.
pub fn find_solar_return(
    birth_date: String,
    birth_time: String,
    latitude: f64,
    longitude: f64,
    timezone: f64,
    house_system: String,
    year: i32,
) -> Result<String, String> {
    astro_ffi::find_solar_return(
        birth_date, birth_time, latitude, longitude, timezone, house_system, year,
    )
}

/// Find lunar return chart closest to target_date. Returns JSON string.
pub fn find_lunar_return(
    birth_date: String,
    birth_time: String,
    latitude: f64,
    longitude: f64,
    timezone: f64,
    house_system: String,
    target_date: String,
) -> Result<String, String> {
    astro_ffi::find_lunar_return(
        birth_date,
        birth_time,
        latitude,
        longitude,
        timezone,
        house_system,
        target_date,
    )
}
