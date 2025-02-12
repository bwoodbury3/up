# Up!

Navigate left on the directory tree with ease.

```
user@mac:/Users/brian/git/up$ up 3
cd ../../..
user@mac:/Users$
```

```
user@mac:/Users/brian/git/up$ up
cd ..
user@mac:/Users/brian/git$
```

```
user@mac:/Users/brian/git/up$ up brian
cd -- /Users/brian
user@mac:/Users/brian$
```

# Installation

Clone:
```
git clone https://github.com/bwoodbury3/up.git <path>
```

On systems with `~/.bashrc`:
```
echo "source <path>/up.sh" > ~/.bashrc
```