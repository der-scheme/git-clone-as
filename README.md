# git-clone-as
With multiple GitHub accounts, there exists overhead in selecting the proper identity at least once per `git clone`, and in configuring it in the config local to the copy. The SSH part of the issue is usually solved by configuring fake hosts in the SSH config. However, this way one cannot simply copy and paste a repository URL. This wrapper solves all of that through a single configuration file with the power of Ruby magic.

To clone a repository, simply execute `git clone-as` instead of `git clone`:
```
git clone-as git@github.com:username/project.git
```
To simulate the actions performed, run:
```
git clone-as --dry-run git@github.com:username/project.git
```
## Configuration
Download file `config.rb` to `~/.local/share/git-clone-as/config.rb`, or pass `--identities-config path/to/config.rb` to `git clone-as`.

If you have a directory where all your cloned repositories live, and if you want `git-clone-as` to always clone to that directory, you can specify it via the `g.root` method.

Define your identities with the `g.identity` method. By default, this will also define a matcher that connects the identity with repositories owned by that user, which can explicitly enabled or disabled with the `define_matcher` keyword argument.

Define your custom matchers with the `g.match` method. The supported matchers are:
<dl>
  <dt>host(arg)</dt>
  <dd>Matches the hostname.</dd>
  <dt>path(arg)</dt>
  <dd>Matches the path of the repository, if it doesn't conform to GitHub's URL style.</dd>
  <dt>project(arg)</dt>
  <dd>Matches the project name.</dd>
  <dt>repository(arg)</dt>
  <dd>Matches the repository (`user/project`).</dd>
  <dt>url(arg)</dt>
  <dd>Matches the entire URL.</dd>
  <dt>user(arg)</dt>
  <dd>Matches the username.</dd>
  <dt>__default__</dt>
  <dd>Matches everything.</dd>
</dl>
Each of those, except the last one, takes a single argument that has to respond to <code>===</code>, which will be passed a String. Typically, this is either the exact String you want, or a Regexp.

Multiple matchers can be composed with the following operators:
<dl>
  <dt>|</dt>
  <dd>Matches if both matchers match ("and").</dd>
  <dt>+</dt>
  <dd>Matches if at least one matcher matches ("or")</dd>
  <dt>-</dt>
  <dd>Matches if the first, but not the second matcher matches ("and not")</dd>
</dl>

## Examples
```
$ git clone-as --dry-run git@github.com:username/foo.git
Simulating...
GIT_SSH_COMMAND=ssh\ -i\ /home/username/.ssh/id_username_github.com_ed25519.pub\ -o\ IdentitiesOnly\=yes git clone git@github.com:username/foo.git foo
cd foo
git config user.name Real\ Name
git config user.email 1234567+username@users.noreply.github.com
git config core.sshcommand ssh\ -i\ /home/username/.ssh/id_username_github.com_ed25519.pub\ -o\ IdentitiesOnly\=yes
git config user.signingkey /home/username/.ssh/id_username_github.com_ed25519.pub
git config gpg.format ssh
git config commit.gpgsign true
cd /path/to/original/pwd
```
```
$ git clone-as --dry-run git@github.com:somebody_else/names.git
Simulating...
GIT_SSH_COMMAND=ssh\ -i\ /home/username/.ssh/id_other_github.com_ed25519.pub\ -o\ IdentitiesOnly\=yes git clone git@github.com:somebody_else/names.git names
cd names
git config user.name other
git config user.email 8901234+other@users.noreply.github.com
git config core.sshcommand ssh\ -i\ /home/username/.ssh/id_other_github.com_ed25519.pub\ -o\ IdentitiesOnly\=yes
git config user.signingkey /home/username/.ssh/id_other_github.com_ed25519.pub
git config gpg.format ssh
git config commit.gpgsign true
cd /path/to/original/pwd
```
