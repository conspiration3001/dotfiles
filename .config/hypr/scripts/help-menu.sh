#!/bin/bash

shortcuts="SUPER + T : Ouvrir le Terminal (Kitty)
SUPER + A : Menu des applications (Rofi)
SUPER + H : Afficher ce menu d'aide
SUPER + D : Dashboard Quickshell (Musique, Calendrier)
SUPER + B : Changer la barre Quickshell de côté
SUPER + CTRL + Flèches : Placer la barre Quickshell (Haut/Bas/Gauche/Droite)
SUPER + E : Explorateur de fichiers
SUPER + V : Historique du presse-papier (Clipboard)
SUPER + L : Verrouiller l'écran
SUPER + R : Changer le fond d'écran aléatoirement
SUPER + W : Configurer le fond d'écran (Quickshell)
SUPER + Q : Fermer la fenêtre active
SUPER + M : Quitter Hyprland (Déconnexion)
SUPER + F : Fenêtre flottante
SUPER + G : Grouper les fenêtres en onglets (Tabs)
ALT + TAB : Naviguer dans les onglets du groupe
SUPER + J : Changer l'orientation de la séparation (Split)
SUPER + Flèches : Changer de fenêtre active
SUPER + [1-9] : Changer d'espace de travail
SUPER + SHIFT + [1-9] : Déplacer la fenêtre vers l'espace de travail
SUPER + S : Espace de travail magique (Caché)
SUPER + SHIFT + S : Envoyer la fenêtre vers l'espace magique
SUPER + Impr. Écran : Capture d'écran (fenêtre active)
Impr. Écran : Capture d'écran (tout l'écran)
SHIFT + Impr. Écran : Capture d'écran (zone sélectionnée)"

echo "$shortcuts" | rofi -dmenu -i -p "⌨️ Raccourcis" -theme-str 'window {width: 600px;} listview {lines: 15;}'
