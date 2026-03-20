# bashrc.d
just a bunch of my personal Linux Bash helper scripts

a common use case, splitting the `.bashrc` file into several includes, under `~/.bashrc.d/`.

That's what i did, i've added 
```bash
# bashrc includes
for file in ~/.bashrc.d/[0-9][0-9]-*.sh; do
    [ -r "$file" ] && source "$file"
done
```
and that's where all my helper scripts live, now.
