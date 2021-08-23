# npm-publish-action-monorepo

Based off: https://github.com/pascalgn/npm-publish-action

GitHub action to automatically publish your entire workspace to npm.

Action assumes that user has monorepository with multiple packages.
Action doesn't require user to maintain package versions.

You can simply bump version in root of your monorepository and action will automatically change versions of the packages when publishing.

## Usage

Create a new `.github/workflows/npm-publish.yml` file:

```yaml
name: npm-publish
on:
  push:
    branches:
      - main # Change this to your default branch
jobs:
  npm-publish:
    name: npm-publish
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Publish if version has been updated
      uses: wtrocki/npm-publish-action-monorepo@2.0.0
      with: 
        workspace: "./packages" # Required
        versionFrom: "."
        tag_name: "v%s"
        tag_message: "v%s"
        create_tag: "true"
        commit_pattern: "^chore: Release (\\S+)"
        publish_args: "--non-interactive --dry-run"
      env: # More info about the environment variables in the README
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # Leave this as is, it's automatically generated
        NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }} # You need to set this in your repo settings
```

Now, when someone changes the version in `package.json` to 1.2.3 and pushes a commit with the message `Release 1.2.3`, the `npm-publish` action will create a new tag `v1.2.3` and publish the package to the npm registry.

### Inputs

## Required

- `workspace`: custom workspace directory that contains folders with multiple `package.json` files

## Optional 

These inputs are optional: that means that if you don't enter them, default values will be used and it'll work just fine.

- `versionFrom`: location of package.json file that will be used to as source for version. Usually root of your monorepo (./)
- `tag_name`: the name pattern of the new tag
- `tag_message`: the message pattern of the new tag
- `create_tag`: whether to create a git tag or not (defaults to `"true"`)
- `commit_pattern`: pattern that the commit message needs to follow
- `publish_args`: publish command arguments (for example `--prod --verbose`, defaults to empty)
- `recursive`: iterate thru folder to find and publish multiple packages

### Environment variables

- `GITHUB_TOKEN`: this is a token that GitHub generates automatically, you only need to pass it to the action as in the example
- `NPM_AUTH_TOKEN`: this is the token the action will use to authenticate to [npm](https://npmjs.com). You need to generate one in npm, then you can add it to your secrets (settings -> secrets) so that it can be passed to the action. DO NOT put the token directly in your workflow file.

## Related projects

- [npm-publish](https://github.com/JS-DevTools/npm-publish) is a similar project
- [version-check](https://github.com/EndBug/version-check) allows to define custom workflows based on version changes

## License

[MIT](LICENSE)
