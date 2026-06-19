use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::net::UnixStream;
use tokio::sync::mpsc::Sender;
use std::env;

pub async fn hypr_eye(tx: Sender<String>) {
    let signature = env::var("HYPRLAND_INSTANCE_SIGNATURE")
        .expect("Erreur: HYPRLAND_INSTANCE_SIGNATURE non définie");
    let runtime_dir = env::var("XDG_RUNTIME_DIR").unwrap_or_else(|_| "/run/user/1000".to_string());
    let socket_path = format!("{}/hypr/{}/.socket2.sock", runtime_dir, signature);
    
    let stream = UnixStream::connect(socket_path).await
        .expect("Erreur de connexion au socket Hyprland");
    let mut reader = BufReader::new(stream).lines();

    while let Ok(Some(line)) = reader.next_line().await {
        if line.starts_with("activewindow>>") {
            let parts: Vec<&str> = line.split(">>").collect();
            if parts.len() > 1 {
                // Extraction stricte de la classe (format: class,title)
                let class = parts[1].split(',').next().unwrap_or("").to_lowercase();
                let _ = tx.send(class).await;
            }
        }
    }
}
