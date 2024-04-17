## [0.1.0] - 2024-02-11

### Added

- **Static web client code closely fit for securely serving the endpoints of three DogDisplay project impementations:**
 - Can serve the output of the C++, PHP and Python implementations as securely as I know of, know how to, am capable of implementing, and have had time to implment.
    - Will not serve the output of those implmentations, as a result of my intended action, until I have had time to implement all that I know of, know how to and am capable of implementing.

- **Test code that can interface with the static web client, capable of performing end to end tests:**  Can evaluate the general expected contract (contract that has partial definitions in multiple locations, but is only formally defined by the tests). And breaches of that contract (breaches of the general structure of the content served by the either endpoint each server exposes, 500 errors, and data signature errors).

- **Capability to build the tests and the static web client independent of server location:** Source code, where environment specific variables are represented by placeholder stings, along with build scripts that can create folders with build versions of the test, and the client code.

- **Development scripts:** Scripts that automate exectuion of the code in a development environment, provided with the potential to aid further develoment, as well as serving as a clarification effort towards the next steps in automation efforts for building, deploying and executing ing the code.

- **Third party licensing scripts:** Scripts that automate setting up a clean execution environment with minimum installed dependencies for the project, extraction of the set of dependencies and their liences info, generation of full third_party_liences text. Provided as a "to-my-best-knowledge" effort, may not be completely reflective of all attributions by external parties to the dependenices of this project, but provided in good faith and with the intent to maintain attibution information to the standard of "to-my-best-knowledge", to the best of my capabilities.

- **Roadmap:** To clarify future intended development efforts, promote accountability towards self in terms of intended actions, and finally, to create some slack between ideal implementation and published implementation.

## [0.2.0] - 2024-03-07

### Changed

- **Picked up the litter, placed it somewhere nice:**
  - I wrote a really long comment in the `scripts/run_target_test_servers.sh` file. [Link to the file in a commit before the comment was removed](https://github.com/mittons/DogDisplayStaticClient/blob/e10acf6f6aca32ed10839c49cf6e5d5ab62d1b7a/dev_scripts/run_target_test_servers.sh
). The comment is on topic, well.. sort of. And it's very reflective on what was going on in the file and then it became self-reflective on its own existence. And yeah. On coding conventions, what should go into collaborative/public space, contextual fit and human behaviour in general.
  - The code file is meant to run the target test servers, not preach about ideas such as coding conventions, what should go into collaborative/public space, contextual fit and human behaviour in general. So having a comment that preaches on those ideas doesn't fit the context of that code file. It does not belong in the latest/working version of that file. In that context it is litter.
  - I think the comment is on point, well structured.. and I probably shouldn't be tooting my horn.. but I also think it's clever. It doesn't fit in the current version, but it's certainly valid. So it gets a place in version control history. I already set this up a long time ago.
  - This change was planned before I [committed the comment on Feb 11, 2024](https://github.com/mittons/DogDisplayStaticClient/commit/4446b134386375a6880444d3213cbc2b038d7fc7) and before I [committed the roadmap to the repo on Feb 12, 2024](https://github.com/mittons/DogDisplayStaticClient/commit/338eeb18e2137c538ec8a3dfc097e5301123ebdf). And the roadmap makes it clear, there is an item on the roadmap "Pick up litter. Put it somewhere nice.", this commit and version update were pre-planned.


## [0.2.1] - 2024-03-08

- **Showcased a continous, daily progress by checking off an item on the roadmap list:**
  - [But it was already completed](https://github.com/mittons/DogDisplayStaticClient/blob/df0ba0b3efaa5b00c97ba7fcf3eedeceddd74de4/deployment_scripts/build_e2e_tests.sh), so it was an easy task 😈.
  
## [0.2.2] - 2024-04-05

## Added

- **Started setting up a script that fetches and builds most/all dependencies for running the full automated test cycle script**
  - Also included the ChatGPT promt used to generate the script, as it is in the code now, for version control documentation purposes, but it will be removed in a later commit.

## [0.3.0] - 2024-04-05

### Added

- **Automation of setting up most or all application dependencies for full testing of all combinations of the static client, cpp/php/python servers, and the mock/prod data sets**
  - Added the script refresh_dev_test_apps_dir to the dev_scripts folder. It creates or refreshes the gitignored dev_test_apps_dir and populates it with the source for all of the server projects (cpp/php/python), the mock api source (built into docker image), and also fetches chromedriver. It builds/compiles all of the source code. Then finally it creates/updates the local env path file in the dev_scripts folder and populates/updates it with all the relevant paths to applications/resources in the dev_test_apps_dir.
    - The only thing that needs to be added manually to the env file now is the path to a bash shell executable.
    - Beyond that there is also generic stuff that should generally be in system/user path. Top of my mind: python, node, docker, general bash commands (like curl).
    - The docker engine also needs to be booted up manually as is, before the automate_full_test_cycle script (in dev_scripts) is run.

## [0.3.1] - 2024-04-05

### Fixed

- **Code quality fixes. Spelling mistakes, working titles, placeholder names, etc. amended properly**
  - Renamed deployment_scripts to build_scripts. Integrated abc.sh into bcd.sh. Moved bcd.sh to build_scripts and renamed it into refresh_build.sh. The folder lets_go renamed to `build`.
  - Spelling mistakes fixed.
  - gitignore
  - Roadmap updated.