# iliana's dotfiles

This is the third generation of [iliana](https://github.com/iliana)'s dotfiles.

![image](https://user-images.githubusercontent.com/52814/106420173-edfc8080-640e-11eb-87fc-83b1c76d5080.png)

The dotfiles are tracked in a bare git repository. This technique has been described in [many](https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html) [different](https://www.atlassian.com/git/tutorials/dotfiles) [ways](https://www.google.com/search?q=dotfiles+bare+git+repo).

## iliana's cheat sheet

```bash
git clone --bare git@github.com:iliana/dotfiles.git ~/.dotfiles.git
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
dotfiles submodule update --init --recursive
```
