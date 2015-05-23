# Development instructions

## Using Vagrant

After cloning this repository, run:

```
$ vagrant up
```

When it finishes, connect to your VM:

```
$ vagrant ssh
```

Load the environment so that you can call the `shak` binary directly:

```
$ cd /vagrant/
$ . .env
```

## On your main Debian system

Read `utils/bootstrap` carefully first, then:

```
$ sudo ./utils/bootstrap
```

If you want to be able to run `shak` in the easiest way possible, load the
environment variables:

```
. .env
```

Otherwise you can still run shak with

```
$ ruby -Ilib ./bin/shak [ARGS]
```

## Running tests

After adding tests for the new method in the appropriate test file, run the
following:

```
$ rake
```

This will run unit tests using rspec. You should see output similar to the
following:

```
................................................................

Finished in 0.05459 seconds
64 examples, 0 failures
```


To run functional tests using autopkgtest (this will take a while), issue the
following command:

```
$ rake test
```
