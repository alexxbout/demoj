#!/bin/bash
# shellcheck shell=bash

log_file=".logs.txt"

# Fonction pour afficher un message d'erreur et quitter le script avec un code de sortie non nul
die() {
    echo "Something went wrong. Do you want to see the logs? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        less "$log_file"
    fi

    echo "$1" >&2
    exit 1
}

# Fonction pour vérifier si le script est exécuté en tant que root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        die "Please run this script as root."
    fi
}

# Fonction pour vérifier si un paramètre fait partie d'un tableau de paramètres
check_param_in_array() {
    local param="$1"
    shift
    local param_array=("$@")

    for p in "${param_array[@]}"; do
        if [ "$param" = "$p" ]; then
            return 0  # Paramètre trouvé dans le tableau
        fi
    done

    return 1  # Paramètre non trouvé dans le tableau
}

# Fonction pour vérifier si le répertoire d'exécution existe
check_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        die "Directory $dir does not exist"
    fi
}

# Function pour créer une sauvegarde d'un fichier
create_bak() {
    local file="$1"
    if [ ! -f "$file.bak" ]; then
        cp "$file" "$file.bak" || die "Failed to create backup of $file"
    fi
}

# Fonction pour rediriger la sortie standard et la sortie d'erreur vers un fichier de log
redirect_output() {
    # Redirection de stdout des échos vers le terminal
    exec > >(while IFS= read -r line; do printf '%s\n' "$line"; done)
    # Utilisation d'une sous-coquille pour rediriger seulement la sortie des commandes
    {
        # Redirection de stderr et stdout des commandes vers le fichier de log
        exec 2>> >(while IFS= read -r line; do printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$line"; done >> "$log_file")
    }
}