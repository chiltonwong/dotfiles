backup_stow_conflict() {
  dotfiles_echo "Conflict detected: ${1} Backing up.."
  local BACKUP_SUFFIX
  BACKUP_SUFFIX="$(date +%Y-%m-%d)_$(date +%s)"
  mv -v "$1" "${1}_${BACKUP_SUFFIX}"
}
