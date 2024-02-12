## [0.1.0] - 2024-02-11

### Added

- **Static web client code closely fit for securely serving the endpoints of three DogDisplay project impementations:**
 - Can serve the output of the C++, PHP and Python implementations as securely as I know of, know how to, am capable of implementing, and have had time to implment.
    - Will not serve the output of those implmentations, as a result of my intended action, until I have had time to implement all that I know of, know how to and am capable of implementing.

- **Test code that can interface with the static web client, capable of performing end to end tests:**  Can evaluate the general expected contract (contract that has partial definitions in multiple locations, but is only formally defined by the tests). And breaches of that contract (breaches of the general structure of the content served by the either endpoint each server exposes, 500 errors, and data signature errors).

- **Capability to build the tests and the static web client independent of server location:** Source code, where environment specific variables are represented by placeholder stings, along with build scripts that can create folders with build versions of the test, and the client code.

- **Development scripts:** Scripts that automate exectuion of the code in a development environment, provided with the potential to aid further develoment, as well as serving as a clarification effort towards the next steps in automation efforts for building, deploying and executing ing the code.

- **Third party licensing scripts:** Scripts that automate setting up a clean execution environment with minimum installed dependencies for the project, extraction of the set of dependencies and their liences info, generation of full third_party_liences text. Provided as a "to-my-best-knowledge" effort, may not be completely reflective of all attributions by external parties to the dependenices of this project, but provided in good faith and with the intent to maintain attibution information to the standard of "to-my-best-knowledge", to the best of my capabilities.

- **Roadmap:** To clarify future intended development efforts, promote accountability towards self in terms of intended actions, and finally, to create some slack between ideal implementation and published implementation.\