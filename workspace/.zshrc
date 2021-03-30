# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
plugins=(
        git
        github
        composer
        encode64
        iterm2
        jsontools
)
source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ $(id -u -n) = "develop" ] ; then
  /usr/bin/keychain -q ~/.ssh/id_ed25519
  source ~/.keychain/$HOSTNAME-sh

  export GPG_TTY=$(tty)
  gpg --list-secret-keys $(head -1 ~/.gpg/keyid.txt) > /dev/null 2>&1
  found=$?
  if [ $found -ne 0 ]; then
     gpg --import ~/.gpg/gpg.key
     git config --global user.signingkey $(head -1 ~/.gpg/signingkey.txt)
  fi
fi
