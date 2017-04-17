#!/usr/bin/env bash

[[ -z "$DCONF" ]] && DCONF=dconf

dset() {
  local key="$1"; shift
  local val="$1"; shift

  if [[ "$type" == "string" ]]; then
    val="'$val'"
  fi

  "$DCONF" write "$DEFAULT_KEY/$key" "$val"
}

dcreate() {
  local key="$1"; shift
  local val="$1"; shift
  {
    echo "[/]"
    echo "$key=$val"
  } | $DCONF load "$DEFAULT_KEY/"
}

# Newest versions of gnome-terminal use dconf
if which "$DCONF" > /dev/null 2>&1; then
  [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

  if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
    if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
      DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
    else
      DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
    fi

    DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"

    dcreate font "'$1'"
    dcreate use-system-font "false"
    $DCONF dump "$DEFAULT_KEY/"

    unset DCONF
    exit 0
  fi
fi
