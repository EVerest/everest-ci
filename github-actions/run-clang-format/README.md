# Run clang format action

This action runs clang format on a directory.

## Inputs

## `source-dir`

**Required** The directory to lint
`"."`.

## `extensions`

**Required** File extensions to lint
`"hpp,cpp"`

## `exclude`

**Required** Directories to exclude
`"cache"`

## `color`

**Required** Color output
`"always"`

## Example usage

```
uses: everest/everest-ci/github-actions/run-clang-format@v1.0.0
with:
  source-dir: source
  extensions: hpp,cpp
  exclude: cache
```