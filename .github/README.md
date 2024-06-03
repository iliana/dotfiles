# iliana's dotfiles

![image](https://github.com/iliana/dotfiles/assets/52814/4c77c5e7-8276-46b3-a286-7c75c12e6333)

I find it is important to share little parts of how I operate a computer to others who are also cursed to operate computers.

These dotfiles are tracked in a bare git repository. This technique has been described in [many](https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html) [different](https://www.atlassian.com/git/tutorials/dotfiles) [ways](https://www.google.com/search?q=dotfiles+bare+git+repo).

For reference, I use macOS and Arch Linux on my desktop machines, mostly NixOS for servers ([here are my NixOS configurations](https://git.iliana.fyi/nixos-configs)), and illumos for work.

The description for this repo comes from [this excellent tweet](https://web.archive.org/web/20211120005609/https://twitter.com/cakesandcourage/status/1461481653059129345).

## iliana's cheat sheet

<pre>curl <a href="https://ili.fyi/dotfiles.sh">https://ili.fyi/dotfiles.sh</a> | sh</pre>

## Firefox about:config tweaks

- browser.eme.ui.enabled: false
- browser.tabs.closeWindowWithLastTab: false
- extensions.pocket.enabled: false
- media.eme.enabled: false
- pdfjs.disabled: true (ymmv)
- toolkit.legacyUserProfileCustomizations.stylesheets: true ([also userChrome.css](https://iliana.fyi/blog/firefox-pinned-tab-attention-icon/))

References: <https://support.mozilla.org/en-US/questions/1388341>
