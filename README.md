## Overview

This is a Replication Hook for `riak_repl` that can hit a configured URL that will have the replicated object's `key` appended to it.

This webhook is only triggered on the receive (site/sink) side of replication.

## Installation

**Pre-requisites:** You must build this hook using the version of `erlc` bundled with your Riak installation. See below for common locations...

Distribution | Path
  --- | ---
  CentOS & RHEL Linux    | /usr/lib64/riak/erts-5.9.1/bin/erlc |
  Debian & Ubuntu Linux	| /usr/lib/riak/erts-5.9.1/bin/erlc |
  FreeBSD	| /usr/local/lib/riak/erts-5.9.1/bin/erlc |
  SmartOS	| /opt/local/lib/riak/erts-5.9.1/bin/erlc
  Solaris 10	| /opt/riak/lib/erts-5.9.1/bin/erlc
  Source    | /path/to/riak/rel/erts-5.9.1.bin/erlc
  
Then you can build the hook by doing the following:

	$ cd /path/to/riak
	$ git clone git://github.com/nathanaschbacher/riak-repl-webook.git
	$ cd riak-repl-webhook
	$ make
	
## Configuration

Add `-pa` and `-run` arguments to your `vm.args` file.

```
-pa riak_repl_webhook/ebin
-run riak_repl_webhook register
```

Add a section to the `riak_repl` stanza in `app.config` that enables the hook and defines the URL to hit.

```
  {riak_repl, [
    {data_root, "./data/riak_repl/"},
    {riak_repl_webhook, [
      {enabled, true},
      {url, "http://localhost:3000/?key="}
    ]}
  ]},

```
The `key` of the replicated Riak object will be appended to whatever value you set for `url`.


## License

(The MIT License)

Copyright (c) 2013 Nathan Aschbacher

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.