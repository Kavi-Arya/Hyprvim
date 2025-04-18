use notify::{DebouncedEvent, RecommendedWatcher, RecursiveMode, Watcher};
use std::env;
use std::fs;
use std::path::PathBuf;
use std::sync::mpsc::channel;
use std::time::Duration;

fn update_mode(mode_path: &PathBuf) {
    // Read and trim the current mode from file
    let mode = fs::read_to_string(mode_path)
        .unwrap_or_else(|err| {
            eprintln!("Error reading mode file: {}", err);
            String::new()
        })
        .trim()
        .to_string();

    // Construct the destination CSS file path
    let home = env::var("HOME").unwrap();
    let dest = format!("{}/.config/waybar/colors.css", home);

    // Match the mode and copy the corresponding CSS file
    match mode.as_str() {
        "Normal Mode" => {
            println!("Normal Mode");
            let src = format!("{}/.config/waybar/MODES/colors-Normal-Mode.css", home);
            if let Err(e) = fs::copy(&src, &dest) {
                eprintln!("Failed to copy {} to {}: {}", src, dest, e);
            }
            // Uncomment the following if you want to signal waybar:
            // send_signal_to_waybar();
        }
        "Insert Mode" => {
            println!("Insert Mode");
            let src = format!("{}/.config/waybar/MODES/colors-Insert-Mode.css", home);
            if let Err(e) = fs::copy(&src, &dest) {
                eprintln!("Failed to copy {} to {}: {}", src, dest, e);
            }
        }
        "Site Mode" => {
            // The original script echoes "Insert Mode" for Site Mode.
            println!("Insert Mode (Site Mode)");
            let src = format!("{}/.config/waybar/MODES/colors-Site-Mode.css", home);
            if let Err(e) = fs::copy(&src, &dest) {
                eprintln!("Failed to copy {} to {}: {}", src, dest, e);
            }
        }
        "Run Mode" => {
            // The original script echoes "Insert Mode" for Run Mode.
            println!("Insert Mode (Run Mode)");
            let src = format!("{}/.config/waybar/MODES/colors-Run-Mode.css", home);
            if let Err(e) = fs::copy(&src, &dest) {
                eprintln!("Failed to copy {} to {}: {}", src, dest, e);
            }
            // Uncomment below to signal waybar if needed:
            // send_signal_to_waybar();
        }
        _ => {
            println!("Unknown mode: {}", mode);
        }
    }
}

fn main() {
    // Build the path to the mode file
    let home = env::var("HOME").expect("Could not determine HOME directory");
    let mode_file = format!("{}/.config/hypr/mode.txt", home);
    let mode_path = PathBuf::from(&mode_file);

    // Ensure mode.txt exists
    if !mode_path.exists() {
        eprintln!("Error: mode.txt not found!");
        std::process::exit(1);
    }

    // Perform the initial update
    update_mode(&mode_path);
    // Read and trim initial mode for reliable comparison
    let mut last_mode = fs::read_to_string(&mode_path)
        .unwrap_or_default()
        .trim()
        .to_string();

    // Create a channel to receive file change events
    let (tx, rx) = channel();

    // Set up the file watcher with a debounce delay of 2 seconds
    let mut watcher: RecommendedWatcher =
        Watcher::new(tx, Duration::from_secs(0)).expect("Failed to initialize watcher");
    watcher
        .watch(&mode_path, RecursiveMode::NonRecursive)
        .expect("Failed to watch mode file");

    // Monitor mode.txt for changes
    loop {
        match rx.recv() {
            Ok(event) => {
                // Listen for both Write and Chmod events
                match event {
                    DebouncedEvent::Write(_) | DebouncedEvent::Chmod(_) => {
                        let new_mode = fs::read_to_string(&mode_path)
                            .unwrap_or_default()
                            .trim()
                            .to_string();
                        if new_mode != last_mode {
                            last_mode = new_mode;
                            update_mode(&mode_path);
                        }
                    }
                    _ => {
                        // Uncomment the following line for debugging other events:
                        // println!("Other event: {:?}", event);
                    }
                }
            }
            Err(e) => eprintln!("watch error: {:?}", e),
        }
    }
}
