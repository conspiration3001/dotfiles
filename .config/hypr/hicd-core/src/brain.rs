#[derive(PartialEq, Debug, Clone, Copy)]
pub enum SystemState {
    Overdrive,
    NeuralFocus,
    Chill,
}

pub struct FSM {
    pub current_state: SystemState,
}

impl FSM {
    pub fn new() -> Self {
        Self { current_state: SystemState::Chill }
    }

    pub fn process_event(&mut self, window_class: &str, _cpu_load: f32) -> Option<SystemState> {
        let new_state = match window_class {
            "steam_app" | "cs2" | "steam" => SystemState::Overdrive,
            "code" | "kitty" | "alacritty" => SystemState::NeuralFocus,
            "discord" | "spotify" | "vesktop" => SystemState::Chill,
            _ => SystemState::Chill,
        };

        if new_state != self.current_state {
            self.current_state = new_state;
            return Some(self.current_state); // Déclenche les effecteurs
        }
        None
    }
}
