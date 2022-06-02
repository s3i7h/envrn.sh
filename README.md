# envrn.sh

"**envrn**" (pronounced en-vern) as in "environment" or "env run", is the ultimate bash task runner for any environment.

Defining a task is as easy as defining a single function, with everything a bash shell script can do included natively.

# Installation / Upgrade

Move to any folder of a project and execute:

```bash
$ curl -sL envrn.sh | bash
```

Note that if `envrn.sh` already exists, it will move it to `envrn.sh.bak` before downloading the latest script

# Usage

Edit the `envrn.sh` file to add task definitions.

## 1. Adding tasks

Define a top level function with a good name. The task will be executed inside the directory `envrn.sh` is in, but you can access the original `$PWD` with `$__PWD__`.

```bash

yarn_build() {
  cd src/frontend
  echo yarn build
}

yarn_serve() {
  cd src/frontend
  echo yarn serve
}

yarn_run() {
  echo "The script was invoked at $__PWD__, but is executed at $PWD"
  # utilizing bash subshells to make `cd` taking effect only inside each task
  ( yarn_build )
  ( yarn_serve )
}
```

```bash
/path/to/project/src/backend $ ../envrn.sh yarn_run
The script was invoked at /path/to/project/src/backend, but is executed at /path/to/project
yarn build
yarn serve
```

In a task, the project `.env` file is loaded to the enviroment variables, making it easy to utilize them. You can override it by passing a real environment variable to `envrn.sh` itself.

```bash
show_env() {
  echo "The APP_ENV is $APP_ENV"
}

```

```bash
/path/to/project $ cat .env
APP_ENV=develop
/path/to/project $ ./envrn.sh show_env
The APP_ENV is develop
/path/to/project $ APP_ENV=production ./envrn.sh show_env
The APP_ENV is production
```

## 2. Using `envrn.sh shell`

There is a pre-defined task `shell`, which executes a new shell that reads .env into environment variables.

```
/path/to/project $ ./envrn.sh shell
/path/to/project $ env
(... all the envs with .env loaded ...)
```

## 3. Executing global commands in the context of the project

As the example above, you can execute any commands or functions outside of `envrn.sh` with project envs simply by:

```
/path/to/project $ ./envrn.sh [global_command]
```

