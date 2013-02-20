# capistrano-deploy-strategy-archive

## Overview

**capistrano-deploy-strategy-archive** provides a simple archive strategy for [Capistrano](https://github.com/capistrano/capistrano). The strategy takes an existing, pre-built package, copies it as-is to each target host and uncompresses it to the release directory.

While normally discouraged, you'll usually want to use the :none SCM with this strategy (or for even less overhead, the :passthrough SCM from [capistrano-deploy-scm-passthrough](https://rubygems.org/gems/capistrano-deploy-scm-passthrough)).

You'll see the most benefit if you've got a build server cranking out builds for you, which you then later deploy. You'll often want to separate the build phase from the deploy phase in production. If necessary, you can of course use `capistrano/ext/multistage` to do `:archive` deploys for, say, production only.

## Installation

Simply install the gem and you're done:

    gem install capistrano-deploy-strategy-archive

No other setup is needed.

## Usage

Set your options as follows:

**deploy.rb**

    set :scm, :none
    set :deploy_via, :archive
    set :repository, "target/#{application}.tar.gz"

Note that we've set the `:repository` option to match the target archive.

If you'd like to have as little overhead as possible, consider using the [:passthrough](https://rubygems.org/gems/capistrano-deploy-scm-passthrough) SCM:

**deploy.rb**

    set :scm, :passthrough
    set :deploy_via, :archive
    set :repository, "target/#{application}.tar.gz"

This will transfer the archive directly, without any local copies being made. The `:none` strategy actually creates a local copy, which is usually not what you want if you've already got a package made.

Note: if your archive is not a gzipped tar archive, you must set the `:copy_compression` option. The currently available options are `:gzip` (default), `:bz2`, and `:zip`. Please use `cap deploy:check` to check if your servers have the necessary decompressors installed.

You can also set the `:copy_remote_dir` option to control where the package is initially transferred to on each host.

## License

Copyright (c) 2013 Simo Kinnunen

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.