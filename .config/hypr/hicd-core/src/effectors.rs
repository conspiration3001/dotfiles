use std::process::Command;

pub fn trigger_morph(state: &crate::brain::SystemState) {
    match state {
        crate::brain::SystemState::Overdrive => {
            // UI Morph
            Command::new("hyprctl")
                .args(["--batch", "keyword decoration:shadow:enabled false"])
                .spawn().unwrap();
            
            // Kernel Morph (Nécessite Polkit/User session)
            Command::new("powerprofilesctl")
                .args(["set", "performance"])
                .spawn().unwrap_or_else(|_| std::process::Child::from(Command::new("true").spawn().unwrap()));
        },
        crate::brain::SystemState::NeuralFocus => {
            Command::new("hyprctl")
                .args(["--batch", "keyword decoration:blur:enabled true"])
                .spawn().unwrap();
                
            Command::new("powerprofilesctl")
                .args(["set", "balanced"])
                .spawn().unwrap_or_else(|_| std::process::Child::from(Command::new("true").spawn().unwrap()));
        },
        crate::brain::SystemState::Chill => {
            Command::new("hyprctl")
                .args(["--batch", "keyword decoration:shadow:enabled true"])
                .spawn().unwrap();
                
            Command::new("powerprofilesctl")
                .args(["set", "power-saver"])
                .spawn().unwrap_or_else(|_| std::process::Child::from(Command::new("true").spawn().unwrap()));
        }
    }
}
