## `compile`

- **Usage**: `compile`

Compile all documents for local development.

## `diff-v1.0.0:compile`

- Depends: diff-v1.0.0:create

- **Usage**: `diff-v1.0.0:compile`

Build/compile the diff v1.0.0 PDF.

## `diff-v1.0.0:create`

- **Usage**: `diff-v1.0.0:create`

Regenerate diff-v1.0.0.tex against v1.0.0.

## `diff-v2026.3.0:compile`

- Depends: diff-v2026.3.0:create

- **Usage**: `diff-v2026.3.0:compile`

Build/compile the diff v2026.3.0 PDF.

## `diff-v2026.3.0:create`

- **Usage**: `diff-v2026.3.0:create`

Regenerate diff-v2026.3.0.tex against v2026.3.0.

## `main:compile`

- Depends: main:\*

- **Usage**: `main:compile`

Build/compile the manuscript.

## `main:update-refs`

- **Usage**: `main:update-refs`

Update the bibliography file.

## `package`

- Depends: fix-bib-filepath

- **Usage**: `package`

Package the manuscript into a zip-file to be submitted to The Journal

## `review-v1.0.0:compile`

- Depends: review-v1.0.0:update-refs

- **Usage**: `review-v1.0.0:compile`

Build/compile the review v1.0.0 response PDF.

## `review-v1.0.0:update-refs`

- **Usage**: `review-v1.0.0:update-refs`

Update the bibliography for review response v1.0.0.

## `review-v2026.3.0:compile`

- Depends: review-v2026.3.0:update-refs

- **Usage**: `review-v2026.3.0:compile`

Build/compile the review v2026.3.0 response PDF.

## `review-v2026.3.0:update-refs`

- **Usage**: `review-v2026.3.0:update-refs`

Update the bibliography for review response v2026.3.0.

## `setup-revision`

- **Usage**: `setup-revision`

Set up files for a new revision cycle: diff against latest tag + review response
template
