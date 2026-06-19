use tokio::sync::mpsc;

mod sensors;
mod brain;
mod effectors;

#[tokio::main]
async fn main() {
    // Channel de communication : Senseurs -> Cerveau
    let (tx, mut rx) = mpsc::channel::<String>(32);

    // Lancement du Senseur Visuel (Thread séparé)
    tokio::spawn(async move {
        sensors::hypr_eye(tx).await;
    });

    let mut fsm = brain::FSM::new();
    println!("H.I.C.D Démarré. Écoute du système nerveux...");
    
    // Déclencheur initial
    effectors::trigger_morph(&fsm.current_state);

    // Boucle d'écoute du Cerveau
    while let Some(window_class) = rx.recv().await {
        // Processus
        if let Some(new_state) = fsm.process_event(&window_class, 0.0) {
            println!("[METAMORPHOSE] Transition vers : {:?}", new_state);
            effectors::trigger_morph(&new_state);
        }
    }
}
