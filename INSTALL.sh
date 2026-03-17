#!/bin/sh
set -eu

BASE_URL="https://raw.githubusercontent.com/engeir/paper-publishing-process/main"

#region logging setup
if [ "${MISE_DEBUG-}" = "true" ] || [ "${MISE_DEBUG-}" = "1" ]; then
  debug() {
    echo "$@" >&2
  }
else
  debug() {
    :
  }
fi

if [ "${MISE_QUIET-}" = "1" ] || [ "${MISE_QUIET-}" = "true" ]; then
  info() {
    :
  }
else
  info() {
    echo "$@" >&2
  }
fi

error() {
  echo "$@" >&2
  exit 1
}
#endregion

fetch_url() {
  url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO - "$url"
  else
    error "curl or wget is required but neither is installed."
  fi
}

download_file() {
  url="$1"
  dest="$2"
  mkdir -p "$(dirname "$dest")"
  fetch_url "$url" > "$dest"
  info "  $dest"
}

info "Bootstrapping paper project from $BASE_URL"
info ""

# .github/workflows/
info "Downloading workflow files..."
download_file "$BASE_URL/.github/workflows/build.yml"            ".github/workflows/build.yml"
download_file "$BASE_URL/.github/workflows/fix-bib-filepath.yml" ".github/workflows/fix-bib-filepath.yml"
download_file "$BASE_URL/.github/workflows/release.yml"          ".github/workflows/release.yml"

# .mise/tasks/
info "Downloading mise tasks..."
download_file "$BASE_URL/.mise/tasks/package"        ".mise/tasks/package"
download_file "$BASE_URL/.mise/tasks/setup-revision" ".mise/tasks/setup-revision"

# tex/
info "Downloading tex class/style files..."
download_file "$BASE_URL/tex/reviewresponse.cls"       "tex/reviewresponse.cls"
download_file "$BASE_URL/tex/reviewresponse-extra.sty" "tex/reviewresponse-extra.sty"

# Root config files
info "Downloading root config files..."
download_file "$BASE_URL/.gitignore"        ".gitignore"
download_file "$BASE_URL/.prettierrc.toml"  ".prettierrc.toml"
download_file "$BASE_URL/.taplo.toml"       ".taplo.toml"
download_file "$BASE_URL/.yamlfmt.yml"      ".yamlfmt.yml"
download_file "$BASE_URL/LICENSE"           "LICENSE"
download_file "$BASE_URL/MISE_BOOTSTRAP.sh" "MISE_BOOTSTRAP.sh"
download_file "$BASE_URL/hk.pkl"            "hk.pkl"
download_file "$BASE_URL/mise.ci.toml"      "mise.ci.toml"
download_file "$BASE_URL/mise.lock"         "mise.lock"
download_file "$BASE_URL/mise.toml"         "mise.toml"
download_file "$BASE_URL/tex-fmt.toml"      "tex-fmt.toml"

# cliff.toml — comment out owner/repo so the user fills in their own
info "Downloading cliff.toml (with owner/repo commented out)..."
fetch_url "$BASE_URL/cliff.toml" \
  | sed 's/^owner = /# owner = /; s/^repo = /# repo = /' \
  > cliff.toml
info "  cliff.toml"

# Permissions
info ""
info "Setting executable permissions..."
chmod +x MISE_BOOTSTRAP.sh .mise/tasks/package .mise/tasks/setup-revision

# Generate tex/main.tex
info "Generating tex/main.tex..."
mkdir -p tex
cat > tex/main.tex << 'MAINTEX'
\documentclass{article}

\title{Paper Title}
\author{Author Name}
\date{\today}

\begin{document}

\maketitle

\begin{abstract}
  Abstract text goes here.
\end{abstract}

\section{Introduction}
Introduction text goes here.

% Uncomment the following two lines once you have a .bib file:
% \bibliographystyle{plain}
% \bibliography{references}

\end{document}
MAINTEX
info "  tex/main.tex"

# Generate README.md
info "Generating README.md..."
cat > README.md << 'READMEEOF'
# Paper

For full documentation see <https://github.com/engeir/paper-publishing-process>.

## Getting started

1. `git init` — initialise a git repository
2. Edit `cliff.toml` — set `owner` and `repo` under `[remote.github]`
3. `./MISE_BOOTSTRAP.sh` — install [mise](https://mise.jdx.dev)
4. `mise install` — install all tools and set up git hooks
5. Edit `tex/main.tex` — add your title, author, and content

> **Optional:** create `mise.local.toml` with `LOCAL_BIB_PATH = "/path/to/refs"` (no `.bib`
> extension) to enable local bibliography support.
READMEEOF
info "  README.md"

info ""
info "Done. Edit tex/main.tex and cliff.toml (set owner/repo) to get started."
