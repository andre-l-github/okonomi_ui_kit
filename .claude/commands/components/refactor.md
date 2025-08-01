Please refactor legacy code $ARGUMENTS to become a proper component.

Follow the guidelines from `docs/COMPONENT_GUIDE.md`.

* Ensure the component is self-contained
* Ensure well defined tests
* Extract styles into dedicated block
* Check if component usage must be updated in the gem
* Check if there are showcases in the dummy app that need to be updated, if not, create a new showcase
* create a user guide under `guides/components/<component_name>.md`, link it from `README.md`
* create a migration guid under `guides/migrations/<component_name>.md`, do not link it from `README.md`
* Ensure $ARGUMENTS has been removed
* Ensure all tests pass