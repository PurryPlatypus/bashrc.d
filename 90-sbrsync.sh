
# rsync Steam Backup

# WARNING: this is deprecated
# the zackupSteam function works much more reliably
# it creates a COMPLETE backup/replication
# without complaining about those dos/windows/wine/proton files

sbrsync () {
  # Define the mount point and the target directory
  MOUNT_POINT="/mnt/backup"
  TARGET_DIR="$MOUNT_POINT/SteamLibrary/"
  SOURCE_DIR="/bigNVME/SteamLibrary/"
  ALREADY_MOUNTED=false
  RETVAL=0

  # mount the target, unless already mounted
  if mountpoint -q "$MOUNT_POINT"; then
    ALREADY_MOUNTED=true
    echo "$MOUNT_POINT is already mounted"
  else
    echo "Mounting $MOUNT_POINT..."
    mount "$MOUNT_POINT"
    if [ $? -ne 0 ]; then
      echo "Failed to mount $MOUNT_POINT"
      return 1
    fi
  fi

  # Check if the target directory exists and is not empty
  if [ -d "$TARGET_DIR" ] && [ "$(ls -A $TARGET_DIR)" ]; then
    echo "Target directory $TARGET_DIR exists and is not empty."
    echo "Running rsync..."
    # Run rsync command (modify the rsync command as needed)
    #rsync -avv --info=progress2 --stats --itemize-changes --delete "$SOURCE_DIR" "$TARGET_DIR"
    #rsync -avv --info=progress2 --stats --itemize-changes --delete-excluded --exclude="ubuntu12_32" --exclude="ubuntu12_64" --exclude="steamrt64" --exclude="compatdata" --exclude="SteamLinuxRuntime_soldier" --exclude="SteamLinuxRuntime_sniper" --exclude="SteamLinuxRuntime" --exclude="Steam.dll" --delete "$SOURCE_DIR" "$TARGET_DIR"
    #rsync -avv --info=progress2 --stats --itemize-changes --safe-links --copy-dirlinks --delete-excluded --exclude="ubuntu12_32" --exclude="ubuntu12_64" --exclude="steamrt64" --exclude="windows" --exclude="dosdevices" --exclude="SteamLinuxRuntime_soldier" --exclude="SteamLinuxRuntime_sniper" --exclude="SteamLinuxRuntime" --exclude="Steam.dll" --delete "$SOURCE_DIR" "$TARGET_DIR"
    rsync -avv --info=progress2 --stats --itemize-changes --safe-links --keep-dirlinks --omit-dir-times --delete-excluded --exclude="dosdevices" --delete "$SOURCE_DIR" "$TARGET_DIR"
    if [ $? -eq 0 ]; then
      echo "rsync completed successfully"
    else
      echo "rsync failed"
      RETVAL=1
    fi
  else
    echo "$TARGET_DIR does not exist or is empty"
    RETVAL=1
  fi

  # Unmount the directory if it was not already mounted before
  if [ "$ALREADY_MOUNTED" = false ]; then
    echo "Unmounting $MOUNT_POINT..."
    umount "$MOUNT_POINT"
    if [ $? -ne 0 ]; then
      echo "Failed to unmount $MOUNT_POINT"
      RETVAL=1
    fi
  else
    echo "$MOUNT_POINT was already mounted before, not unmounting."
  fi

  return $RETVAL
}
