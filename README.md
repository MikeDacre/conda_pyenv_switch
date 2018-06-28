# conda_pyenv_switch
A simple zsh function to switch anaconda and pyenv in the PATH

pyenv is great, but if you install an anaconda version in pyenv that you use
heavily, you can easily clobber your entire shell. The reason is that conda
hosts so many different things, including some shell replacements, and pyenv
provides shims for every executable... so you end up with anaconda versions of
stuff in your path that destroy everything.

The solution for me is to use a primary anaconda separately from pyenv, I use
the conda install for most of my scientific programming, but I keep pyenv for
some things, particularly testing or really easy virtualenvs.

The two don't play well together though, so my solution is to detect if both
~/anconda[3] and ~/.pyenv exist and then if so provided two functions:

- `use_pyenv`
- `use_conda`

These functions just munge the path to flip the priority of the two, so
`use_pyenv` make the PATH `$HOME/.pyenv/bin:$HOME/anaconda3/bin:...`, and
`use_conda` just flips those two.

Note: This is a dumb way of doing this, it could easily be written smaller, more
compact, more efficient. I just don't care enough, it is a quick job.
