# Repository roadmap (may be subject to removal upon necessary completion)

This roadmap details planned changes to the state of this project/repository:
*Additionally it details potential changes to related repositories that reflect incorporation of this repository, as well as change that can result of incorporating this repository*

**Planned changes to the state of this project, or related projects:**
- [ ] Rename scripts that still have placeholder names
- [ ] Fix Server_URL_PLACEHOLRDER constant in build_tests.sh
- [ ] Remove server port from build_tests.sh
- [X] Rename build_tests.sh to build_e2e_tests.sh
- [ ] Set up versioning.
- [ ] Set up readmes.
- [X] Set up license (5 min).
- [X] Third party licence generation.
- [X] Pick up litter. Put it somewhere nice.
- [ ] Public key dependency injection.
- [ ] Implement code that properly generates static_web_build.
- [ ] Explore SRI.
- [ ] Explore, test and verify that the C++ server side repository can be Dockerized, within the 500 MB image size limit that Heroku enforces, with code functionality intact and aligned with other builds.
- [ ] Verify that repo can be submoduled, i.e. any sub-step of the next item in this roadmap has been tested and verified to have a viable solution.
- [ ] Set up dependent projects to interface with this project.
    - [ ] Explore further integrity checks of static data, and automation there of, server side.
    - [ ] Ensure server projects offer build/env options to set exposed server port manually as well as options to define external data source configurations manually
    - [ ] Set up workflows to automate environment setup, configurations, (potential) build, testing of server code upon push to remote repository.
    - [ ] Import this repository as a submodule in server projets
    - [ ] Extend server repositories to offer environment to support this repo as submodule
    - [ ] Execute server repository CI/CD scripts to build the repository code, and:
        - [ ] Automate the excution of the built tests
        - [ ] Automate the deployment of the built static client, to GH-pages, using predetermined url for production server location, among other relevant environment/context variables
    - [ ] Finally, extend server repositories to deploy built versions of the server side code to the intended deployment platforms


- [ ] Tie it all together. 
    - Either write a Github Actions workflow, or a bash script executable on inside a docker container of base ubuntu, that pulls all the dependent projects, builds them for both mock and prod data sources, and then performs the same functionality as the [automate_full_test_cycle.sh](dev_scripts/automate_full_test_cycle.sh) script in the dev script folder defines.