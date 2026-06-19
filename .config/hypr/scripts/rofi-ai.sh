#!/bin/bash
# Script IA interactif avec Ollama et Rofi
# Dépendances: ollama, rofi, jq, wl-clipboard, wl-paste

# Vérifier si Ollama tourne
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    rofi -e "Erreur: Le service Ollama (IA locale) n'est pas démarré."
    exit 1
fi

# Demander à l'utilisateur sa question via Rofi
QUESTION=$(rofi -dmenu -p "Posez votre question à l'IA" -theme-str 'window {width: 600px;} entry {placeholder: "Exemple: Écris-moi une fonction Python...";}' -l 0)

# Si vide ou annulé, on quitte
if [ -z "$QUESTION" ]; then
    exit 0
fi

# Afficher un message de chargement via notify-send
notify-send -t 10000 "🧠 L'IA réfléchit..." "$QUESTION"

# Appeler Ollama (Modèle Llama 3.2 1B Ultra-Rapide)
RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate -d "{
  \"model\": \"llama3.2:1b\",
  \"prompt\": \"$QUESTION\",
  \"stream\": false
}" | jq -r '.response')

# Si la réponse est vide (erreur)
if [ -z "$RESPONSE" ] || [ "$RESPONSE" == "null" ]; then
    notify-send -u critical "❌ Erreur IA" "Impossible d'obtenir une réponse d'Ollama."
    exit 1
fi

# Copier la réponse dans le presse-papier
echo "$RESPONSE" | wl-copy

# Afficher la réponse dans une fenêtre Rofi (formatée avec des sauts de ligne)
echo -e "$RESPONSE" | rofi -dmenu -p "Réponse (Copiée !)" -theme-str 'window {width: 800px; height: 600px;} listview {lines: 15;}' 

# Notification de succès
notify-send "✅ Réponse copiée" "La réponse de l'IA a été copiée dans votre presse-papier."
