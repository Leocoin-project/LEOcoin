LEOcoin
======
LEOcoin HTML5 UI


Windows usage:
In C:\ root, `git clone https://bitbucket.org/mmitech/leocoin-ui`

Linux / Mac usage:
in /opt, `git clone https://bitbucket.org/mmitech/leocoin-ui`


## New linux way
In the home directory do,
`git clone https://bitbucket.org/mmitech/leocoin-ui`

`cd leocoin-ui`

Then get the current path, keep note of this:
`pwd`

Now move to the directory where your LEOcoin fork is stored or clone the repo if you don't have it yet
`cd ..`

`git clone https://bitbucket.org/mmitech/leocoin-ui`

Move into the directory
`cd  leocoin-ui`

Then symlink /opt/LEOcoin
`ln -s that_pwd_path /opt/leocoin-ui`

RUn ./LEOcoin and the GUI should be loaded from LEOcoin-UI



Feel free to customise it :)

To compile into executable, run `fixAssets.sh`, copy `build/*` into appropriate directories.

Depends:
https://www.npmjs.com/package/minify
