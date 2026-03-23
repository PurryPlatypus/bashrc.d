zackupSteam () {
  echo "zackupSteam - ZFS Steam Backup"

  # detect destructive mode flag
  DESTROY=false
  if [[ "$1" == "--destroy" ]]; then
    echo "destructive --destroy mode enabled"
    DESTROY=true
  fi

  # initialise sudo, ask password
  echo "sudo elevated privileges"
  if ! sudo -v; then
    echo "authentication failed: we're done here!"
    return 1
  fi

  # keep the sudo session alive, in the background
  # this is required for long runtime / large snapshots
  echo "starting sudo -v keepalive loop in the background"
  (while sleep 60; do sudo -v; done) & SUDO_LOOP_PID=$!

  #initialise variables
  echo "initialising variables"
  NOW=$($(which date) +"%Y%m%d%H%M%S") # quirk, due to conflicting alias
  REMOTE_HOST="elitedesk.lan"
  LOCAL_Steam="bigNVME/Steam"
  LOCAL_Steam_CURRSNAP="$LOCAL_Steam@$NOW"
  LOCAL_Steam_PREVSNAP=$(zfs list -H -t snapshot -o name -s creation $LOCAL_Steam | tail -n1)
  REMOTE_Steam="tank/backup/Steam"
  REMOTE_Steam_PREVSNAP=$(ssh $REMOTE_HOST "zfs list -H -t snapshot -o name -s creation $REMOTE_Steam" | tail -n1)

  # create ZFS snapshot
  echo "creating recursive snapshots LOCAL_Steam_CURRSNAP = $LOCAL_Steam_CURRSNAP"
  sudo zfs snap -r $LOCAL_Steam_CURRSNAP

  # ZFS send/receive incrementally
  echo "sending recursive incremental snapshots $LOCAL_Steam_PREVSNAP → $LOCAL_Steam_CURRSNAP"
  sudo zfs send -c -R -i $LOCAL_Steam_PREVSNAP $LOCAL_Steam_CURRSNAP | pv | ssh $REMOTE_HOST "zfs receive -u -v $REMOTE_Steam"

  # destroy old snapshot
  if $DESTROY; then
    echo "destroying snapshot LOCAL_Steam_PREVSNAP = $LOCAL_Steam_PREVSNAP"
    sudo zfs destroy -r $LOCAL_Steam_PREVSNAP
    echo "destroying snapshot REMOTE_Steam_PREVSNAP = $REMOTE_Steam_PREVSNAP"
    ssh $REMOTE_HOST "zfs destroy -r $REMOTE_Steam_PREVSNAP"
  else
    echo "skipping destruction of previous snapshots (use --destroy to enable)"
  fi

  # kill the sudo loop when the script/function ends
  # no automated traps, just kill it, explicitely
  echo "clean up: kill sudo keepalive background loop SUDO_LOOP_PID = $SUDO_LOOP_PID"
  kill "$SUDO_LOOP_PID"
}
