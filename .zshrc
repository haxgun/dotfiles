export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
git
zsh-autosuggestions
)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)

source $ZSH/oh-my-zsh.sh

alias c='clear'

alias pd='pnpm dev'
alias pf='pnpm format'
alias pi='pnpm install'
alias pui='pnpm uninstall'
alias pxi='pnpx node-modules-inspector'

alias ur='uv run main.py'

alias bd='bun dev'
alias bf='bun format'
alias bi='bun add'
alias bui='bun remove'
alias bx='bunx'
alias bl='bun lint'

alias gs='git status'
alias gp='git push'
alias gpf='git push --force'
alias gpft='git push --follow-tags'
alias gpl='git pull --rebase'
alias gcl='git clone'
alias gst='git stash'
alias grm='git rm'
alias gmv='git mv'

alias main='git checkout main'

alias gco='git checkout'
alias gcob='git checkout -b'

alias gb='git branch'
alias gbd='git branch -d'

alias grb='git rebase'
alias grbom='git rebase origin/master'
alias grbc='git rebase --continue'

alias gl='git log'
alias glo='git log --oneline --graph'

alias grh='git reset HEAD'
alias grh1='git reset HEAD~1'

alias ga='git add'
alias gA='git add -A'

alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git add -A && git commit -m'
alias gfrb='git fetch origin && git rebase origin/master'

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gsha='git rev-parse HEAD | pbcopy'

alias ghci='gh run list -L 1'

alias ls="eza --tree --level=1 --icons=always --no-time --no-user --no-permissions"

alias .="source"

eval "$(starship init zsh)"

alias ssh="TERM=xterm-256color ssh"
