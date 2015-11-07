#!/bin/bash
echo "[+] Purging potential databases"
mix ecto.drop
echo "[+] Creating Database…"
mix ecto.create -r Queerlink.Repo
echo "[+] Migrating Database…"
mix ecto.migrate -r Queerlink.Repo

